<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageResources.aspx.cs" Inherits="StudySphere.Admin.ManageResources" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Manage Learning Resources | StudySphere</title>
    <link href="<%= ResolveUrl("~/Admin/AdminStyle.css") %>" rel="stylesheet" />
    <link href="<%= ResolveUrl("~/Admin/ManageUsers.css") %>" rel="stylesheet" />
    <style>
        .wrap {
            max-width: 1200px;
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
                min-height: 100px
            }

        .wide {
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
                padding: 10px;
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

        .scroll {
            overflow: auto
        }

        @media(max-width:650px) {
            .form {
                grid-template-columns: 1fr
            }

            .wide {
                grid-column: auto
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="admin-navbar">
            <div class="nav-left">
                <img src="StudySphere.png" class="admin-logo" alt="StudySphere" /><span class="admin-title">StudySphere Admin</span></div>
            <div class="nav-links"><a class="nav-link" href="AdminDashboard.aspx">Dashboard</a><a class="nav-link" href="ManageUsers.aspx">Users</a><a class="nav-link" href="ManageCourses.aspx">Courses</a><a class="nav-link active" href="ManageResources.aspx">Resources</a><a class="nav-link" href="ManageQuizzes.aspx">Quizzes</a><asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="logout-button" OnClick="btnLogout_Click" /></div>
        </div>
        <div class="wrap">
            <div class="top">
                <div><a class="back" href="AdminDashboard.aspx"> &larr;Admin dashboard</a><h1>Manage learning resources</h1>
                    <p>Add notes and tutorial videos to course learning pages.</p>
                </div>
            </div>
            <asp:Label ID="lblMessage" runat="server" CssClass="msg" />
            <section class="card">
                <h2>Add a resource</h2>
                <div class="form">
                    <asp:DropDownList ID="ddlCourse" runat="server" /><asp:DropDownList ID="ddlType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlType_SelectedIndexChanged">
                        <asp:ListItem Value="Note">Note</asp:ListItem>
                        <asp:ListItem Value="Video">Video tutorial</asp:ListItem>
                    </asp:DropDownList>
                    <asp:TextBox ID="txtTitle" runat="server" MaxLength="160" placeholder="Resource title" /><asp:TextBox ID="txtUrl" runat="server" MaxLength="500" placeholder="Optional resource URL (https://...)" />
                    <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" placeholder="Notes content or a short video description" CssClass="wide" /><div class="wide">
                        <asp:Button ID="btnAdd" runat="server" Text="Add resource" CssClass="btn" OnClick="btnAdd_Click" /></div>
                </div>
            </section>
            <section class="card">
                <h2>Existing resources</h2>
                <div class="scroll">
                    <asp:GridView ID="gvResources" runat="server" AutoGenerateColumns="False" DataKeyNames="ResourceID" CssClass="table" GridLines="None" EmptyDataText="No resources yet." OnRowEditing="gvResources_RowEditing" OnRowCancelingEdit="gvResources_RowCancelingEdit" OnRowUpdating="gvResources_RowUpdating" OnRowDeleting="gvResources_RowDeleting">
                        <Columns>
                            <asp:BoundField DataField="ResourceID" HeaderText="ID" ReadOnly="true" />
                            <asp:BoundField DataField="CourseTitle" HeaderText="Course" ReadOnly="true" />
                            <asp:BoundField DataField="ResourceType" HeaderText="Type" ReadOnly="true" />
                            <asp:BoundField DataField="Title" HeaderText="Title" />
                            <asp:BoundField DataField="Content" HeaderText="Content / description" />
                            <asp:BoundField DataField="ResourceUrl" HeaderText="URL" />
                            <asp:CommandField ShowEditButton="true" ShowDeleteButton="true" />
                        </Columns>
                    </asp:GridView>
                </div>
            </section>
        </div>
    </form>
</body>
</html>
