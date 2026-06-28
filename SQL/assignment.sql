
-- =============================================
-- Week 3 Assignment
-- SQL Advanced Analytics
-- Dataset: Superstore
-- =============================================

CREATE DATABASE superstore;
USE superstore;

-- =============================================
-- Renameing table
-- =============================================

RENAME TABLE `sample - superstore` TO superstore_raw;

-- =============================================
-- Verify Import
-- =============================================

SELECT COUNT(*)
FROM superstore_raw;

SELECT *
FROM superstore_raw
LIMIT 10;

-- =============================================
-- Create Customers Table
-- =============================================

CREATE TABLE customers AS
SELECT DISTINCT
    `Customer ID`,
    `Customer Name`,
    Segment
FROM superstore_raw;

SELECT *
FROM customers
LIMIT 10;

-- =============================================
-- Create Products Table
-- =============================================

CREATE TABLE products AS
SELECT DISTINCT
    `Product ID`,
    `Product Name`,
    Category,
    `Sub-Category`
FROM superstore_raw;

SELECT *
FROM products
LIMIT 10;

-- =============================================
-- Create Orders Table
-- =============================================

CREATE TABLE orders AS
SELECT DISTINCT
    `Order ID`,
    `Order Date`,
    `Ship Date`,
    `Customer ID`,
    `Product ID`,
    Sales, Quantity, Discount, Profit
FROM superstore_raw;

SELECT *
FROM orders
LIMIT 10;

SELECT COUNT(*) AS Customers
FROM customers;

SELECT COUNT(*) AS Products
FROM products;

SELECT COUNT(*) AS Orders
FROM orders;

-- =============================================
-- Task 7: Orders with Sales Greater Than Average
-- (Subquery)
-- =============================================

SELECT *
FROM orders
WHERE Sales >
(
    SELECT AVG(Sales) 
    FROM orders
);

-- =============================================
-- Task 8: Highest Sales Order Per Customer
-- (Correlated Subquery)
-- =============================================

SELECT o.*
FROM orders o
JOIN (
    SELECT
        `Customer ID`,
        MAX(Sales) AS MaxSales
    FROM orders
    GROUP BY `Customer ID`
) max_orders
ON o.`Customer ID` = max_orders.`Customer ID`
AND o.Sales = max_orders.MaxSales;

-- =============================================
-- Task 9: Total Sales for Each Customer (CTE)
-- =============================================

WITH CustomerSales AS
(
    SELECT
        `Customer ID`,
        SUM(Sales) AS TotalSales
    FROM orders
    GROUP BY `Customer ID`
)
SELECT *
FROM CustomerSales
ORDER BY TotalSales DESC;

-- =============================================
-- Task 10: Above Average Customers
-- (CTE + Subquery)
-- =============================================

WITH CustomerSales AS
(
    SELECT
        `Customer ID`,
        SUM(Sales) AS TotalSales
    FROM orders
    GROUP BY `Customer ID`
)
SELECT *
FROM CustomerSales
WHERE TotalSales >
(
    SELECT AVG(TotalSales)
    FROM CustomerSales
)
ORDER BY TotalSales DESC;

-- =============================================
-- Task 11: ROW_NUMBER()
-- =============================================

SELECT
    `Customer ID`,
    `Order ID`,
    `Order Date`,
    Sales,
    ROW_NUMBER() OVER(
        PARTITION BY `Customer ID`
        ORDER BY `Order Date`
    ) AS Order_Number
FROM orders;

-- =============================================
-- Task 12: RANK()
-- =============================================

WITH CustomerSales AS
(
    SELECT
        `Customer ID`,
        SUM(Sales) AS TotalSales
    FROM orders
    GROUP BY `Customer ID`
)
SELECT
    `Customer ID`,
    TotalSales,
    RANK() OVER(ORDER BY TotalSales DESC) AS CustomerRank
FROM CustomerSales;

-- =============================================
-- Task 13: DENSE_RANK()
-- =============================================

WITH CustomerSales AS
(
    SELECT
        `Customer ID`,
        SUM(Sales) AS TotalSales
    FROM orders
    GROUP BY `Customer ID`
)

SELECT
    `Customer ID`,
    TotalSales,
    DENSE_RANK() OVER(ORDER BY TotalSales DESC) AS DenseRank
FROM CustomerSales;

-- =============================================
-- Task 14: Top 3 Customers
-- =============================================

WITH CustomerSales AS
(
    SELECT
        `Customer ID`,
        SUM(Sales) AS TotalSales
    FROM orders
    GROUP BY `Customer ID`
)

SELECT *
FROM
(
    SELECT
        `Customer ID`,
        TotalSales,
        RANK() OVER(ORDER BY TotalSales DESC) AS CustomerRank
    FROM CustomerSales
) RankedCustomers
WHERE CustomerRank <= 3;

-- =============================================
-- Task 15: Final Combined Query
-- JOIN + CTE + Window Function
-- =============================================

WITH CustomerSales AS
(
    SELECT
        `Customer ID`,
        SUM(Sales) AS TotalSales
    FROM orders
    GROUP BY `Customer ID`
)

SELECT
    c.`Customer Name`,
    cs.TotalSales,
    RANK() OVER(ORDER BY cs.TotalSales DESC) AS CustomerRank
FROM CustomerSales cs
JOIN customers c
ON cs.`Customer ID` = c.`Customer ID`
ORDER BY CustomerRank;

-- =============================================
-- Mini Project: Top 5 Customers
-- =============================================

SELECT
    c.`Customer Name`,
    SUM(o.Sales) AS TotalSales
FROM customers c
JOIN orders o
ON c.`Customer ID` = o.`Customer ID`
GROUP BY c.`Customer Name`
ORDER BY TotalSales DESC
LIMIT 5;

-- =============================================
-- Mini Project: Bottom 5 Customers
-- =============================================

SELECT
    c.`Customer Name`,
    SUM(o.Sales) AS TotalSales
FROM customers c
JOIN orders o
ON c.`Customer ID` = o.`Customer ID`
GROUP BY c.`Customer Name`
ORDER BY TotalSales ASC
LIMIT 5;

-- =============================================
-- Mini Project: Customers with One Order
-- =============================================

SELECT
    c.`Customer Name`,
    COUNT(o.`Order ID`) AS TotalOrders
FROM customers c
JOIN orders o
ON c.`Customer ID` = o.`Customer ID`
GROUP BY c.`Customer Name`
HAVING COUNT(o.`Order ID`) = 1; 

-- =============================================
-- Mini Project: Above Average Customers
-- =============================================

WITH CustomerSales AS
(
    SELECT
        `Customer ID`,
        SUM(Sales) AS TotalSales
    FROM orders
    GROUP BY `Customer ID`
)
SELECT
    c.`Customer Name`,
    cs.TotalSales
FROM CustomerSales cs
JOIN customers c
ON cs.`Customer ID` = c.`Customer ID`
WHERE cs.TotalSales >
(
    SELECT AVG(TotalSales)
    FROM CustomerSales
)
ORDER BY cs.TotalSales DESC;


-- =============================================
-- Mini Project: Highest Order Value Per Customer
-- =============================================

SELECT
    c.`Customer Name`,
    MAX(o.Sales) AS HighestOrderValue
FROM customers c
JOIN orders o
ON c.`Customer ID` = o.`Customer ID`
GROUP BY c.`Customer Name`
ORDER BY HighestOrderValue DESC;