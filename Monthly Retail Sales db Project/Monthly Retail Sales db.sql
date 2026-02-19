/* =========================================
   DATABASE CREATION
========================================= */

IF DB_ID('retail_sales') IS NULL
    CREATE DATABASE retail_sales;
GO

USE retail_sales;
GO


/* =========================================
   DROP & CREATE TABLE
========================================= */

IF OBJECT_ID('dbo.retail_sales_stage','U') IS NOT NULL
    DROP TABLE dbo.retail_sales_stage;
GO

CREATE TABLE dbo.retail_sales_stage (
    csv_index INT NULL,
    month INT NULL,
    year INT NULL,
    naics_Code VARCHAR(60) NULL,
    kind_of_business VARCHAR(300) NULL,
    industry VARCHAR(100) NULL,
    sales BIGINT NULL
);
GO


/* =========================================
   BULK INSERT (Fixed)
========================================= */

BEGIN TRY

    BULK INSERT dbo.retail_sales_stage
    FROM 'C:\Users\Admin\Desktop\us_monthly_retail_sales_wrangled (2).csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );

    PRINT 'Data loaded successfully.';

END TRY
BEGIN CATCH
    PRINT 'Error during BULK INSERT:';
    PRINT ERROR_MESSAGE();
END CATCH;
GO


/* =========================================
   DATA CLEANING
========================================= */

-- Set sales = NULL if 0
UPDATE dbo.retail_sales_stage
SET sales = NULL
WHERE sales = 0;


-- Check first 50 rows
SELECT TOP 50 *
FROM dbo.retail_sales_stage
ORDER BY csv_index ASC;

-- Check last 50 rows
SELECT TOP 50 *
FROM dbo.retail_sales_stage
ORDER BY csv_index DESC;



/* =========================================
   BUSINESS QUESTION 1
========================================= */

SELECT 
    industry,
    kind_of_business,
    SUM(sales) AS total_sales
FROM dbo.retail_sales_stage
GROUP BY industry, kind_of_business
ORDER BY total_sales DESC;



/* =========================================
   BUSINESS QUESTION 2 (NAICS Distribution)
========================================= */

SELECT 
    naics_Code,
    industry,
    SUM(sales) AS total_sales
FROM dbo.retail_sales_stage
GROUP BY naics_Code, industry
ORDER BY naics_Code, total_sales DESC;



/* =========================================
   BUSINESS QUESTION 3 (Seasonality)
========================================= */

SELECT 
    industry,
    year,
    month,
    SUM(sales) AS total_sales
FROM dbo.retail_sales_stage
GROUP BY industry, year, month
ORDER BY year, industry, month;



/* =========================================
   AVG > 10 BILLION
========================================= */

SELECT
    kind_of_business,
    AVG(sales) AS average_sales
FROM dbo.retail_sales_stage
GROUP BY kind_of_business
HAVING AVG(sales) > 10000000000;   -- 10 Billion



/* =========================================
   Automotive 2022 Highest Sales
========================================= */

SELECT 
    kind_of_business,
    SUM(sales) AS total_sales
FROM dbo.retail_sales_stage
WHERE industry = 'Automotive'
  AND year = 2022
GROUP BY kind_of_business
ORDER BY total_sales DESC;



/* =========================================
   Automotive Contribution Percentage 2022
========================================= */

WITH automotive_sales AS (
    SELECT 
        kind_of_business,
        SUM(COALESCE(sales,0)) AS total_sales
    FROM dbo.retail_sales_stage
    WHERE industry = 'Automotive'
      AND year = 2022
    GROUP BY kind_of_business
),
total_sales_automotive AS (
    SELECT 
        SUM(COALESCE(sales,0)) AS total_sales_automotive
    FROM dbo.retail_sales_stage
    WHERE industry = 'Automotive'
      AND year = 2022
)
SELECT 
    a.kind_of_business,
    CAST(
        ROUND(
            100.0 * a.total_sales / NULLIF(t.total_sales_automotive,0),
        2)
    AS DECIMAL(10,2)) AS contribution_percentage
FROM automotive_sales a
CROSS JOIN total_sales_automotive t
ORDER BY contribution_percentage DESC;



/* =========================================
   Top Industry Per Month (2021)
========================================= */

WITH monthly_sales AS (
    SELECT 
        year,
        month,
        industry,
        SUM(sales) AS total_sales
    FROM dbo.retail_sales_stage
    WHERE year = 2021
    GROUP BY year, month, industry
),
top_industries AS (
    SELECT 
        year,
        month,
        industry,
        total_sales,
        RANK() OVER (
            PARTITION BY year, month 
            ORDER BY total_sales DESC
        ) AS industry_rank
    FROM monthly_sales
)
SELECT 
    year,
    month,
    industry,
    total_sales
FROM top_industries
WHERE industry_rank = 1
ORDER BY year, month;



/* =========================================
   OUTLIER / SIGNIFICANT CHANGE DETECTION
========================================= */

WITH sales_analysis AS (
    SELECT 
        industry,
        year,
        month,
        sales,
        LAG(sales) OVER (
            PARTITION BY industry 
            ORDER BY year, month
        ) AS prev_sales,
        LEAD(sales) OVER (
            PARTITION BY industry 
            ORDER BY year, month
        ) AS next_sales
    FROM dbo.retail_sales_stage
)
SELECT 
    industry,
    year,
    month,
    sales
FROM sales_analysis
WHERE (prev_sales IS NOT NULL AND sales > 1.5 * prev_sales)
   OR (next_sales IS NOT NULL AND sales > 1.5 * next_sales)
ORDER BY industry, year, month;
