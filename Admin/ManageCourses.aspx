<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageCourses.aspx.cs" Inherits="StudySphere.Admin.ManageCourses" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Manage Courses | StudySphere</title>
    <link href="<%= ResolveUrl("~/Admin/AdminStyle.css") %>" rel="stylesheet" />
    <link href="<%= ResolveUrl("~/Admin/ManageUsers.css") %>" rel="stylesheet" />
    <style>
        .wrap {
            max-width: 1150px;
            margin: 40px auto;
            padding: 0 20px
        }

        .top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px
        }

        .card {
            background: #fff;
            border-radius: 12px;
            padding: 24px;
            margin: 20px 0;
            box-shadow: 0 5px 20px #18345412
        }

        .form {
            display: grid;
            grid-template-columns: repeat(2,minmax(0,1fr));
            gap: 14px
        }

            .form input, .form select, .form textarea {
                width: 100%;
                padding: 11px;
                border: 1px solid #cbd5e1;
                border-radius: 7px
            }

            .form textarea {
                min-height: 90px
            }

        .full {
            grid-column: 1/-1
        }

        .btn {
            padding: 11px 18px;
            border: 0;
            border-radius: 7px;
            background: #0756a5;
            color: #fff;
            cursor: pointer
        }

        .table {
            width: 100%;
            border-collapse: collapse
        }

            .table th, .table td {
                padding: 11px;
                text-align: left;
                border-bottom: 1px solid #e2e8f0
            }

        .msg {
            display: block;
            margin: 12px 0;
            color: #0756a5
        }

        .back {
            color: #0756a5
        }

        @media(max-width:650px) {
            .form {
                grid-template-columns: 1fr
            }

            .full {
                grid-column: auto
            }

            .card {
                overflow: auto
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="admin-navbar">
            <div class="nav-left">
                <img src="StudySphere.png" class="admin-logo" alt="StudySphere" /><span class="admin-title">StudySphere Admin</span></div>
            <div class="nav-links"><a class="nav-link" href="AdminDashboard.aspx">Dashboard</a><a class="nav-link" href="ManageUsers.aspx">Users</a><a class="nav-link active" href="ManageCourses.aspx">Courses</a><a class="nav-link" href="ManageResources.aspx">Resources</a><a class="nav-link" href="ManageQuizzes.aspx">Quizzes</a><asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="logout-button" OnClick="btnLogout_Click" /></div>
        </div>
        <div class="wrap">
            <div class="top">
                <div><a class="back" href="AdminDashboard.aspx"> &larr;Admin dashboard</a><h1>Manage course pages</h1>
                    <p>Create, update, and remove the courses shown to students.</p>
                </div>
                <a class="back" href="ManageResources.aspx">Resources</a></div>
            <asp:Label ID="lblMessage" runat="server" CssClass="msg" />
            <section class="card">
                <h2>Add a course</h2>
                <div class="form">
                    <asp:TextBox ID="txtTitle" runat="server" MaxLength="100" placeholder="Course title" />
                    <asp:TextBox ID="txtCategory" runat="server" MaxLength="50" placeholder="Category (e.g. Programming)" />
                    <asp:DropDownList ID="ddlLevel" runat="server">
                        <asp:ListItem>Beginner</asp:ListItem>
                        <asp:ListItem>Intermediate</asp:ListItem>
                        <asp:ListItem>Advanced</asp:ListItem>
                    </asp:DropDownList>
                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" MaxLength="500" placeholder="Course description" />
                    <div class="full">
                        <asp:Button ID="btnAdd" runat="server" Text="Add course" CssClass="btn" OnClick="btnAdd_Click" /></div>
                </div>
            </section>
            <section class="card">
                <h2>Course catalog</h2>
                <asp:GridView ID="gvCourses" runat="server" AutoGenerateColumns="False" DataKeyNames="CourseID" CssClass="table" GridLines="None" EmptyDataText="No courses yet." OnRowEditing="gvCourses_RowEditing" OnRowCancelingEdit="gvCourses_RowCancelingEdit" OnRowUpdating="gvCourses_RowUpdating" OnRowDeleting="gvCourses_RowDeleting">
                    <Columns>
                        <asp:BoundField DataField="CourseID" HeaderText="ID" ReadOnly="true" />
                        <asp:BoundField DataField="CourseTitle" HeaderText="Title" />
                        <asp:BoundField DataField="Category" HeaderText="Category" />
                        <asp:BoundField DataField="Level" HeaderText="Level" />
                        <asp:BoundField DataField="Description" HeaderText="Description" />
                        <asp:CommandField ShowEditButton="true" ShowDeleteButton="true" />
                    </Columns>
                </asp:GridView>
            </section>
        </div>
    </form>
</body>
</html>
