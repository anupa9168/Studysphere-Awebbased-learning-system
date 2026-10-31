<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="StudentDashboard.aspx.cs"
    Inherits="StudySphere.Student.StudentDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">

    <meta charset="utf-8" />
    <title>Student Dashboard - StudySphere</title>

    <link rel="stylesheet"
          type="text/css"
          href="<%= ResolveUrl("~/Student/StudentDashboard/StudentDashboard.css") %>?v=5" />

</head>

<body>

<form id="form1" runat="server">

    <!-- HEADER -->
    <header class="main-header">

        <div class="header-container">

            <!-- LOGO -->
            <a href="StudentDashboard.aspx"
               class="logo-area">

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

                <a href="StudentDashboard.aspx"
                   class="nav-link active">
                    Dashboard
                </a>

                <a href="../Courses/Courses.aspx"
                   class="nav-link">
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

                <asp:LinkButton ID="btnLogout" runat="server"
                                CssClass="logout-button"
                                OnClick="btnLogout_Click">Logout</asp:LinkButton>

            </nav>

        </div>

    </header>


    <!-- MAIN CONTENT -->
    <main class="dashboard-container">


        <!-- WELCOME SECTION -->
        <section class="welcome-section">

            <div class="welcome-content">

                <p class="welcome-label">
                    STUDENT DASHBOARD
                </p>

                <h1>
                    Welcome,
                    <asp:Label
                        ID="lblFullName"
                        runat="server">
                    </asp:Label>
                </h1>

                <p class="welcome-text">
                    Continue your learning journey,
                    explore courses and improve your skills.
                </p>

            </div>

        </section>


        <!-- STATISTICS -->
        <section class="stats-section">

            <div class="stat-card">

                <div class="stat-icon">
                    <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M12 7v14M12 7C10.5 5.8 8.7 5 6.5 5S3 5.8 3 7v11c0-1.2 1.5-2 3.5-2s3.8.8 5.5 2c1.7-1.2 3.5-2 5.5-2s3.5.8 3.5 2V7c0-1.2-1.5-2-3.5-2S13.5 5.8 12 7Z" /></svg>
                </div>

                <div class="stat-content">

                    <span class="stat-number">
                        <asp:Label ID="lblCourseCount" runat="server" Text="0" />
                    </span>

                    <span class="stat-label">
                        Available Courses
                    </span>

                </div>

            </div>


            <div class="stat-card">

                <div class="stat-icon">
                    <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M8 4h8l1 2h3v14H4V6h3l1-2Z" /><path d="M8 11h8M8 15h8" /></svg>
                </div>

                <div class="stat-content">

                    <span class="stat-number">
                        <asp:Label ID="lblQuizCount" runat="server" Text="0" />
                    </span>

                    <span class="stat-label">
                        Quizzes
                    </span>

                </div>

            </div>


            <div class="stat-card">

                <div class="stat-icon">
                    <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="m3 17 6-6 4 4 8-8M15 7h6v6" /></svg>
                </div>

                <div class="stat-content">

                    <span class="stat-number">
                        <asp:Label ID="lblLearningProgress" runat="server" Text="0%" />
                    </span>

                    <span class="stat-label">
                        Learning Progress
                    </span>

                </div>

            </div>


            <div class="stat-card">

                <div class="stat-icon">
                    <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><circle cx="12" cy="12" r="9" /><path d="m8 12 2.5 2.5L16 9" /></svg>
                </div>

                <div class="stat-content">

                    <span class="stat-number">
                        <asp:Label ID="lblQuizAttempts" runat="server" Text="0" />
                    </span>

                    <span class="stat-label">
                        Quiz Attempts
                    </span>

                </div>

            </div>

        </section>


        <!-- QUICK ACTIONS -->
        <section class="section-block">

            <div class="section-heading">

                <h2>
                    Quick Actions
                </h2>

                <p>
                    Start learning from your dashboard.
                </p>

            </div>


            <div class="action-grid">

                <a href="../Courses/Courses.aspx"
                   class="action-card">

                    <div class="action-icon">
                        <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M12 7v14M12 7C10.5 5.8 8.7 5 6.5 5S3 5.8 3 7v11c0-1.2 1.5-2 3.5-2s3.8.8 5.5 2c1.7-1.2 3.5-2 5.5-2s3.5.8 3.5 2V7c0-1.2-1.5-2-3.5-2S13.5 5.8 12 7Z" /></svg>
                    </div>

                    <div class="action-content">

                        <h3>
                            Browse Courses
                        </h3>

                        <p>
                            Explore available courses
                            and start learning.
                        </p>

                    </div>

                    <span class="action-arrow">
                        <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M5 12h14m-6-6 6 6-6 6" /></svg>
                    </span>

                </a>


                <a href="../Quizzes/Quizzes.aspx"
                   class="action-card">

                    <div class="action-icon">
                        <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M8 4h8l1 2h3v14H4V6h3l1-2Z" /><path d="M8 11h8M8 15h8" /></svg>
                    </div>

                    <div class="action-content">

                        <h3>
                            Take a Quiz
                        </h3>

                        <p>
                            Test your knowledge
                            with quizzes.
                        </p>

                    </div>

                    <span class="action-arrow">
                        <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M5 12h14m-6-6 6 6-6 6" /></svg>
                    </span>

                </a>


                <a href="../Progress/Progress.aspx"
                   class="action-card">

                    <div class="action-icon">
                        <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="m3 17 6-6 4 4 8-8M15 7h6v6" /></svg>
                    </div>

                    <div class="action-content">

                        <h3>
                            View Progress
                        </h3>

                        <p>
                            Track your learning
                            progress.
                        </p>

                    </div>

                    <span class="action-arrow">
                        <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M5 12h14m-6-6 6 6-6 6" /></svg>
                    </span>

                </a>

            </div>

        </section>


        <!-- LEARNING MESSAGE -->
        <section class="learning-card">

            <div class="learning-icon">
                <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="m2 9 10-5 10 5-10 5L2 9Z" /><path d="M6 11v5c3.5 3 8.5 3 12 0v-5m4-2v6" /></svg>
            </div>

            <div class="learning-content">

                <h2>
                    Keep Learning
                </h2>

                <p>
                    Explore our courses and build your
                    knowledge step by step.
                </p>

            </div>

            <a href="../Courses/Courses.aspx"
               class="start-button">
                Explore Courses
            </a>

        </section>


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
