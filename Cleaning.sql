-- Dataset Overview
-- View first 10 rows
SELECT * 
FROM health
LIMIT 5;

-- Sanity check
SELECT
	MIN(age) AS min_age
	, MAX(age) AS max_age
	, MIN(years_of_experience) AS min_years_of_experience
	, MAX(years_of_experience) AS max_years_of_experience
	, MIN(hours_worked_per_week) AS min_hours_worked_per_week
	, MAX(hours_worked_per_week) AS max_hours_worked_per_week
	, MIN(number_of_virtual_meetings) AS min_number_of_virtual_meetings
	, MAX(number_of_virtual_meetings) AS max_number_of_virtual_meetings
FROM health;

-- Gender column overview
SELECT
	 DISTINCT gender
FROM 
	health;

-- Resource-efficient queries for column overview (gender, job_role, industry, work_location, ...)
WITH gender_values AS (
    SELECT 
		DISTINCT gender
    FROM health
),
job_role_values AS (
    SELECT 
		DISTINCT job_role
    FROM health
),
industry_values AS (
    SELECT 
		DISTINCT industry
    FROM health
),
work_location_values AS (
    SELECT 
		DISTINCT work_location
    FROM health
),
stress_level_values AS (
	SELECT 
		DISTINCT stress_level
	FROM health
),
mental_health_condition_values AS (
	SELECT 
		DISTINCT mental_health_condition
	FROM health 
),
access_to_mental_health_resources_values AS (
	SELECT 
		DISTINCT access_to_mental_health_resources
	FROM health
),
productivity_change_values AS (
	SELECT 
		DISTINCT productivity_change
	FROM health
),
satisfaction_with_remote_work_values AS (
	SELECT 
		DISTINCT satisfaction_with_remote_work
	FROM health
),
physical_activity_values AS (
	SELECT 
		DISTINCT physical_activity
	FROM health
),
sleep_quality_values AS (
	SELECT 
		DISTINCT sleep_quality
	FROM health
),
region_values AS (
	SELECT 
		DISTINCT region
	FROM health
)
SELECT 
    'Gender' AS column_name
	, gender AS value 
FROM gender_values

UNION ALL

SELECT 
    'Job Role' AS column_name
	, job_role AS value 
FROM job_role_values

UNION ALL

SELECT 
    'Industry' AS column_name
	, industry AS value 
FROM industry_values

UNION ALL

SELECT 
    'Work Location' AS column_name
	, work_location AS value 
FROM work_location_values

UNION ALL

SELECT
	'Stress Level' AS column_name
	, stress_level AS value 
FROM stress_level_values

UNION ALL

SELECT 
	'Mental Health Condition' AS column_name
	, mental_health_condition AS value 
FROM mental_health_condition_values

UNION ALL

SELECT 
	'Access to Mental Health Resources' AS column_name
	, access_to_mental_health_resources AS value 
FROM access_to_mental_health_resources_values

UNION ALL

SELECT 
	'Productivity Change' AS column_name
	, productivity_change AS value 
FROM productivity_change_values

UNION ALL

SELECT 
	'Satisfaction with Remote Work' AS column_name
	, satisfaction_with_remote_work AS value 
FROM satisfaction_with_remote_work_values

UNION ALL

SELECT 
	'Physical Activity' AS column_name
	, physical_activity AS value 
FROM physical_activity_values

UNION ALL

SELECT 
	'Sleep Quality' AS column_name
	, sleep_quality AS value 
FROM sleep_quality_values

UNION ALL

SELECT 
	'Region' AS column_name
	, region AS value 
FROM region_values



-- Check for duplicates 
-- Fast method
SELECT 
	COUNT(employee_id) - COUNT(DISTINCT employee_id) AS count_duplicates
FROM health;

-- Another method for detailed view
SELECT 
	employee_id
	, COUNT(*)                                                                                                                                                                            
FROM health
GROUP BY 
	employee_id  
HAVING 
	COUNT(*) > 1
ORDER BY 
	COUNT(*) DESC;


-- Check NULLs across all columns 
SELECT 
	COUNT(*) FILTER (WHERE employee_id IS NULL) AS employee_id_NULL
    , COUNT(*) FILTER (WHERE age IS NULL) AS age_NULL
    , COUNT(*) FILTER (WHERE gender IS NULL) AS gender_NULL
    , COUNT(*) FILTER (WHERE job_role IS NULL) AS job_role_NULL
    , COUNT(*) FILTER (WHERE industry IS NULL) AS industry_NULL
    , COUNT(*) FILTER (WHERE years_of_experience IS NULL) AS years_of_experience_NULL
    , COUNT(*) FILTER (WHERE work_location IS NULL) AS work_location_NULL
    , COUNT(*) FILTER (WHERE hours_worked_per_week IS NULL) AS hours_worked_per_week_NULL
    , COUNT(*) FILTER (WHERE number_of_virtual_meetings IS NULL) AS number_of_virtual_meetings_NULL
    , COUNT(*) FILTER (WHERE work_life_balance_rating IS NULL) AS work_life_balance_rating_NULL
	, COUNT(*) FILTER (WHERE stress_level IS NULL) AS stress_level_NULL
	, COUNT(*) FILTER (WHERE mental_health_condition IS NULL) AS mental_health_condition_NULL
	, COUNT(*) FILTER (WHERE access_to_mental_health_resources IS NULL) AS access_to_mental_health_resources_NULL
	, COUNT(*) FILTER (WHERE productivity_change IS NULL) AS productivity_change_NULL
	, COUNT(*) FILTER (WHERE social_isolation_rating IS NULL) AS social_isolation_rating_NULL
	, COUNT(*) FILTER (WHERE satisfaction_with_remote_work IS NULL) AS satisfaction_with_remote_work_NULL
	, COUNT(*) FILTER (WHERE company_support_for_remote_work IS NULL) AS company_support_for_remote_work_NULL
	, COUNT(*) FILTER (WHERE physical_activity IS NULL) AS physical_activity_NULL
	, COUNT(*) FILTER (WHERE sleep_quality IS NULL) AS sleep_quality_NULL
	, COUNT(*) FILTER (WHERE region IS NULL) AS region_NULL
FROM health;


-- Check rating columns
SELECT
	COUNT(work_life_balance_rating) AS count_wlbr_greather_then_five
	, COUNT(social_isolation_rating) AS count_sir_greather_then_five
	, COUNT(company_support_for_remote_work) AS count_csfrw_greather_then_five
FROM health
WHERE
	work_life_balance_rating > 5
	OR work_life_balance_rating < 1
	OR social_isolation_rating > 5
	OR social_isolation_rating < 1
	OR company_support_for_remote_work > 5
	OR company_support_for_remote_work < 1;