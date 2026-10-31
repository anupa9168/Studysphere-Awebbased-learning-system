<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="Quizzes.aspx.cs"
    Inherits="StudySphere.Student.Quizzes.Quizzes" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quizzes | StudySphere</title>
    <link href="<%= ResolveUrl("~/Student/Quizzes/Quizzes.css") %>?v=3" rel="stylesheet" />
</head>
<body>
<form id="form1" runat="server">
    <nav class="learning-nav">
        <a class="brand" href="../Home.aspx"><img src="../StudySphere.png" alt="" />StudySphere</a>
        <div class="nav-actions">
            <a href="../Courses/Courses.aspx">Courses</a>
            <a class="active" href="Quizzes.aspx">Quizzes</a>
            <a href="../Progress/Progress.aspx">My progress</a>
            <asp:LinkButton ID="btnLogout" runat="server" CssClass="nav-link" OnClick="btnLogout_Click">Logout</asp:LinkButton>
        </div>
    </nav>

    <main class="page-shell">
        <section class="page-hero">
            <p class="eyebrow">PRACTICE AND REVIEW</p>
            <h1>Choose a quiz</h1>
            <p>Check your understanding of the courses you are studying.</p>
        </section>

        <section class="quiz-list">
            <asp:Repeater ID="rptQuizzes" runat="server">
                <ItemTemplate>
                    <article class="quiz-card">
                        <div>
                            <span class="pill"><%#: Eval("CourseTitle") %></span>
                            <h2><%#: Eval("QuizTitle") %></h2>
                            <p><%#: Eval("Description") %></p>
                            <span class="question-count"><%#: Eval("QuestionCount") %> questions</span>
                        </div>
                        <a class="primary-button" href='Quiz.aspx?QuizID=<%# Eval("QuizID") %>'>Take quiz</a>
                    </article>
                </ItemTemplate>
            </asp:Repeater>
        </section>

        <asp:Panel ID="pnlEmpty" runat="server" CssClass="empty-state" Visible="false">
            <h2>No quizzes are available yet</h2>
            <p>Check back after a quiz has been added to your courses.</p>
        </asp:Panel>
    </main>

  <footer class="learning-footer">
    &copy; <%: DateTime.Now.Year %> StudySphere &middot; Learn, practise, grow.
</footer>
</form>
</body>
</html>
