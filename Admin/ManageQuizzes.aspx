<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageQuizzes.aspx.cs" Inherits="StudySphere.Admin.ManageQuizzes" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Manage Quizzes | StudySphere</title>
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

        .form, .question-form {
            display: grid;
            grid-template-columns: repeat(2,minmax(0,1fr));
            gap: 14px
        }

            .form input, .form select, .form textarea, .question-form input, .question-form select {
                width: 100%;
                padding: 11px;
                border: 1px solid #cbd5e1;
                border-radius: 7px
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

        .wide {
            grid-column: 1/-1
        }

        @media(max-width:650px) {
            .form, .question-form {
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
            <div class="nav-links"><a class="nav-link" href="AdminDashboard.aspx">Dashboard</a><a class="nav-link" href="ManageUsers.aspx">Users</a><a class="nav-link" href="ManageCourses.aspx">Courses</a><a class="nav-link" href="ManageResources.aspx">Resources</a><a class="nav-link active" href="ManageQuizzes.aspx">Quizzes</a><asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="logout-button" OnClick="btnLogout_Click" /></div>
        </div>
        <div class="wrap">
            <div class="top">
                <div><a class="back" href="AdminDashboard.aspx"> &larr; Admin dashboard</a><h1>Manage quizzes</h1>
                    <p>Create quizzes, maintain their details, and manage multiple-choice questions.</p>
                </div>
                <a class="back" href="ManageCourses.aspx">Courses</a></div>
            <asp:Label ID="lblMessage" runat="server" CssClass="msg" />
            <section class="card">
                <h2>Create a quiz</h2>
                <div class="form">
                    <asp:DropDownList ID="ddlCourse" runat="server" /><asp:TextBox ID="txtQuizTitle" runat="server" MaxLength="100" placeholder="Quiz title" /><asp:TextBox ID="txtDescription" runat="server" MaxLength="255" placeholder="Short description" /><div>
                        <asp:Button ID="btnAddQuiz" runat="server" Text="Create quiz" CssClass="btn" OnClick="btnAddQuiz_Click" /></div>
                </div>
            </section>
            <section class="card">
                <h2>Quiz catalog</h2>
                <div class="scroll">
                    <asp:GridView ID="gvQuizzes" runat="server" AutoGenerateColumns="False" DataKeyNames="QuizID" CssClass="table" GridLines="None" EmptyDataText="No quizzes yet." OnRowEditing="gvQuizzes_RowEditing" OnRowCancelingEdit="gvQuizzes_RowCancelingEdit" OnRowUpdating="gvQuizzes_RowUpdating" OnRowDeleting="gvQuizzes_RowDeleting">
                        <Columns>
                            <asp:BoundField DataField="QuizID" HeaderText="ID" ReadOnly="true" />
                            <asp:BoundField DataField="CourseTitle" HeaderText="Course" ReadOnly="true" />
                            <asp:BoundField DataField="QuizTitle" HeaderText="Quiz title" />
                            <asp:BoundField DataField="Description" HeaderText="Description" />
                            <asp:BoundField DataField="QuestionCount" HeaderText="Questions" ReadOnly="true" />
                            <asp:CommandField ShowEditButton="true" ShowDeleteButton="true" />
                        </Columns>
                    </asp:GridView>
                </div>
            </section>
            <section class="card">
                <h2>Add a multiple-choice question</h2>
                <div class="question-form">
                    <asp:DropDownList ID="ddlQuiz" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlQuiz_SelectedIndexChanged" /><asp:TextBox ID="txtQuestion" runat="server" MaxLength="500" placeholder="Question" /><asp:TextBox ID="txtOptionA" runat="server" MaxLength="255" placeholder="Option A" /><asp:TextBox ID="txtOptionB" runat="server" MaxLength="255" placeholder="Option B" /><asp:TextBox ID="txtOptionC" runat="server" MaxLength="255" placeholder="Option C" /><asp:TextBox ID="txtOptionD" runat="server" MaxLength="255" placeholder="Option D" /><asp:DropDownList ID="ddlAnswer" runat="server">
                        <asp:ListItem>A</asp:ListItem>
                        <asp:ListItem>B</asp:ListItem>
                        <asp:ListItem>C</asp:ListItem>
                        <asp:ListItem>D</asp:ListItem>
                    </asp:DropDownList><div>
                        <asp:Button ID="btnAddQuestion" runat="server" Text="Add question" CssClass="btn" OnClick="btnAddQuestion_Click" /></div>
                </div>
            </section>
            <section class="card">
                <h2>Existing questions</h2>
                <div class="scroll">
                    <asp:GridView ID="gvQuestions" runat="server" AutoGenerateColumns="False" DataKeyNames="QuestionID" CssClass="table" GridLines="None" EmptyDataText="Select a quiz to view its questions." OnRowDeleting="gvQuestions_RowDeleting">
                        <Columns>
                            <asp:BoundField DataField="QuestionID" HeaderText="ID" />
                            <asp:BoundField DataField="QuizTitle" HeaderText="Quiz" />
                            <asp:BoundField DataField="QuestionText" HeaderText="Question" />
                            <asp:BoundField DataField="CorrectAnswer" HeaderText="Answer" />
                            <asp:CommandField ShowDeleteButton="true" DeleteText="Remove" />
                        </Columns>
                    </asp:GridView>
                </div>
            </section>
        </div>
    </form>
</body>
</html>
