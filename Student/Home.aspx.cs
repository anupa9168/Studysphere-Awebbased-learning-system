
using System;

namespace StudySphere.Student
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnExploreCourses_Click(
            object sender,
            EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else
            {
                Response.Redirect("Courses/Courses.aspx");
            }
        }
    }
}

