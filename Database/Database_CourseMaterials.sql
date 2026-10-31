USE StudySphereDB;
GO

IF OBJECT_ID(N'dbo.CourseResources', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CourseResources
    (
        ResourceID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        CourseID INT NOT NULL,
        ResourceType VARCHAR(10) NOT NULL,
        Title NVARCHAR(160) NOT NULL,
        Content NVARCHAR(MAX) NOT NULL,
        ResourceUrl NVARCHAR(500) NULL,
        CONSTRAINT FK_CourseResources_Courses FOREIGN KEY (CourseID)
            REFERENCES dbo.Courses(CourseID),
        CONSTRAINT CK_CourseResources_Type CHECK (ResourceType IN ('Note', 'Video')),
        CONSTRAINT UQ_CourseResources_Course_Type_Title UNIQUE (CourseID, ResourceType, Title)
    );
END;
GO

INSERT INTO dbo.CourseResources (CourseID, ResourceType, Title, Content, ResourceUrl)
SELECT c.CourseID, r.ResourceType, r.Title, r.Content, r.ResourceUrl
FROM (VALUES
    ('Web Development Fundamentals', 'Note', 'HTML page structure', N'HTML gives a page its structure. Start with <!doctype html>, then use html, head, and body. Put headings, paragraphs, links, images, and forms inside body. Choose semantic elements such as header, nav, main, section, and footer to describe each part of the page.', NULL),
    ('Web Development Fundamentals', 'Video', 'HTML and CSS for beginners', N'Build a page structure, style it with CSS, and follow along with a beginner friendly project.', 'https://www.youtube.com/watch?v=dX8396ZmSPk'),
    ('Java Programming', 'Note', 'Java foundations', N'A Java program is organized into classes. The main method is the application entry point. Variables have declared types; conditionals choose a path; loops repeat work. Objects hold state and expose behavior through methods. Encapsulation keeps an object’s data behind a clear public interface.', NULL),
    ('Java Programming', 'Video', 'Java programming for beginners', N'Work through variables, control flow, arrays, collections, and object oriented programming.', 'https://www.youtube.com/watch?v=A74TOX803D0'),
    ('Database Management Systems', 'Note', 'Relational database essentials', N'A relational database stores data in tables. A primary key uniquely identifies a row. A foreign key connects rows across tables. Normalize related data to reduce duplication, then use SELECT, INSERT, UPDATE, and DELETE to work with it. JOIN combines related rows from multiple tables.', NULL),
    ('Database Management Systems', 'Video', 'SQL and database fundamentals', N'Follow a complete beginner course covering tables, keys, queries, joins, and database design.', 'https://www.youtube.com/watch?v=HXV3zeQKqGY'),
    ('Computer Networks', 'Note', 'Network layers and addressing', N'Networks move data in packets. IP addresses identify hosts at the network layer, while ports identify application endpoints. DNS maps names to addresses. TCP provides ordered, reliable delivery; UDP has less overhead and does not guarantee delivery. Routers forward packets between networks.', NULL),
    ('Computer Networks', 'Video', 'Computer networking complete course', N'Review network fundamentals, addressing, protocols, and how data moves between devices.', 'https://www.youtube.com/watch?v=0PbTi_Prpgs'),
    ('Software Engineering', 'Note', 'Software development lifecycle', N'A typical development lifecycle moves through requirements, design, implementation, testing, deployment, and maintenance. Agile teams deliver in small increments and use feedback to adjust priorities. Clear requirements and version control help teams make changes safely.', NULL),
    ('Software Engineering', 'Video', 'Software engineering tutorials', N'Open YouTube results for beginner lessons on requirements, design, testing, and the software lifecycle.', 'https://www.youtube.com/results?search_query=software+engineering+fundamentals+beginner+tutorial'),
    ('UI/UX Design Fundamentals', 'Note', 'UI and UX design basics', N'User experience covers the whole journey a person has while using a product. User interface is the set of screens and controls they interact with. Start by understanding users and tasks, sketch a flow, make a wireframe, then test a prototype. Keep hierarchy, contrast, spacing, and repeated patterns consistent.', NULL),
    ('UI/UX Design Fundamentals', 'Video', 'Figma UI design for beginners', N'Follow a practical walkthrough of common interface design and Figma workflow techniques.', 'https://www.youtube.com/watch?v=jwCmIBJ8Jtc'),
    ('Python Programming', 'Note', 'Python language essentials', N'Python uses indentation to mark code blocks. Store values in variables and choose suitable types such as strings, numbers, lists, and dictionaries. Use if statements for decisions, loops for repetition, and def to create reusable functions. A list is ordered and mutable; a tuple is ordered and immutable.', NULL),
    ('Python Programming', 'Video', 'Python for Everybody', N'A complete university style introduction to Python programming, from core syntax to working with data.', 'https://www.youtube.com/watch?v=8DvywoWv6fI'),
    ('Cybersecurity Fundamentals', 'Note', 'Security foundations', N'Confidentiality, integrity, and availability are the core security goals. Use unique passwords and multi-factor authentication, keep software updated, and verify unexpected links or attachments. Phishing relies on social engineering. A firewall filters network traffic, while encryption protects data from being read by unauthorized parties.', NULL),
    ('Cybersecurity Fundamentals', 'Video', 'Cybersecurity fundamentals tutorials', N'Open YouTube results for beginner lessons on security principles, common threats, and practical defenses.', 'https://www.youtube.com/results?search_query=cybersecurity+fundamentals+beginner+course')
) AS r(CourseTitle, ResourceType, Title, Content, ResourceUrl)
INNER JOIN dbo.Courses AS c ON c.CourseTitle = r.CourseTitle
WHERE NOT EXISTS
(
    SELECT 1 FROM dbo.CourseResources AS existing
    WHERE existing.CourseID = c.CourseID
      AND existing.ResourceType = r.ResourceType
      AND existing.Title = r.Title
);
GO