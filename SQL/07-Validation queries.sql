
Project: Breast Cancer Clinical and Survival Analysis
File: 07-Validation queries.sql

Purpose: 
This script demonstrates the validation queries for Fact and Dimension Tables of above mentioned project.
-------------------------------------------------------------------------------------------------------------
-- Count rows

Select Count(*)
From dbo.breast_cancer_cleaned

Select Count(*)
From dbo.fact_BreastCancer

Select count(*)
From dbo.dim_stage

Select count(*)
From dbo.dim_grade

Select count(*)
From dbo.dim_hormonal_status
-------------------------------------------------------------------------------------------------------------
-- Check null values

Select count(*)
From dbo.fact_BreastCancer
Where StageKey is null
or GradeKey is null
or HormoneKey is null;

Select count(*)
From dbo.fact_BreastCancer bc
Left Join dbo.dim_stage s
on bc.STAGEKEY = s.STAGEKEY
where s.STAGEKEY is null;

Select count(*)
From dbo.fact_BreastCancer bc
Left Join dbo.dim_grade g
on bc.GRADEKEY = g.GRADEKEY
where g.GRADEKEY is null;

Select count(*)
From dbo.fact_BreastCancer bc
Left Join dbo.dim_hormonal_status h
on bc.HORMONEKEY = h.HORMONEKEY
where h.HORMONEKEY is null;
--------------------------------------------------------
-- Check duplicate values

Select TStage, NStage, AJCC6thStage, AStage,
COUNT(*) as dup_count
From dbo.dim_stage
Group by TStage, NStage, AJCC6thStage, AStage
Having COUNT(*) > 1;

Select Grade, Differentiation,
COUNT(*) as dup_count
From dbo.dim_grade
Group by Grade, Differentiation
Having COUNT(*) > 1;

Select EstrogenStatus, ProgesteroneStatus,
COUNT(*) as dup_count
From dbo.dim_hormonal_status
Group by EstrogenStatus, ProgesteroneStatus
Having COUNT(*) > 1;

Select StageKey,
GradeKey, HormoneKey, Age,
Race, MaritalStatus,TumorSize,
RegionalNodeExamined,
RegionalNodePositive,
SurvivalMonths, Status,
COUNT(*) as dup_count
From dbo.fact_BreastCancer
Group by StageKey, 
GradeKey, HormoneKey, Age,
Race, MaritalStatus,
TumorSize, RegionalNodeExamined,
RegionalNodePositive,
SurvivalMonths, Status
Having COUNT(*) > 1;
--------------------------------------------------------------------
-- Compare aggregates of fact table with those of source table

Select sum(tumor_size)
From dbo.breast_cancer_cleaned;

select sum(tumorsize)
from dbo.fact_BreastCancer;

Select AVG(Survival_Months)
From dbo.breast_cancer_cleaned;

Select AVG(SurvivalMonths)
From dbo.fact_BreastCancer;

Select AVG(Regional_Node_Examined)
From dbo.breast_cancer_cleaned;

Select AVG(RegionalNodeExamined)
From dbo.fact_BreastCancer;

Select SUM(Reginol_Node_Positive)
From dbo.breast_cancer_cleaned;

Select SUM(RegionalNodePositive)
From dbo.fact_BreastCancer;
---------------------------------------------------------------------------------------------
-- Referential integrity (Foreign key integrity) to confirm the absence of orphan records

Select count(*)
From dbo.fact_BreastCancer bc
Left Join dbo.dim_stage s
on bc.StageKey = s.StageKey
Where s.StageKey is null;

Select count(*)
From dbo.fact_BreastCancer bc
Left Join dbo.dim_grade g
on bc.GradeKey = g.GradeKey
Where g.GradeKey is null;

Select count(*)
From dbo.fact_BreastCancer bc
Left Join dbo.dim_hormonal_status h
on bc.HormoneKey = h.HormoneKey
Where h.HormoneKey is null;
------------------------------------------------------------------------------
-- Reconstruction of original data to validate the working of this model
Select Top 20
f.FactKey, f.Age, f.TumorSize,
s.TStage, s.AStage,
g.Grade, h.EstrogenStatus
From dbo.fact_BreastCancer f
JOIN dbo.dim_stage s
on f.StageKey = s.StageKey
JOIN dbo.dim_grade g
on f.GradeKey = g.GradeKey
JOIN dbo.dim_hormonal_status h
on f.HormoneKey = h.HormoneKey;
