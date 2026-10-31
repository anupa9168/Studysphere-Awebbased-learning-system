<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="Learning.aspx.cs"
    Inherits="StudySphere.Student.Courses.Learning" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Learning - StudySphere</title>
    <link rel="stylesheet" type="text/css"
          href="<%= ResolveUrl("~/Student/Courses/Learning.css") %>?v=2" />
</head>
<body>
<form id="form1" runat="server">
    <header class="main-header">
        <div class="header-container">
            <a href="../Home.aspx" class="logo-area">
                <span class="logo-badge">
                    <img src="StudySphere.png" alt="StudySphere Logo" class="logo-image" />
                </span>
                <span class="logo-text">StudySphere</span>
            </a>
            <nav class="main-nav">
                <a href="Courses.aspx" class="nav-link">Courses</a>
                <a href="#course-notes" class="nav-link">Notes</a>
                <a href="#video-tutorials" class="nav-link">Tutorials</a>
                <asp:LinkButton ID="btnLogout" runat="server" CssClass="logout-button"
                                OnClick="btnLogout_Click">Logout</asp:LinkButton>
            </nav>
        </div>
    </header>

    <main class="learning-container">
        <a href="Courses.aspx" class="back-link">← Back to courses</a>

        <asp:Panel ID="pnlLearning" runat="server" CssClass="learning-content">
            <p class="eyebrow">YOUR LEARNING SPACE</p>
            <h1><asp:Label ID="lblCourseTitle" runat="server" /></h1>
            <div class="course-meta">
                <asp:Label ID="lblCategory" runat="server" CssClass="category-tag" />
                <asp:Label ID="lblLevel" runat="server" CssClass="level-tag" />
            </div>
            <section class="course-overview">
                <h2>Course overview</h2>
                <asp:Label ID="lblDescription" runat="server" CssClass="description" />
            </section>

            <section id="course-notes" class="resource-section">
                <div class="section-heading">
                    <div><p class="eyebrow">REVIEW THE KEY IDEAS</p><h2>Course notes</h2></div>
                    <span class="resource-count"><asp:Label ID="lblNoteCount" runat="server" CssClass="js-note-count" /> notes</span>
                </div>
                <asp:Repeater ID="rptNotes" runat="server">
                    <HeaderTemplate><div class="notes-grid"></HeaderTemplate>
                    <ItemTemplate>
                        <article class="note-card">
                            <span class="note-mark" aria-hidden="true">N</span>
                            <h3><%#: Eval("Title") %></h3>
                            <p class="note-copy"><%#: Eval("Content") %></p>
                            <asp:HyperLink ID="lnkNoteSource" runat="server" CssClass="note-source" Text="Read more"
                                NavigateUrl='<%# Eval("ResourceUrl") %>' Target="_blank" rel="noopener noreferrer"
                                Visible='<%# IsHttpsResourceUrl(Eval("ResourceUrl")) %>' />
                        </article>
                    </ItemTemplate>
                    <FooterTemplate></div></FooterTemplate>
                </asp:Repeater>
                <div id="fallbackNotes" class="notes-grid"></div>
                <asp:Panel ID="pnlNoNotes" runat="server" CssClass="empty-material" Visible="false">
                    Notes for this course will be added soon.
                </asp:Panel>
            </section>

            <section id="video-tutorials" class="resource-section video-section">
                <div class="section-heading">
                    <div><p class="eyebrow">WATCH AND FOLLOW ALONG</p><h2>Video tutorials</h2></div>
                    <span class="resource-count"><asp:Label ID="lblVideoCount" runat="server" CssClass="js-video-count" /> videos</span>
                </div>
                <asp:Repeater ID="rptVideos" runat="server">
                    <HeaderTemplate><div class="video-list"></HeaderTemplate>
                    <ItemTemplate>
                        <article class="video-card">
                            <div class="play-mark" aria-hidden="true">▶</div>
                            <div class="video-info">
                                <h3><%#: Eval("Title") %></h3>
                                <p><%#: Eval("Content") %></p>
                            </div>
                            <a class="watch-link" href='<%#: Eval("ResourceUrl") %>'
                               target="_blank" rel="noopener noreferrer">Watch tutorial</a>
                        </article>
                    </ItemTemplate>
                    <FooterTemplate></div></FooterTemplate>
                </asp:Repeater>
                <div id="fallbackVideos" class="video-list"></div>
                <asp:Panel ID="pnlNoVideos" runat="server" CssClass="empty-material" Visible="false">
                    Video tutorials for this course will be added soon.
                </asp:Panel>
            </section>
        </asp:Panel>

        <asp:Label ID="lblCourseNotFound" runat="server" CssClass="not-found" Visible="false">
            Course not found. Return to the course list and choose a course to continue.
        </asp:Label>
    </main>

    <footer class="main-footer">
        <h3>StudySphere</h3>
        <p>Learn. Explore. Grow.</p>
    </footer>
</form>
<script type="text/javascript">
(function () {
    var materialsByCourse = {
        "Web Development Fundamentals": {
            notes: [
                ["HTML page structure", "HTML gives a page its structure. Start with <!doctype html>, then use html, head, and body. Semantic elements such as header, nav, main, section, and footer describe each part of the page.", "https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Structuring_content/Basic_HTML_syntax"],
                ["HTML elements and links", "Most HTML elements have an opening tag, content, and a closing tag. Use headings in order, paragraphs for text, and anchor elements for links. Add useful alt text to images so their purpose is available to screen readers.", "https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements"],
                ["CSS layout basics", "CSS rules use a selector and declarations inside braces. Use classes to style groups of elements. The box model is content, padding, border, and margin. Flexbox and Grid help arrange responsive layouts; media queries adapt them to smaller screens.", "https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Styling_basics/Box_model"]
            ],
            videos: [
                ["HTML and CSS for beginners", "Build a page structure, style it with CSS, and follow along with a beginner friendly project.", "https://www.youtube.com/watch?v=dX8396ZmSPk"],
                ["JavaScript for beginners", "Learn variables, functions, conditions, loops, and basic browser interactivity.", "https://www.youtube.com/watch?v=Zi-Q0t4gMC8"]
            ]
        },
        "Java Programming": {
            notes: [
                ["Java foundations", "A Java program is organized into classes. The main method is the application entry point. Variables have declared types; conditionals choose a path; loops repeat work.", "https://dev.java/learn/"],
                ["Methods and arrays", "A method groups reusable instructions and can receive parameters and return a value. An array stores a fixed-size sequence of one type. Array indexes start at zero, so the last valid index is length minus one.", "https://dev.java/learn/classes-objects/"],
                ["Objects and encapsulation", "A class describes the data and behavior of a kind of object. Create an object with new. Keep fields private and expose carefully chosen methods so other code uses the object through a clear interface.", "https://dev.java/learn/language/oop/"]
            ],
            videos: [
                ["Java programming for beginners", "Work through variables, control flow, arrays, collections, and object oriented programming.", "https://www.youtube.com/watch?v=A74TOX803D0"],
                ["Java object oriented programming", "Find beginner lessons on classes, objects, constructors, and inheritance.", "https://www.youtube.com/results?search_query=Java+object+oriented+programming+beginner+tutorial"]
            ]
        },
        "Database Management Systems": {
            notes: [
                ["Relational database essentials", "A relational database stores data in tables. A primary key uniquely identifies a row. A foreign key connects rows across tables. JOIN combines related rows from multiple tables.", "https://learn.microsoft.com/en-us/sql/relational-databases/tables/primary-and-foreign-key-constraints?view=sql-server-ver17"],
                ["Writing basic SQL", "Use SELECT to read rows, INSERT to add rows, UPDATE to change rows, and DELETE to remove rows. Use WHERE to limit which rows are affected. Always check the condition before running an UPDATE or DELETE.", "https://learn.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql/"],
                ["Normalization and relationships", "Normalization reduces repeated facts by separating subjects into related tables. One-to-many relationships place the foreign key on the many side. A many-to-many relationship usually needs a linking table with two foreign keys.", "https://learn.microsoft.com/en-us/training/modules/explore-performance-based-design/"]
            ],
            videos: [
                ["SQL and database fundamentals", "Follow a beginner course covering tables, keys, queries, joins, and database design.", "https://www.youtube.com/watch?v=HXV3zeQKqGY"],
                ["SQL joins for beginners", "Practise matching rows from related tables with INNER JOIN and LEFT JOIN.", "https://www.youtube.com/results?search_query=SQL+joins+beginner+tutorial"]
            ]
        },
        "Computer Networks": {
            notes: [
                ["Network layers and addressing", "Networks move data in packets. IP addresses identify hosts, while ports identify application endpoints. DNS maps names to addresses. Routers forward packets between networks.", "https://www.cisco.com/site/us/en/learn/topics/small-business/networking-basics.html"],
                ["TCP and UDP", "TCP establishes a connection and provides ordered, reliable delivery. UDP sends datagrams with less overhead but does not guarantee delivery or order. Applications choose based on whether reliability or low latency matters more.", "https://developer.mozilla.org/en-US/docs/Learn_web_development/Getting_started/Web_standards/How_the_web_works"],
                ["HTTP and DNS", "A browser uses DNS to find a server for a domain name. It then sends an HTTP request and receives a response. HTTPS protects that exchange with encryption, helping prevent others from reading or changing the traffic in transit.", "https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Overview"]
            ],
            videos: [
                ["Computer networking complete course", "Review network fundamentals, addressing, protocols, and how data moves between devices.", "https://www.youtube.com/watch?v=0PbTi_Prpgs"],
                ["TCP/IP explained for beginners", "Find short lessons that explain IP addresses, ports, TCP, UDP, and packets.", "https://www.youtube.com/results?search_query=TCP+IP+explained+for+beginners"]
            ]
        },
        "Software Engineering": {
            notes: [
                ["Software development lifecycle", "A typical lifecycle moves through requirements, design, implementation, testing, deployment, and maintenance. Agile teams deliver in small increments and use feedback to adjust priorities.", "https://www.atlassian.com/agile/software-development/sdlc"],
                ["Requirements and user stories", "A requirement describes a need or constraint. A user story states who needs something, what they need, and why. Clear acceptance criteria make it easier to decide whether the finished work meets that need.", "https://www.atlassian.com/agile/project-management/user-stories"],
                ["Testing and version control", "Unit tests check small pieces of logic; integration tests check how components work together. Version control records changes over time, supports collaboration, and lets a team review or restore earlier work.", "https://www.atlassian.com/agile/software-development"]
            ],
            videos: [
                ["Software engineering tutorials", "Find beginner lessons on requirements, design, testing, and the software lifecycle.", "https://www.youtube.com/results?search_query=software+engineering+fundamentals+beginner+tutorial"],
                ["SDLC and Agile for beginners", "Watch introductory lessons on development phases, Scrum, and iterative delivery.", "https://www.youtube.com/results?search_query=SDLC+Agile+beginner+tutorial"]
            ]
        },
        "UI/UX Design Fundamentals": {
            notes: [
                ["UI and UX design basics", "User experience covers the journey a person has with a product. User interface is the set of screens and controls they interact with. Start by understanding users and their tasks.", "https://www.w3.org/WAI/fundamentals/"],
                ["Wireframes and prototypes", "A wireframe lays out content and navigation before visual details are finalized. A prototype makes screens clickable so people can try a flow. Test the prototype early and note where users hesitate or get lost.", "https://help.figma.com/hc/en-us/articles/360040314193-Guide-to-prototyping-in-Figma"],
                ["Visual hierarchy and accessibility", "Use size, spacing, contrast, and alignment to show what matters first. Keep text readable and provide clear focus states for keyboard users. Do not rely on color alone to communicate important information.", "https://www.w3.org/WAI/WCAG22/quickref/"]
            ],
            videos: [
                ["Figma UI design for beginners", "Follow a practical walkthrough of interface design and common Figma techniques.", "https://www.youtube.com/watch?v=jwCmIBJ8Jtc"],
                ["Figma prototyping for beginners", "Learn to connect screens, add interactions, and preview a simple prototype.", "https://www.youtube.com/results?search_query=Figma+prototyping+beginner+tutorial"]
            ]
        },
        "Python Programming": {
            notes: [
                ["Python language essentials", "Python uses indentation to mark code blocks. Use if statements for decisions, loops for repetition, and def to create reusable functions.", "https://docs.python.org/3/tutorial/index.html"],
                ["Collections and loops", "Lists keep an ordered, changeable sequence; dictionaries map keys to values. Use for to visit each item in a collection. Use a while loop when repetition should continue until a condition changes.", "https://docs.python.org/3/tutorial/datastructures.html"],
                ["Functions and errors", "Functions give a useful name to reusable work and can accept inputs. Return a result with return. Use exceptions to handle expected errors, and keep functions focused so they are easier to test and understand.", "https://docs.python.org/3/tutorial/controlflow.html"]
            ],
            videos: [
                ["Python for Everybody", "A university style introduction to Python, from core syntax to working with data.", "https://www.youtube.com/watch?v=8DvywoWv6fI"],
                ["Python functions and collections", "Find beginner walkthroughs for functions, lists, dictionaries, and loops.", "https://www.youtube.com/results?search_query=Python+functions+lists+dictionaries+beginner+tutorial"]
            ]
        },
        "Cybersecurity Fundamentals": {
            notes: [
                ["Security foundations", "Confidentiality, integrity, and availability are core security goals. Use unique passwords and multi-factor authentication, keep software updated, and verify unexpected links or attachments.", "https://www.cisa.gov/secure-our-world"],
                ["Phishing and social engineering", "Phishing messages try to make people reveal information or open harmful links. Check the sender and destination carefully, be wary of urgent requests, and confirm unusual payment or password requests through a separate trusted channel.", "https://www.cisa.gov/secure-our-world"],
                ["Authentication and encryption", "Authentication checks who is signing in; authorization decides what they may do. Multi-factor authentication adds another proof of identity. Encryption makes data unreadable without the appropriate key, both in storage and during transmission.", "https://www.cisa.gov/secure-our-world"]
            ],
            videos: [
                ["Cybersecurity fundamentals tutorials", "Find beginner lessons on security principles, common threats, and practical defenses.", "https://www.youtube.com/results?search_query=cybersecurity+fundamentals+beginner+course"],
                ["Online safety and phishing", "Watch beginner lessons on recognizing scams, protecting accounts, and safer browsing.", "https://www.youtube.com/results?search_query=phishing+and+online+safety+beginner+tutorial"]
            ]
        }
    };

    function addText(parent, tag, className, text) {
        var element = document.createElement(tag);
        if (className) element.className = className;
        element.textContent = text;
        parent.appendChild(element);
        return element;
    }

    var titleElement = document.querySelector(".learning-content h1");
    if (!titleElement) return;
    var selected = materialsByCourse[titleElement.textContent.trim()];
    if (!selected) return;

    var notes = document.getElementById("fallbackNotes");
    selected.notes.forEach(function (note) {
        var heading = Array.prototype.filter.call(
            document.querySelectorAll("#course-notes .note-card h3"),
            function (item) { return item.textContent.trim() === note[0]; })[0];
        var noteCard = heading ? heading.closest(".note-card") : null;
        if (!noteCard) {
            noteCard = document.createElement("article");
            noteCard.className = "note-card";
            addText(noteCard, "span", "note-mark", "N").setAttribute("aria-hidden", "true");
            addText(noteCard, "h3", "", note[0]);
            addText(noteCard, "p", "note-copy", note[1]);
            notes.appendChild(noteCard);
        }

        var sourceUrl;
        try { sourceUrl = new URL(note[2]); } catch (e) { return; }
        if (sourceUrl.protocol !== "https:" || noteCard.querySelector(".note-source")) return;
        var sourceLink = addText(noteCard, "a", "note-source", "Read more");
        sourceLink.href = sourceUrl.href;
        sourceLink.target = "_blank";
        sourceLink.rel = "noopener noreferrer";
    });

    var videos = document.getElementById("fallbackVideos");
    selected.videos.forEach(function (video) {
        var alreadyShown = Array.prototype.some.call(
            document.querySelectorAll("#video-tutorials .video-card h3"),
            function (heading) { return heading.textContent.trim() === video[0]; });
        if (alreadyShown) return;
        var videoUrl;
        try { videoUrl = new URL(video[2]); } catch (e) { return; }
        if (videoUrl.protocol !== "https:" ||
            ["www.youtube.com", "youtube.com", "youtu.be"].indexOf(videoUrl.hostname) < 0) return;
        var videoCard = document.createElement("article");
        videoCard.className = "video-card";
        addText(videoCard, "div", "play-mark", "▶").setAttribute("aria-hidden", "true");
        var videoInfo = addText(videoCard, "div", "video-info", "");
        addText(videoInfo, "h3", "", video[0]);
        addText(videoInfo, "p", "", video[1]);
        var watchLink = addText(videoCard, "a", "watch-link", "Watch tutorial");
        watchLink.href = videoUrl.href;
        watchLink.target = "_blank";
        watchLink.rel = "noopener noreferrer";
        videos.appendChild(videoCard);
    });

    var noteCount = document.querySelector(".js-note-count");
    var videoCount = document.querySelector(".js-video-count");
    if (noteCount) noteCount.textContent = document.querySelectorAll("#course-notes .note-card").length.toString();
    if (videoCount) videoCount.textContent = document.querySelectorAll("#video-tutorials .video-card").length.toString();
})();
</script>
</body>
</html>
