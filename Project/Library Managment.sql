---NEW PROJECT 
----------------------------------------Library Management--------------------------
__GL_APP_COPY__:-- Step 1: Create Tables
CREATE TABLE Books (Book_ID Bigint, Title VARCHAR(200),Author VARCHAR(200), category VARCHAR, Available INT );
CREATE TABLE Members (Member_ID INT UNIQUE KEY, Name VARCHAR(100), Email VARCHAR(100));
CREATE TABLE Borrowed_Books (Borrow_ID INT, Member_ID INT ,Book_ID INT, Borrow_Date Date );

-- Step 2: Insert Sample Data
INSERT INTO Books (Title,Author,category) VALUES ('Harry Potter','J.K.Rowling','Fantasy')
('Data structure','Mark Allen  Weiss','Education');
INSERT INTO Members (Name, Email) VALUES ('Rutuja Bidkar','Rutuja@gmail.com')
('Amit Sharma','Amit@gmail.com');

-- Step 3: CRUD Operations
-- Add a book
INSERT INTO Books (Title,Author,category,Available) VALUES ('The Alchemist','Paulo Coelho','Fiction',1);

-- Borrow a book
INSERT INTO Borrowed_Books (Member_ID,Book_ID,Borrow_Date) VALUES (1,2,Curdate());

-- Update book availability
UPDATE Books SET Available = 0 WHERE Book_ID = 2;

-- Step 4: Queries
-- List available books
SELECT Book_ID, Title ,Author,category FROM Books WHERE Available = 1;

-- List books borrowed by a member
SELECT B.Title, B.Author, BB.Borrow_Date  FROM Borrowed_Books BB 
JOIN Book B ON BB.Book_ID WHERE BB.Member_ID =1;

-- Count books by category
SELECT category, Count(*) AS Total_Books
 FROM Books GROUP BY category;

-- List all members with borrowed books
SELECT DISTINCT M.Member_ID,M.Name,M.Email FROM Members m
JOIN Borrowed_Books b ON M.Member_ID= BB.Member_ID ;

-- Step 5: Report Generation
-- Generate a Report of All Borrowed Books
SELECT 
BB.Borrow_ID,
M.Name AS Member_Name,
B.Title As Book_Title,
B.Author,
BB.Borrow_Date 
FROM Borrowed_Books BB;
JOIN Members M ON BB.Member_ID = M.Member_ID
JOIN Books B ON BB.Book_ID = B.Book_ID

-- Generate a Summary of Available and Borrowed Books
