SELECT * FROM Supermarket_file.supermarket;
SHOW COLUMNS FROM Supermarket_file.supermarket;

SELECT Branch, City, COUNT(*) AS TotalSales
FROM Supermarket_file.supermarket
GROUP BY Branch, City;


SELECT `Customer type`, Gender, COUNT(*) AS TotalCustomers
FROM Supermarket_file.supermarket
GROUP BY `Customer type`, Gender;

SELECT `Product Line`, SUM(Total) AS TotalSales
FROM Supermarket_file.supermarket
GROUP BY `Product Line`;

SELECT SUM(cogs) AS TotalCOGS, SUM(`gross income`) AS TotalGrossIncome
FROM Supermarket_file.supermarket;

SELECT Rating, COUNT(*) AS TotalCount
FROM Supermarket_file.supermarket
GROUP BY Rating
ORDER BY Rating DESC;

SELECT CASE
     WHEN Rating >= 0 AND Rating < 2 THEN 'Very Poor'
    WHEN Rating >= 2 AND Rating < 4 THEN 'Poor'
    WHEN Rating >= 4 AND Rating < 6 THEN 'Fair'
    WHEN Rating >= 6 AND Rating < 8 THEN 'Good'
    WHEN Rating >= 8 AND Rating <= 10 THEN 'Excellent'
         ELSE 'Excellent'
       END AS RatingRange,
       COUNT(*) AS TotalSales
FROM Supermarket_file.supermarket
GROUP BY RatingRange;


SELECT Payment, COUNT(*) AS TotalCount
FROM Supermarket_file.supermarket
GROUP BY Payment;

SELECT `Product Line`, AVG(Total) AS `Average Sales`, AVG(Quantity) AS `Average Quantity`
FROM Supermarket_file.supermarket
GROUP BY `Product Line`;

SELECT `Product Line`, SUM(Quantity) AS `Total Quantity`
FROM Supermarket_file.supermarket
GROUP BY `Product Line`
ORDER BY `Total Quantity` DESC
LIMIT 5;

SELECT
    Branch,
    SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) AS MaleCustomers,
    SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS FemaleCustomers,
    COUNT(*) AS TotalCustomers,
    ROUND((SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS MalePercentage,
    ROUND((SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS FemalePercentage
FROM Supermarket_file.supermarket
GROUP BY Branch;

SELECT 
    `Product Line`,
    DATE_FORMAT(STR_TO_DATE(`Date`, '%m/%d/%Y'), '%Y-%m') AS Month,
    SUM(Total) AS MonthlySales
FROM Supermarket_file.supermarket
WHERE `Date` IS NOT NULL
GROUP BY `Product Line`, Month
ORDER BY `Product Line`, Month;

-- Average sales per customer by gender
SELECT Gender, AVG(Total) AS AverageSalesPerCustomer
FROM Supermarket_file.supermarket
GROUP BY Gender;

-- Total sales by month
SELECT DATE_FORMAT(STR_TO_DATE(`Date`, '%m/%d/%Y'), '%Y-%m') AS Month,
       SUM(Total) AS MonthlySales
FROM Supermarket_file.supermarket
WHERE `Date` IS NOT NULL
GROUP BY Month
ORDER BY Month;

-- Total sales by branch and product line
SELECT Branch, `Product Line`, SUM(Total) AS TotalSales
FROM Supermarket_file.supermarket
GROUP BY Branch, `Product Line`;

-- Average sales per transaction by payment method
SELECT Payment, AVG(Total) AS AverageSalesPerTransaction
FROM Supermarket_file.supermarket
GROUP BY Payment;

-- Total sales by customer type and gender
SELECT `Customer type`, Gender, SUM(Total) AS TotalSales
FROM Supermarket_file.supermarket
GROUP BY `Customer type`, Gender;

-- Average rating by product line
SELECT `Product Line`, AVG(Rating) AS AverageRating
FROM Supermarket_file.supermarket
GROUP BY `Product Line`;

-- Most popular payment methods by branch
SELECT Branch, Payment, COUNT(*) AS TotalCount
FROM Supermarket_file.supermarket
GROUP BY Branch, Payment
ORDER BY Branch, TotalCount DESC;

-- Total sales per hour of the day
SELECT HOUR(Time) AS HourOfDay, SUM(Total) AS HourlySales
FROM Supermarket_file.supermarket
GROUP BY HourOfDay
ORDER BY HourOfDay;

-- Top 5 customers with the highest total purchases
SELECT `Invoice ID`, SUM(Total) AS TotalPurchases
FROM Supermarket_file.supermarket
GROUP BY `Invoice ID`
ORDER BY TotalPurchases DESC
LIMIT 5;

-- Total sales by city and rating range
SELECT City,
       CASE
         WHEN Rating >= 0 AND Rating < 2 THEN 'Very Poor'
         WHEN Rating >= 2 AND Rating < 4 THEN 'Poor'
         WHEN Rating >= 4 AND Rating < 6 THEN 'Fair'
         WHEN Rating >= 6 AND Rating < 8 THEN 'Good'
         WHEN Rating >= 8 AND Rating <= 10 THEN 'Excellent'
         ELSE 'Unknown'
       END AS RatingRange,
       SUM(Total) AS TotalSales
FROM Supermarket_file.supermarket
GROUP BY City, RatingRange
ORDER BY City, RatingRange;

SELECT
    `Product Line`,
    `City`,
    DATE_FORMAT(STR_TO_DATE(`Date`, '%m/%d/%Y'), '%Y-%m') AS Month,
    COUNT(DISTINCT `Invoice ID`) AS TotalInvoices,
    COUNT(*) AS TotalTransactions,
    SUM(Quantity) AS TotalQuantity,
    SUM(Total) AS TotalSales,
    SUM(Total) / COUNT(DISTINCT `Invoice ID`) AS AverageSalePerInvoice,
    SUM(Total) / COUNT(*) AS AverageSalePerTransaction,
    (
        SELECT SUM(Total)
        FROM Supermarket_file.supermarket
        WHERE `Product Line` = s.`Product Line` AND `City` = s.`City`
    ) AS TotalSalesByProductCity,
    (
        SELECT COUNT(DISTINCT `Invoice ID`)
        FROM Supermarket_file.supermarket
        WHERE `Product Line` = s.`Product Line` AND `City` = s.`City`
    ) AS TotalInvoicesByProductCity,
    (
        SELECT SUM(Quantity)
        FROM Supermarket_file.supermarket
        WHERE `Product Line` = s.`Product Line` AND `City` = s.`City`
    ) AS TotalQuantityByProductCity,
    (
        SELECT AVG(Rating)
        FROM Supermarket_file.supermarket
        WHERE `Product Line` = s.`Product Line` AND `City` = s.`City`
    ) AS AverageRatingByProductCity
FROM Supermarket_file.supermarket s
WHERE `Date` IS NOT NULL
GROUP BY `Product Line`, `City`, Month
ORDER BY `Product Line`, `City`, Month;


