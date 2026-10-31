using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StudySphere.Admin
{
    public partial class ManageQuizzes : Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["StudySphereDB"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminID"] == null) { Response.Redirect("~/Admin/AdminLogin.aspx"); return; }
            if (!IsPostBack) { LoadCourses(); LoadQuizChoices(); LoadQuizzes(); LoadQuestions(); }
        }
        private void LoadCourses()
        {
            using (SqlConnection c = new SqlConnection(connectionString)) using (SqlCommand q = new SqlCommand("SELECT CourseID,CourseTitle FROM dbo.Courses ORDER BY CourseTitle", c))
            { c.Open(); ddlCourse.DataSource = q.ExecuteReader(); ddlCourse.DataTextField = "CourseTitle"; ddlCourse.DataValueField = "CourseID"; ddlCourse.DataBind(); }
        }
        private void LoadQuizChoices()
        {
            string selected = ddlQuiz.SelectedValue;
            using (SqlConnection c = new SqlConnection(connectionString)) using (SqlCommand q = new SqlCommand("SELECT QuizID,QuizTitle FROM dbo.tblQuizzes ORDER BY QuizTitle", c))
            { c.Open(); ddlQuiz.DataSource = q.ExecuteReader(); ddlQuiz.DataTextField = "QuizTitle"; ddlQuiz.DataValueField = "QuizID"; ddlQuiz.DataBind(); }
            if (ddlQuiz.Items.FindByValue(selected) != null) ddlQuiz.SelectedValue = selected;
        }
        private void LoadQuizzes()
        {
            const string sql = @"SELECT q.QuizID,c.CourseTitle,q.QuizTitle,q.Description,COUNT(question.QuestionID) AS QuestionCount
                FROM dbo.tblQuizzes q INNER JOIN dbo.Courses c ON c.CourseID=q.CourseID LEFT JOIN dbo.tblQuestions question ON question.QuizID=q.QuizID
                GROUP BY q.QuizID,c.CourseTitle,q.QuizTitle,q.Description ORDER BY c.CourseTitle,q.QuizTitle";
            using (SqlDataAdapter a = new SqlDataAdapter(sql, connectionString)) { DataTable t = new DataTable(); a.Fill(t); gvQuizzes.DataSource = t; gvQuizzes.DataBind(); }
        }
        private void LoadQuestions()
        {
            int id; if (!Int32.TryParse(ddlQuiz.SelectedValue, out id)) { gvQuestions.DataSource = null; gvQuestions.DataBind(); return; }
            using (SqlCommand q = new SqlCommand(@"SELECT question.QuestionID, quiz.QuizTitle,
                    question.QuestionText, question.CorrectAnswer
                FROM dbo.tblQuestions AS question
                INNER JOIN dbo.tblQuizzes AS quiz ON quiz.QuizID = question.QuizID
                WHERE question.QuizID = @id
                ORDER BY question.QuestionID", new SqlConnection(connectionString)))
            { q.Parameters.AddWithValue("@id", id); using (SqlDataAdapter a = new SqlDataAdapter(q)) { DataTable t = new DataTable(); a.Fill(t); gvQuestions.DataSource = t; gvQuestions.DataBind(); } }
        }
        protected void btnAddQuiz_Click(object s, EventArgs e)
        {
            int course; if (!Int32.TryParse(ddlCourse.SelectedValue, out course)) { Message("Add a course before creating a quiz."); return; }
            if (String.IsNullOrWhiteSpace(txtQuizTitle.Text)) { Message("Quiz title is required."); return; }
            using (SqlConnection c = new SqlConnection(connectionString)) using (SqlCommand q = new SqlCommand("INSERT INTO dbo.tblQuizzes(CourseID,QuizTitle,Description) VALUES(@course,@title,@description)", c))
            { q.Parameters.AddWithValue("@course", course); q.Parameters.Add("@title", SqlDbType.VarChar, 100).Value = txtQuizTitle.Text.Trim(); q.Parameters.Add("@description", SqlDbType.VarChar, 255).Value = String.IsNullOrWhiteSpace(txtDescription.Text) ? (object)DBNull.Value : txtDescription.Text.Trim(); c.Open();
                try { q.ExecuteNonQuery(); } catch (SqlException ex) { Message(ex.Number == 2627 || ex.Number == 2601 ? "A quiz with this title already exists for this course." : "Quiz could not be created."); return; } }
            txtQuizTitle.Text = txtDescription.Text = ""; LoadQuizChoices(); LoadQuizzes(); LoadQuestions(); Message("Quiz created.");
        }
        protected void btnAddQuestion_Click(object s, EventArgs e)
        {
            int quiz; if (!Int32.TryParse(ddlQuiz.SelectedValue, out quiz)) { Message("Create a quiz first."); return; }
            string[] values = { txtQuestion.Text.Trim(), txtOptionA.Text.Trim(), txtOptionB.Text.Trim(), txtOptionC.Text.Trim(), txtOptionD.Text.Trim() };
            foreach (string value in values) if (String.IsNullOrWhiteSpace(value)) { Message("Enter the question and all four answer options."); return; }
            using (SqlConnection c = new SqlConnection(connectionString)) using (SqlCommand q = new SqlCommand("INSERT INTO dbo.tblQuestions(QuizID,QuestionText,OptionA,OptionB,OptionC,OptionD,CorrectAnswer) VALUES(@quiz,@question,@a,@b,@c,@d,@answer)", c))
            { q.Parameters.AddWithValue("@quiz", quiz); q.Parameters.Add("@question", SqlDbType.VarChar, 500).Value = values[0]; q.Parameters.Add("@a", SqlDbType.VarChar, 255).Value = values[1]; q.Parameters.Add("@b", SqlDbType.VarChar, 255).Value = values[2]; q.Parameters.Add("@c", SqlDbType.VarChar, 255).Value = values[3]; q.Parameters.Add("@d", SqlDbType.VarChar, 255).Value = values[4]; q.Parameters.Add("@answer", SqlDbType.Char, 1).Value = ddlAnswer.SelectedValue; c.Open(); q.ExecuteNonQuery(); }
            txtQuestion.Text = txtOptionA.Text = txtOptionB.Text = txtOptionC.Text = txtOptionD.Text = ""; LoadQuestions(); LoadQuizzes(); Message("Question added.");
        }
        protected void ddlQuiz_SelectedIndexChanged(object s, EventArgs e) { LoadQuestions(); }
        protected void gvQuizzes_RowEditing(object s, GridViewEditEventArgs e) { gvQuizzes.EditIndex = e.NewEditIndex; LoadQuizzes(); }
        protected void gvQuizzes_RowCancelingEdit(object s, GridViewCancelEditEventArgs e) { gvQuizzes.EditIndex = -1; LoadQuizzes(); }
        protected void gvQuizzes_RowUpdating(object s, GridViewUpdateEventArgs e)
        {
            int id = Convert.ToInt32(gvQuizzes.DataKeys[e.RowIndex].Value); GridViewRow r = gvQuizzes.Rows[e.RowIndex];
            string title = EditValue(r, 2), description = EditValue(r, 3); if (String.IsNullOrWhiteSpace(title)) { Message("Quiz title is required."); return; }
            using (SqlConnection c = new SqlConnection(connectionString)) using (SqlCommand q = new SqlCommand("UPDATE dbo.tblQuizzes SET QuizTitle=@title,Description=@description WHERE QuizID=@id", c))
            { q.Parameters.AddWithValue("@title", title); q.Parameters.Add("@description", SqlDbType.VarChar, 255).Value = String.IsNullOrWhiteSpace(description) ? (object)DBNull.Value : description; q.Parameters.AddWithValue("@id", id); c.Open(); q.ExecuteNonQuery(); }
            gvQuizzes.EditIndex = -1; LoadQuizzes(); LoadQuizChoices(); LoadQuestions(); Message("Quiz updated.");
        }
        protected void gvQuizzes_RowDeleting(object s, GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(gvQuizzes.DataKeys[e.RowIndex].Value);
            try { using (SqlConnection c = new SqlConnection(connectionString)) { c.Open(); using (SqlTransaction tr = c.BeginTransaction()) { using (SqlCommand q1 = new SqlCommand("DELETE FROM dbo.tblQuestions WHERE QuizID=@id", c, tr)) { q1.Parameters.AddWithValue("@id", id); q1.ExecuteNonQuery(); } using (SqlCommand q2 = new SqlCommand("DELETE FROM dbo.tblQuizzes WHERE QuizID=@id", c, tr)) { q2.Parameters.AddWithValue("@id", id); q2.ExecuteNonQuery(); } tr.Commit(); } } Message("Quiz deleted."); }
            catch (SqlException) { Message("This quiz has saved student attempts and cannot be deleted."); }
            LoadQuizzes(); LoadQuizChoices(); LoadQuestions();
        }
        protected void gvQuestions_RowDeleting(object s, GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(gvQuestions.DataKeys[e.RowIndex].Value);
            try { using (SqlConnection c = new SqlConnection(connectionString)) using (SqlCommand q = new SqlCommand("DELETE FROM dbo.tblQuestions WHERE QuestionID=@id", c)) { q.Parameters.AddWithValue("@id", id); c.Open(); q.ExecuteNonQuery(); } Message("Question deleted."); }
            catch (SqlException) { Message("This question is part of saved student results and cannot be deleted."); }
            LoadQuestions(); LoadQuizzes();
        }
        private string EditValue(GridViewRow r, int i) { TextBox t = r.Cells[i].Controls[0] as TextBox; return t == null ? "" : t.Text.Trim(); }
        private void Message(string text) { lblMessage.Text = Server.HtmlEncode(text); }
        protected void btnLogout_Click(object sender, EventArgs e) { Session.Clear(); Session.Abandon(); Response.Redirect("~/Admin/AdminLogin.aspx"); }
    }
}
