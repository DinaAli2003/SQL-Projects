# US Monthly Retail Sales Analysis

## 📋 Project Overview

This project implements a comprehensive data warehouse solution for analyzing US monthly retail sales data. It demonstrates ETL processes, data cleaning techniques, and advanced analytical queries to derive business intelligence from large-scale retail data.

## 🎯 Project Objectives

- Implement bulk data loading from external sources
- Perform data cleaning and transformation
- Develop complex analytical queries for business insights
- Identify sales patterns, outliers, and trends
- Calculate market share and contribution percentages

## 🛠️ Technical Implementation

### Data Pipeline Architecture

#### 1. Database Setup
```sql
-- Automatic database creation if not exists
IF DB_ID('retail_sales') IS NULL
    CREATE DATABASE retail_sales;
GO

-- Staging table design
CREATE TABLE dbo.retail_sales_stage (
    csv_index INT NULL,
    month INT NULL,
    year INT NULL,
    naics_Code VARCHAR(60) NULL,
    kind_of_business VARCHAR(300) NULL,
    industry VARCHAR(100) NULL,
    sales BIGINT NULL
);
```

#### 2. ETL Process
- **Extract**: BULK INSERT from CSV with comprehensive error handling
- **Transform**: NULL value treatment for zero sales, data type conversion
- **Load**: Cleaned data ready for analytical processing

### Analytical Query Categories

#### Business Question 1: Sales by Industry and Business Type
- Aggregated sales by industry and business category
- Performance ranking and comparison
- Market segment analysis

#### Business Question 2: NAICS Code Distribution
- Industry classification analysis
- Sales distribution across NAICS codes
- Regulatory reporting preparation

#### Business Question 3: Seasonality Analysis
- Year-over-year monthly comparisons
- Industry-specific seasonal patterns
- Peak season identification

### Advanced Analytics Implemented

**High-Value Business Identification**
```sql
-- Identify businesses with average sales > 10 Billion
SELECT kind_of_business, AVG(sales) AS average_sales
FROM dbo.retail_sales_stage
GROUP BY kind_of_business
HAVING AVG(sales) > 10000000000;
```

**Market Share Analysis**
- Contribution percentage calculations using CTEs
- Top performer identification by month
- Industry leadership tracking

**Anomaly Detection**
```sql
-- Detect significant sales changes (>50% variation)
WITH sales_analysis AS (
    SELECT industry, year, month, sales,
           LAG(sales) OVER (PARTITION BY industry ORDER BY year, month) AS prev_sales
    FROM dbo.retail_sales_stage
)
SELECT industry, year, month, sales
FROM sales_analysis
WHERE prev_sales IS NOT NULL AND sales > 1.5 * prev_sales;
```

## 📊 Business Insights Generated

- Market share distribution across industries
- Seasonal sales patterns by industry
- Growth opportunities identification
- Performance benchmarking against 10B threshold
- Automotive sector detailed analysis for 2022
- Monthly industry leadership tracking

## 🔧 Technologies Used
- T-SQL with window functions
- Common Table Expressions (CTEs)
- BULK INSERT operations with error handling
- TRY-CATCH blocks for robust execution
- Complex aggregations and ranking functions
- Data cleaning and transformation techniques

## 📁 File Structure
```
📦 Monthly Retail Sales Project
 ┗ 📜 Monthly Retail Sales db.sql    # Complete ETL and analysis implementation
```

## 🚀 How to Execute
1. Update the file path in BULK INSERT statement to point to your CSV file
2. Execute the entire script in SQL Server Management Studio
3. Review error messages if any during BULK INSERT
4. Analyze the business question results


---

## 🎓 Program Recognition

**All four projects were developed as part of the prestigious **Digilians Initiative**, a collaborative program between:**

- **Ministry of Communications and Information Technology (MCIT)** 
- **Egyptian Military Academy**

*This initiative represents Egypt's commitment to developing world-class technical talent and fostering digital innovation across the nation.*
