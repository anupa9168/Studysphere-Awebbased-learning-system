using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace StudySphere.Student
{
    public partial class CoursesPage : System.Web.UI.Page
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
                LoadCourses();
            }
        }

        private void LoadCourses()
        {
            const string query = @"
                SELECT CourseID, CourseTitle, Category, Level, Description
                FROM Courses
                ORDER BY CourseTitle";

            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlDataAdapter adapter = new SqlDataAdapter(query, connection))
            {
                DataTable courses = new DataTable();
                adapter.Fill(courses);

                rptCourses.DataSource = courses;
                rptCourses.DataBind();
                lblNoCourses.Visible = courses.Rows.Count == 0;
            }
        }

        protected string GetCourseIcon(string category)
        {
            switch (category)
            {
                case "Web Development":
                    return "<svg viewBox='0 0 24 24' aria-hidden='true'><rect x='3' y='4' width='18' height='16' rx='2'/><path d='M3 9h18M7 6.5h.01M10 6.5h.01'/></svg>";
                case "Programming":
                    return "<svg viewBox='0 0 24 24' aria-hidden='true'><path d='m8 8-4 4 4 4m8-8 4 4-4 4m-3-10-2 12'/></svg>";
                case "Database":
                    return "<svg viewBox='0 0 24 24' aria-hidden='true'><ellipse cx='12' cy='5' rx='8' ry='3'/><path d='M4 5v14c0 1.7 3.6 3 8 3s8-1.3 8-3V5M4 12c0 1.7 3.6 3 8 3s8-1.3 8-3'/></svg>";
                case "Networking":
                    return "<svg viewBox='0 0 24 24' aria-hidden='true'><circle cx='12' cy='5' r='2.5'/><circle cx='5' cy='18' r='2.5'/><circle cx='19' cy='18' r='2.5'/><path d='m10.7 7.2-4.4 8.6m7-8.6 4.4 8.6M7.5 18h9'/></svg>";
                case "Software Development":
                    return "<svg viewBox='0 0 24 24' aria-hidden='true'><path d='m8 8-4 4 4 4m8-8 4 4-4 4m-3-10-2 12'/><circle cx='12' cy='12' r='10'/></svg>";
                case "Design":
                    return "<svg viewBox='0 0 24 24' aria-hidden='true'><path d='m12 19 7-7 2 2-7 7-3 1 1-3ZM16 8l3 3M4 20h5M5 4h8l6 6M5 4v12'/></svg>";
                case "Security":
                    return "<svg viewBox='0 0 24 24' aria-hidden='true'><path d='M12 22s8-4 8-11V5l-8-3-8 3v6c0 7 8 11 8 11Z'/><path d='m9 12 2 2 4-4'/></svg>";
                default:
                    return "<svg viewBox='0 0 24 24' aria-hidden='true'><path d='M12 7v14M12 7C10.5 5.8 8.7 5 6.5 5S3 5.8 3 7v11c0-1.2 1.5-2 3.5-2s3.8.8 5.5 2c1.7-1.2 3.5-2 5.5-2s3.5.8 3.5 2V7c0-1.2-1.5-2-3.5-2S13.5 5.8 12 7Z'/></svg>";
            }
        }

        protected void btnViewCourse_Command(object sender, CommandEventArgs e)
        {
            int courseID;
            if (int.TryParse(Convert.ToString(e.CommandArgument), out courseID) && courseID > 0)
            {
                Response.Redirect("CourseDetails.aspx?CourseID=" + courseID);
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
