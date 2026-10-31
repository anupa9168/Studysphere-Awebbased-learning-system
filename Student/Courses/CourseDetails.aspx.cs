
using System;
using System.Configuration;
using System.Data.SqlClient;

namespace StudySphere.Student
{
    public partial class CourseDetails : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings["StudySphereDB"].ConnectionString;


        protected string Category { get; set; }


        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Student/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCourseDetails();
            }
        }


        private void LoadCourseDetails()
        {
            int courseID;

            // Check CourseID from URL
            if (!int.TryParse(
                Request.QueryString["CourseID"],
                out courseID))
            {
                ShowCourseNotFound();
                return;
            }


            // SQL query
            string query = @"
                SELECT
                    CourseTitle,
                    Category,
                    Level,
                    Description
                FROM Courses
                WHERE CourseID = @CourseID";


            using (SqlConnection con =
                new SqlConnection(connectionString))

            using (SqlCommand cmd =
                new SqlCommand(query, con))
            {
                // Add CourseID parameter
                cmd.Parameters.AddWithValue(
                    "@CourseID",
                    courseID);


                con.Open();


                using (SqlDataReader reader =
                    cmd.ExecuteReader())
                {
                    // Course found
                    if (reader.Read())
                    {
                        // Course title
                        lblCourseTitle.Text =
                            Server.HtmlEncode(Convert.ToString(reader["CourseTitle"]));


                        // Category
                        Category =
                            reader["Category"].ToString();

                        lblCategory.Text =
                            Server.HtmlEncode(Category);


                        // Course icon
                        lblCourseIcon.Text =
                            GetCourseIcon(Category);


                        // Level
                        lblLevel.Text =
                            Server.HtmlEncode(Convert.ToString(reader["Level"]));


                        // Description
                        lblDescription.Text =
                            Server.HtmlEncode(Convert.ToString(reader["Description"]));
                    }

                    // Course not found
                    else
                    {
                        ShowCourseNotFound();
                    }
                }
            }
        }


        // Display message when course does not exist
        private void ShowCourseNotFound()
        {
            lblCourseIcon.Visible = false;

            lblCourseTitle.Visible = false;

            lblCategory.Visible = false;

            lblLevel.Visible = false;

            lblDescription.Visible = false;

            btnStartLearning.Visible = false;

            lblCourseNotFound.Visible = true;
        }


        // Return icon based on course category
        protected string GetCourseIcon(string category)
        {
            switch (category)
            {
                case "Web Development":
                    return "🌐";

                case "Programming":
                    return "💻";

                case "Database":
                    return "🗄️";

                case "Networking":
                    return "📡";

                case "Software Development":
                    return "⚙️";

                case "Design":
                    return "🎨";

                case "Security":
                    return "🔐";

                default:
                    return "📚";
            }
        }


        // Start Learning button
        protected void btnStartLearning_Click(
            object sender,
            EventArgs e)
        {
            int courseID;


            if (int.TryParse(
                Request.QueryString["CourseID"],
                out courseID))
            {
                Response.Redirect(
                    "Learning.aspx?CourseID=" + courseID);
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
