-- How many rows in sales?
SELECT COUNT(*) AS total_rows FROM adventureworks.sales;
-- Check for nulls in every key column
SELECT
  SUM(CASE WHEN SalesOrderNumber IS NULL THEN 1 ELSE 0 END) AS null_order_number,
  SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END)        AS null_order_date,
  SUM(CASE WHEN ProductKey IS NULL THEN 1 ELSE 0 END)        AS null_product,
  SUM(CASE WHEN ResellerKey IS NULL THEN 1 ELSE 0 END)       AS null_reseller,
  SUM(CASE WHEN EmployeeKey IS NULL THEN 1 ELSE 0 END)       AS null_employee,
  SUM(CASE WHEN SalesTerritoryKey IS NULL THEN 1 ELSE 0 END) AS null_territory
FROM adventureworks.sales;

-- Check for duplicate order numbers
SELECT SalesOrderNumber, COUNT(*) AS occurrences
FROM adventureworks.sales
GROUP BY SalesOrderNumber
HAVING COUNT(*) > 1
LIMIT 20;

-- Check OrderDate format (is it consistent?)
SELECT DISTINCT OrderDate
FROM adventureworks.sales
LIMIT 20;

-- Check for nulls in product
SELECT
  SUM(CASE WHEN Product IS NULL THEN 1 ELSE 0 END)        AS null_product_name,
  SUM(CASE WHEN `Standard Cost` IS NULL THEN 1 ELSE 0 END) AS null_cost,
  SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END)        AS null_category,
  SUM(CASE WHEN Subcategory IS NULL THEN 1 ELSE 0 END)     AS null_subcategory
FROM adventureworks.product;

-- Check what the OrderDate format looks like
SELECT DISTINCT OrderDate
FROM adventureworks.sales
LIMIT 20;

-- Add a clean date column
ALTER TABLE adventureworks.sales
ADD COLUMN OrderDateClean DATE;

-- Parse the text date into a real DATE
UPDATE adventureworks.sales
SET OrderDateClean = STR_TO_DATE(OrderDate, '%W, %M %d, %Y');

-- Verify it worked
SELECT OrderDate, OrderDateClean
FROM adventureworks.sales
LIMIT 10;

-- See if duplicate rows are identical or have different products/resellers
SELECT *
FROM adventureworks.sales
WHERE SalesOrderNumber = 'SO47028'
LIMIT 10;

-- Clean product table
UPDATE adventureworks.product
SET
  Product         = TRIM(Product),
  Color           = TRIM(Color),
  Subcategory     = TRIM(Subcategory),
  Category        = TRIM(Category),
  `Standard Cost` = TRIM(REPLACE(REPLACE(`Standard Cost`, '$', ''), ',', ''));
  
  -- Clean reseller table
UPDATE adventureworks.reseller
SET
  Reseller         = TRIM(Reseller),
  City             = TRIM(City),
  `State-Province` = TRIM(`State-Province`),
  `Country-Region` = TRIM(`Country-Region`),
  `Business Type`  = TRIM(`Business Type`);
  
  -- Clean salesperson table
UPDATE adventureworks.salesperson
SET
  Salesperson = TRIM(Salesperson),
  Title       = TRIM(Title);
  
  -- Fix character encoding for salesperson name
UPDATE adventureworks.salesperson
SET Salesperson = 'José Saraiva'
WHERE Salesperson LIKE 'Jos%Saraiva';
  
  CREATE VIEW adventureworks.vw_sales_analysis AS
SELECT
  -- Order identifiers
  s.SalesOrderNumber,
  s.OrderDateClean                                    AS OrderDate,
  YEAR(s.OrderDateClean)                              AS OrderYear,
  MONTH(s.OrderDateClean)                             AS OrderMonth,
  DATE_FORMAT(s.OrderDateClean, '%Y-%m')              AS YearMonth,

  -- Product
  p.ProductKey,
  p.Product                                           AS ProductName,
  p.`Standard Cost`                                   AS StandardCost,
  p.Color,
  p.Subcategory,
  p.Category,
   -- Reseller
  r.ResellerKey,
  r.Reseller                                          AS ResellerName,
  r.`Business Type`                                   AS BusinessType,
  r.City                                              AS ResellerCity,
  r.`State-Province`                                  AS ResellerState,
  r.`Country-Region`                                  AS ResellerCountry,

  -- Salesperson
  sp.EmployeeKey,
  sp.Salesperson                                      AS SalespersonName,
  sp.Title                                            AS SalespersonTitle,

  -- Territory
  rg.SalesTerritoryKey,
  rg.Region                                           AS SalesRegion,
  rg.Country                                          AS SalesCountry,
  rg.Group                                            AS SalesGroup
FROM adventureworks.sales s
LEFT JOIN adventureworks.product p
  ON s.ProductKey = p.ProductKey
LEFT JOIN adventureworks.reseller r
  ON s.ResellerKey = r.ResellerKey
LEFT JOIN adventureworks.salesperson sp
  ON s.EmployeeKey = sp.EmployeeKey
LEFT JOIN adventureworks.region rg
  ON s.SalesTerritoryKey = rg.SalesTerritoryKey;
  SELECT * FROM adventureworks.vw_sales_analysis LIMIT 10;
  
  -- MAIN QUESTION: Which territories are underperforming?
SELECT
  SalesRegion,
  SalesCountry,
  SalesGroup,
  COUNT(DISTINCT SalesOrderNumber) AS TotalOrders,
  COUNT(DISTINCT ResellerKey)      AS UniqueResellers,
  COUNT(DISTINCT EmployeeKey)      AS Salespersons,
  ROUND(COUNT(DISTINCT SalesOrderNumber) /
        COUNT(DISTINCT EmployeeKey), 1) AS OrdersPerSalesperson
FROM adventureworks.vw_sales_analysis
GROUP BY SalesRegion, SalesCountry, SalesGroup
ORDER BY TotalOrders DESC;

-- Which category drives the most orders per region?
SELECT
  SalesRegion,
  Category,
  COUNT(DISTINCT SalesOrderNumber) AS TotalOrders
FROM adventureworks.vw_sales_analysis
GROUP BY SalesRegion, Category
ORDER BY SalesRegion, TotalOrders DESC;

-- Salesperson performance ranked
SELECT
  SalespersonName,
  SalespersonTitle,
  SalesRegion,
  COUNT(DISTINCT SalesOrderNumber) AS TotalOrders,
  COUNT(DISTINCT ResellerKey)      AS ResellersServed
FROM adventureworks.vw_sales_analysis
GROUP BY SalespersonName, SalespersonTitle, SalesRegion
ORDER BY TotalOrders DESC;

-- Monthly order trend
SELECT
  YearMonth,
  OrderYear,
  OrderMonth,
  COUNT(DISTINCT SalesOrderNumber) AS TotalOrders
FROM adventureworks.vw_sales_analysis
GROUP BY YearMonth, OrderYear, OrderMonth
ORDER BY YearMonth;

-- What years does the data cover?
SELECT 
  MIN(OrderDate) AS earliest_order,
  MAX(OrderDate) AS latest_order,
  COUNT(DISTINCT OrderYear) AS years_covered
FROM adventureworks.vw_sales_analysis;

-- Full monthly trend to see seasonality
SELECT
  YearMonth,
  COUNT(DISTINCT SalesOrderNumber) AS TotalOrders
FROM adventureworks.vw_sales_analysis
GROUP BY YearMonth
ORDER BY YearMonth;

-- Category breakdown by region
SELECT
  SalesRegion,
  Category,
  COUNT(DISTINCT SalesOrderNumber) AS TotalOrders
FROM adventureworks.vw_sales_analysis
GROUP BY SalesRegion, Category
ORDER BY SalesRegion, TotalOrders DESC;
  