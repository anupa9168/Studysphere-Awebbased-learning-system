using System;
using System.Configuration;
using System.Data.SqlClient;

namespace StudySphere.Student
{
    public partial class StudentDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Student/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                lblFullName.Text = Server.HtmlEncode(
                    Convert.ToString(Session["FullName"]));
                LoadStatistics();
            }
        }

        private void LoadStatistics()
        {
            const string query = @"
                SELECT
                    (SELECT COUNT(*) FROM dbo.Courses) AS CourseCount,
                    (SELECT COUNT(*) FROM dbo.tblQuizzes) AS QuizCount,
                    (SELECT COUNT(*) FROM dbo.tblQuizAttempts WHERE UserID = @UserID) AS AttemptCount,
                    (SELECT ISNULL(AVG(Percentage), 0)
                     FROM dbo.tblQuizAttempts WHERE UserID = @UserID) AS AverageProgress";

            string connectionString = ConfigurationManager
                .ConnectionStrings["StudySphereDB"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@UserID", Convert.ToInt32(Session["UserID"]));
                connection.Open();

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        lblCourseCount.Text = Convert.ToString(reader["CourseCount"]);
                        lblQuizCount.Text = Convert.ToString(reader["QuizCount"]);
                        lblQuizAttempts.Text = Convert.ToString(reader["AttemptCount"]);
                        lblLearningProgress.Text = Convert.ToDecimal(reader["AverageProgress"]).ToString("0") + "%";
                    }
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Student/Login.aspx");
        }
    }
}
