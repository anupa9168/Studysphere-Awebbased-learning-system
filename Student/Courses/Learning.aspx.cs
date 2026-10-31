using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace StudySphere.Student.Courses
{
    public partial class Learning : System.Web.UI.Page
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
                LoadCourse();
        }

        private void LoadCourse()
        {
            int courseID;
            if (!int.TryParse(Request.QueryString["CourseID"], out courseID) || courseID <= 0)
            {
                ShowCourseNotFound();
                return;
            }

            const string query = @"
                SELECT CourseTitle, Category, Level, Description
                FROM dbo.Courses
                WHERE CourseID = @CourseID";

            string courseTitle;
            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@CourseID", courseID);
                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        ShowCourseNotFound();
                        return;
                    }

                    courseTitle = Convert.ToString(reader["CourseTitle"]);
                    lblCourseTitle.Text = Server.HtmlEncode(courseTitle);
                    lblCategory.Text = Server.HtmlEncode(Convert.ToString(reader["Category"]));
                    lblLevel.Text = Server.HtmlEncode(Convert.ToString(reader["Level"]));
                    lblDescription.Text = Server.HtmlEncode(Convert.ToString(reader["Description"]));
                }
            }

            LoadMaterials(courseID, courseTitle);
        }

        private void LoadMaterials(int courseID, string courseTitle)
        {
            const string query = @"
                SELECT ResourceID, ResourceType, Title, Content, ResourceUrl
                FROM dbo.CourseResources
                WHERE CourseID = @CourseID
                  AND (ResourceType = 'Note' OR
                       (ResourceType = 'Video' AND
                        (ResourceUrl LIKE 'https://www.youtube.com/%' OR
                         ResourceUrl LIKE 'https://youtube.com/%' OR
                         ResourceUrl LIKE 'https://youtu.be/%')))
                ORDER BY CASE ResourceType WHEN 'Note' THEN 0 ELSE 1 END, ResourceID";

            DataTable resources = new DataTable();
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                using (SqlDataAdapter adapter = new SqlDataAdapter(query, connection))
                {
                    adapter.SelectCommand.Parameters.AddWithValue("@CourseID", courseID);
                    adapter.Fill(resources);
                }
            }
            catch (SqlException ex)
            {
                // A missing optional materials table should not block the learning page.
                if (ex.Number != 208) throw;
            }

            if (resources.Rows.Count == 0)
                resources = CreateDefaultMaterials(courseTitle);

            DataTable notes = resources.Clone();
            DataTable videos = resources.Clone();
            foreach (DataRow row in resources.Rows)
            {
                if (string.Equals(Convert.ToString(row["ResourceType"]), "Note", StringComparison.OrdinalIgnoreCase))
                    notes.ImportRow(row);
                else if (string.Equals(Convert.ToString(row["ResourceType"]), "Video", StringComparison.OrdinalIgnoreCase))
                    videos.ImportRow(row);
            }

            rptNotes.DataSource = notes;
            rptNotes.DataBind();
            rptVideos.DataSource = videos;
            rptVideos.DataBind();
            lblNoteCount.Text = notes.Rows.Count.ToString();
            lblVideoCount.Text = videos.Rows.Count.ToString();
            pnlNoNotes.Visible = notes.Rows.Count == 0;
            pnlNoVideos.Visible = videos.Rows.Count == 0;
        }

        private DataTable CreateDefaultMaterials(string courseTitle)
        {
            DataTable materials = new DataTable();
            materials.Columns.Add("ResourceID", typeof(int));
            materials.Columns.Add("ResourceType", typeof(string));
            materials.Columns.Add("Title", typeof(string));
            materials.Columns.Add("Content", typeof(string));
            materials.Columns.Add("ResourceUrl", typeof(string));

            string noteTitle;
            string noteContent;
            string videoTitle;
            string videoDescription;
            string videoUrl;

            switch (courseTitle)
            {
                case "Web Development Fundamentals":
                    noteTitle = "HTML page structure";
                    noteContent = "HTML gives a page its structure. Start with <!doctype html>, then use html, head, and body. Put headings, paragraphs, links, images, and forms inside body. Choose semantic elements such as header, nav, main, section, and footer to describe each part of the page.";
                    videoTitle = "HTML and CSS for beginners";
                    videoDescription = "Build a page structure, style it with CSS, and follow along with a beginner friendly project.";
                    videoUrl = "https://www.youtube.com/watch?v=dX8396ZmSPk";
                    break;
                case "Java Programming":
                    noteTitle = "Java foundations";
                    noteContent = "A Java program is organized into classes. The main method is the application entry point. Variables have declared types; conditionals choose a path; loops repeat work. Objects hold state and expose behavior through methods. Encapsulation keeps object data behind a clear public interface.";
                    videoTitle = "Java programming for beginners";
                    videoDescription = "Work through variables, control flow, arrays, collections, and object oriented programming.";
                    videoUrl = "https://www.youtube.com/watch?v=A74TOX803D0";
                    break;
                case "Database Management Systems":
                    noteTitle = "Relational database essentials";
                    noteContent = "A relational database stores data in tables. A primary key uniquely identifies a row. A foreign key connects rows across tables. Normalize related data to reduce duplication, then use SELECT, INSERT, UPDATE, and DELETE to work with it. JOIN combines related rows from multiple tables.";
                    videoTitle = "SQL and database fundamentals";
                    videoDescription = "Follow a beginner course covering tables, keys, queries, joins, and database design.";
                    videoUrl = "https://www.youtube.com/watch?v=HXV3zeQKqGY";
                    break;
                case "Computer Networks":
                    noteTitle = "Network layers and addressing";
                    noteContent = "Networks move data in packets. IP addresses identify hosts at the network layer, while ports identify application endpoints. DNS maps names to addresses. TCP provides ordered, reliable delivery; UDP has less overhead and does not guarantee delivery. Routers forward packets between networks.";
                    videoTitle = "Computer networking complete course";
                    videoDescription = "Review network fundamentals, addressing, protocols, and how data moves between devices.";
                    videoUrl = "https://www.youtube.com/watch?v=0PbTi_Prpgs";
                    break;
                case "Software Engineering":
                    noteTitle = "Software development lifecycle";
                    noteContent = "A typical development lifecycle moves through requirements, design, implementation, testing, deployment, and maintenance. Agile teams deliver in small increments and use feedback to adjust priorities. Clear requirements and version control help teams make changes safely.";
                    videoTitle = "Software engineering tutorials";
                    videoDescription = "Find beginner lessons on requirements, design, testing, and the software lifecycle.";
                    videoUrl = "https://www.youtube.com/results?search_query=software+engineering+fundamentals+beginner+tutorial";
                    break;
                case "UI/UX Design Fundamentals":
                    noteTitle = "UI and UX design basics";
                    noteContent = "User experience covers the whole journey a person has while using a product. User interface is the set of screens and controls they interact with. Start by understanding users and tasks, sketch a flow, make a wireframe, then test a prototype. Keep hierarchy, contrast, spacing, and repeated patterns consistent.";
                    videoTitle = "Figma UI design for beginners";
                    videoDescription = "Follow a practical walkthrough of interface design and common Figma techniques.";
                    videoUrl = "https://www.youtube.com/watch?v=jwCmIBJ8Jtc";
                    break;
                case "Python Programming":
                    noteTitle = "Python language essentials";
                    noteContent = "Python uses indentation to mark code blocks. Store values in variables and choose types such as strings, numbers, lists, and dictionaries. Use if statements for decisions, loops for repetition, and def to create reusable functions. A list is ordered and mutable; a tuple is ordered and immutable.";
                    videoTitle = "Python for Everybody";
                    videoDescription = "A university style introduction to Python, from core syntax to working with data.";
                    videoUrl = "https://www.youtube.com/watch?v=8DvywoWv6fI";
                    break;
                case "Cybersecurity Fundamentals":
                    noteTitle = "Security foundations";
                    noteContent = "Confidentiality, integrity, and availability are core security goals. Use unique passwords and multi-factor authentication, keep software updated, and verify unexpected links or attachments. Phishing relies on social engineering. A firewall filters network traffic, while encryption helps protect data from unauthorized readers.";
                    videoTitle = "Cybersecurity fundamentals tutorials";
                    videoDescription = "Find beginner lessons on security principles, common threats, and practical defenses.";
                    videoUrl = "https://www.youtube.com/results?search_query=cybersecurity+fundamentals+beginner+course";
                    break;
                default:
                    noteTitle = "Getting started";
                    noteContent = "Begin with the course overview and identify the main concepts. Break each topic into smaller ideas, write down unfamiliar terms, and practise by explaining each concept in your own words.";
                    videoTitle = "Course video tutorials";
                    videoDescription = "Search for beginner video tutorials related to this course.";
                    videoUrl = "https://www.youtube.com/results?search_query=" +
                        Uri.EscapeDataString((courseTitle ?? "learning") + " beginner tutorial");
                    break;
            }

            materials.Rows.Add(1, "Note", noteTitle, noteContent, DBNull.Value);
            materials.Rows.Add(2, "Video", videoTitle, videoDescription, videoUrl);
            return materials;
        }

        private void ShowCourseNotFound()
        {
            pnlLearning.Visible = false;
            lblCourseNotFound.Visible = true;
        }

        protected bool IsHttpsResourceUrl(object value)
        {
            Uri url;
            return value != null && value != DBNull.Value &&
                Uri.TryCreate(Convert.ToString(value), UriKind.Absolute, out url) &&
                url.Scheme == Uri.UriSchemeHttps;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Student/Login.aspx");
        }
    }
}
