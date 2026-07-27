-------------------------------------------------------------------------------------------------------------------------------
Project: Breast Cancer Clinical and Survival Analysis
File: 01-Data cleaning queries.sql

Purpose:
This script has been used to explore the raw breast cancer dataset, perform quality checks and clean the data before dimensional modelling.
--------------------------------------------------------------------------------------------------------------------------------
-- Explored the dataset.
Select *
From dbo.breast_cancer_raw;
-----------------------------------------------------
-- Counted number of rows.
Select count(*)
From dbo.breast_cancer_raw;
-----------------------------------------------------
-- Checked for null values, none appeared.
Select *
From dbo.breast_cancer_raw
where age is null
or race is null
or Marital_Status is null
or T_Stage is null 
or N_Stage is null
or AJCC_6th_Stage is null
or differentiate is null
or Grade is null
or A_Stage is null
or Tumor_Size is null
or Estrogen_Status is null
or Progesterone_Status is null
or Regional_Node_Examined is null
or Reginol_Node_Positive is null
or Survival_Months is null
or status is null;
---------------------------------------------------------------------------
-- The range of numerical values were examined.
Select min(age),max(age)
From dbo.breast_cancer_raw
-- Along with age, other numerical values were also examined.
---------------------------------------------------------------------------
-- All individual columns were inspected for their distinct values, the query to inspect the column 'Status' has been given here.
Select Distinct Status
From dbo.breast_cancer_raw
---------------------------------------------------------------------------------------------------------------------------------------------
-- Checked for duplicates, one exact duplicate row appeared.
With DuplicateRows as (
Select count(*) as dup_count,
Age, Race,Marital_Status,
T_Stage,N_Stage,AJCC_6th_Stage,
differentiate,Grade,A_Stage,Tumor_Size,
Estrogen_Status,
Progesterone_Status,Regional_Node_Examined,
Reginol_Node_Positive, 
Survival_Months,Status
From dbo.breast_cancer_raw
group by Age, Race,Marital_Status,T_Stage,N_Stage,AJCC_6th_Stage,
differentiate,Grade,A_Stage,Tumor_Size,Estrogen_Status,Progesterone_Status,Regional_Node_Examined,
Reginol_Node_Positive, Survival_Months,Status)
Select *
From DuplicateRows
where dup_count>1;
------------------------------------------------------------------------------------------------------------------------------------
-- A copy of the raw dataset was created before making any changes.
Select *
Into dbo.breast_cancer_cleaned
From dbo.breast_cancer_raw;
--------------------------------------------------------------------------------------------------------------
-- Data of the copied table inspected.  
Select *
From dbo.breast_cancer_cleaned
--------------------------------------------------------------------------------------------
-- To remove the duplicate row, Row_Number() was used.
With RowNumber as (
Select *,
Row_Number() over (Partition by Age,Race,Marital_Status,
T_Stage,N_Stage,AJCC_6th_Stage,differentiate,Grade,A_Stage,Tumor_Size,
Estrogen_Status, Progesterone_Status,Regional_Node_Examined,
Reginol_Node_Positive, Survival_Months,Status Order by (Select null)) as row_num
From dbo.breast_cancer_cleaned)
Delete
From RowNumber
where row_num> 1;
---------------------------------------------------------------------------------------------
-- Checked number of rows once more and also ran a previous query to confirm deletion.
Select count(*)
From dbo.breast_cancer_cleaned;

With DuplicateRows as (
Select count(*) as dup_count,
Age, Race,Marital_Status,
T_Stage,N_Stage,AJCC_6th_Stage,
differentiate,Grade,A_Stage,Tumor_Size,
Estrogen_Status,
Progesterone_Status,Regional_Node_Examined,
Reginol_Node_Positive, 
Survival_Months,Status
From breast_cancer_cleaned
group by Age, Race,Marital_Status,T_Stage,N_Stage,AJCC_6th_Stage,
differentiate,Grade,A_Stage,Tumor_Size,Estrogen_Status,Progesterone_Status,Regional_Node_Examined,
Reginol_Node_Positive, Survival_Months,Status)
Select *
From DuplicateRows
where dup_count>1;
-- Deletion of duplicate row was confirmed when no rows were returned.