-- Load data from CSV file into the Supermarket table
LOAD DATA INFILE '/Users/liliamarzougui/Desktop/Supermarket.csv'
INTO TABLE Supermarket
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Query 1: Retrieve all invoices with their total amounts
SELECT `Invoice ID`, Total
FROM Supermarket;

-- Query 2: Calculate the total revenue for each city
SELECT City, SUM(Total) AS TotalRevenue
FROM Supermarket
GROUP BY City;

-- Query 3: Find the average rating by gender
SELECT Gender, AVG(Rating) AS AverageRating
FROM Supermarket
GROUP BY Gender;
