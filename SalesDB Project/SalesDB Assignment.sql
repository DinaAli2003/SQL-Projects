CREATE DATABASE Sales_DB_SV
USE Sales_DB_SV;
GO

CREATE TABLE dbo.Customers (
  CustomerID INT IDENTITY(1,1) PRIMARY KEY,
  FullName   NVARCHAR(100) NOT NULL,
  Email      NVARCHAR(150) NOT NULL UNIQUE,
  CreatedAt  DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE dbo.CustomerProfiles (
  ProfileID   INT IDENTITY(1,1) PRIMARY KEY,
  CustomerID  INT NOT NULL UNIQUE,
  AddressLine NVARCHAR(200) NULL,
  City        NVARCHAR(80) NULL,
  BirthDate   DATE NULL,
  CONSTRAINT FK_Profiles_Customers
    FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID) ON DELETE CASCADE
);

CREATE TABLE dbo.Categories (
  CategoryID   INT IDENTITY(1,1) PRIMARY KEY,
  CategoryName NVARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE dbo.Products (
  ProductID   INT IDENTITY(1,1) PRIMARY KEY,
  ProductName NVARCHAR(120) NOT NULL,
  CategoryID  INT NOT NULL,
  Price       DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
  Active      BIT NOT NULL DEFAULT 1,
  CONSTRAINT FK_Products_Categories
    FOREIGN KEY (CategoryID) REFERENCES dbo.Categories(CategoryID)
);

CREATE TABLE dbo.Orders (
  OrderID     INT IDENTITY(1,1) PRIMARY KEY,
  CustomerID  INT NOT NULL,
  OrderDate   DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
  Status      NVARCHAR(20) NOT NULL DEFAULT 'NEW',
  CONSTRAINT FK_Orders_Customers
    FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID),
  CONSTRAINT CK_Orders_Status
    CHECK (Status IN ('NEW','PAID','CANCELLED'))
);

CREATE TABLE dbo.OrderItems (
  OrderID   INT NOT NULL,
  ProductID INT NOT NULL,
  Quantity  INT NOT NULL CHECK (Quantity > 0),
  UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
  CONSTRAINT PK_OrderItems PRIMARY KEY (OrderID, ProductID),
  CONSTRAINT FK_OrderItems_Orders
    FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID) ON DELETE CASCADE,
  CONSTRAINT FK_OrderItems_Products
    FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID)
);

CREATE TABLE dbo.Payments (
  PaymentID INT IDENTITY(1,1) PRIMARY KEY,
  OrderID   INT NOT NULL UNIQUE,
  PaidAt    DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
  Amount    DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
  Method    NVARCHAR(20) NOT NULL CHECK (Method IN ('CARD','CASH','WALLET')),
  CONSTRAINT FK_Payments_Orders
    FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID) ON DELETE CASCADE
);
GO


INSERT INTO dbo.Customers(FullName,Email) VALUES
(N'Radwa Taher', N'radwa@example.com'),
(N'Omar Ali',    N'omar@example.com'),
(N'Mona Hassan', N'mona@example.com');

INSERT INTO dbo.CustomerProfiles(CustomerID,AddressLine,City,BirthDate) VALUES
(1,N'Nasr City, Street 10', N'Cairo','2000-05-10'),
(2,N'Dokki, Street 5',      N'Giza', '1999-09-01'),
(3,N'Sidi Gaber',           N'Alex','2001-01-15');

INSERT INTO dbo.Categories(CategoryName) VALUES
(N'Electronics'),(N'Books'),(N'Home');

INSERT INTO dbo.Products(ProductName,CategoryID,Price) VALUES
(N'Wireless Mouse', 1, 450.00),
(N'USB-C Cable',    1, 120.00),
(N'Coffee Mug',     3, 90.00);

-- FIX: Insert missing ProductID = 4
INSERT INTO dbo.Products(ProductName,CategoryID,Price)
VALUES (N'Notebook', 2, 90.00);

INSERT INTO dbo.Orders(CustomerID,Status,OrderDate) VALUES
(1,'NEW',  DATEADD(day,-10,SYSDATETIME())),
(1,'PAID', DATEADD(day,-6, SYSDATETIME())),
(2,'PAID', DATEADD(day,-2, SYSDATETIME())),
(3,'NEW',  DATEADD(day,-1, SYSDATETIME()));

INSERT INTO dbo.OrderItems(OrderID,ProductID,Quantity,UnitPrice) VALUES
(1,1,2,450.00),
(1,2,1,120.00),
(2,3,1,300.00),
(3,1,1,450.00),
(3,4,3,90.00);

INSERT INTO dbo.Payments(OrderID,Amount,Method,PaidAt) VALUES
(2,300.00,'CARD',   DATEADD(day,-6,SYSDATETIME())),
(3,720.00,'WALLET', DATEADD(day,-2,SYSDATETIME()));
GO


CREATE OR ALTER VIEW dbo.vw_OrdersTotals
AS
SELECT
    o.OrderID,
    o.CustomerID,
    o.Status,
    o.OrderDate,
    SUM(oi.Quantity*oi.UnitPrice) AS OrderTotal
FROM dbo.Orders o
JOIN dbo.OrderItems oi ON oi.OrderID=o.OrderID
GROUP BY o.OrderID, o.CustomerID,o.status,o.OrderDate;
GO

SELECT * FROM dbo.vw_OrdersTotals ORDER BY OrderTotal DESC;


WITH CustomerSpend AS(
    SELECT
        c.CustomerID,
        c.FullName,
        ISNULL(SUM(v.OrderTotal),0) AS TotalSpend
    FROM dbo.Customers c
    LEFT JOIN dbo.vw_OrdersTotals v
        ON v.CustomerID=c.CustomerID
        AND v.Status='PAID'
    GROUP BY c.CustomerID,c.FullName
)
SELECT *
FROM CustomerSpend
ORDER BY TotalSpend DESC;


SELECT 
     c.FullName,
     COUNT(*) AS OrderCount
FROM dbo.Customers c
JOIN dbo.Orders o ON o.CustomerID=c.CustomerID
GROUP BY c.FullName
HAVING COUNT(*)>2;


SELECT o.CustomerID,
       SUM(oi.Quantity* oi.UnitPrice) AS TotalSpend
FROM dbo.Orders o
JOIN dbo.OrderItems oi ON oi.OrderID=O.OrderID
GROUP BY o.CustomerID
HAVING SUM(oi.Quantity*oi.UnitPrice)>500;


SELECT 
    OrderID,
    SUM(Quantity* UnitPrice) AS OrderTotal
FROM OrderItems
GROUP BY OrderID;


SELECT 
    OrderID,
    ProductID,
    Quantity,
    UnitPrice,
    SUM(Quantity * UnitPrice) OVER (PARTITION BY OrderID) AS OrderTotal
FROM OrderItems;


WITH CustomerSpend AS(
    SELECT 
        o.CustomerID,
        SUM(oi.Quantity*oi.UnitPrice) AS TotalSpend
    FROM dbo.Orders o
    JOIN dbo.OrderItems oi ON oi.OrderID=o.OrderID
    GROUP BY o.CustomerID
)
SELECT 
    cs.CustomerID,
    cs.TotalSpend,
    RANK() OVER (ORDER BY cs.TotalSpend DESC )AS SpendRank
FROM CustomerSpend cs
ORDER BY SpendRank;


WITH OrderTotal AS(
    SELECT 
        o.CustomerID,
        o.OrderID,
        SUM(oi.Quantity*oi.UnitPrice) AS OrderTotal
    FROM dbo.Orders o
    JOIN dbo.OrderItems oi ON oi.OrderID=o.OrderID
    GROUP BY O.CustomerID ,O.OrderID
)
SELECT
    CustomerID,
    OrderID,
    OrderTotal,
    AVG(OrderTotal) OVER (PARTITION BY CustomerID) AS AvgOrderForCustomer,
    OrderTotal-AVG(OrderTotal) OVER (PARTITION BY CustomerID ) AS DiffFromAvg
FROM OrderTotal
ORDER BY CustomerID,OrderID;
