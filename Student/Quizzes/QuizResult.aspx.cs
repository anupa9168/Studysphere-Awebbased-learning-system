using System;
using System.Configuration;
using System.Data.SqlClient;

namespace StudySphere.Student.Quizzes
{
    public partial class QuizResult : System.Web.UI.Page
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
                LoadResult();
            }
        }

        private void LoadResult()
        {
            int attemptID;
            int userID;
            if (!int.TryParse(Request.QueryString["AttemptID"], out attemptID) || attemptID <= 0 ||
                !int.TryParse(Convert.ToString(Session["UserID"]), out userID))
            {
                ShowNotFound();
                return;
            }

            const string query = @"
                SELECT a.AttemptNumber, a.Score, a.TotalQuestions, a.Percentage,
                       ISNULL(a.EndTime, a.StartTime) AS DateTaken,
                       q.QuizTitle, c.CourseTitle
                FROM dbo.tblQuizAttempts AS a
                INNER JOIN dbo.tblQuizzes AS q ON q.QuizID = a.QuizID
                INNER JOIN dbo.Courses AS c ON c.CourseID = q.CourseID
                WHERE a.AttemptID = @AttemptID AND a.UserID = @UserID";

            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@AttemptID", attemptID);
                command.Parameters.AddWithValue("@UserID", userID);
                connection.Open();

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        ShowNotFound();
                        return;
                    }

                    lblCourse.Text = Server.HtmlEncode(Convert.ToString(reader["CourseTitle"]));
                    lblQuizTitle.Text = Server.HtmlEncode(Convert.ToString(reader["QuizTitle"]));
                    lblScore.Text = Convert.ToDecimal(reader["Percentage"]).ToString("0") + "%";
                    lblCorrectAnswers.Text = Convert.ToString(reader["Score"]) + " of " +
                        Convert.ToString(reader["TotalQuestions"]);
                    lblAttemptNumber.Text = Convert.ToString(reader["AttemptNumber"]);
                    lblDateTaken.Text = Convert.ToDateTime(reader["DateTaken"])
                        .ToString("dd MMM yyyy, h:mm tt");
                }
            }
        }

        private void ShowNotFound()
        {
            pnlResult.Visible = false;
            pnlNotFound.Visible = true;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Student/Login.aspx");
        }
    }
}
