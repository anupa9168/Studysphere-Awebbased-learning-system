<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="StudySphere.Admin.AdminDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <title>Admin Dashboard - StudySphere</title>
   <link rel="stylesheet"
      type="text/css"
      href="<%= ResolveUrl("~/Admin/AdminStyle.css") %>" />

<link rel="stylesheet"
      type="text/css"
      href="<%= ResolveUrl("~/Admin/AdminDashboard.css") %>?v=3" />
</head>
<body>
    <form id="form1" runat="server">

        <!-- Navigation Bar -->
        <div class="admin-navbar">
            <div class="nav-logo">
                <div class="logo-badge">
                    <img src="/Admin/StudySphere.png" alt="StudySphere Logo" />
                </div>
                <span class="site-name">StudySphere</span>
            </div>

            <div class="nav-menu">
                <asp:LinkButton ID="lnkDashboard" runat="server" CssClass="nav-link nav-link-active" Text="Dashboard" OnClick="lnkDashboard_Click" />
                <asp:LinkButton ID="lnkUsers" runat="server" CssClass="nav-link" Text="Users" OnClick="btnManageUsers_Click" />
                <asp:LinkButton ID="lnkCourses" runat="server" CssClass="nav-link" Text="Courses" OnClick="btnManageCourses_Click" />
                <asp:LinkButton ID="lnkResources" runat="server" CssClass="nav-link" Text="Resources" OnClick="btnManageResources_Click" />
                <asp:LinkButton ID="lnkQuizzes" runat="server" CssClass="nav-link" Text="Quizzes" OnClick="btnManageQuizzes_Click" />
            </div>

            <div class="nav-admin">
                <span>Administrator</span>
                <asp:Button ID="btnLogout" runat="server" CssClass="logout-btn" Text="Logout" OnClick="btnLogout_Click" />
            </div>
        </div>

        <!-- Wave divider transitioning navbar into page background -->
        <div class="wave-divider">
            <svg viewBox="0 0 1440 60" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none">
                <path fill="#F4F8FC" d="M0,32L80,37.3C160,43,320,53,480,48C640,43,800,21,960,16C1120,11,1280,21,1360,26.7L1440,32L1440,60L0,60Z"></path>
            </svg>
        </div>

        <!-- Main Dashboard Section -->
        <div class="dashboard-container">

            <div class="dashboard-header">
                <!-- Decorative background shapes -->
                <div class="blob blob-blue"></div>
                <div class="blob blob-green"></div>

                <h1>Admin Dashboard</h1>
                <p>Welcome to the StudySphere Administration Panel</p>
            </div>
            <!-- Statistics Section -->
<section class="statistics">

    <asp:Label ID="lblStatsMessage" runat="server" CssClass="stats-message" Visible="false" />

    <div class="stat-card">
        <div class="stat-icon">👥</div>
        <div class="stat-content">
            <h3>Total Users</h3>
            <asp:Label ID="lblTotalUsers" runat="server" Text="0"></asp:Label>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon">📚</div>
        <div class="stat-content">
            <h3>Total Courses</h3>
            <asp:Label ID="lblTotalCourses" runat="server" Text="0"></asp:Label>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon">📄</div>
        <div class="stat-content">
            <h3>Total Resources</h3>
            <asp:Label ID="lblTotalResources" runat="server" Text="0"></asp:Label>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon">📝</div>
        <div class="stat-content">
            <h3>Total Quizzes</h3>
            <asp:Label ID="lblTotalQuizzes" runat="server" Text="0"></asp:Label>
        </div>
    </div>

</section>

            <div class="dashboard-grid">

                <!-- Card 1: Manage Users -->
                <div class="dashboard-card card-accent-blue">
                    <div class="card-icon-circle icon-blue">
                        <span class="card-icon">👤</span>
                    </div>
                    <h2>Manage Users</h2>
                    <p>Add, view, update and delete registered users.</p>
                    <asp:Button ID="btnManageUsers" runat="server" CssClass="manage-btn" Text="Manage Users" OnClick="btnManageUsers_Click" />
                </div>

                <!-- Card 2: Manage Courses -->
                <div class="dashboard-card card-accent-blue">
                    <div class="card-icon-circle icon-blue">
                        <span class="card-icon">📚</span>
                    </div>
                    <h2>Manage Courses</h2>
                    <p>Add, view, update and delete courses.</p>
                    <asp:Button ID="btnManageCourses" runat="server" CssClass="manage-btn" Text="Manage Courses" OnClick="btnManageCourses_Click" />
                </div>

                <!-- Card 3: Manage Resources -->
                <div class="dashboard-card card-accent-blue">
                    <div class="card-icon-circle icon-blue">
                        <span class="card-icon">📄</span>
                    </div>
                    <h2>Manage Resources</h2>
                    <p>Upload, update and delete learning resources.</p>
                    <asp:Button ID="btnManageResources" runat="server" CssClass="manage-btn" Text="Manage Resources" OnClick="btnManageResources_Click" />
                </div>

                <!-- Card 4: Manage Quizzes -->
                <div class="dashboard-card card-accent-blue">
                    <div class="card-icon-circle icon-blue">
                        <span class="card-icon">📝</span>
                    </div>
                    <h2>Manage Quizzes</h2>
                    <p>Create, update and manage online quizzes.</p>
                    <asp:Button ID="btnManageQuizzes" runat="server" CssClass="manage-btn" Text="Manage Quizzes" OnClick="btnManageQuizzes_Click" />
                </div>

            </div>
        </div>

      <!-- Footer -->
<!-- Footer (matches Student Dashboard style) -->
<footer class="admin-footer">
    <h3>StudySphere</h3>
    <p>Learn. Practice. Grow.</p>
    <p>&copy; 2026 StudySphere. All rights reserved.</p>
</footer>
    </form>
</body>
</html>
