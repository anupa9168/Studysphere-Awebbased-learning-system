using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace StudySphere.Student.Quizzes
{
    public partial class Quizzes : System.Web.UI.Page
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
                LoadQuizzes();
            }
        }

        private void LoadQuizzes()
        {
            const string query = @"
                SELECT q.QuizID, q.QuizTitle, q.Description,
                       c.CourseTitle, COUNT(question.QuestionID) AS QuestionCount
                FROM tblQuizzes q
                INNER JOIN Courses c ON c.CourseID = q.CourseID
                LEFT JOIN tblQuestions question ON question.QuizID = q.QuizID
                GROUP BY q.QuizID, q.QuizTitle, q.Description, c.CourseTitle
                ORDER BY c.CourseTitle, q.QuizTitle";

            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlDataAdapter adapter = new SqlDataAdapter(query, connection))
            {
                DataTable quizzes = new DataTable();
                adapter.Fill(quizzes);
                rptQuizzes.DataSource = quizzes;
                rptQuizzes.DataBind();
                pnlEmpty.Visible = quizzes.Rows.Count == 0;
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
