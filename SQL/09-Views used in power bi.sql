-------------------------------------------------------------------------------------------------------------------------------
Project: Breast Cancer Clinical and Survival Analysis
File: 09-Views used in Power BI.sql

Purpose:
This script has been used to create views (not linked to star schema) which were used in clinical analysis of breast cancer in the Power BI dashboard.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Correlation between grades and stages of Cancer

Create View stagegradeanalysis as (
Select g.Grade, s.AJCC6thStage,
COUNT(*) as patient_count
From dbo.fact_BreastCancer f
Join dbo.dim_grade g
On g.GradeKey = f.GradeKey
Join dbo.dim_stage s
On s.StageKey = f.StageKey
Group by g.Grade, s.AJCC6thStage
);
----------------------------------------------------------------------------------------
-- Added average survival months later to calculate survival outcomes at different stages and tumor grades
Alter View stagegradeanalysis as (
Select g.Grade, s.AJCC6thStage,
COUNT(*) as patient_count,
AVG(f.SurvivalMonths) as AvgSurvivalMonths
From dbo.fact_BreastCancer f
Join dbo.dim_grade g
On g.GradeKey = f.GradeKey
Join dbo.dim_stage s
On s.StageKey = f.StageKey
Group by g.Grade, s.AJCC6thStage
);
-----------------------------------------------------------------------------------------
-- Does differentiation of cells affect the tumor size

Create View TumorSizeDifferentiation as (
Select g.Differentiation,
AVG(f.TumorSize) as AvgTumorSize
From dbo.fact_BreastCancer f
Join dbo.dim_grade g
On g.GradeKey = f.GradeKey
Group by g.Differentiation
);
-----------------------------------------------------------------------------------------
-- How positive regional nodes impact N Staging

Create View NodalAnalysis as (
Select s.NStage,
AVG(f.RegionalNodeExamined) as RegionalNodesExamined,
AVG(f.RegionalNodePositive) as RegionalNodesPositive,
AVG(f.SurvivalMonths) as AvgSurvivalMonths,
COUNT(*) as PatientCount
From dbo.fact_BreastCancer f
Join dbo.dim_stage s
On s.StageKey = f.StageKey
Group by s.NStage
);