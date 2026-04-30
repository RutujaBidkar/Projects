CREATE DATABASE PerformanceDB;
GO
USE PerformanceDB;
GO

CREATE TAble Orders
(OrderID INT primary KEY,
CustomerName VARCHAR(100),
City Varchar(50),
OrderDate Date,
Amount DeCimal(10,2)
);

--INSERT LARGE DATA IMPORTANT 
DECLARE @i INT = 1;

WHILE @i <= 10000
BEGIN
    INSERT INTO Orders VALUES
    (
        @i,
        'Customer' + CAST(@i AS VARCHAR),
        CASE WHEN @i % 3 = 0 THEN 'Pune'
             WHEN @i % 3 = 1 THEN 'Mumbai'
             ELSE 'Delhi' END,
        DATEADD(DAY, -@i, GETDATE()),
        RAND() * 10000
    );

    SET @i = @i + 1;
END;

Select *from Orders;  

--QUERY WITHOUT INDEX
SELECT *FROM 
Orders WHERE City='Pune';

--CREATE INDEX 
CREATE NONCLUSTERED INDEX idX_city
ON Orders(City);

SELECT *FROM 
Orders WHERE City ='Pune';  

--COMPOSITE INDEX
CREATE NONCLUSTERED INDEX idx_city_date 
ON Orders(City,OrderDate);

SELECT *from Orders 
WHERE City ='Pune'
AND OrderDate > '2024-01-01';

