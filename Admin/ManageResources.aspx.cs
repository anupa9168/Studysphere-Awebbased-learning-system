using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StudySphere.Admin
{
    public partial class ManageResources : Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["StudySphereDB"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminID"] == null) { Response.Redirect("~/Admin/AdminLogin.aspx"); return; }
            if (!IsPostBack) { LoadCourses(); LoadResources(); }
        }
        private void LoadCourses()
        {
            using (SqlConnection c = new SqlConnection(connectionString)) using (SqlCommand q = new SqlCommand("SELECT CourseID,CourseTitle FROM dbo.Courses ORDER BY CourseTitle", c))
            { c.Open(); ddlCourse.DataSource = q.ExecuteReader(); ddlCourse.DataTextField = "CourseTitle"; ddlCourse.DataValueField = "CourseID"; ddlCourse.DataBind(); }
        }
        private void LoadResources()
        {
            const string sql = "SELECT r.ResourceID,c.CourseTitle,r.ResourceType,r.Title,r.Content,r.ResourceUrl FROM dbo.CourseResources r INNER JOIN dbo.Courses c ON c.CourseID=r.CourseID ORDER BY c.CourseTitle,r.ResourceType,r.Title";
            using (SqlDataAdapter a = new SqlDataAdapter(sql, connectionString)) { DataTable t = new DataTable(); a.Fill(t); gvResources.DataSource = t; gvResources.DataBind(); }
        }
        protected void ddlType_SelectedIndexChanged(object s, EventArgs e) { }
        protected void btnLogout_Click(object s, EventArgs e) { Session.Clear(); Session.Abandon(); Response.Redirect("~/Admin/AdminLogin.aspx"); }
        protected void btnAdd_Click(object s, EventArgs e)
        {
            int courseId; if (!Int32.TryParse(ddlCourse.SelectedValue, out courseId)) { Message("Add a course before adding resources."); return; }
            string title = txtTitle.Text.Trim(), content = txtContent.Text.Trim(), url = txtUrl.Text.Trim();
            if (title.Length == 0 || content.Length == 0) { Message("Title and notes/description are required."); return; }
            if (!ValidUrl(url) || (ddlType.SelectedValue == "Video" && !ValidYouTubeUrl(url))) { Message("Notes may use HTTPS links. Video tutorials need a YouTube HTTPS link."); return; }
            using (SqlConnection c = new SqlConnection(connectionString)) using (SqlCommand q = new SqlCommand("INSERT INTO dbo.CourseResources(CourseID,ResourceType,Title,Content,ResourceUrl) VALUES(@course,@type,@title,@content,@url)", c))
            { q.Parameters.AddWithValue("@course", courseId); q.Parameters.AddWithValue("@type", ddlType.SelectedValue); q.Parameters.Add("@title", SqlDbType.NVarChar, 160).Value = title; q.Parameters.Add("@content", SqlDbType.NVarChar, -1).Value = content; q.Parameters.Add("@url", SqlDbType.NVarChar, 500).Value = url.Length == 0 ? (object)DBNull.Value : url; c.Open();
                try { q.ExecuteNonQuery(); } catch (SqlException ex) { Message(ex.Number == 2627 || ex.Number == 2601 ? "That title already exists for this course and resource type." : "Resource could not be saved."); return; } }
            txtTitle.Text = txtContent.Text = txtUrl.Text = ""; Message("Resource added to the course learning page."); LoadResources();
        }
        protected void gvResources_RowEditing(object s, GridViewEditEventArgs e) { gvResources.EditIndex = e.NewEditIndex; LoadResources(); }
        protected void gvResources_RowCancelingEdit(object s, GridViewCancelEditEventArgs e) { gvResources.EditIndex = -1; LoadResources(); }
        protected void gvResources_RowUpdating(object s, GridViewUpdateEventArgs e)
        {
            GridViewRow r = gvResources.Rows[e.RowIndex]; int id = Convert.ToInt32(gvResources.DataKeys[e.RowIndex].Value);
            string title = EditValue(r, 3), content = EditValue(r, 4), url = EditValue(r, 5);
            if (title.Length == 0 || content.Length == 0) { Message("Title and content cannot be empty."); return; }
            string type = Server.HtmlDecode(r.Cells[2].Text).Trim();
            if (!ValidUrl(url) || (type == "Video" && !ValidYouTubeUrl(url))) { Message("Notes may use HTTPS links. Video tutorials need a YouTube HTTPS link."); return; }
            using (SqlConnection c = new SqlConnection(connectionString)) using (SqlCommand q = new SqlCommand("UPDATE dbo.CourseResources SET Title=@title,Content=@content,ResourceUrl=@url WHERE ResourceID=@id", c))
            { q.Parameters.AddWithValue("@title", title); q.Parameters.AddWithValue("@content", content); q.Parameters.Add("@url", SqlDbType.NVarChar, 500).Value = url.Length == 0 ? (object)DBNull.Value : url; q.Parameters.AddWithValue("@id", id); c.Open(); q.ExecuteNonQuery(); }
            gvResources.EditIndex = -1; Message("Resource updated."); LoadResources();
        }
        protected void gvResources_RowDeleting(object s, GridViewDeleteEventArgs e)
        { int id = Convert.ToInt32(gvResources.DataKeys[e.RowIndex].Value); using (SqlConnection c = new SqlConnection(connectionString)) using (SqlCommand q = new SqlCommand("DELETE FROM dbo.CourseResources WHERE ResourceID=@id", c)) { q.Parameters.AddWithValue("@id", id); c.Open(); q.ExecuteNonQuery(); } Message("Resource deleted."); LoadResources(); }
        private string EditValue(GridViewRow r, int n) { TextBox t = r.Cells[n].Controls[0] as TextBox; return t == null ? "" : t.Text.Trim(); }
        private bool ValidUrl(string url) { if (url.Length == 0) return true; Uri parsed; return Uri.TryCreate(url, UriKind.Absolute, out parsed) && parsed.Scheme == Uri.UriSchemeHttps; }
        private bool ValidYouTubeUrl(string url) { Uri parsed; return Uri.TryCreate(url, UriKind.Absolute, out parsed) && parsed.Scheme == Uri.UriSchemeHttps && (parsed.Host == "youtube.com" || parsed.Host == "www.youtube.com" || parsed.Host == "youtu.be"); }
        private void Message(string value) { lblMessage.Text = Server.HtmlEncode(value); }
    }
}
