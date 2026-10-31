<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="QuizResult.aspx.cs"
    Inherits="StudySphere.Student.Quizzes.QuizResult" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quiz Result | StudySphere</title>
    <link href="<%= ResolveUrl("~/Student/Quizzes/Quizzes.css") %>?v=3" rel="stylesheet" />
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

    <main class="page-shell narrow result-page">
        <a class="back-link" href="Quizzes.aspx">&larr; Back to quizzes</a>
        <section class="result-page-heading">
            <p class="eyebrow">QUIZ SUMMARY</p>
            <h1>Your result</h1>
            <p>Review your score and keep building your knowledge.</p>
        </section>

        <asp:Panel ID="pnlResult" runat="server" CssClass="result-card">
            <div class="result-overview">
                <div class="score-orb">
                    <strong><asp:Label ID="lblScore" runat="server" /></strong>
                    <span>score</span>
                </div>
                <div class="result-title">
                    <span class="pill"><asp:Label ID="lblCourse" runat="server" /></span>
                    <h2><asp:Label ID="lblQuizTitle" runat="server" /></h2>
                    <p>Quiz completed. Your attempt has been saved.</p>
                </div>
            </div>

            <div class="result-details">
                <div class="result-detail">
                    <span>Correct answers</span>
                    <strong><asp:Label ID="lblCorrectAnswers" runat="server" /></strong>
                </div>
                <div class="result-detail">
                    <span>Attempt</span>
                    <strong>#<asp:Label ID="lblAttemptNumber" runat="server" /></strong>
                </div>
                <div class="result-detail">
                    <span>Completed</span>
                    <strong><asp:Label ID="lblDateTaken" runat="server" /></strong>
                </div>
            </div>

            <div class="result-actions">
                <a class="secondary-button" href="../Progress/Progress.aspx">View my progress</a>
                <a class="primary-button" href="Quizzes.aspx">Choose another quiz</a>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlNotFound" runat="server" CssClass="empty-state" Visible="false">
            <h2>Result not found</h2>
            <p>This result does not exist or does not belong to your account.</p>
            <a class="primary-button" href="Quizzes.aspx">Return to quizzes</a>
        </asp:Panel>
    </main>

    <footer class="learning-footer">&copy; <%: DateTime.Now.Year %> StudySphere &middot; Learn, practise, grow.</footer>
</form>
</body>
</html>
