using System;

using System.Configuration;
using System.Data.SqlClient;

namespace StudySphere.Admin
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if the admin is logged in.
            // If there is no AdminID in the session, send them back to the login page.
            if (Session["AdminID"] == null)
            {
                Response.Redirect("~/Admin/AdminLogin.aspx");
                return;
            }

            if (!IsPostBack)
                LoadStatistics();
        }

        private void LoadStatistics()
        {
            lblTotalUsers.Text = lblTotalCourses.Text = lblTotalResources.Text = lblTotalQuizzes.Text = "N/A";
            const string query = @"
                SELECT
                    (SELECT COUNT(*) FROM dbo.Users) AS TotalUsers,
                    (SELECT COUNT(*) FROM dbo.Courses) AS TotalCourses,
                    (SELECT COUNT(*) FROM dbo.CourseResources) AS TotalResources,
                    (SELECT COUNT(*) FROM dbo.tblQuizzes) AS TotalQuizzes";
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["StudySphereDB"].ConnectionString;
                using (SqlConnection connection = new SqlConnection(connectionString))
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblTotalUsers.Text = Convert.ToString(reader["TotalUsers"]);
                            lblTotalCourses.Text = Convert.ToString(reader["TotalCourses"]);
                            lblTotalResources.Text = Convert.ToString(reader["TotalResources"]);
                            lblTotalQuizzes.Text = Convert.ToString(reader["TotalQuizzes"]);
                        }
                    }
                }
            }
            catch (Exception)
            {
                lblStatsMessage.Text = "Dashboard totals could not be loaded. Check the database connection and setup scripts.";
                lblStatsMessage.Visible = true;
            }
        }

        // Nav menu: Dashboard link (stays on this page)
        protected void lnkDashboard_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/AdminDashboard.aspx");
        }

        // Logout button: clear the session and go back to login
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Admin/AdminLogin.aspx");
        }

        // Card 1: Manage Users
        protected void btnManageUsers_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/ManageUsers.aspx");
        }

        // Card 2: Manage Courses
        protected void btnManageCourses_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/ManageCourses.aspx");
        }

        // Card 3: Manage Resources
        protected void btnManageResources_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/ManageResources.aspx");
        }

        // Card 4: Manage Quizzes
        protected void btnManageQuizzes_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/ManageQuizzes.aspx");
        }
    }
}
