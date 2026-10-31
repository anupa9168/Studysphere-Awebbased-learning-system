<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="ViewResult.aspx.cs"
    Inherits="StudySphere.Student.Quizzes.ViewResult" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Review Answers | StudySphere</title>
    <link href="<%= ResolveUrl("~/Student/Quizzes/Quizzes.css") %>?v=4" rel="stylesheet" />
</head>
<body>
<form id="form1" runat="server">
    <nav class="learning-nav">
        <a class="brand" href="../StudentDashboard/StudentDashboard.aspx"><img src="../StudySphere.png" alt="" />StudySphere</a>
        <div class="nav-actions">
            <a href="../Courses/Courses.aspx">Courses</a>
            <a class="active" href="Quizzes.aspx">Quizzes</a>
            <a href="../Progress/Progress.aspx">My progress</a>
            <asp:LinkButton ID="btnLogout" runat="server" CssClass="nav-link" OnClick="btnLogout_Click">Logout</asp:LinkButton>
        </div>
    </nav>

    <main class="page-shell narrow">
        <a class="back-link" href="../Progress/Progress.aspx">&larr; Back to progress</a>
        <section class="quiz-header">
            <p class="eyebrow"><asp:Label ID="lblCourse" runat="server" /></p>
            <h1><asp:Label ID="lblQuizTitle" runat="server" /></h1>
            <p><asp:Label ID="lblScoreSummary" runat="server" /></p>
        </section>

        <asp:Panel ID="pnlAnswers" runat="server">
            <asp:Repeater ID="rptAnswers" runat="server">
                <ItemTemplate>
                    <article class='answer-card <%# Convert.ToBoolean(Eval("IsCorrect")) ? "correct" : "incorrect" %>'>
                        <span class="question-number">Question <%# Container.ItemIndex + 1 %></span>
                        <h2><%#: Eval("QuestionText") %></h2>
                        <p class="answer-status"><%# Convert.ToBoolean(Eval("IsCorrect")) ? "Correct" : "Needs review" %></p>
                        <p class="answer-detail"><strong>Your answer:</strong> <%#: Eval("SelectedText") %></p>
                        <p class="answer-detail"><strong>Correct answer:</strong> <%#: Eval("CorrectText") %></p>
                    </article>
                </ItemTemplate>
            </asp:Repeater>
        </asp:Panel>

        <asp:Panel ID="pnlNotFound" runat="server" CssClass="empty-state" Visible="false">
            <h2>Result not found</h2>
            <p>This result does not exist or does not belong to your account.</p>
            <a class="primary-button" href="../Progress/Progress.aspx">Back to progress</a>
        </asp:Panel>
    </main>

    <footer class="learning-footer">&copy; <%: DateTime.Now.Year %> StudySphere &middot; Learn, practise, grow.</footer>
</form>
</body>
</html>
