<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="Courses.aspx.cs"
    Inherits="StudySphere.Student.CoursesPage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Courses - StudySphere</title>
    <link rel="stylesheet" type="text/css"
          href="<%= ResolveUrl("~/Student/Courses/Courses.css") %>?v=4" />
</head>
<body>
<form id="form1" runat="server">
    <header class="main-header">
        <div class="header-container">
            <a href="../Home.aspx" class="logo-area">
                <span class="logo-badge">
                    <img src="StudySphere.png" alt="StudySphere Logo" class="logo-image" />
                </span>
                <span class="logo-text">StudySphere</span>
            </a>
            <nav class="main-nav">
                <a href="../StudentDashboard/StudentDashboard.aspx" class="nav-link">Dashboard</a>
                <a href="Courses.aspx" class="nav-link active">Courses</a>
                <a href="../Quizzes/Quizzes.aspx" class="nav-link">Quizzes</a>
                <a href="../Progress/Progress.aspx" class="nav-link">Progress</a>
                <asp:LinkButton ID="btnLogout" runat="server" CssClass="logout-button"
                                OnClick="btnLogout_Click">Logout</asp:LinkButton>
            </nav>
        </div>
    </header>

    <main class="courses-container">
        <section class="page-heading">
            <h1>Explore Courses</h1>
            <p>Discover courses and improve your knowledge with StudySphere.</p>
        </section>

        <section class="course-grid">
            <asp:Repeater ID="rptCourses" runat="server">
                <ItemTemplate>
                    <article class="course-card">
                        <div class="course-icon"><%# GetCourseIcon(System.Convert.ToString(Eval("Category"))) %></div>
                        <div class="course-content">
                            <h2><%#: Eval("CourseTitle") %></h2>
                            <div class="course-info">
                                <span class="category"><%#: Eval("Category") %></span>
                                <span class="level"><%#: Eval("Level") %></span>
                            </div>
                            <p class="course-description"><%#: Eval("Description") %></p>
                            <asp:Button ID="btnViewCourse" runat="server" Text="View Course"
                                CssClass="view-button"
                                CommandArgument='<%# Eval("CourseID") %>'
                                CommandName="ViewCourse"
                                OnCommand="btnViewCourse_Command" />
                        </div>
                    </article>
                </ItemTemplate>
            </asp:Repeater>
        </section>

        <asp:Label ID="lblNoCourses" runat="server" CssClass="no-courses" Visible="false">
            No courses are available at the moment.
        </asp:Label>
    </main>

  <footer class="main-footer">
    <div class="footer-container">
        <h3>StudySphere</h3>
        <p>Learn. Explore. Grow.</p>
        <p class="copyright">
            &copy; <%: DateTime.Now.Year %> StudySphere. All rights reserved.
        </p>
    </div>
</footer>
</form>
</body>
</html>
