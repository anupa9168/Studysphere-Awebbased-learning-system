
using System;
using System.Configuration;
using System.Data.SqlClient;
using StudySphere.Security;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string username = txtUsername.Text.Trim();
        string password = txtPassword.Text;

        if (username == "" || password == "")
        {
            lblMessage.Text = "Please enter username and password.";
            return;
        }

        string connectionString =
            ConfigurationManager.ConnectionStrings["StudySphereDB"].ConnectionString;

        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = @"
                SELECT UserID, FullName, Password
                FROM Users
                WHERE Username = @Username";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Username", username);

                con.Open();

                int userID = 0;
                string fullName = null;
                string storedPassword = null;
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        userID = Convert.ToInt32(reader["UserID"]);
                        fullName = Convert.ToString(reader["FullName"]);
                        storedPassword = Convert.ToString(reader["Password"]);
                    }
                }

                if (storedPassword != null && VerifyAndUpgradePassword(con, userID, password, storedPassword))
                {
                    Session["UserID"] = userID.ToString();
                    Session["Username"] = username;
                    Session["FullName"] = fullName;
                    string courseID = Request.QueryString["CourseID"];
                    if (!string.IsNullOrEmpty(courseID))
                        Response.Redirect("~/Student/Courses/Learning.aspx?CourseID=" + courseID);
                    else
                        Response.Redirect("~/Student/StudentDashboard/StudentDashboard.aspx");
                }
                else
                    {
                        lblMessage.Text = "Invalid username or password.";
                    }
            }
        }
    }

    private bool VerifyAndUpgradePassword(SqlConnection connection, int userID, string password, string storedPassword)
    {
        if (PasswordHasher.IsHashed(storedPassword))
            return PasswordHasher.Verify(password, storedPassword);

        if (!string.Equals(password, storedPassword, StringComparison.Ordinal))
            return false;

        using (SqlCommand upgrade = new SqlCommand(
            "UPDATE Users SET Password = @Password WHERE UserID = @UserID AND Password = @OldPassword", connection))
        {
            upgrade.Parameters.AddWithValue("@Password", PasswordHasher.Hash(password));
            upgrade.Parameters.AddWithValue("@UserID", userID);
            upgrade.Parameters.AddWithValue("@OldPassword", storedPassword);
            upgrade.ExecuteNonQuery();
        }
        return true;
    }
}

