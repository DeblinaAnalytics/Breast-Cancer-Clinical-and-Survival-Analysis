Project: Breast Cancer Clinical and Survival Analysis
File: 02-Creating dimension tables.sql

Purpose:
This script has been used to create dimension tables for the above mentioned project.
----------------------------------------------------------------------------------------
-- Create dim_stage
Create Table dim_stage
(
StageKey INT IDENTITY(1,1) PRIMARY KEY,
TStage VARCHAR (20) NOT NULL,
NStage VARCHAR (20) NOT NULL,
AJCC6thStage VARCHAR (20) NOT NULL,
AStage VARCHAR (20) NOT NULL
);
-----------------------------------------------------------------------------------------
-- Create dim_grade
Create Table dim_grade
(
GradeKey INT IDENTITY(1,1) PRIMARY KEY,
Grade TINYINT NOT NULL,
Differentiation VARCHAR (50) NOT NULL
);
------------------------------------------------------------------------------------------
-- Create dim_hormonal_status
Create Table dim_hormonal_status
(
HormoneKey INT IDENTITY(1,1) PRIMARY KEY,
EstrogenStatus VARCHAR (30) NOT NULL,
ProgesteroneStatus VARCHAR (30) NOT NULL
);

