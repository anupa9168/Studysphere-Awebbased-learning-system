<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="Quiz.aspx.cs"
    Inherits="StudySphere.Student.Quizzes.QuizPage" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Take Quiz | StudySphere</title>
    <link href="<%= ResolveUrl("~/Student/Quizzes/Quizzes.css") %>?v=2" rel="stylesheet" />
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

    <main class="page-shell narrow">
        <a class="back-link" href="Quizzes.aspx">&larr; Back to quizzes</a>
        <section class="quiz-header">
            <p class="eyebrow"><asp:Label ID="lblCourse" runat="server" /></p>
            <h1><asp:Label ID="lblQuizTitle" runat="server" /></h1>
            <p><asp:Label ID="lblDescription" runat="server" /></p>
        </section>

        <asp:Label ID="lblMessage" runat="server" CssClass="message error" Visible="false" />
        <asp:Panel ID="pnlQuiz" runat="server">
            <asp:Repeater ID="rptQuestions" runat="server" OnItemDataBound="rptQuestions_ItemDataBound">
                <ItemTemplate>
                    <article class="question-card">
                        <asp:HiddenField ID="hidQuestionId" runat="server" Value='<%# Eval("QuestionID") %>' />
                        <span class="question-number">Question <%# Container.ItemIndex + 1 %></span>
                        <p class="question-text"><%#: Eval("QuestionText") %></p>
                        <asp:RadioButtonList ID="rblOptions" runat="server" CssClass="options" RepeatLayout="Flow">
                            <asp:ListItem Value="A" />
                            <asp:ListItem Value="B" />
                            <asp:ListItem Value="C" />
                            <asp:ListItem Value="D" />
                        </asp:RadioButtonList>
                    </article>
                </ItemTemplate>
            </asp:Repeater>

            <div class="quiz-actions">
                <span class="note">Answer every question before submitting. You can take a quiz again later.</span>
                <asp:Button ID="btnSubmit" runat="server" Text="Submit quiz" CssClass="submit-button" OnClick="btnSubmit_Click" />
            </div>
        </asp:Panel>

        <asp:Label ID="lblNotFound" runat="server" CssClass="empty-state" Visible="false">
            This quiz could not be found or does not have any questions yet.
        </asp:Label>
    </main>

    <footer class="learning-footer">&copy; <%: DateTime.Now.Year %> StudySphere &middot; Learn, practise, grow.</footer>
</form>
</body>
</html>
