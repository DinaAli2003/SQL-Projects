# 🌐 Global COVID-19 Data Exploration and Analysis Project

## 📌 Project Overview

This project comprises a comprehensive **Exploratory Data Analysis (EDA)** of global COVID-19 data, executed entirely using **Structured Query Language (SQL)**. The primary objective is to transform raw, aggregated case and vaccination statistics into a set of robust, report-ready metrics suitable for in-depth public health analysis and data visualization.

The analysis leverages sophisticated SQL techniques, including **Window Functions, Common Table Expressions (CTEs), and persistent Views**, demonstrating proficiency in data manipulation and complex querying within a Relational Database Management System (RDBMS).

***

## ⚙️ Technology Stack

| Component | Tool / Language | RDBMS Functionality |
| :--- | :--- | :--- |
| **Database** | MySQL (or similar RDBMS) | Data Storage and Query Execution |
| **Query Language** | **SQL** | Transformation, Aggregation, and Reporting |
| **Script File** | `COVID Data Exploration project.sql` | End-to-End Analysis Pipeline |

***

## 📊 Data Integration and Foundation

The analysis is built upon the integration of two distinct, time-series datasets, joined on a consistent geographic and temporal key.

| Dataset | Table Name | Key Fields | Purpose |
| :--- | :--- | :--- | :--- |
| **COVID-19 Deaths** | `CovidDeaths` | `location`, `date`, `population` | Core data on cases, deaths, and population figures. |
| **COVID-19 Vaccinations** | `CovidVaccinations` | `location`, `date`, `new_vaccinations` | Data tracking daily vaccination doses administered. |

**Database Setup:** The script initiates by creating the `COVID19` database and defining the necessary schemas, ensuring optimal data types (`DATE`, `BIGINT`, `FLOAT`) are used for accuracy.

***

## 🔍 Key Analytical Queries & Metrics

The `COVID Data Exploration project.sql` script systematically derives five core categories of metrics crucial for understanding the pandemic's impact.

### 1. Infection and Mortality Rates 💀

* **Percent Population Infected:** Calculates the percentage of the population that contracted COVID-19 in each country/location.
    $$\frac{\text{Total Cases}}{\text{Population}} \times 100$$
* **Death Percentage (Mortality Rate):** Determines the probability of death for a confirmed case in each country/location.
    $$\frac{\text{Total Deaths}}{\text{Total Cases}} \times 100$$

### 2. Global and Regional Summaries 🌍

* **Global Totals:** Aggregate calculation of total worldwide cases and deaths, and the resultant global mortality rate, utilizing `SUM()` on all records.
* **Continent-Level Analysis:** Identification of total death counts grouped by `continent`, providing a high-level geographical summary of the pandemic's severity.

### 3. Population-Adjusted Metrics 💉

* **Rolling Vaccination Count:** Utilizes the powerful **`SUM() OVER (PARTITION BY ...)` Window Function** to calculate the cumulative sum of daily `new_vaccinations` over time, per country. This is the **`RollingPeopleVaccinated`** column.
* **Percent Population Vaccinated:** Derives the percentage of a country's population that has received at least one vaccine dose over the recorded timeline.
    $$\frac{\text{Rolling People Vaccinated}}{\text{Population}} \times 100$$

### 4. Data Persistence for BI 💾

To facilitate seamless integration with visualization tools (e.g., Tableau, Power BI), the final cleaned and calculated data is persisted using the following structures:

* **Temporary Table (`#PercentPopulationVaccinated`):** Used to perform calculations on the partition results before output.
* **Permanent View (`PercentPopulationVaccinated`):** A simplified, pre-aggregated view that stores the logic for the final population-vaccinated metric, ensuring future data consumption is efficient and consistent.

***

## ✅ Execution & Deliverables

The provided SQL script is designed to be executed sequentially. Upon successful execution, the project yields:

1.  **Clean, Joined Datasets:** Two tables (`CovidDeaths` and `CovidVaccinations`) are successfully integrated.
2.  **Key Analytical Outputs:** All specified global, continental, and country-level metrics are calculated.
3.  **Visualization-Ready View:** A persistent `PercentPopulationVaccinated` View is created, serving as the final, clean data source for     external reporting.
