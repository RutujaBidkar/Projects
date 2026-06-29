Create Database HealthInsurance
use HealthInsurance
--Create a Customer Table 
CREATE TABLE Customers
(
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Gender VARCHAR(10),
    DOB DATE,
    City VARCHAR(50),
    MobileNo VARCHAR(15)
);

--Create a policy Table 
CREATE TABLE Polices
(
    PolicyID INT PRIMARY KEY IDENTITY(101,1),
    CustomerID INT,
    PolicyName VARCHAR(100),
    SumInsured DECIMAL(12,2),
    PremiumAmount DECIMAL(10,2),
    StartDate Date,
    EndDate DATE,
    FOREIGN KEY(CustomerID)
    REFERENCES Customers(CustomerID)
    );

--Create Claims Table
CREATE TABLE Claims
(
    ClaimID INT PRIMARY KEY IDENTITY(1001,1),
    PolicyID INT,
    ClaimAmount DECIMAL(10,2),
    ClaimDate DATE,
    ClaimStatus VARCHAR(20),
    FOREIGN KEY (PolicyID)
    REFERENCES Polices (PolicyID)
);

-- Insert Data into Customer 
INSERT INTO Customers
(CustomerName, Gender, DOB, City, MobileNo)
VALUES
('Rahul Sharma','Male','1990-05-10','Pune','9876543210'),
('Priya Patil','Female','1995-08-20','Mumbai','9876543211'),
('Amit Joshi','Male','1988-11-15','Nagpur','9876543212'),
('Sneha Kulkarni','Female','1992-03-25','Pune','9876543213');

--Insert Into Polices
INSERT INTO Polices
(CustomerID, PolicyName, SumInsured, PremiumAmount, StartDate, EndDate)
VALUES
(1,'Family Health Plan',500000,12000,'2025-01-01','2025-12-31'),
(2,'Senior Citizen Plan',300000,15000,'2025-02-01','2026-01-31'),
(3,'Individual Plan',400000,10000,'2025-03-01','2026-02-28'),
(4,'Family Health Plan',600000,14000,'2025-01-15','2026-01-14');

--Insert Into Claims 
INSERT INTO Claims
(PolicyID, ClaimAmount, ClaimDate, ClaimStatus)
VALUES
(101,50000,'2025-04-10','Approved'),
(101,25000,'2025-05-12','Pending'),
(102,75000,'2025-06-01','Approved'),
(103,40000,'2025-06-15','Rejected');


--Problem 1 (JOINS)
--Write a query to display:(Customer Name,Policy Name,Sum Insured,Premium Amount)
--using the Customers and Policies tables.

SELECT
     Cust.CustomerName,
     Po.PolicyName,
     Po.SumInsured,
     Po.PremiumAmount
From Customers Cust
Inner Join Polices Po 
ON Cust.CustomerID= Po.CustomerID;

--Problem 2 Three-Table JOIN 
--Customer Name  Policy Name, Claim Amount,Claim Date,Claim Status
--Using: Customers,Polices,Claims

SELECT
    Cust.CustomerName,
    Po.PolicyName,
    Cla.ClaimAmount,
    Cla.ClaimDate,
    Cla.ClaimStatus
FROM Customers Cust
INNER JOIN Polices Po
    ON Cust.CustomerID = Po.CustomerID
INNER JOIN Claims Cla
    ON Po.PolicyID = Cla.PolicyID;

Select *from Customers;

SELECT
    Cust.CustomerName,
     COUNT(Cla.ClaimID) AS TotalClaims,
     SUM(Cla.ClaimAmount) AS TotalClaimAmount
FROM Customers Cust
INNER JOIN Polices Po
    ON Cust.CustomerID = Po.CustomerID
INNER JOIN Claims Cla
    ON Po.PolicyID = Cla.PolicyID
GROUP BY
    Polices;
    --Problem 
    --Create a view named: CustomerName,PolicyName,SumInsured,,PremiumAmount

    CREATE VIEW vw_CustomerPolicyDetails
    As
    Select 
          Cust.CustomerName,
          Po.PolicyName,
          Po.SumInsured,
          Po.PremiumAmount

     From Customers Cust 
     INNER JOIN Polices Po
     ON Cust.CustomerID= Po.CustomerID

     SELECT *
     FROM vw_CustomerPolicyDetails;

     --Problem
     --Create a function that adds 18% GST to the premium amount.
CREATE FUNCTION fn_CalculatePremiumWithGST
(
  @premiumAmount DECIMAL(10,2)
 )
 RETURNS DECIMAL(10,2)
 AS
 BEGIN 
      DECLARE @TotalAmount DECIMAl(10,2)

      SET @TotalAmount =@premiumAmount +(@premiumAmount *0.18)

      Return @TotalAmount

END

SELECT dbo.fn_CalculatePremiumWithGST(10000) AS TotalPremium;

--Problem :Claim Eligibility 
--Create a function that returns:Eligible if ClaimAmount <= 50000  Not Eligible if ClaimAmount > 50000

CREATE FUNCTION fn_CheckClaimEligibility
(
    @ClaimAmount DECIMAL(10,2)
)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @Result VARCHAR(20)

    IF @ClaimAmount <= 50000
        SET @Result = 'Eligible'
    ELSE
        SET @Result = 'Not Eligible'

    RETURN @Result
END


SELECT dbo.fn_CheckClaimEligibility(40000) AS Status;


-- Probleme Calculate Remaining Sum Insured
 --SumInsured = 500000 ClaimAmount = 50000

 CREATE FUNCTION CheckSumInsured
(
    @SumInsured DECIMAL(12,2),
    @ClaimAmount DECIMAL(12,2)
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @RemainingCoverage DECIMAL(12,2)

    SET @RemainingCoverage = @SumInsured - @ClaimAmount

    RETURN @RemainingCoverage
END

SELECT dbo.CheckSumInsured(500000,50000) AS RemainingCoverage;


--Problem 5: Total Claims by Policy
DECLARE @TotalClaimAmount DECIMAL(12,2)

SELECT @TotalClaimAmount = SUM(ClaimAmount)
FROM Claims
WHERE PolicyID = @PolicyID

RETURN @TotalClaimAmount


--Create a procedure that displays all claims based on claim status.
CREATE PROCEDURE sp_GetClaimsByStatus
(
    @ClaimStatus VARCHAR(50)
)
AS
BEGIN
    SELECT *
    FROM Claims
    WHERE ClaimStatus = @ClaimStatus
END


EXEC sp_GetClaimsByStatus 'Approved';


--using CTE Function Display All Claims Above Average Claim Amount 
--Find claims whose amount is greater than the average claim amount.
With AvgClaimsCTE AS
(
  SELECT AVG(ClaimAmount) As AvgAmount
  FROM Claims
 )
 SELECT 
       C.ClaimID,
       C.ClaimAmount
From Claims C 
CROSS JOIN AvgClaimsCTE A 
WHERE C.ClaimAmount > A.AvgAmount;

--problem :Customer Total Claim Amount
WITH CustomerClaims AS
(
    SELECT
        Cust.CustomerID,
        Cust.CustomerName,
        SUM(Cla.ClaimAmount) AS TotalClaimAmount
    FROM Customers Cust
    INNER JOIN Polices PO
        ON Cust.CustomerID = Po.CustomerID
    INNER JOIN Claims Cla
        ON Po.PolicyID = Cla.PolicyID
    GROUP BY
        Cust.CustomerID,
        Cust.CustomerName
)
SELECT *
FROM CustomerClaims;

--Create a stored procedure that displays all customers.
Create procedure getcust
As
Begin 
Select *from 
Customers
End

Exec getcust

--Create a stored procedure that accepts a CustomerID and displays only that customer's details.
Create procedure getCstbyId
@CustID Int
As
Begin 
Select CustomerId,CustomerName,city FROM 
Customers
Where CustomerID=@CustID
End

Exec getCstbyID 2;


--Stored Procedure with 2 Parameters  Display policies based on: CustomerID ,PolicyName

CREATE PROCEDURE sp_GetPolicyDetails
    @CustID INT,
    @PolicyName VARCHAR(100)
AS
BEGIN
    SELECT
        Cust.CustomerID,
        Cust.CustomerName,
        Po.PolicyName,
        Cl.ClaimAmount,
        Cl.ClaimDate,
        Cl.ClaimStatus
    FROM Customers Cust
    INNER JOIN Polices Po
        ON Cust.CustomerID = Po.CustomerID
    INNER JOIN Claims Cl
        ON Po.PolicyID = Cl.PolicyID
    WHERE Cust.CustomerID = @CustID
      AND Po.PolicyName = @PolicyName;
END;

EXEC sp_GetPolicyDetails
    @CustID = 1,
    @PolicyName = 'Family Health Plan';
    
-- Stored Procedure + INNER JOIN (Easy) Create a stored procedure that displays: Customer Name, Policy Name, Sum Insured, Premium Amount
CREATE PROCEDURE CustDetails
AS
BEGIN 
     SELECT Cust.CustomerName,
            Po.PolicyName,
            Po.SumInsured,
            Po.premiumAmount
            FROM Customers Cust
            INNER JOIN 
            Polices Po ON 
            Cust.CustomerID = Po.CustomerID 
END 

EXEC CustDetails;

--Stored Procedure + JOIN + Parameter Display all claims for a specific customer.
CREATE PROCEDURE DisplayCustdetail
@CustID INT
AS
BEGIN 
     SELECT 
     Cust.CustomerName,
     Po.policyName,
     Cl.ClaimAmount,
     Cl.claimStatus
     FROM Customers Cust
     INNER JOIN Polices Po ON 
     Cust.CustomerID= Po.CustomerID
     INNER JOIN Claims Cl
     ON Po.PolicyID = Cl.PolicyID

END

EXEC DisplayCustdetail 2;

--JOIN + Aggregate Function 
CREATE PROCEDURE sp_GetCustomerClaimSummry
AS
BEGIN
    SELECT
        C.CustomerID,
        C.CustomerName,
        COUNT(CL.ClaimID) AS TotalClaims,
        SUM(CL.ClaimAmount) AS TotalClaimAmount
    FROM Customers C
    INNER JOIN Polices P
        ON C.CustomerID = P.CustomerID
    INNER JOIN Claims CL
        ON P.PolicyID = CL.PolicyID
    GROUP BY
        C.CustomerID,
        C.CustomerName;
END;

EXEC sp_GetCustomerClaimSummry;


--City Wise Policy Details 
CREATE PROCEDURE SpCityWiseCustomerDetails
    @City VARCHAR(100)
AS
BEGIN
    SELECT
        Cust.CustomerName,
        Cust.City,
        P.PolicyName,
        COUNT(C.ClaimID) AS TotalClaims,
        ISNULL(SUM(C.ClaimAmount), 0) AS TotalClaimAmount
    FROM Customers Cust
    INNER JOIN Polices P
        ON Cust.CustomerID = P.CustomerID
    LEFT JOIN Claims C
        ON P.PolicyID = C.PolicyID
    WHERE Cust.City = @City
    GROUP BY
        Cust.CustomerName,
        Cust.City,
        P.PolicyName;
END;

EXEC SpCityWiseCustomerDetails 'PUNe';


