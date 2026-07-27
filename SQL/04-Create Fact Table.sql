Project: Breast Cancer Clinical and Survival Analysis
File: 04-Create Fact Table.sql

Purpose: 
This script has been used to create the fact table for above mentioned project.
-------------------------------------------------------------------------------------
Create Table dbo.fact_BreastCancer
(
FactKey INT IDENTITY(1,1) PRIMARY KEY,
StageKey INT not null,
GradeKey INT not null,
HormoneKey INT not null,
Age TINYINT not null,
Race VARCHAR(30) not null,
MaritalStatus VARCHAR(30) not null,
TumorSize DECIMAL(5,2),
RegionalNodeExamined TINYINT,
RegionalNodePositive TINYINT,
SurvivalMonths INT,
Status VARCHAR(20) not null
);
