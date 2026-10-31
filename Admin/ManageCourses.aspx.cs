using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StudySphere.Admin
{
    public partial class ManageCourses : Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["StudySphereDB"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminID"] == null) { Response.Redirect("~/Admin/AdminLogin.aspx"); return; }
            if (!IsPostBack) LoadCourses();
        }
        private void LoadCourses()
        {
            using (SqlDataAdapter a = new SqlDataAdapter("SELECT CourseID,CourseTitle,Category,Level,Description FROM dbo.Courses ORDER BY CourseTitle", connectionString))
            { DataTable t = new DataTable(); a.Fill(t); gvCourses.DataSource = t; gvCourses.DataBind(); }
        }
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (String.IsNullOrWhiteSpace(txtTitle.Text) || String.IsNullOrWhiteSpace(txtCategory.Text) || String.IsNullOrWhiteSpace(txtDescription.Text)) { Message("Complete all course fields."); return; }
            if (txtTitle.Text.Trim().Length > 100 || txtCategory.Text.Trim().Length > 50 || txtDescription.Text.Trim().Length > 500) { Message("Title, category, or description exceeds its maximum length."); return; }
            try
            {
                using (SqlConnection c = new SqlConnection(connectionString)) using (SqlCommand q = new SqlCommand("INSERT INTO dbo.Courses(CourseTitle,Category,Level,Description) VALUES(@t,@c,@l,@d)", c))
                { q.Parameters.Add("@t", SqlDbType.VarChar, 100).Value = txtTitle.Text.Trim(); q.Parameters.Add("@c", SqlDbType.VarChar, 60).Value = txtCategory.Text.Trim(); q.Parameters.Add("@l", SqlDbType.VarChar, 30).Value = ddlLevel.SelectedValue; q.Parameters.Add("@d", SqlDbType.VarChar, 1000).Value = txtDescription.Text.Trim(); c.Open(); q.ExecuteNonQuery(); }
                txtTitle.Text = txtCategory.Text = txtDescription.Text = ""; Message("Course added."); LoadCourses();
            }
            catch (SqlException ex) { Message(ex.Number == 2627 || ex.Number == 2601 ? "A course with that title already exists." : "Course could not be saved. Check the field values and database constraints."); }
        }
        protected void gvCourses_RowEditing(object s, GridViewEditEventArgs e) { gvCourses.EditIndex = e.NewEditIndex; LoadCourses(); }
        protected void gvCourses_RowCancelingEdit(object s, GridViewCancelEditEventArgs e) { gvCourses.EditIndex = -1; LoadCourses(); }
        protected void gvCourses_RowUpdating(object s, GridViewUpdateEventArgs e)
        {
            GridViewRow r = gvCourses.Rows[e.RowIndex]; int id = Convert.ToInt32(gvCourses.DataKeys[e.RowIndex].Value);
            string title = EditValue(r, 1), category = EditValue(r, 2), level = EditValue(r, 3), description = EditValue(r, 4);
            if (String.IsNullOrWhiteSpace(title) || String.IsNullOrWhiteSpace(category) || String.IsNullOrWhiteSpace(level) || String.IsNullOrWhiteSpace(description)) { Message("Course fields cannot be empty."); return; }
            if (title.Length > 100 || category.Length > 50 || level.Length > 50 || description.Length > 500) { Message("Title, category, level, or description exceeds its database limit."); return; }
            using (SqlConnection c = new SqlConnection(connectionString)) using (SqlCommand q = new SqlCommand("UPDATE dbo.Courses SET CourseTitle=@t,Category=@c,Level=@l,Description=@d WHERE CourseID=@id", c))
            { q.Parameters.AddWithValue("@t", title); q.Parameters.AddWithValue("@c", category); q.Parameters.AddWithValue("@l", level); q.Parameters.AddWithValue("@d", description); q.Parameters.AddWithValue("@id", id); c.Open(); q.ExecuteNonQuery(); }
            gvCourses.EditIndex = -1; Message("Course updated."); LoadCourses();
        }
        protected void gvCourses_RowDeleting(object s, GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(gvCourses.DataKeys[e.RowIndex].Value);
            try { using (SqlConnection c = new SqlConnection(connectionString)) using (SqlCommand q = new SqlCommand("DELETE FROM dbo.Courses WHERE CourseID=@id", c)) { q.Parameters.AddWithValue("@id", id); c.Open(); q.ExecuteNonQuery(); } Message("Course deleted."); }
            catch (SqlException) { Message("This course is in use by resources, quizzes, or student records. Remove those links before deleting it."); }
            LoadCourses();
        }
        private string EditValue(GridViewRow r, int cell) { TextBox t = r.Cells[cell].Controls[0] as TextBox; return t == null ? "" : t.Text.Trim(); }
        private void Message(string text) { lblMessage.Text = Server.HtmlEncode(text); }
        protected void btnLogout_Click(object sender, EventArgs e) { Session.Clear(); Session.Abandon(); Response.Redirect("~/Admin/AdminLogin.aspx"); }
    }
}
