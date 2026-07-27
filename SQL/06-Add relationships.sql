Project: Breast Cancer Clinical and Survival Analysis
File: 06-Add relationships.sql

Purpose: 
This script has been used to add foreign key constraints to the fact table.
---------------------------------------------------------------------------------
-- Connecting fact table to dbo.dim_stage
Alter Table dbo.fact_BreastCancer
Add Constraint FK_BC_stage
Foreign Key (StageKey)
References dbo.dim_stage (StageKey);
---------------------------------------------------------------------------------
-- Connecting fact table to dbo.dim_grade
Alter Table dbo.fact_BreastCancer
Add Constraint FK_BC_grade
Foreign Key (GradeKey)
References dbo.dim_grade (GradeKey);
---------------------------------------------------------------------------------
-- Connecting fact table to dbo.dim_hormonal_status
Alter Table dbo.fact_BreastCancer
Add Constraint FK_BC_hormone
Foreign Key (HormoneKey)
References dbo.dim_hormonal_status (HormoneKey);
