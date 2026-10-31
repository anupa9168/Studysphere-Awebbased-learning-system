using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace StudySphere.Student.Quizzes
{
    public partial class QuizPage : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings["StudySphereDB"].ConnectionString;

        protected void Page_Init(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Student/Login.aspx");
                return;
            }

            LoadQuiz();
        }

        private void LoadQuiz()
        {
            int quizID;
            if (!int.TryParse(Request.QueryString["QuizID"], out quizID) || quizID <= 0)
            {
                ShowQuizNotFound();
                return;
            }

            const string quizQuery = @"
                SELECT q.QuizTitle, q.Description, c.CourseTitle
                FROM tblQuizzes q
                INNER JOIN Courses c ON c.CourseID = q.CourseID
                WHERE q.QuizID = @QuizID";

            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand(quizQuery, connection))
            {
                command.Parameters.AddWithValue("@QuizID", quizID);
                connection.Open();

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        ShowQuizNotFound();
                        return;
                    }

                    lblCourse.Text = Server.HtmlEncode(Convert.ToString(reader["CourseTitle"]));
                    lblQuizTitle.Text = Server.HtmlEncode(Convert.ToString(reader["QuizTitle"]));
                    lblDescription.Text = Server.HtmlEncode(Convert.ToString(reader["Description"]));
                }
            }

            const string questionQuery = @"
                SELECT QuestionID, QuestionText, OptionA, OptionB, OptionC, OptionD
                FROM tblQuestions
                WHERE QuizID = @QuizID
                ORDER BY QuestionID";

            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlDataAdapter adapter = new SqlDataAdapter(questionQuery, connection))
            {
                adapter.SelectCommand.Parameters.AddWithValue("@QuizID", quizID);
                DataTable questions = new DataTable();
                adapter.Fill(questions);

                if (questions.Rows.Count == 0)
                {
                    ShowQuizNotFound();
                    return;
                }

                rptQuestions.DataSource = questions;
                rptQuestions.DataBind();
            }
        }

        protected void rptQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            {
                return;
            }

            DataRowView question = e.Item.DataItem as DataRowView;
            RadioButtonList options = e.Item.FindControl("rblOptions") as RadioButtonList;
            if (question == null || options == null || options.Items.Count != 4)
            {
                return;
            }

            options.Items[0].Text = Server.HtmlEncode(Convert.ToString(question["OptionA"]));
            options.Items[1].Text = Server.HtmlEncode(Convert.ToString(question["OptionB"]));
            options.Items[2].Text = Server.HtmlEncode(Convert.ToString(question["OptionC"]));
            options.Items[3].Text = Server.HtmlEncode(Convert.ToString(question["OptionD"]));
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int quizID;
            int userID;
            if (!int.TryParse(Request.QueryString["QuizID"], out quizID) ||
                !int.TryParse(Convert.ToString(Session["UserID"]), out userID))
            {
                ShowQuizNotFound();
                return;
            }

            Dictionary<int, string> correctAnswers = LoadCorrectAnswers(quizID);
            if (correctAnswers.Count == 0)
            {
                ShowQuizNotFound();
                return;
            }

            int correctCount = 0;
            Dictionary<int, string> studentAnswers = new Dictionary<int, string>();
            foreach (RepeaterItem item in rptQuestions.Items)
            {
                HiddenField questionField = item.FindControl("hidQuestionId") as HiddenField;
                RadioButtonList options = item.FindControl("rblOptions") as RadioButtonList;
                int questionID;

                if (questionField == null || options == null ||
                    !int.TryParse(questionField.Value, out questionID) ||
                    !correctAnswers.ContainsKey(questionID) ||
                    studentAnswers.ContainsKey(questionID))
                {
                    ShowQuizNotFound();
                    return;
                }

                string selectedAnswer = options.SelectedValue;
                if (string.IsNullOrEmpty(selectedAnswer))
                {
                    lblMessage.Text = "Please select an answer for every question.";
                    lblMessage.Visible = true;
                    return;
                }

                studentAnswers.Add(questionID, selectedAnswer);

                if (string.Equals(selectedAnswer, correctAnswers[questionID], StringComparison.OrdinalIgnoreCase))
                {
                    correctCount++;
                }
            }

            if (studentAnswers.Count != correctAnswers.Count)
            {
                lblMessage.Text = "The quiz questions changed. Please reload and try again.";
                lblMessage.Visible = true;
                return;
            }

            int percentage = (int)Math.Round(correctCount * 100.0 / correctAnswers.Count, MidpointRounding.AwayFromZero);
            const string nextAttemptQuery = @"
                SELECT ISNULL(MAX(AttemptNumber), 0) + 1
                FROM dbo.tblQuizAttempts WITH (UPDLOCK, HOLDLOCK)
                WHERE UserID = @UserID AND QuizID = @QuizID";
            const string insertAttemptQuery = @"
                INSERT INTO dbo.tblQuizAttempts
                    (UserID, QuizID, AttemptNumber, StartTime, EndTime, Score, TotalQuestions, Percentage)
                VALUES
                    (@UserID, @QuizID, @AttemptNumber, GETDATE(), GETDATE(), @Score, @TotalQuestions, @Percentage);
                SELECT CAST(SCOPE_IDENTITY() AS INT)";
            const string insertAnswerQuery = @"
                INSERT INTO dbo.tblStudentAnswers (AttemptID, QuestionID, SelectedAnswer)
                VALUES (@AttemptID, @QuestionID, @SelectedAnswer)";

            int attemptID;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (SqlTransaction transaction = connection.BeginTransaction())
                {
                    int attemptNumber;
                    using (SqlCommand command = new SqlCommand(nextAttemptQuery, connection, transaction))
                    {
                        command.Parameters.AddWithValue("@UserID", userID);
                        command.Parameters.AddWithValue("@QuizID", quizID);
                        attemptNumber = Convert.ToInt32(command.ExecuteScalar());
                    }

                    using (SqlCommand command = new SqlCommand(insertAttemptQuery, connection, transaction))
                    {
                        command.Parameters.AddWithValue("@UserID", userID);
                        command.Parameters.AddWithValue("@QuizID", quizID);
                        command.Parameters.AddWithValue("@AttemptNumber", attemptNumber);
                        command.Parameters.AddWithValue("@Score", correctCount);
                        command.Parameters.AddWithValue("@TotalQuestions", correctAnswers.Count);
                        command.Parameters.AddWithValue("@Percentage", percentage);
                        attemptID = Convert.ToInt32(command.ExecuteScalar());
                    }

                    foreach (KeyValuePair<int, string> answer in studentAnswers)
                    {
                        using (SqlCommand command = new SqlCommand(insertAnswerQuery, connection, transaction))
                        {
                            command.Parameters.AddWithValue("@AttemptID", attemptID);
                            command.Parameters.AddWithValue("@QuestionID", answer.Key);
                            command.Parameters.AddWithValue("@SelectedAnswer", answer.Value);
                            command.ExecuteNonQuery();
                        }
                    }

                    transaction.Commit();
                }
            }

            Response.Redirect("~/Student/Quizzes/QuizResult.aspx?AttemptID=" + attemptID, false);
            Context.ApplicationInstance.CompleteRequest();
        }

        private Dictionary<int, string> LoadCorrectAnswers(int quizID)
        {
            const string query = @"
                SELECT QuestionID, CorrectAnswer
                FROM tblQuestions
                WHERE QuizID = @QuizID";

            Dictionary<int, string> answers = new Dictionary<int, string>();
            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@QuizID", quizID);
                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        answers[Convert.ToInt32(reader["QuestionID"])] =
                            Convert.ToString(reader["CorrectAnswer"]);
                    }
                }
            }

            return answers;
        }

        private void ShowQuizNotFound()
        {
            pnlQuiz.Visible = false;
            lblNotFound.Visible = true;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Student/Login.aspx");
        }
    }
}
