# 🏡 Nashville Housing Data Cleaning Project

This repository documents a comprehensive **Data Cleaning and Transformation** project executed using **Structured Query Language (SQL)**. The primary goal is to refine a raw housing dataset, addressing common data quality issues to establish a clean, normalized, and analytically ready foundation for subsequent exploratory data analysis (EDA) and reporting.

***

## 📊 Dataset Overview

* **Source:** Public Domain Nashville Housing Data (`Nashville Housing Data for Data Cleaning.xlsx - Sheet1.csv`).
* **Initial State:** The dataset contained numerous inconsistencies, including non-standard date formats, missing values, combined address fields, and inconsistent binary representations.
* **Database:** MySQL (The provided scripts leverage MySQL syntax for data manipulation).

***

## 💻 Technology Stack

| Component | Tool / Language |
| :--- | :--- |
| **Database Management** | MySQL (or similar RDBMS) |
| **Query Language** | SQL (T-SQL/PL/SQL concepts applied) |
| **Script File** | `Housing Cleaning Project.sql` |

***

## ✨ Key Data Cleaning & Transformation Procedures

The `Housing Cleaning Project.sql` script executes a series of precise and formal data cleaning operations to ensure data integrity and usability.

### 1. Database and Schema Setup ⚙️

* **Initialization:** Creation of the `Housing_db` database and the `nashville_housing` table with appropriate schema (e.g., `BIGINT` for currency, `VARCHAR` for text, `DATE` for timestamps).
* **Data Ingestion:** Utilized the `LOAD DATA LOCAL INFILE` command for efficient, large-scale import of the CSV data into the SQL table.

### 2. Standardizing Date Formats 📅

* **Objective:** Convert the `SaleDate` field, which contained inconsistent string formats, into a uniform `DATE` datatype to enable temporal analysis.
* **Method:** Employed conditional `UPDATE` statements using MySQL's `STR_TO_DATE()` function to parse various date string conventions.

### 3. Handling Missing and Inconsistent Addresses 🗺️

* **Populating Nulls:** Addressed missing `PropertyAddress` entries by exploiting the known data relationship where records sharing the same **`ParcelID`** often correspond to the same property. Missing addresses were populated via a **Self-JOIN** operation.
* **Address Decomposition:** Split the composite `PropertyAddress` and `OwnerAddress` fields into dedicated, atomic columns (e.g., `PropertySplitAddress`, `PropertySplitCity`, and the corresponding owner fields) using `SUBSTRING()` and `PARSENAME()` logic. This normalization facilitates easier querying and spatial analysis.

### 4. Binary Value Consistency 📝

* **Objective:** Normalize the `SoldAsVacant` column, which contained binary values represented by 'Y' and 'N', to the more explicit and standardized values of **'Yes'** and **'No'**.
* **Method:** Implemented a `CASE` statement within an `UPDATE` command to ensure all records use a consistent and clear textual label.

### 5. Duplicate Record Elimination 🗑️

* **Identification:** Used a **Common Table Expression (CTE)** and the **`ROW_NUMBER()`** window function to partition the data based on a unique key composite (`ParcelID`, `PropertyAddress`, `SalePrice`, `SaleDate`, `LegalReference`).
* **Removal:** Records assigned a `row_num` greater than 1 (indicating a duplicate) were targeted for deletion, ensuring each unique property transaction is represented exactly once.

### 6. Final Schema Refinement 🧹

* **Objective:** Drop redundant, raw, or legacy columns that were replaced by the newly created, cleaned, and split columns.
* **Removed Columns:** `OwnerAddress`, `TaxDistrict`, the original `PropertyAddress`, and the original `SaleDate`.

This structured and meticulous process ensures that the resulting `nashville_housing` table is optimized for downstream reporting, business analysis, and machine learning model training.
