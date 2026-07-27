Project: Breast Cancer Clinical and Survival Analysis
File: 03-Insert values to dim tables.sql

Purpose: 
This script has been used to populate the dimension tables from cleaned dataset for the above mentioned project.
------------------------------------------------------------------------------------------------------------------------
-- Add values to dim_stage.
Insert into dbo.dim_stage
(
TStage,
NStage,
AJCC6thStage,
AStage
)
Select Distinct
T_Stage,
N_Stage,
AJCC_6th_Stage,
A_Stage
From dbo.breast_cancer_cleaned;
-----------------------------------------------------
-- View the table.
Select *
From dim_stage;
---------------------------------------------------------
-- Add values to dim_grade.
Insert into dim_grade
(
Grade,
Differentiation
)
Select Distinct
Grade,
differentiate
From dbo.breast_cancer_cleaned;
-----------------------------------------------------
-- View the table.
Select *
From dim_grade;
----------------------------------------------------------
-- Add values to dim_hormonal_status.
Insert into dim_hormonal_status
(
EstrogenStatus,
ProgesteroneStatus
)
Select Distinct
Estrogen_Status,
Progesterone_Status
From dbo.breast_cancer_cleaned;

Select *
From dim_hormonal_status;