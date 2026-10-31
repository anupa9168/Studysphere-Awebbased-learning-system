
<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="Home.aspx.cs"
    Inherits="StudySphere.Student.Home" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>StudySphere - Home</title>

    <link href="<%= ResolveUrl("~/Student/Home.css") %>?v=2" rel="stylesheet" />

</head>

<body>

    <form id="form1" runat="server">

        <!-- ================= NAVBAR ================= -->

        <nav class="navbar">

            <div class="navbar-container">

                <a href="Home.aspx" class="logo-section">

                    <span class="logo-badge">
                        <img src="StudySphere.png"
                             alt="StudySphere Logo"
                             class="logo" />
                    </span>

                    <span class="logo-text">StudySphere</span>

                </a>

                <div class="nav-links">

                    <a href="Home.aspx" class="active">Home</a>

                    <a href="Courses/Courses.aspx">Courses</a>

                    <a href="#features">Features</a>

                    <a href="#about">About</a>

                    <a href="Login.aspx">Login</a>

                    <a href="Register.aspx" class="register-btn">
                        Register
                    </a>

                </div>

            </div>

        </nav>


        <!-- ================= HERO ================= -->

        <section class="hero">

            <div class="hero-container">

                <div class="hero-content">

                    <span class="hero-badge">
                        LEARN • PRACTICE • GROW
                    </span>

                    <h1>
                        Learn Smarter with StudySphere
                    </h1>

                    <p>
                        StudySphere is a web-based educational resource
                        platform that helps students access courses,
                        learning materials, video lessons and online
                        quizzes in one place.
                    </p>

                    <div class="hero-buttons">

                        <asp:Button
                            ID="btnExploreCourses"
                            runat="server"
                            Text="Explore Courses"
                            CssClass="primary-btn"
                            OnClick="btnExploreCourses_Click" />

                        <a href="Register.aspx"
                           class="secondary-btn">
                            Join StudySphere
                        </a>

                    </div>

                </div>


                <div class="hero-card">

                    <div class="hero-card-icon">
                        📚
                    </div>

                    <h3>Your Learning Space</h3>

                    <p>
                        Learn at your own pace with organised
                        educational resources designed to make
                        studying easier and more convenient.
                    </p>

                </div>

            </div>

        </section>


        <!-- ================= STATISTICS ================= -->

        <section class="stats">

            <div class="stats-container">

                <div class="stat-item">

                    <div class="stat-number">
                        20+
                    </div>

                    <div class="stat-label">
                        Courses
                    </div>

                </div>


                <div class="stat-item">

                    <div class="stat-number">
                        100+
                    </div>

                    <div class="stat-label">
                        Learning Resources
                    </div>

                </div>


                <div class="stat-item">

                    <div class="stat-number">
                        50+
                    </div>

                    <div class="stat-label">
                        Video Lessons
                    </div>

                </div>


                <div class="stat-item">

                    <div class="stat-number">
                        100+
                    </div>

                    <div class="stat-label">
                        Quiz Questions
                    </div>

                </div>

            </div>

        </section>


        <!-- ================= FEATURES ================= -->

        <section class="section features"
                 id="features">

            <div class="container">

                <div class="section-heading">

                    <h2>
                        Everything You Need to Learn
                    </h2>

                    <p>
                        StudySphere brings essential learning
                        resources together in one simple platform.
                    </p>

                </div>


                <div class="feature-grid">

                    <div class="feature-card">

                        <div class="feature-icon">
                            📚
                        </div>

                        <h3>
                            Learning Materials
                        </h3>

                        <p>
                            Access organised notes, documents and
                            other educational resources for your
                            selected courses.
                        </p>

                    </div>


                    <div class="feature-card">

                        <div class="feature-icon">
                            🎥
                        </div>

                        <h3>
                            Video Lessons
                        </h3>

                        <p>
                            Learn through video-based lessons that
                            support your understanding of different
                            course topics.
                        </p>

                    </div>


                    <div class="feature-card">

                        <div class="feature-icon">
                            📝
                        </div>

                        <h3>
                            Online Quizzes
                        </h3>

                        <p>
                            Test your knowledge through quizzes and
                            review your results after completing them.
                        </p>

                    </div>

                </div>

            </div>

        </section>


        <!-- ================= EXPLORE COURSES ================= -->

        <section class="section explore-section">

            <div class="container explore-container">

                <div class="explore-content">

                    <h2>
                        Explore Courses
                    </h2>

                    <p>
                        Find courses based on your learning needs
                        and explore subjects such as programming,
                        web development, databases and networking.
                    </p>

                    <a href="Courses/Courses.aspx"
                       class="primary-btn">
                        View Courses
                    </a>

                </div>


                <div class="explore-card">

                    <h3>
                        Popular Categories
                    </h3>

                    <ul>

                        <li>Programming</li>

                        <li>Web Development</li>

                        <li>Database</li>

                        <li>Networking</li>

                    </ul>

                </div>

            </div>

        </section>


        <!-- ================= CATEGORIES ================= -->

        <section class="section categories">

            <div class="container">

                <div class="section-heading">

                    <h2>
                        Learning Categories
                    </h2>

                    <p>
                        Explore different areas of technology
                        and improve your knowledge.
                    </p>

                </div>


                <div class="category-grid">

                    <div class="category-card">

                        <div class="category-icon">
                            💻
                        </div>

                        <h3>
                            Programming
                        </h3>

                    </div>


                    <div class="category-card">

                        <div class="category-icon">
                            🌐
                        </div>

                        <h3>
                            Web Development
                        </h3>

                    </div>


                    <div class="category-card">

                        <div class="category-icon">
                            🗄️
                        </div>

                        <h3>
                            Database
                        </h3>

                    </div>


                    <div class="category-card">

                        <div class="category-icon">
                            📡
                        </div>

                        <h3>
                            Networking
                        </h3>

                    </div>

                </div>

            </div>

        </section>


        <!-- ================= HOW IT WORKS ================= -->

        <section class="section how-it-works">

            <div class="container">

                <div class="section-heading">

                    <h2>
                        How StudySphere Works
                    </h2>

                    <p>
                        Start learning in three simple steps.
                    </p>

                </div>


                <div class="steps">

                    <div class="step">

                        <div class="step-number">
                            1
                        </div>

                        <h3>
                            Create an Account
                        </h3>

                        <p>
                            Register as a student and create
                            your StudySphere account.
                        </p>

                    </div>


                    <div class="step">

                        <div class="step-number">
                            2
                        </div>

                        <h3>
                            Choose a Course
                        </h3>

                        <p>
                            Browse available courses and select
                            a subject you want to learn.
                        </p>

                    </div>


                    <div class="step">

                        <div class="step-number">
                            3
                        </div>

                        <h3>
                            Learn and Practice
                        </h3>

                        <p>
                            Study materials, watch videos and
                            complete quizzes to improve your knowledge.
                        </p>

                    </div>

                </div>

            </div>

        </section>


        <!-- ================= ABOUT ================= -->

        <section class="section about-section"
                 id="about">

            <div class="container about-container">

                <div class="about-content">

                    <h2>
                        About StudySphere
                    </h2>

                    <p>
                        StudySphere is designed to provide students
                        with a simple and organised environment for
                        accessing educational resources online.
                    </p>

                    <p>
                        Instead of searching through different
                        sources, students can use one platform to
                        explore courses, study learning materials,
                        watch video lessons and practise through
                        quizzes.
                    </p>


                    <ul class="about-list">

                        <li>
                            Organised educational resources
                        </li>

                        <li>
                            Course-based learning
                        </li>

                        <li>
                            Video-based lessons
                        </li>

                        <li>
                            Online quizzes and results
                        </li>

                    </ul>

                </div>


                <div class="about-box">

                    <h3>
                        Learn at Your Own Pace
                    </h3>

                    <p>
                        StudySphere provides students with a
                        convenient learning environment where
                        educational content can be accessed
                        whenever they need it.
                    </p>

                </div>

            </div>

        </section>


        <!-- ================= CTA ================= -->

        <section class="cta">

            <h2>
                Start Your Learning Journey
            </h2>

            <p>
                Create your StudySphere account and explore
                available learning resources.
            </p>

            <a href="Register.aspx"
               class="secondary-btn">
                Get Started
            </a>

        </section>


        <!-- ================= FOOTER ================= -->

        <footer class="footer">

            <div class="footer-container">

                <div>

                    <h3>
                        StudySphere
                    </h3>

                    <p>
                        A web-based educational resource platform
                        designed to support students in learning
                        and practising online.
                    </p>

                </div>


                <div>

                    <h4>
                        Quick Links
                    </h4>

                    <ul>

                        <li>
                            <a href="Home.aspx">
                                Home
                            </a>
                        </li>

                        <li>
                            <a href="Courses/Courses.aspx">
                                Courses
                            </a>
                        </li>

                        <li>
                            <a href="#features">
                                Features
                            </a>
                        </li>

                        <li>
                            <a href="#about">
                                About
                            </a>
                        </li>

                    </ul>

                </div>


                <div>

                    <h4>
                        Student
                    </h4>

                    <ul>

                        <li>
                            <a href="Login.aspx">
                                Login
                            </a>
                        </li>

                        <li>
                            <a href="Register.aspx">
                                Register
                            </a>
                        </li>

                        <li>
                            <a href="Courses/Courses.aspx">
                                Courses
                            </a>
                        </li>

                        <li>
                            <a href="Progress/Progress.aspx">
                                Progress
                            </a>
                        </li>

                    </ul>

                </div>

            </div>


            <div class="footer-bottom">

               &copy; <%: DateTime.Now.Year %> StudySphere &middot; Learn, practise, grow.
            </div>

        </footer>

    </form>

</body>
</html>
