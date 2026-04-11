# 📌 NBA Data Analysis Project

## 🏀 Project Title

**NBA Data Analysis & Data Warehouse Project (SQL & Power BI)**

## 📖 Overview

This project focuses on transforming raw NBA data into a structured data warehouse and performing advanced analytics using SQL. The project enables efficient reporting, dashboard creation, and extraction of insights related to teams, players, and game performance.

## 🎯 Objectives

* Clean and prepare NBA datasets
* Build a structured Data Warehouse (Star Schema)
* Perform advanced SQL analytics
* Generate insights for dashboards and reporting

## 🗄️ Data Source

* NBA dataset from Kaggle
* Originally stored in **SQLite database**
* Migrated to **SQL Server (SSMS)**

## ⚙️ Data Preparation

### 1. Data Cleaning

* Fixed data type inconsistencies
* Removed duplicate records
* Handled missing values using placeholders
* Resolved foreign key conflicts

### 2. Data Modeling

* Defined **Primary Keys**
* Created **Foreign Key relationships**
* Ensured referential integrity

## 🏗️ Data Warehouse Design

### ⭐ Star Schema Architecture

#### Fact Tables

* **Fact_Game** → Game performance metrics
* **Fact_Draft** → Draft data
* **Fact_Combine** → Player physical metrics

#### Dimension Tables

* **Dim_Player**
* **Dim_Team**
* **Dim_Date**
* **Dim_Game_Info**

### Benefits

* Faster queries
* Optimized Power BI dashboards
* Scalable analytical structure

## 📊 SQL Analytics

### 🔹 Game Performance

* Total games and points
* Average home vs away scoring
* Win percentages
* Close game analysis

### 🔹 Team Performance

* Team rankings
* Offensive & defensive metrics
* Win rates
* Clutch performance

### 🔹 Season Trends

* Points evolution over time
* Assists & rebounds trends
* Historical performance analysis

### 🔹 Shooting Analysis

* Field goal percentage (FG%)
* Shooting efficiency comparison

### 🔹 Player Combine Analytics

* Height & weight distribution
* Sprint & vertical jump performance
* BMI analysis

## 📈 Key Insights

* **Home Advantage:**

  * Home win rate ≈ 61.95%

* **Scoring Trends:**

  * Avg points per game ≈ 205.55

* **Top Teams:**

  * Boston Celtics
  * Golden State Warriors
  * Los Angeles Lakers

* **Historical Trends:**

  * Scoring fluctuations across decades
  * Increasing competitiveness over time

## 🛠️ Tools & Technologies

* SQL Server (SSMS)
* SQLite
* Power BI
* SQL (Joins, Aggregations, Window Functions)

## 📊 Output

* Structured Data Warehouse
* Analytical SQL queries
* Interactive Power BI Dashboard

## 🔮 Future Work

* Add real-time data updates
* Integrate predictive analytics
* Enhance player performance modeling

## 👥 Team

* **Dina Ali** – Data preparation & modeling
* Team collaboration within Digilians Initiative

## 🏛️ Program

Developed under **Digilians Initiative**
Supervised by the **Ministry of Communications and Information Technology (MCIT)**
In collaboration with the **Egyptian Military Academy**


