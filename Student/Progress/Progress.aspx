<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="Progress.aspx.cs"
    Inherits="StudySphere.Student.Progress.Progress" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Progress | StudySphere</title>
    <link href="<%= ResolveUrl("~/Student/Progress/Progress.css") %>?v=1" rel="stylesheet" />
</head>
<body>
<form id="form1" runat="server">
    <nav class="learning-nav">
        <a class="brand" href="../StudentDashboard/StudentDashboard.aspx"><img src="../StudySphere.png" alt="" />StudySphere</a>
        <div class="nav-actions">
            <a href="../Courses/Courses.aspx">Courses</a>
            <a href="../Quizzes/Quizzes.aspx">Quizzes</a>
            <a class="active" href="Progress.aspx">My progress</a>
            <asp:LinkButton ID="btnLogout" runat="server" CssClass="nav-link" OnClick="btnLogout_Click">Logout</asp:LinkButton>
        </div>
    </nav>

    <main class="page-shell">
        <section class="page-hero">
            <p class="eyebrow">YOUR LEARNING SUMMARY</p>
            <h1>My progress</h1>
            <p>Review your quiz activity and see how your scores are improving.</p>
        </section>

        <section class="progress-summary" aria-label="Progress summary">
            <article class="summary-card">
                <span>Quizzes taken</span>
                <strong><asp:Label ID="lblAttempts" runat="server" Text="0" /></strong>
            </article>
            <article class="summary-card">
                <span>Average score</span>
                <strong><asp:Label ID="lblAverage" runat="server" Text="0%" /></strong>
            </article>
            <article class="summary-card">
                <span>Best score</span>
                <strong><asp:Label ID="lblBest" runat="server" Text="0%" /></strong>
            </article>
        </section>

        <section class="history-section">
            <div class="section-heading">
                <div>
                    <h2>Recent quiz attempts</h2>
                    <p>Your latest submissions appear first.</p>
                </div>
                <a class="secondary-button" href="../Quizzes/Quizzes.aspx">Take a quiz</a>
            </div>

            <asp:Panel ID="pnlEmpty" runat="server" CssClass="empty-state" Visible="false">
                <h2>No quiz attempts yet</h2>
                <p>Complete a quiz and your results will appear here.</p>
                <a class="primary-button" href="../Quizzes/Quizzes.aspx">Browse quizzes</a>
            </asp:Panel>

            <asp:Repeater ID="rptAttempts" runat="server">
                <HeaderTemplate>
                    <div class="table-scroll">
                    <table class="attempt-table">
                        <thead>
                            <tr><th>Course</th><th>Quiz</th><th>Score</th><th>Date</th><th></th></tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%#: Eval("CourseTitle") %></td>
                        <td><%#: Eval("QuizTitle") %></td>
                        <td><strong><%#: Eval("Score") %>/<%#: Eval("TotalQuestions") %></strong> (<%#: Eval("Percentage", "{0:0}%") %>)</td>
                        <td><%#: Eval("DateTaken", "{0:dd MMM yyyy, h:mm tt}") %></td>
                        <td><a class="view-result" href='../Quizzes/ViewResult.aspx?AttemptID=<%# Eval("AttemptID") %>'>Review answers</a></td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                    </div>
                </FooterTemplate>
            </asp:Repeater>
        </section>
    </main>

    <footer class="learning-footer">&copy; <%: DateTime.Now.Year %> StudySphere &middot; Learn, practise, grow.</footer>
</form>
</body>
</html>
