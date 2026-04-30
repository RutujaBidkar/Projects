CREATE DATABASE BankingDB;
GO

USE BankingDB;
GO

--CREATE TABLE CUSTOMERS
CREATE TABLE Customers ( 
CustomerID INT PRIMARY KEY,
Name VARCHAR(100),
City VARCHAR(50)
);

--CREATE TABLE Accounts
CREATE TABLE ACCOUNTS (
AccountID INT PRIMARY KEY,
CustomerID INT,
AccountType VARCHAR(20),
Balance Decimal(10,2),
FOREIGN KEY (CustomerID) REFERENCES 
Customers(CustomerID)
);

--CREATE TABLE TRANSACTION 
CREATE TABLE TRANSACTIONS (
TransactionID INT PRIMARY KEY,
AccountID INT,
TransactionDate DATE,
Amount DECIMAL(10,2),
TransactionType VARCHAR(10),
FOREIGN KEY (AccountID) REFERENCES 
Accounts(AccountID)
);

--INSERTING VALUES INTO CUSTOMERS 
INSERT INTO Customers Values
( 1,'Rutuja', 'Pune'),
( 2,'preeti', 'Mumabi'),
( 3,'Sneha', 'Delhi');

--INSERTING INTO ACCOUNTS 
INSERT INTO Accounts VALUES
( 101,1,'Saving', 50000),
( 102,2,'Current',30000),
( 103,3,'Saving', 40000);

--INSERTING INTO TRANSACTION 
INSERT INTO Transactions VALUES 
(1001,101,'2024-01-10',5000,'Credit'),
(1002,101,'2024-01-12',2000,'Debit'),
(1003,102,'2024-02-15',10000,'Credit'),
(1004,103,'2024-03-01',5000,'Debit'),
(1005,101,'2024-03-05',3000,'Credit');

--PRACTICE QUERIES 
--FIND TOTAL BALANCE PER CUSTOMER
SELECT c.Name,SUM(a.Balance) AS TotalBalannce 
From Customers c
JOIN ACCOUNTS a ON c.CustomerID = a.CustomerID
GROUP BY c.Name;

--TOTAL CREDIT VS DEBIT 
SELECT TransactionType,
SUM(Amount) AS TotalAmount
FROM Transactions 
GROUP BY TransactionType;

--MONTHLY TRANSACTIONS 
SELECT 
FORMAT(TransactionDate,'yyyy-MM') AS Month,
SUM(Amount) AS TotalAmount
From Transactions
GROUP BY FORMAT(TransactionDate,'yyyy-MM');

--TOP CUSTOMER BY TRANSACTION AMOUNT
SELECT TOP 1 c.Name,SUM(t.Amount) AS 
TotalTransaction 
FROM Customers c
JOIN ACCOUNTS a ON c.CustomerID= a.CustomerID
JOIN TRANSACTIONS t ON a.AccountID= t.AccountID
GROUP BY c.Name
ORDER BY TotalTransaction DESC;

--CTE 
WITH TransactionSummary AS (
SELECT 
a.AccountID,
SUM(CASE WHEN TransactionType ='Credit'
THEN Amount ELSE 0 END) AS TotalCredit,
SUM (CASE WHEN TransactionType ='Debit'
Then Amount ELSE 0 END) AS TotalDebit
From TRANSACTIONS t 
JOIN ACCOUNTS a ON t.AccountID = a.AccountID
GROUP BY a.AccountID )

SELECT *FROM TransactionSummary;



