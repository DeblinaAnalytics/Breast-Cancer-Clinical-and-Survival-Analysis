-------------------------------------------------------------------------------------------------------------------------------
Project: Breast Cancer Clinical and Survival Analysis
File: 08-Analytical queries.sql
--------------------------------------------------------------------------------------------------
-- 1. Count the total number of patients in each T stage.
Select s.TStage, 
COUNT(*) as patient_count
From dim_stage s
Join fact_BreastCancer f
on s.StageKey = f.StageKey
Group by s.TStage;
--------------------------------------------------------------------------------------------------
-- 2. Find the average survival months for each cancer grade.
Select g.grade, 
AVG(f.SurvivalMonths) as avg_survival
From fact_BreastCancer f
Join dim_grade g
on f.GradeKey = g.GradeKey
Group by g.Grade;
---------------------------------------------------------------------------------------------------
-- 3. Calculate the average number of positive regional nodes for each hormone status.
Select h.EstrogenStatus, 
h.ProgesteroneStatus,
AVG(f.RegionalNodePositive) 
As avg_positive_regionalnodes
From fact_BreastCancer f
Join dim_hormonal_status h
on f.HormoneKey = h.HormoneKey
Group by h.EstrogenStatus, 
h.ProgesteroneStatus;
----------------------------------------------------------------------------------------------------
-- 4. Find the minimum, maximum, and average age of patients for each T stage.
Select s.TStage, 
AVG(f.age) as avg_patient_age,
MIN(f.age) as min_patient_age,
MAX(f.age) as max_patient_age
From fact_BreastCancer f
Join dim_stage s
On s.StageKey = f.StageKey
Group by s.TStage;
-----------------------------------------------------------------------------------------------------
-- 5. Create age groups (<40, 40–49, 50–59, 60–69, 70+) and count the patients in each group.
With AgeGroup As (
Select
Case
When age < 40 then '<40'
When age >= 40 and age < 50 then '40-49'
When age >= 50 and age < 60 then '50-59'
When age >= 60 and age < 70 then '60-69'
Else '70+'
End as AgeGroup
From fact_BreastCancer)
Select AgeGroup, count(*) 
As PatientPerGroup
From AgeGroup
Group by AgeGroup
Order by AgeGroup;
--------------------------------------------------------------------------------------------------------------------
-- 6. Identify T stages where the average survival months are greater than the overall average survival months.
Select s.TStage, 
Avg(f.SurvivalMonths) 
As avg_survival_months
From fact_BreastCancer f
Join dim_stage s
On f.StageKey = s.StageKey
Group by s.TStage
Having Avg(f.SurvivalMonths) > (
Select Avg(f.SurvivalMonths)
From fact_BreastCancer f
);
---------------------------------------------------------------------------------------------------------------------
-- 7. Find grades with more patients than the average number of patients across all grades.
With PatientCount as (
Select grade, count(*) 
As patient_count
from fact_BreastCancer f
Join dim_grade g
on g.GradeKey = f.GradeKey
Group by Grade
)
Select *
From PatientCount
where patient_count > (Select avg(patient_count)
From PatientCount);
-------------------------------------------------------------------------------------------------------------
-- 8. List hormone status categories whose average survival is below the overall average.
Select h.EstrogenStatus, 
h.ProgesteroneStatus,
avg(f.SurvivalMonths) 
As avg_survival
From dim_hormonal_status h
Join fact_BreastCancer f
on f.HormoneKey = h.HormoneKey
Group by h.EstrogenStatus, 
h.ProgesteroneStatus
Having avg(f.SurvivalMonths) < (
Select avg(f.SurvivalMonths) 
As overall_avg
From fact_BreastCancer f
);
----------------------------------------------------------------------------------------------------------------------------------
-- 9. Categorize tumor size into Small, Medium, and Large using a CASE expression and count patients in each category.
With SizeCategory As(
Select 
Case
When TumorSize < (Select AVG(TumorSize) from fact_BreastCancer) then 'Small'
When TumorSize = (Select AVG(TumorSize) from fact_BreastCancer) then 'Medium'
When TumorSize > (Select AVG(TumorSize) from fact_BreastCancer) then 'Large'
Else 'Unknown'
End as TumorSizeCategory
From fact_BreastCancer)
Select TumorSizeCategory, Count(*) as patient_count
From SizeCategory
Group by TumorSizeCategory;
-----------------------------------------------------------------------------------------
-- 10. Find the percentage of patients who are alive and deceased.
Select Status, 
COUNT(*) * 100/ (
Select COUNT(*)
From fact_BreastCancer
) As LiveDeadPercentage
From fact_BreastCancer
Group by Status;
-------------------------------------------------------------------------------------------
-- 11. Rank T stages by average survival months.
With AvgSurvival As (
Select s.TStage, 
avg(f.SurvivalMonths) as survival_avg
From dim_stage s
Join fact_BreastCancer f
On s.StageKey = f.StageKey
Group by s.TStage
)
Select *,
Rank() over (Order by survival_avg Desc) as survival_rank
From AvgSurvival;
---------------------------------------------------------------------------------------------
-- 12. Dense rank cancer grades by average tumor size.
With AvgSize as (
Select g.grade, 
avg(f.TumorSize) as avg_size
From fact_BreastCancer f
Join dim_grade g
On g.GradeKey = f.GradeKey
Group by g.grade
)
Select *,
Dense_Rank() over (
Order by avg_size Desc
) as size_rank
From AvgSize;
------------------------------------------------------------------------------------------------
-- 13. Rank hormone status categories by survival rate.
With SurvivalRate as (
Select h.EstrogenStatus, 
h.ProgesteroneStatus,
 100 * Sum(
 Case
 When f.status = 'Alive' then 1 
 Else 0
 End)
 / count(*) as survival_rate
From fact_BreastCancer f
Join dim_hormonal_status h
On h.HormoneKey = f.HormoneKey
Group by h.EstrogenStatus,
h.ProgesteroneStatus)
Select *,
Rank() Over (
Order by survival_rate DESC)
As survival_rank
From SurvivalRate;
------------------------------------------------------------------------------------------------------------
-- 14. For each grade, show the patient count along with the total patient count using a window function.
With GradeCount as (
Select g.grade, 
Count(*) as patient_per_grade
From fact_BreastCancer f
Join dim_grade g
On g.GradeKey = f.GradeKey
Group by g.grade
)
Select *,
sum(patient_per_grade) over () as total_patients
From GradeCount;
----------------------------------------------------------------------------------------------------
-- 15. Find the stage with the second-highest average survival months.
With AvgSurvival as (
Select s.AStage,
AVG(SurvivalMonths) 
As avg_survival_months
From fact_BreastCancer f
Join dim_stage s
On s.StageKey = f.StageKey
Group by s.AStage
),
SurvivalRank as (
Select *,
RANK() Over (
Order by avg_survival_months DESC) 
as SurvivalRank
From AvgSurvival)
Select *
From SurvivalRank
Where SurvivalRank = 2;
------------------------------------------------------------------------------------------------------
-- 16. Which combination of T stage and grade has the highest average survival months?
With AvgSurvival as (
Select s.TStage, g.grade,
AVG(f.SurvivalMonths) as avg_survival
From fact_BreastCancer f
Join dim_stage s
On s.StageKey=f.StageKey
Join dim_grade g
On g.GradeKey=f.GradeKey
Group by s.TStage, g.grade
),
ASRank as (
Select *,
Rank() over (
Order by avg_survival DESC
) as avg_survival_rank
From AvgSurvival)
Select *
From ASRank
Where avg_survival_rank = 1;
-----------------------------------------------------------------------------------------------------
-- 17. Build a summary report showing, for each T stage:
-- Patient count
-- Average age
-- Average tumor size
-- Average survival months
-- Survival rate

Select s.TStage,
Count(*) as PatientCount,
AVG(f.Age) as AvgAge,
AVG(f.SurvivalMonths) as AvgSurvivalMonths,
SUM(Case
When f.Status = 'Alive' then 1
Else 0
End) * 100 / COUNT(*) as SurvivalRate
From fact_BreastCancer f
Join dim_stage s
On f.StageKey=s.StageKey
Group by s.TStage;
-------------------------------------------------------------------
-- 18. Which race has the highest average tumor size?
With RaceAvg as (
Select Race,
AVG(TumorSize) as avg_size
From fact_BreastCancer
Group by Race
),
SizeRanks as (
Select *,
RANK() over
(Order by avg_size DESC)
As size_rank
From RaceAvg
)
Select *
From SizeRanks
Where size_rank = 1;
-------------------------------------------------------------------------------------------------
-- 19. Which T stage has the highest average number of positive regional nodes?
Select top 1 with ties s.TStage,
AVG(f.RegionalNodePositive) as avg_positive_nodes
From fact_BreastCancer f
Join dim_stage s
On s.StageKey = f.StageKey
Group by s.TStage
Order by avg_positive_nodes DESC;
--------------------------------------------------------------------------------------------------
-- 20. Which grade has the largest variation between minimum and maximum survival months?
Select top 1 with ties g.Grade, 
MIN(f.SurvivalMonths) as min_survival,
MAX(f.SurvivalMonths) as max_survival,
(MAX(f.SurvivalMonths) - MIN(f.SurvivalMonths)) as variation
From fact_BreastCancer f
Join dim_grade g
On g.GradeKey = f.GradeKey
Group by g.Grade
Order by variation DESC;
---------------------------------------------------------------------------------------------------
-- 21. Find the five combinations of stage and grade with the largest patient populations.
With PatientCount as (
Select s.TStage, g.Grade,
COUNT(*) as patient_count
From fact_BreastCancer f
Join dim_grade g
On g.GradeKey = f.GradeKey
Join dim_stage s
On s.StageKey = f.StageKey
Group by s.TStage, g.Grade
),
ComboRank as (
Select *,
RANK() Over
(Order by patient_count DESC)
As count_rank
From PatientCount)
Select *
From ComboRank
Where count_rank <=5;
----------------------------------------------------------------------------------------------------
-- 22. Which age group has the highest proportion of deceased patients?
-- Since age groups were not mentioned explicitly, patients were categorised into Child, Adult and Senior Citizen
With AgeGroups as (
Select 
Case
When Age<18 then 'Child'
When Age>=18 and Age<60 then 'Adult'
Else 'Senior Citizen'
End as AgeGroup,
Status
From fact_BreastCancer),
PatientCount as (
Select AgeGroup,
COUNT(*) as TotalCount,
SUM( Case
When Status = 'Dead' then 1 
Else 0
End) as DeadCount
From AgeGroups
Group by AgeGroup)
Select AgeGroup,
(DeadCount*100.0)/TotalCount
As DeadProportion
From PatientCount
Order by DeadProportion Desc;
-----------------------------------------------------------------------------------------------------
-- 23. Compare average survival months across different races within each T stage.
Select s.TStage, f.Race,
AVG(f.SurvivalMonths)
As AvgSurvival
From fact_BreastCancer f
Join dim_stage s
On s.StageKey = f.StageKey
Group by f.Race, s.TStage;
---------------------------------------------------------------------------------------------------------------------------------
-- 24. Calculate the average survival months for each T stage and compare it with the previous T stage using LAG().
With AvgSurvival as (
Select s.TStage,
AVG(f.SurvivalMonths)
as AvgSurvival
From fact_BreastCancer f
Join dim_stage s
On s.StageKey = f.StageKey
Group by s.TStage)
Select TStage, AvgSurvival,
LAG(AvgSurvival) OVER (Order by TStage)
As PreviousSurvival
From AvgSurvival;
-----------------------------------------------------------------------------------------------------------------------------------
-- 25. Calculate the average tumor size for each cancer grade and compare it with the next higher grade using LEAD().
With GradewiseSize as (
Select g.Grade, 
AVG(f.TumorSize) as avg_size
From fact_BreastCancer f
Join dim_grade g
On g.GradeKey = f.GradeKey
Group by g.Grade)
Select Grade, avg_size,
LEAD(avg_size) Over (
Order by Grade) as NextSize
From GradewiseSize;