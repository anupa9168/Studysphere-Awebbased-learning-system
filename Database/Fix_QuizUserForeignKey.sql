USE StudySphereDB;
GO

IF OBJECT_ID(N'dbo.Users', N'U') IS NULL
    THROW 50001, 'dbo.Users was not found in StudySphereDB.', 1;

IF OBJECT_ID(N'dbo.tblQuizAttempts', N'U') IS NULL
    THROW 50002, 'dbo.tblQuizAttempts was not found. Run Database_Quizzes.sql first.', 1;

-- Stop safely if existing attempts do not map to the app's Users table.
IF EXISTS
(
    SELECT 1
    FROM dbo.tblQuizAttempts AS a
    LEFT JOIN dbo.Users AS u ON u.UserID = a.UserID
    WHERE u.UserID IS NULL
)
    THROW 50003, 'Some saved quiz attempts have UserIDs missing from dbo.Users. No constraint was changed.', 1;

-- Remove the stale FK if it points to a different user table.
IF EXISTS
(
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = N'FK_tblQuizAttempts_User'
      AND parent_object_id = OBJECT_ID(N'dbo.tblQuizAttempts')
      AND referenced_object_id <> OBJECT_ID(N'dbo.Users')
)
BEGIN
    ALTER TABLE dbo.tblQuizAttempts
        DROP CONSTRAINT FK_tblQuizAttempts_User;
END;
GO

-- Recreate the FK against the Users table used by the student login page.
IF NOT EXISTS
(
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = N'FK_tblQuizAttempts_User'
      AND parent_object_id = OBJECT_ID(N'dbo.tblQuizAttempts')
      AND referenced_object_id = OBJECT_ID(N'dbo.Users')
)
BEGIN
    ALTER TABLE dbo.tblQuizAttempts WITH CHECK
        ADD CONSTRAINT FK_tblQuizAttempts_User
        FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID);
END;
GO
