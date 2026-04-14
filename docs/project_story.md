# Project Story

## **Introduction**

This document outlines the full thought process behind the project — from initial data exploration and cleaning decisions to the design and structure of the final dashboard.

The goal was not only to build a functional visualization, but to approach the dataset as an analyst: asking the right questions, identifying meaningful patterns, and presenting insights in a clear and intuitive way.

Each step reflects the reasoning behind key decisions, including data preparation, feature selection, and visualization choices.

## **Table of Contents**
- [Introduction](#introduction)
- [Data Familiarization: Understand the structure, variables, and content of the dataset](#data-familiarization-understand-the-structure-variables-and-content-of-the-dataset)
- [Data Cleaning: Preprocess the data by handling missing values, outliers, and inconsistencies to ensure quality for analysis](#data-cleaning-preprocess-the-data-by-handling-missing-values-outliers-and-inconsistencies-to-ensure-quality-for-analysis)
- [Dashboard Creation: Build interactive dashboards using Tableau to visualize key metrics and patterns in the data](#dashboard-creation-build-interactive-dashboards-using-tableau-to-visualize-key-metrics-and-patterns-in-the-data)
  - [Intro](#intro)
  - [Data Preparation](#data-preparation)
  - [Dashboard Structure](#dashboard-structure)
  - [Visual Design](#visual-design)
  - [Building Visualizations](#building-visualizations)
  - [Interactivity](#interactivity)
- [Conclusion](conclusion)

## Data Familiarization: Understand the structure, variables and content of the dataset

**Dataset Overview:**

🔗 **Link to the Original Dataset**: [click here](https://www.kaggle.com/datasets/waqi786/remote-work-and-mental-health)

The dataset used in this project is sourced from Kaggle. It's a synthetically generated dataset designed to simulate workplace trends related to remote work and mental health. The data does not represent real-world information and is intended solely for educational purposes, exploratory analysis. Consists of a single sheet (non-relational), containing all relevant data in one table.

📝 **Columns Description** [click here](./project_story.md)

## Data Cleaning: Preprocess the data by handling missing values, outliers and inconsistencies to ensure quality for analysis

🔗 Link to the Cleaning script: [click here](../sql/cleaning.sql)

Let's start with Dataset overview!

First of all I have to check if everything is working and displaying correctly

```sql
SELECT * 
FROM health
LIMIT 5;
```

📊 Result: [View result (.csv)](../data/processed/view_first_5_rows.csv)

Next, I have to do a sanity check. For example, making sure that an employee isn't 1 year old or 157 years old and so on. Let's consider the following columns: **age**, **years\_of\_experience**, **hours\_worked\_per\_week**, and **number\_of\_virtual\_meetings**.

```sql
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
```

📊 Result: [View result (.csv)](../data/processed/sanity_check.csv)

If I need to see what values exist in the columns I can use the following query

```sql
SELECT
  DISTINCT gender
FROM health;
```

📊 Result: [View result (.csv)](../data/processed/gender_column.csv)

But if there is a need to view the values for all columns I can use resource-efficient queries for column overview

```sql
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

...

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

...
```

📊 Result: [View result (.csv)](../data/processed/resource_efficient_queries.csv)

The next step is checking for duplicates. We can use this fast method

```sql
SELECT
  COUNT(employee_id) - COUNT(DISTINCT employee_id) AS count_duplicates
FROM health;
```

📊 Result: [View result (.csv)](../data/processed/duplicates_check_fast.csv)

But for a more detailed overview I can execute the following query

```sql
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
```

The next step is checking for NULLs values. Let's run the following query

```sql
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
```

📊 Result: [View result (.csv)](../data/processed/check_nulls.csv)

Also this dataset contains ratings and I have to check the columns. According to the criteria ratings can be from 1 to 5. So, let's run the following query

```sql
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
```

📊 Result: [View result (.csv)](../data/processed/check_rating_columns.csv)

✅ **At this stage:**
- The data has passed basic quality checks;
- It is clean, consistent, and free of anomalies or duplicates;
- The dataset is ready for the next step.

## **Dashboard Creation: Build interactive dashboards using Tableau to visualize key metrics and patterns in the data**

The Tableau Public Project can be found here: [click here](https://public.tableau.com/views/mental-health-analysis/Dashboard?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

### **Intro**

This stage focuses on building an interactive Tableau dashboard to transform processed data into clear and meaningful visual insights. The goal is to present key metrics, highlight important patterns, and enable users to explore the data through dynamic filters and intuitive visualizations.

### **Data Preparation**



### **Dashboard Structure**

### **Visual Design**

### **Building Visualizations**

### **Interactivity**

## **Conclusion**

