# Breast Cancer Clinical and Survival Analysis | SQL Data Warehouse & Power BI

## Project Overview

This project demonstrates the design of a dimensional SQL Server data warehouse for analysing survival outcomes in a breast cancer dataset containing **4,023 patient records**. A star schema was implemented to support efficient analytical querying and Power BI dashboard reporting.

---

## Objectives

- Cleaning and validating raw clinical data
- Designing a star schema using fact and dimension tables
- Implementing surrogate keys and foreign key relationships
- Performing analytical SQL queries to identify survival patterns
- Building SQL views for Power BI dashboards

---

## Tech Stack

- SQL Server (T-SQL)
- Power BI
- DAX

---

## Data Model

### Fact Table

- `fact_BreastCancer`

### Dimension Tables

- `dim_stage`
- `dim_grade`
- `dim_hormonal_status`

> *(Insert your star schema image here after uploading it.)*

---

## Project Workflow

1. Data Cleaning
2. Create Dimension Tables
3. Populate Dimension Tables
4. Create Fact Table
5. Populate Fact Table
6. Create Relationships
7. Validate Data Warehouse
8. Perform Analytical SQL Queries
9. Create SQL Views for Power BI

---

## Repository Structure

```text
SQL/
├── 01_Data_Cleaning.sql
├── 02_Create_Dimension_Tables.sql
├── 03_Load_Dimension_Tables.sql
├── 04_Create_Fact_Table.sql
├── 05_Load_Fact_Table.sql
├── 06_Create_Relationships.sql
├── 07_Validation_Queries.sql
├── 08_Analytical_Queries.sql
└── 09_SQL_Views.sql

├── PowerBI/
│   ├── Breast_Cancer_Survival_Dashboard.pbix
│   └── Breast_Cancer_Survival_Dashboard.pdf

Images/

README.md
```

---

## SQL Concepts Demonstrated

- Data Cleaning
- Dimensional Modelling (Star Schema)
- Surrogate Keys
- Foreign Keys
- Joins
- Common Table Expressions (CTEs)
- Window Functions
- Aggregate Functions
- CASE Expressions
- SQL Views
- Data Validation

---

## Analytical Highlights

- Survival analysis by cancer stage
- Survival analysis by tumour grade
- Hormone receptor status comparison
- Patient demographics analysis
- Ranking and trend analysis
- Average and median survival calculations

---

## Dashboard

The validated star schema and SQL views were used as the data source for interactive Power BI dashboards exploring survival outcomes and clinical characteristics.

> *(Insert dashboard screenshots here after uploading them.)*

---

## Dataset

**Source:** Reihan Enamdari, *Breast Cancer Dataset* (Kaggle)

Derived from the **SEER Program** of the U.S. National Cancer Institute.

https://www.kaggle.com/datasets/reihanenamdari/breast-cancer

---

## Author

**Deblina Bharadwaj**
