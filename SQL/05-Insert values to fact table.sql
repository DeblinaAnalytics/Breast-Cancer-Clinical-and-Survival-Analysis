Project: Breast Cancer Clinical and Survival Analysis
File: 05-Insert values to fact table.sql

Purpose: 
This script has been used to load values to the fact table of above mentioned project.
-----------------------------------------------------------------------------------------
Insert into dbo.fact_BreastCancer
(
StageKey,
GradeKey,
HormoneKey,
Age,
Race,
MaritalStatus,
TumorSize,
RegionalNodeExamined,
RegionalNodePositive,
SurvivalMonths,
Status
)
Select
s.StageKey,
g.GradeKey,
h.HormoneKey,
bc.Age,
bc.Race,
bc.Marital_Status,
bc.Tumor_Size,
bc.Regional_Node_Examined,
bc.Reginol_Node_Positive,
bc.Survival_Months,
bc.Status
From dbo.breast_cancer_cleaned bc
Join dbo.dim_stage s
on bc.T_Stage = s.TStage
And bc.N_Stage = s.NStage
And bc.AJCC_6th_Stage = s.AJCC6thStage
And bc.A_Stage = s.AStage
Join dbo.dim_grade g
on bc.Grade = g.Grade
And bc.differentiate = g.Differentiation
Join dbo.dim_hormonal_status h
on bc.Estrogen_Status = h.EstrogenStatus
And bc.Progesterone_Status = h.ProgesteroneStatus;

 