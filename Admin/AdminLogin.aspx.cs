using System;
using System.Configuration;
using System.Data.SqlClient;
using StudySphere.Security;

namespace StudySphere.Admin
{
    public partial class AdminLogin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;
            string connectionString = ConfigurationManager.ConnectionStrings["StudySphereDB"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand(
                @"IF COL_LENGTH(N'dbo.Users', N'IsAdmin') IS NULL
                    SELECT CAST(0 AS bit) AS RoleColumnAvailable,
                           CAST(NULL AS int) AS UserID,
                           CAST(NULL AS varchar(255)) AS Password;
                  ELSE
                    EXEC sp_executesql
                        N'SELECT CAST(1 AS bit) AS RoleColumnAvailable, UserID, Password
                          FROM dbo.Users WHERE Username = @Username AND IsAdmin = 1',
                        N'@Username varchar(50)', @Username = @Username;", connection))
            {
                command.Parameters.AddWithValue("@Username", username);
                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        if (!Convert.ToBoolean(reader["RoleColumnAvailable"]))
                        {
                            lblMessage.Text = "Admin login needs a database update. Run Database_userTable.sql against StudySphereDB, then grant an account admin access as described at the end of that script.";
                            return;
                        }
                        if (PasswordHasher.Verify(password, Convert.ToString(reader["Password"])))
                        {
                            Session["AdminID"] = Convert.ToInt32(reader["UserID"]);
                            Response.Redirect("~/Admin/AdminDashboard.aspx");
                            return;
                        }
                    }
                }
            }
            lblMessage.Text = "Invalid username or password.";
        }
    }
}
