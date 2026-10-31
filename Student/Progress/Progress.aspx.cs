using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace StudySphere.Student.Progress
{
    public partial class Progress : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings["StudySphereDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Student/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProgress();
            }
        }

        private void LoadProgress()
        {
            int userID;
            if (!int.TryParse(Convert.ToString(Session["UserID"]), out userID))
            {
                Response.Redirect("~/Student/Login.aspx");
                return;
            }

            const string summaryQuery = @"
                SELECT COUNT(*) AS AttemptCount,
                       ISNULL(AVG(Percentage), 0) AS AverageScore,
                       ISNULL(MAX(Percentage), 0) AS BestScore
                FROM dbo.tblQuizAttempts
                WHERE UserID = @UserID";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (SqlCommand command = new SqlCommand(summaryQuery, connection))
                {
                    command.Parameters.AddWithValue("@UserID", userID);
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblAttempts.Text = Convert.ToString(reader["AttemptCount"]);
                            lblAverage.Text = Convert.ToDecimal(reader["AverageScore"]).ToString("0") + "%";
                            lblBest.Text = Convert.ToDecimal(reader["BestScore"]).ToString("0") + "%";
                        }
                    }
                }

                const string attemptsQuery = @"
                    SELECT TOP (20) a.AttemptID, a.Score, a.TotalQuestions,
                           a.Percentage, ISNULL(a.EndTime, a.StartTime) AS DateTaken,
                           q.QuizTitle, c.CourseTitle
                    FROM dbo.tblQuizAttempts AS a
                    INNER JOIN dbo.tblQuizzes AS q ON q.QuizID = a.QuizID
                    INNER JOIN dbo.Courses AS c ON c.CourseID = q.CourseID
                    WHERE a.UserID = @UserID
                    ORDER BY ISNULL(a.EndTime, a.StartTime) DESC, a.AttemptID DESC";

                using (SqlDataAdapter adapter = new SqlDataAdapter(attemptsQuery, connection))
                {
                    adapter.SelectCommand.Parameters.AddWithValue("@UserID", userID);
                    DataTable attempts = new DataTable();
                    adapter.Fill(attempts);
                    rptAttempts.DataSource = attempts;
                    rptAttempts.DataBind();
                    pnlEmpty.Visible = attempts.Rows.Count == 0;
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
