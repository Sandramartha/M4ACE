CREATE DATABASE HR_Project;

CREATE TABLE hr_data
(
id VARCHAR(20),
first_name VARCHAR(50),
last_name VARCHAR(50),
birthdate DATE,
gender VARCHAR(20),
race VARCHAR(50),
department VARCHAR(100),
jobtitle VARCHAR(100),
location VARCHAR(100),
hire_date DATE,
termdate DATE,
location_city VARCHAR(100),
location_state VARCHAR(100)
);

--Clean the data
SELECT id, COUNT(*)
FROM hr_data
GROUP BY id
HAVING COUNT(*) > 1;

--CHECK NULL
SELECT
SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS Gender_Nulls,
SUM(CASE WHEN department IS NULL THEN 1 ELSE 0 END) AS Department_Nulls,
SUM(CASE WHEN hire_date IS NULL THEN 1 ELSE 0 END) AS HireDate_Nulls;

--REMOVE DUPLICATE
WITH DuplicateRows AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS rn
FROM hr_data
)

DELETE
FROM DuplicateRows
WHERE rn > 1;

--Standardize Gender
UPDATE hr_data
SET gender='Male'
WHERE gender='M';

UPDATE hr_data
SET gender='Female'
WHERE gender='F';

--Active Employees
SELECT *
FROM hr_data
WHERE termdate IS NULL;

--Total Employees
SELECT COUNT(*) AS TotalEmployees
FROM hr_data;

--Active Employees
SELECT COUNT(*) AS ActiveEmployees
FROM hr_data
WHERE termdate IS NULL;

--Employees by Gender
SELECT
gender,
COUNT(*) AS Total
FROM hr_data
GROUP BY gender
ORDER BY Total DESC;

Employees by Department
SELECT
department,
COUNT(*) AS Employees
FROM hr_data
GROUP BY department
ORDER BY Employees DESC;

--Employees by Job Title
SELECT
jobtitle,
COUNT(*) AS Employees
FROM hr_data
GROUP BY jobtitle
ORDER BY Employees DESC;
Employees by Race
SELECT
race,
COUNT(*) AS Employees
FROM hr_data
GROUP BY race
ORDER BY Employees DESC;

Employees by State
SELECT
location_state,
COUNT(*) AS Employees
FROM hr_data
GROUP BY location_state
ORDER BY Employees DESC;

Employees by City
SELECT
location_city,
COUNT(*) AS Employees
FROM hr_data
GROUP BY location_city
ORDER BY Employees DESC;

--RETENTION ANALYSIS

Employees who left
SELECT COUNT(*) AS Terminated
FROM hr_data
WHERE termdate IS NOT NULL;

--Retention Rate
SELECT
COUNT(CASE WHEN termdate IS NULL THEN 1 END) *100.0 /
COUNT(*) AS RetentionRate
FROM hr_data;

--Attrition Rate
SELECT
COUNT(CASE WHEN termdate IS NOT NULL THEN 1 END)*100.0/
COUNT(*) AS AttritionRate
FROM hr_data;

--Attrition by Department
SELECT
department,

COUNT(CASE WHEN termdate IS NOT NULL THEN 1 END) AS LeftCompany,

COUNT(*) AS TotalEmployees,

ROUND(
COUNT(CASE WHEN termdate IS NOT NULL THEN 1 END)*100.0/
COUNT(*),2
) AS AttritionRate

FROM hr_data

GROUP BY department

ORDER BY AttritionRate DESC;

--Hiring Trend
--Employees hired each year
SELECT

YEAR(hire_date) AS HiringYear,

COUNT(*) AS EmployeesHired

FROM hr_data

GROUP BY YEAR(hire_date)

ORDER BY HiringYear;

--Monthly hiring

SELECT

MONTH(hire_date) AS Month,

COUNT(*) AS Hired

FROM hr_data

GROUP BY MONTH(hire_date)

ORDER BY Month;

--Employee Age
SELECT

AVG(TIMESTAMPDIFF(YEAR,birthdate,CURDATE())) AS AverageAge

FROM hr_data;

--Age Groups

SELECT

CASE

WHEN TIMESTAMPDIFF(YEAR,birthdate,CURDATE())<30 THEN 'Below 30'

WHEN TIMESTAMPDIFF(YEAR,birthdate,CURDATE()) BETWEEN 30 AND 39 THEN '30-39'

WHEN TIMESTAMPDIFF(YEAR,birthdate,CURDATE()) BETWEEN 40 AND 49 THEN '40-49'

ELSE '50+'

END AS AgeGroup,

COUNT(*) AS Employees

FROM hr_data

GROUP BY AgeGroup

ORDER BY Employees DESC;

--CTE Analysis

--Active Employees per Department

WITH ActiveEmployees AS
(
SELECT *
FROM hr_data
WHERE termdate IS NULL
)

SELECT

department,

COUNT(*) AS Employees

FROM ActiveEmployees

GROUP BY department

ORDER BY Employees DESC;

--Window Functions

Rank Departments by Number of Employees

SELECT

department,

COUNT(*) AS TotalEmployees,

RANK() OVER(ORDER BY COUNT(*) DESC) AS DepartmentRank

FROM hr_data

GROUP BY department;

Rank Job Titles

SELECT

jobtitle,

COUNT(*) AS Employees,

DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS JobRank

FROM hr_data

GROUP BY jobtitle
