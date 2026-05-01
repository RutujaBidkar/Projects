Use BookStore

--Creating Tables 
CREATE TABLE Books (
Book_ID INT PRIMARY KEY,
Title VARCHAR(100),
Author VARCHAR(100),
Genre VARCHAR(50),
Published_Year INT,
Price Int,
Stock INT
);
select *from Books 

---Import Data 

BULK INSERT Books
FROM 'D:\Online Book Store\Books.csv'
WITH (
    FIRSTROW = 2,         -- skips header
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',
    TABLOCK
);

--Creating 2nd Table 
CREATE TABLE Customers(
Customer_ID INT PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Phone Bigint,
City VARCHAR(50),
Country VARCHAR(150)
);

Select * from Customers

--Creating 3rd Table 
CREATE TABLE Orders (
Order_ID INT PRIMARY KEY,
Customer_ID INT REFERENCES Customers(Customer_ID),
Book_ID INT REFERENCES Books(Book_ID),
Order_Date DATE,
Quantity INT,
Total_Amount NUMERIC (10,2)
);

--Import Data
BULK INSERT Orders
FROM 'D:\Online Book Store\Order.csv'
WITH (
    FIRSTROW = 2,               -- skip header
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '\n'
);
ALTER TABLE Orders
ADD CONSTRAINT PK_Orders PRIMARY KEY (Order_ID);

ALTER TABLE Orders
ALTER COLUMN Customer_ID INT;

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Customers
FOREIGN KEY (Customer_ID)
REFERENCES Customers(Customer_ID);


ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Books
FOREIGN KEY (Book_ID)
REFERENCES Books(Book_ID);

ALTER TABLE Orders
ALTER COLUMN Book_ID VARCHAR(10);   -- match exact size 

Select *from Books

--practical Question 
--1. Retrive all books in "fiction " genre 
select  *from Books 
where Genre ='Fiction';

--2. find Books published after the year 1950
select *from Books 
where Published_Year >= 1950;

--or 
SELECT Published_Year
FROM Books
WHERE Published_Year >= 1950;

--3. List all customers from the canada 
select * from Customers 
where Country ='canada';

--4.show orders placed in November 2023 
select *from Books
select *from Orders
where Order_Date Between '2023-11-1' AND '2023-11-30';

--5.Retrieve the total stock of books available 
select sum(stock) As total_Stock from Books

--6.Find the details of the most expensive book
Select *from Books 
ORDER BY Price DESC ;

--or
Select Max(price) AS Most_Expensive_Book 
from Books

--7.show all customers who ordered more than 1 quantity of a book 
select *from Customers

Select *from Orders
where Quantity >1 ;

--8. Retrieve all orders where the total amount exceeds $20
select *from Orders 
where Total_Amount >= 20;

--9. list all genres available in the books table:
select  DISTINCT genre from Books

select *from Customers 

--10. Find the book With the lowest stock:
Select *from Books
ORDER BY stock ASC;

--11. calculate the total revenue generated from all orders:
SELECT Sum(Total_Amount) As Total_revenue 
From Orders;

--ADVANCE QUESTION 
--1.Retrieve the total number of books sold for each genre:
Select b.genre, SUM(o.quantity) As Total_Books_sold 
from Orders o 
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Genre ;

--2.find the Average Price of books in the "fantasy" genre 
select AVG(Price) AS Avg_Price 
From Books 
where genre= 'fantasy';

--3.list customers who have placed at least 2 orders:

select o.Customer_id,c.name , COUNT(o.Order_id) AS Order_Count 
from Orders o
join Customers c ON o.Customer_id = c.customer_id 
GROUP BY o.Customer_ID,  c.name
HAVING COUNT(Order_ID) >=2 ;


--4. Find the most frequently ordered book 
Select o.Book_id, b.title,COUNT(order_id) as order_count
From Orders o
Join Books b on o.book_id =b.Book_ID
GROUP BY o.Book_ID ,b.Title
ORDER BY order_count Desc ;


--5. Show the top 3 most expensive books of 'fantasy' genre 
Select *from Books
where genre ='Fantasy'
order by Price Desc ;
--or
SELECT TOP 3 *
FROM Books
WHERE Genre = 'fantasy'
ORDER BY Published_Year DESC;

--6.Retrieve the total Quantiity of books sold by each author ;
SELECT b.author, SUM(o.quantity) AS Total_Books_Sold 
From Orders o 
JOIN Books b ON o.Book_id = b.book_id
GROUP BY b.Author

--7.List the Cities Where Customers who spent over $30 are located 
SELECT DISTINCT c.city,Total_Amount
FROM Orders o 
JOIN Customers c ON o.Customer_ID= c.Customer_ID
where o.Total_Amount > 300;

--8.Find the Customer who spent the most on orders:
Select c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Total_Spent Desc;


--9.calculate the stock remaining after fulfillingg all orders :
Select b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity) ,0) As Order_quantity, 
b.stock-COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
From Books b 
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;



