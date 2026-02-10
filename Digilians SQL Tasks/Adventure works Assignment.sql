

-- SQL Assignment – AdventureWorks Database
-- Assignment1
USE adventureworks;

/* =====================================================
   Part 1: Basic SELECT
===================================================== */

-- 1. Retrieve ProductID, Name, and ListPrice from Production.Product
SELECT ProductID, Name, ListPrice
FROM Product;

-- 2. Display all products with ListPrice greater than 100
SELECT *
FROM Product
WHERE ListPrice > 100;

-- 3. Retrieve all products where Color is NULL
SELECT *
FROM Product
WHERE Color IS NULL;

-- 4. List all products ordered by ListPrice in descending order
SELECT *
FROM Product
ORDER BY ListPrice DESC;

-- 5. Retrieve distinct ProductSubcategoryID values
SELECT DISTINCT ProductSubcategoryID
FROM Product;


/* =====================================================
   Part 2: WHERE, LIKE, IN, BETWEEN
===================================================== */

-- 1. Find products whose Name starts with 'Road'
SELECT *
FROM Product
WHERE Name LIKE 'Road%';

-- 2. Retrieve products with ListPrice between 500 and 1500
SELECT *
FROM Product
WHERE ListPrice BETWEEN 500 AND 1500;

-- 3. List products whose Color is Red, Black, or Silver
SELECT *
FROM Product
WHERE Color IN ('Red', 'Black', 'Silver');

-- 4. Retrieve sales orders where TotalDue is greater than 2000
SELECT *
FROM SalesOrderHeader
WHERE TotalDue > 2000;

-- 5. Find vendors whose Name contains the word 'Bike'
SELECT *
FROM productsubcategory
WHERE Name LIKE '%Bike%';


/* =====================================================
   Part 3: ORDER BY & LIMITING RESULTS
===================================================== */

-- 1. Retrieve the top 10 most expensive products
SELECT  ProductID, Name, ListPrice
FROM Product
ORDER BY ListPrice DESC
LIMIT 10;

-- 2. List the latest 5 sales orders ordered by OrderDate
SELECT *
FROM SalesOrderHeader
ORDER BY OrderDate DESC
LIMIT 5;

-- 3. Retrieve purchase orders ordered by OrderDate
SELECT *
FROM PurchaseOrderHeader
ORDER BY OrderDate;

-- 4. Display vendors ordered alphabetically by Name
SELECT *
FROM productvendor
ORDER BY VendorID ASC;


/* =====================================================
   Part 4: Aggregate Functions & GROUP BY
===================================================== */

-- 1. Count the total number of products
SELECT COUNT(*) AS TotalProducts
FROM Product;

-- 2. Find the average ListPrice of products
SELECT AVG(ListPrice) AS AverageListPrice
FROM Product;

-- 3. Display the total sales amount per SalesOrderID
SELECT SalesOrderID, SUM(TotalDue) AS TotalSalesAmount
FROM SalesOrderHeader
GROUP BY SalesOrderID;

-- 4. Count the number of products in each ProductSubcategoryID
SELECT ProductSubcategoryID, COUNT(*) AS ProductCount
FROM Product
GROUP BY ProductSubcategoryID;

-- 5. Show vendors that have more than 3 purchase orders
SELECT VendorID, COUNT(PurchaseOrderID) AS PurchaseOrderCount
FROM PurchaseOrderHeader
GROUP BY VendorID
HAVING COUNT(PurchaseOrderID) > 3;


/* =====================================================
   Bonus Question
===================================================== */

-- Show ProductSubcategoryID that has more than 10 products
SELECT ProductSubcategoryID, COUNT(*) AS ProductCount
FROM Product
GROUP BY ProductSubcategoryID
HAVING COUNT(*) > 10;





-- Assignment2 
-- SQL Assignment: JOIN, GROUP BY, and HAVING

-- Question 1: Sales Analysis by Product Category
SELECT  category , SUM(sales_amount) as total_sales 
FROM fact_sales as fs
INNER JOIN 
dim_products AS dp
ON fs.product_key = dp.product_key
GROUP BY category
ORDER BY total_sales DESC;


-- Question 2: High-Performing Products
SELECT product_name , SUM(sales_amount) as total_sales 
FROM fact_sales as fs
INNER JOIN 
dim_products AS dp
ON fs.product_key = dp.product_key
GROUP BY product_name
HAVING total_sales > 50000
ORDER BY total_sales DESC;