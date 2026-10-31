using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace StudySphere.Student.Quizzes
{
    public partial class ViewResult : System.Web.UI.Page
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
                LoadAttemptReview();
            }
        }

        private void LoadAttemptReview()
        {
            int attemptID;
            int userID;
            if (!int.TryParse(Request.QueryString["AttemptID"], out attemptID) || attemptID <= 0 ||
                !int.TryParse(Convert.ToString(Session["UserID"]), out userID))
            {
                ShowNotFound();
                return;
            }

            const string attemptQuery = @"
                SELECT a.QuizID, a.Score, a.TotalQuestions, a.Percentage,
                       q.QuizTitle, c.CourseTitle
                FROM dbo.tblQuizAttempts AS a
                INNER JOIN dbo.tblQuizzes AS q ON q.QuizID = a.QuizID
                INNER JOIN dbo.Courses AS c ON c.CourseID = q.CourseID
                WHERE a.AttemptID = @AttemptID AND a.UserID = @UserID";

            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand(attemptQuery, connection))
            {
                command.Parameters.AddWithValue("@AttemptID", attemptID);
                command.Parameters.AddWithValue("@UserID", userID);
                connection.Open();

                int quizID;
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        ShowNotFound();
                        return;
                    }

                    quizID = Convert.ToInt32(reader["QuizID"]);
                    lblCourse.Text = Server.HtmlEncode(Convert.ToString(reader["CourseTitle"]));
                    lblQuizTitle.Text = Server.HtmlEncode(Convert.ToString(reader["QuizTitle"]));
                    lblScoreSummary.Text = "Score: " + Convert.ToString(reader["Score"]) + " of " +
                        Convert.ToString(reader["TotalQuestions"]) + " correct (" +
                        Convert.ToDecimal(reader["Percentage"]).ToString("0") + "%).";
                }

                const string answersQuery = @"
                    SELECT question.QuestionText, answers.SelectedText, correct.CorrectText,
                           CASE WHEN answer.SelectedAnswer = question.CorrectAnswer THEN 1 ELSE 0 END AS IsCorrect
                    FROM dbo.tblQuestions AS question
                    INNER JOIN dbo.tblStudentAnswers AS answer
                        ON answer.QuestionID = question.QuestionID AND answer.AttemptID = @AttemptID
                    CROSS APPLY
                    (
                        SELECT CASE answer.SelectedAnswer
                            WHEN 'A' THEN question.OptionA WHEN 'B' THEN question.OptionB
                            WHEN 'C' THEN question.OptionC WHEN 'D' THEN question.OptionD END AS SelectedText
                    ) AS answers
                    CROSS APPLY
                    (
                        SELECT CASE question.CorrectAnswer
                            WHEN 'A' THEN question.OptionA WHEN 'B' THEN question.OptionB
                            WHEN 'C' THEN question.OptionC WHEN 'D' THEN question.OptionD END AS CorrectText
                    ) AS correct
                    WHERE question.QuizID = @QuizID
                    ORDER BY question.QuestionID";

                using (SqlDataAdapter adapter = new SqlDataAdapter(answersQuery, connection))
                {
                    adapter.SelectCommand.Parameters.AddWithValue("@AttemptID", attemptID);
                    adapter.SelectCommand.Parameters.AddWithValue("@QuizID", quizID);
                    DataTable answers = new DataTable();
                    adapter.Fill(answers);

                    if (answers.Rows.Count == 0)
                    {
                        ShowNotFound();
                        return;
                    }

                    rptAnswers.DataSource = answers;
                    rptAnswers.DataBind();
                }
            }
        }

        private void ShowNotFound()
        {
            pnlAnswers.Visible = false;
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
