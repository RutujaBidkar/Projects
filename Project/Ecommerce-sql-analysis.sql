CREATE DATABASE EcommerceDB
GO

USE EcommerceDB;
GO


--Customers Table 
CREATE TABLE Customers(
CustomerID INT PRIMARY KEY,
Name VARCHAR(100), 
City VARCHAR(50));

--Product Table 
CREATE TABLE Products(
productID INT PRIMARY KEY,
ProductName VARCHAR(100),
Price DECIMAL(10,2)
);

--Order Table 
CREATE TABLE Orders(
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  OrderDate Date,
  FOREIGN KEY (CustomerID) REFERENCES 
  Customers(CustomerID)
  );

--OrderDetails Table 
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

--INSERTING VALUES INTO CUSTOMER TABLE
INSERT INTO Customers VALUES
(101,'Rutuja','pune'),
(102,'Amit','Mumbai'),
(103,'Sneha', 'Delhi');

--INSERTING VALUES INTO PRODUCT TABLE
INSERT INTO Products VALUES
(1001,'Laptop',50000),
(1002,'Phone',20000),
(1003, 'Headphones',2000);

--INSERTING VALUES INTO ORDER TABLE
Insert INTO Orders VALUES 
(10001,101,'2024-01-10'),
(10002,102,'2024-02-15'),
(10003,101,'2024-03-15');

---PRACTICE QUERIES (HOW MANY TOTAL SALES PER CUSTOMER)
SELECT c.Name, SUM (p.Price * od.Quantity) AS 
TotalSales
FROM Customers c
JOIN Orders o ON c.CustomerID= o.CustomerID  
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p on od.ProductID = p.ProductID 
GROUP BY c.Name;

---FIND TOP SELLING PRODUCT
SELECT TOP 1 p.ProductName, SUM(od.Quantity) AS 
TotalSold 
FROM Products p
JOIN OrderDetails od on p.productID = od.ProductID
GROUP BY p.ProductName
ORDER BY TotalSold DESC;

--TO CHECK MONTHLY REVENUE 
SELECT 
FORMAT(o.OrderDate, 'yyyy-MM') AS Month,
SUM (p.Price * od.Quantity ) AS Revenue
FROM Orders o
JOIN OrderDetails od ON o.OrderID= od.OrderID 
JOIN Products p ON od.ProductID= p.productID 
GROUP BY FORMAT(O.OrderDate,'yyyy-MM');

---TO CHECK CUSTOMERS WITH NO ORDERS 
SELECT c.Name
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
where o.orderID IS NULL 

--USE OF CTE(COMMON TABLE EXPRESSSION)
WITH SalesCTE AS( 
SELECT 
c.Name,SUM(p.Price * od.Quantity) AS TotalSales 
FROM  Customers c
JOIN Orders o ON c.CustomerID= o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
Join Products p ON od.ProductID =p.productID
GROUP BY c.Name
)
SELECT *FROM SalesCTE 
WHERE TotalSales >30000





