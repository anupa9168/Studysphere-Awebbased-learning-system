USE StudySphereDB;
GO

IF OBJECT_ID(N'dbo.tblQuizzes', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.tblQuizzes
    (
        QuizID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        CourseID INT NOT NULL,
        QuizTitle VARCHAR(100) NOT NULL,
        Description VARCHAR(255) NULL,
        CONSTRAINT FK_tblQuizzes_Course FOREIGN KEY (CourseID)
            REFERENCES dbo.Courses(CourseID),
        CONSTRAINT UQ_tblQuizzes_CourseTitle UNIQUE (CourseID, QuizTitle)
    );
END;
GO

IF OBJECT_ID(N'dbo.tblQuestions', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.tblQuestions
    (
        QuestionID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        QuizID INT NOT NULL,
        QuestionText VARCHAR(500) NOT NULL,
        OptionA VARCHAR(255) NOT NULL,
        OptionB VARCHAR(255) NOT NULL,
        OptionC VARCHAR(255) NOT NULL,
        OptionD VARCHAR(255) NOT NULL,
        CorrectAnswer CHAR(1) NOT NULL,
        CONSTRAINT FK_tblQuestions_Quiz FOREIGN KEY (QuizID)
            REFERENCES dbo.tblQuizzes(QuizID),
        CONSTRAINT CK_tblQuestions_CorrectAnswer CHECK (CorrectAnswer IN ('A', 'B', 'C', 'D'))
    );
END;
GO

/*
    tblQuizResults from the original draft is superseded by the two tables below.
    tblQuizAttempts stores the score; tblStudentAnswers stores the answer to each
    individual question for the attempt.
*/
IF OBJECT_ID(N'dbo.tblQuizAttempts', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.tblQuizAttempts
    (
        AttemptID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        UserID INT NOT NULL,
        QuizID INT NOT NULL,
        AttemptNumber INT NOT NULL,
        StartTime DATETIME NOT NULL CONSTRAINT DF_tblQuizAttempts_StartTime DEFAULT (GETDATE()),
        EndTime DATETIME NULL,
        Score INT NULL,
        TotalQuestions INT NULL,
        Percentage DECIMAL(5,2) NULL,
        CONSTRAINT FK_tblQuizAttempts_User FOREIGN KEY (UserID)
            REFERENCES dbo.Users(UserID),
        CONSTRAINT FK_tblQuizAttempts_Quiz FOREIGN KEY (QuizID)
            REFERENCES dbo.tblQuizzes(QuizID),
        CONSTRAINT UQ_tblQuizAttempts_Number UNIQUE (UserID, QuizID, AttemptNumber)
    );
END;
GO

IF OBJECT_ID(N'dbo.tblStudentAnswers', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.tblStudentAnswers
    (
        StudentAnswerID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        AttemptID INT NOT NULL,
        QuestionID INT NOT NULL,
        SelectedAnswer CHAR(1) NOT NULL,
        CONSTRAINT FK_tblStudentAnswers_Attempt FOREIGN KEY (AttemptID)
            REFERENCES dbo.tblQuizAttempts(AttemptID),
        CONSTRAINT FK_tblStudentAnswers_Question FOREIGN KEY (QuestionID)
            REFERENCES dbo.tblQuestions(QuestionID),
        CONSTRAINT UQ_tblStudentAnswers_AttemptQuestion UNIQUE (AttemptID, QuestionID),
        CONSTRAINT CK_tblStudentAnswers_SelectedAnswer CHECK (SelectedAnswer IN ('A', 'B', 'C', 'D'))
    );
END;
GO

DECLARE @Quizzes TABLE
(
    CourseTitle VARCHAR(100),
    QuizTitle VARCHAR(100),
    [Description] VARCHAR(255)
);

INSERT INTO @Quizzes (CourseTitle, QuizTitle, [Description])
VALUES
('Web Development Fundamentals', 'Web Development Quiz', 'Fundamentals Quiz'),
('Java Programming', 'Java Programming Quiz', 'Java Fundamentals Quiz'),
('Database Management Systems', 'Database Management Quiz', 'DBMS Quiz'),
('Computer Networks', 'Computer Networks Quiz', 'Networking Quiz'),
('Software Engineering', 'Software Engineering Quiz', 'SE Quiz'),
('UI/UX Design Fundamentals', 'UI/UX Design Quiz', 'Design Quiz'),
('Python Programming', 'Python Programming Quiz', 'Python Quiz'),
('Cybersecurity Fundamentals', 'Cybersecurity Quiz', 'Security Quiz');

INSERT INTO dbo.tblQuizzes (CourseID, QuizTitle, [Description])
SELECT course.CourseID, source.QuizTitle, source.[Description]
FROM @Quizzes AS source
INNER JOIN dbo.Courses AS course ON course.CourseTitle = source.CourseTitle
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.tblQuizzes AS target
    WHERE target.CourseID = course.CourseID
      AND target.QuizTitle = source.QuizTitle
);
GO

DECLARE @Questions TABLE
(
    QuizTitle VARCHAR(100),
    QuestionText VARCHAR(500),
    OptionA VARCHAR(255),
    OptionB VARCHAR(255),
    OptionC VARCHAR(255),
    OptionD VARCHAR(255),
    CorrectAnswer CHAR(1)
);

INSERT INTO @Questions
(QuizTitle, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectAnswer)
VALUES
('Web Development Quiz', 'What does HTML stand for?', 'Hyper Text Markup Language', 'Home Tool Markup Language', 'Hyper Transfer Markup Language', 'High Text Markup Language', 'A'),
('Web Development Quiz', 'Which CSS property changes text color?', 'background-color', 'color', 'font-style', 'text-align', 'B'),
('Web Development Quiz', 'Which language adds interactivity to web pages?', 'HTML', 'CSS', 'JavaScript', 'SQL', 'C'),
('Web Development Quiz', 'Which HTML tag creates a hyperlink?', '<link>', '<href>', '<a>', '<url>', 'C'),
('Web Development Quiz', 'Which CSS property controls spacing inside an element?', 'margin', 'padding', 'border', 'width', 'B'),

('Java Programming Quiz', 'Java is a:', 'Database', 'Programming Language', 'Operating System', 'Browser', 'B'),
('Java Programming Quiz', 'Which keyword creates an object?', 'object', 'create', 'new', 'class', 'C'),
('Java Programming Quiz', 'Which method starts a Java application?', 'run()', 'execute()', 'main()', 'start()', 'C'),
('Java Programming Quiz', 'Java supports:', 'OOP', 'Networking Only', 'Database Only', 'None', 'A'),
('Java Programming Quiz', 'Which symbol ends a Java statement?', ':', '.', ';', ',', 'C'),

('Database Management Quiz', 'What does DBMS stand for?', 'Database Management System', 'Data Business Management Software', 'Database Monitoring Service', 'Data Backup Management System', 'A'),
('Database Management Quiz', 'Which SQL command retrieves data?', 'INSERT', 'UPDATE', 'SELECT', 'DELETE', 'C'),
('Database Management Quiz', 'A Primary Key must be:', 'Duplicate', 'Unique', 'Optional', 'Foreign', 'B'),
('Database Management Quiz', 'A Foreign Key is used to:', 'Delete records', 'Create relationships', 'Sort data', 'Backup data', 'B'),
('Database Management Quiz', 'Which normal form removes repeating groups?', '1NF', '2NF', '3NF', 'BCNF', 'A'),

('Computer Networks Quiz', 'What does LAN stand for?', 'Local Area Network', 'Large Access Network', 'Logical Area Network', 'Local Access Node', 'A'),
('Computer Networks Quiz', 'Which device forwards packets?', 'Router', 'Printer', 'Monitor', 'Keyboard', 'A'),
('Computer Networks Quiz', 'IP stands for:', 'Internet Protocol', 'Internal Process', 'Internet Program', 'Information Package', 'A'),
('Computer Networks Quiz', 'Which command tests connectivity?', 'ping', 'copy', 'mkdir', 'route', 'A'),
('Computer Networks Quiz', 'Which topology uses a central device?', 'Ring', 'Bus', 'Star', 'Mesh', 'C'),

('Software Engineering Quiz', 'SDLC stands for:', 'Software Development Life Cycle', 'System Data Life Cycle', 'Software Design Logic Cycle', 'System Development Logic Cycle', 'A'),
('Software Engineering Quiz', 'Which is an Agile methodology?', 'Scrum', 'Waterfall', 'Spiral', 'V-Model', 'A'),
('Software Engineering Quiz', 'Requirements are gathered during:', 'Testing', 'Analysis', 'Deployment', 'Maintenance', 'B'),
('Software Engineering Quiz', 'A Use Case Diagram belongs to:', 'UML', 'SQL', 'HTML', 'CSS', 'A'),
('Software Engineering Quiz', 'Testing is performed to:', 'Find defects', 'Delete code', 'Design UI', 'Create database', 'A'),

('UI/UX Design Quiz', 'UX stands for:', 'User Experience', 'User Extension', 'User Example', 'Unified Experience', 'A'),
('UI/UX Design Quiz', 'UI stands for:', 'User Interface', 'Unified Interface', 'User Interaction', 'Universal Input', 'A'),
('UI/UX Design Quiz', 'Which tool is commonly used for wireframing?', 'Figma', 'SSMS', 'MySQL', 'Git', 'A'),
('UI/UX Design Quiz', 'Consistency improves:', 'Usability', 'Storage', 'Security', 'Bandwidth', 'A'),
('UI/UX Design Quiz', 'Wireframes are created during:', 'Design Phase', 'Testing', 'Deployment', 'Maintenance', 'A'),

('Python Programming Quiz', 'Python is:', 'Programming Language', 'Database', 'Browser', 'Network Protocol', 'A'),
('Python Programming Quiz', 'Which function displays output?', 'show()', 'display()', 'print()', 'output()', 'C'),
('Python Programming Quiz', 'Lists use:', '()', '[]', '{}', '<>', 'B'),
('Python Programming Quiz', 'Which keyword creates a function?', 'function', 'method', 'def', 'create', 'C'),
('Python Programming Quiz', 'Python supports:', 'OOP', 'Functional Programming', 'Procedural Programming', 'All of the Above', 'D'),

('Cybersecurity Quiz', 'What is a firewall used for?', 'Network Security', 'Database Design', 'Programming', 'Printing', 'A'),
('Cybersecurity Quiz', 'Phishing is:', 'Social Engineering Attack', 'Programming Language', 'Encryption Method', 'Backup Process', 'A'),
('Cybersecurity Quiz', 'HTTPS provides:', 'Encryption', 'Compression', 'Formatting', 'Storage', 'A'),
('Cybersecurity Quiz', 'Strong passwords should contain:', 'Letters Only', 'Numbers Only', 'Mixed Characters', 'Spaces Only', 'C'),
('Cybersecurity Quiz', 'Malware is:', 'Malicious Software', 'Email Service', 'Database', 'Protocol', 'A');

INSERT INTO dbo.tblQuestions
(QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectAnswer)
SELECT quiz.QuizID, source.QuestionText, source.OptionA, source.OptionB,
       source.OptionC, source.OptionD, source.CorrectAnswer
FROM @Questions AS source
INNER JOIN dbo.tblQuizzes AS quiz ON quiz.QuizTitle = source.QuizTitle
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.tblQuestions AS target
    WHERE target.QuizID = quiz.QuizID
      AND target.QuestionText = source.QuestionText
);
GO


