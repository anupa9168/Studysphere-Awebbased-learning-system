
<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="CourseDetails.aspx.cs"
    Inherits="StudySphere.Student.CourseDetails" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Course Details - StudySphere</title>

    <link rel="stylesheet"
          type="text/css"
          href="CourseDetails.css" />
</head>

<body>

<form id="form1" runat="server">

    <!-- HEADER -->
    <header class="main-header">

        <div class="header-container">

            <!-- LOGO -->
            <a href="../Home.aspx" class="logo-area">

                <div class="logo-badge">
                    <img src="StudySphere.png"
                         alt="StudySphere Logo"
                         class="logo-image" />
                </div>

                <span class="logo-text">
                    StudySphere
                </span>

            </a>

            <!-- NAVIGATION -->
            <nav class="main-nav">

                <a href="../Home.aspx"
                   class="nav-link">
                    Home
                </a>

                <a href="Courses.aspx"
                   class="nav-link active">
                    Courses
                </a>

                <a href="../Quizzes/Quizzes.aspx"
                   class="nav-link">
                    Quizzes
                </a>

                <a href="../Progress/Progress.aspx"
                   class="nav-link">
                    Progress
                </a>

                <asp:LinkButton ID="btnLogout" runat="server" CssClass="logout-button" OnClick="btnLogout_Click">Logout</asp:LinkButton>

            </nav>

        </div>

    </header>


    <!-- MAIN CONTENT -->
    <main class="details-container">

        <!-- BACK LINK -->
      <a href="Courses.aspx" class="back-link">
    &larr; Back to Courses
</a>

        <!-- COURSE DETAILS -->
        <section class="course-details-card">

            <!-- COURSE HEADER -->
            <div class="course-details-header">

                <div class="course-title-area">

                    <h1>

                        <!-- COURSE ICON -->
                        <asp:Label
                            ID="lblCourseIcon"
                            runat="server"
                            CssClass="course-title-icon">
                        </asp:Label>

                        <!-- COURSE TITLE -->
                        <asp:Label
                            ID="lblCourseTitle"
                            runat="server">
                        </asp:Label>

                    </h1>


                    <!-- CATEGORY AND LEVEL -->
                    <div class="course-info">

                        <asp:Label
                            ID="lblCategory"
                            runat="server"
                            CssClass="category">
                        </asp:Label>

                        <asp:Label
                            ID="lblLevel"
                            runat="server"
                            CssClass="level">
                        </asp:Label>

                    </div>

                </div>

            </div>


            <!-- ABOUT COURSE -->
            <div class="details-section">

                <h2>
                    About This Course
                </h2>

                <asp:Label
                    ID="lblDescription"
                    runat="server"
                    CssClass="description">
                </asp:Label>

            </div>


            <!-- COURSE OVERVIEW -->
            <div class="details-section">

                <h2>
                    Course Overview
                </h2>

                <p>
                    This course is designed to help you understand
                    important concepts and develop useful knowledge
                    in this subject area.
                </p>

                <p>
                    Start learning at your own pace and build your
                    understanding step by step.
                </p>

            </div>


            <!-- START LEARNING -->
            <div class="learning-section">

                <asp:Button
                    ID="btnStartLearning"
                    runat="server"
                    Text="Start Learning"
                    CssClass="start-button"
                    OnClick="btnStartLearning_Click" />

            </div>

        </section>


        <!-- COURSE NOT FOUND -->
        <asp:Label
            ID="lblCourseNotFound"
            runat="server"
            CssClass="not-found"
            Visible="false">

            Course not found.

        </asp:Label>

    </main>


    <!-- FOOTER -->
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

