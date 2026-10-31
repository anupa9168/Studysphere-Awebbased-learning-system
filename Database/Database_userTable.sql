USE StudySphereDB;
GO

IF OBJECT_ID(N'dbo.Users', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Users
    (
        UserID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        FullName VARCHAR(100) NOT NULL,
        Username VARCHAR(50) NOT NULL UNIQUE,
        DateOfBirth DATE NOT NULL,
        Email VARCHAR(100) NOT NULL UNIQUE,
        Password VARCHAR(255) NOT NULL,
        IsAdmin BIT NOT NULL CONSTRAINT DF_Users_IsAdmin DEFAULT (0)
    );
END;
GO

IF COL_LENGTH(N'dbo.Users', N'IsAdmin') IS NULL
    ALTER TABLE dbo.Users ADD IsAdmin BIT NOT NULL
        CONSTRAINT DF_Users_IsAdmin DEFAULT (0);
GO

IF OBJECT_ID(N'dbo.Courses', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Courses
    (
        CourseID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        CourseTitle VARCHAR(100) NOT NULL,
        Category VARCHAR(50) NOT NULL,
        Level VARCHAR(50) NOT NULL,
        Description VARCHAR(500) NULL
    );
END;
GO

INSERT INTO dbo.Courses (CourseTitle, Category, Level, Description)
SELECT source.CourseTitle, source.Category, source.Level, source.Description
FROM (VALUES
    ('Web Development Fundamentals', 'Web Development', 'Beginner', 'HTML, CSS and JavaScript basics'),
    ('Java Programming', 'Programming', 'Beginner', 'Java fundamentals and OOP concepts'),
    ('Database Management Systems', 'Database', 'Intermediate', 'SQL, ERD and normalization'),
    ('Computer Networks', 'Networking', 'Intermediate', 'Network concepts and protocols'),
    ('Software Engineering', 'Software Development', 'Intermediate', 'SDLC, Agile and Waterfall'),
    ('UI/UX Design Fundamentals', 'Design', 'Beginner', 'Wireframes and usability'),
    ('Python Programming', 'Programming', 'Beginner', 'Python fundamentals'),
    ('Cybersecurity Fundamentals', 'Security', 'Intermediate', 'Security threats and protection')
) AS source(CourseTitle, Category, Level, Description)
WHERE NOT EXISTS
(
    SELECT 1 FROM dbo.Courses AS existing WHERE existing.CourseTitle = source.CourseTitle
);
GO

-- To provision an administrator: register a normal account, sign in once so its
-- legacy password is upgraded if needed, then grant the role in SQL Server:
-- UPDATE dbo.Users SET IsAdmin = 1 WHERE Username = 'your-admin-username';