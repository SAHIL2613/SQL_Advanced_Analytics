
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

SELECT *
FROM orders o
WHERE Sales =
(
    SELECT MAX(Sales)
    FROM orders
    WHERE `Customer ID` = o.`Customer ID`
);


