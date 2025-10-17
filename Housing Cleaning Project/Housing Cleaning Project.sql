-- Creating Database 
DROP DATABASE IF EXISTS Housing_db;
CREATE DATABASE IF NOT EXISTS Housing_db;
USE Housing_db;


-- MySQL Schema for Nashville Housing Data Cleaning

DROP TABLE IF EXISTS nashville_housing;
CREATE TABLE nashville_housing (
    UniqueID BIGINT NOT NULL PRIMARY KEY,

    ParcelID VARCHAR(50),

    LandUse VARCHAR(100),

    PropertyAddress VARCHAR(255),

    SaleDate varchar(255),

    SalePrice BIGINT,

    LegalReference VARCHAR(50),

    SoldAsVacant VARCHAR(5),

    OwnerName VARCHAR(255),

    OwnerAddress VARCHAR(255),

    Acreage DECIMAL(10, 2),

    TaxDistrict VARCHAR(100),

    LandValue BIGINT,

    BuildingValue BIGINT,

    TotalValue BIGINT,

    YearBuilt INT,

    Bedrooms TINYINT,

    FullBath TINYINT,

    HalfBath TINYINT
);

-- ============================================

LOAD DATA LOCAL INFILE 'D:/Dina Projects/Data Analysis Projects/Data sets/Housing Dataset.csv'
INTO TABLE nashville_housing
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- =========================================
-- Showing all data in our table
SELECT * FROM nashville_housing;
-- =========================================

-- Standardize Date Format
UPDATE nashville_housing
SET SaleDate =
    CASE
        WHEN SaleDate LIKE '%,%' THEN STR_TO_DATE(SaleDate, '%M %d, %Y')
        WHEN SaleDate LIKE '%/%' THEN STR_TO_DATE(SaleDate, '%m/%d/%Y')
        ELSE NULL
    END;

-- Showing Date after handling it 
SELECT SaleDate 
FROM nashville_housing;

-- Altering data type of SaleDate column
ALTER TABLE nashville_housing
MODIFY COLUMN SaleDate Date;

-- =======================================
--  Populate Property Address data

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress
FROM  nashville_housing AS a
JOIN  nashville_housing AS b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID 
WHERE a.PropertyAddress IS NULL ;



UPDATE nashville_housing a
JOIN nashville_housing b
    ON a.ParcelID = b.ParcelID
   AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = COALESCE(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;


SELECT *
FROM nashville_housing
order by ParcelID;

-- =============================================

-- 1) Split PropertyAddress into Address + City
-- ===========================================

SELECT PropertyAddress
FROM nashville_housing;

-- Test preview (optional)
SELECT
    SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1) AS Address,
    SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1) AS City
FROM nashville_housing;

-- Add columns (ONLY if they do not exist already)
ALTER TABLE nashville_housing
ADD COLUMN PropertySplitAddress VARCHAR(255),
ADD COLUMN PropertySplitCity VARCHAR(255);

-- Update values safely
UPDATE nashville_housing
SET 
    PropertySplitAddress = CASE
        WHEN LOCATE(',', PropertyAddress) > 0 
            THEN SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1)
        ELSE PropertyAddress
    END,
    
    PropertySplitCity = CASE
        WHEN LOCATE(',', PropertyAddress) > 0 
            THEN TRIM(SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1))
        ELSE NULL
    END;

-- ============================
-- 2) Split OwnerAddress into Address + City + State
-- ============================

SELECT OwnerAddress
FROM nashville_housing;

-- Test preview (optional)
SELECT
    SUBSTRING_INDEX(OwnerAddress, ',', 1) AS OwnerAddressOnly,
    SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1) AS OwnerCityOnly,
    SUBSTRING_INDEX(OwnerAddress, ',', -1) AS OwnerStateOnly
FROM nashville_housing;

-- Add columns (ONLY once — no duplicates)
ALTER TABLE nashville_housing
ADD COLUMN OwnerSplitAddress VARCHAR(255),
ADD COLUMN OwnerSplitCity VARCHAR(255),
ADD COLUMN OwnerSplitState VARCHAR(255);

-- Update values using MySQL syntax
UPDATE nashville_housing
SET 
    OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1),
    OwnerSplitCity = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)),
    OwnerSplitState = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1));

-- ============================
-- 3) Check results
-- ============================
SELECT *
FROM nashville_housing;



Select *
From nashville_housing;
--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From nashville_housing
Group by SoldAsVacant
order by 2;


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END as New_SoldAsVacant
From nashville_housing;


Update nashville_housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END;

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From nashville_housing

)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;


Select *
From nashville_housing;

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From nashville_housing;


ALTER TABLE nashville_housing
DROP COLUMN OwnerAddress;

ALTER TABLE nashville_housing
DROP COLUMN TaxDistrict;

ALTER TABLE nashville_housing
DROP COLUMN PropertyAddress;

ALTER TABLE nashville_housing
DROP COLUMN SaleDate;

