CREATE DATABASE HR_Analysis;
USE hr_Analysis;

SELECT * FROM employees;

ALTER TABLE employees 
RENAME COLUMN ï»¿EmployeeID TO EmployeeID ;

select * from Performancerating;
UPDATE Performancerating
SET ReviewDate = STR_TO_DATE(ReviewDate, '%m/%d/%Y');

ALTER TABLE Performancerating
CHANGE COLUMN ReviewDate ReviewDate DATE;

-- --------------------------------------------ATTRITION ANALYSES----------------------------------------------------------


-- total attrition 
SELECT 	COUNT(employeeid) as total_attrition 
FROM 	employees
WHERE 	attrition = "yes";


-- overall attrition rate
SELECT 
		SUM(CASE WHEN attrition = "yes" THEN 1 END) / COUNT(employeeid)*100 AS attrition_rate
FROM 	employees;


-- the attrition rate by department
SELECT 	department,
		SUM(CASE WHEN attrition = 'yes' THEN 1 END) / COUNT(employeeid)*100 attrition_rate
FROM employees
GROUP BY department;

-- the attrition rate by job role
SELECT 	jobrole,
		SUM(CASE WHEN attrition = 'yes' THEN 1 END)/ COUNT(employeeid)* 100 AS attrition_rate
FROM 	employees
GROUP BY jobrole
ORDER BY attrition_rate DESC;


-- the attrition rate by gender
SELECT	gender,
		SUM(CASE WHEN attrition = 'yes' THEN 1 END)/ COUNT(employeeid)* 100 AS attrition_rate
FROM 	employees
GROUP BY gender;

select * from employees;


-- the average tenure of employees who left vs. those who stayed
SELECT 	attrition,
		AVG(yearsatcompany) AS average_tenure
FROM employees
GROUP BY attrition;


-- What is the attrition rate by age group
WITH Age_group AS (
SELECT  attrition, employeeid,
		CASE WHEN age BETWEEN 18 AND 20  THEN '18-20'
			 WHEN age BETWEEN 21 AND 25  THEN '21-25'
             WHEN age BETWEEN 26 AND 30  THEN '26-30'
             WHEN age BETWEEN 31 AND 35  THEN '31-35'
             WHEN age BETWEEN 36 AND 40  THEN '36-40'
             WHEN age BETWEEN 41 AND 45  THEN '41-45'
             WHEN age BETWEEN 46 AND 50  THEN '46-50'
             ELSE '50+' END AS age_group
FROM 	employees)
SELECT  age_group,
		SUM(CASE WHEN attrition = 'yes' THEN 1 END)/ COUNT(employeeid)*100  AS attrition_rate
FROM 	age_group
GROUP BY age_group
ORDER BY age_group;


-- What is the average salary of employees who left vs. those who stayed
SELECT attrition,
		AVg(salary) AS AVG_salary
FROM 	employees
GROUP BY attrition; 

SELECT * FROM employees;


-- How does attrition vary by performance rating?
SELECT 	Performancerating,
		COUNT(e.employeeid) AS total_employees,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS EmployeesWhoLeft
FROM 	employees e JOIN Performancerating p
ON 		e.employeeid = p.employeeid
GROUP BY Performancerating;


-- What is the attrition rate for employees who worked overtime vs. those who didn’t?
SELECT 	overtime,
		SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)/ COUNT(Employeeid)*100 AS attrition_rate
FROM 	employees
GROUP BY overtime;


-- ---------------------------------------Performance Analysis-------------------------------------------------------------------

SELECT * FROM Performancerating;

-- 1.What is the average performance rating by department?
SELECT 	department,
		AVG(Performancerating) AS Performance_rating
FROM 	employees e JOIN Performancerating p 
ON		e.employeeid = p.employeeid
GROUP BY department;

-- 2.	How does performance vary by tenure?
SELECT 	yearsatcompany,
		AVG(performancerating) AS Avg_performance_rating
FROM 	employees e JOIN Performancerating p 
ON 	 	e.employeeid = p.employeeid
GROUP BY yearsatcompany
ORDER BY yearsatcompany;

-- 3.How does performance vary by gender?
SELECT 	gender, 
		AVG(performancerating) AS avg_performance_rating
FROM 	employees e JOIN performancerating p
ON 		e.employeeid = p.employeeid
GROUP BY gender;

-- 4. How does performance vary by age group?
WITH Age_group AS (
SELECT  attrition, performancerating,
		CASE WHEN age BETWEEN 18 AND 20  THEN '18-20'
			 WHEN age BETWEEN 21 AND 25  THEN '21-25'
             WHEN age BETWEEN 26 AND 30  THEN '26-30'
             WHEN age BETWEEN 31 AND 35  THEN '31-35'
             WHEN age BETWEEN 36 AND 40  THEN '36-40'
             WHEN age BETWEEN 41 AND 45  THEN '41-45'
             WHEN age BETWEEN 46 AND 50  THEN '46-50'
             ELSE '50+' END AS age_group
FROM 	employees e JOIN performancerating p
ON 		e.EmployeeID = p.EmployeeID)
SELECT  age_group,
		AVG(performancerating) AS avg_performance_rating
FROM age_group
GROUP BY age_group
ORDER BY age_group;

-- 5.What is the performance of employees who left vs. those who stayed?
SELECT  attrition,
		AVG(performancerating) AS avg_performance_rating
FROM 	employees e JOIN performancerating p
ON 		e.EmployeeID = p.EmployeeID
GROUP BY attrition;

-- 6.What is the performance of employees by manager?
SELECT  e.employeeid as Manager_ID, 
		Avg(Performancerating) AS avg_performance_rating
FROM 	employees e JOIN performancerating p 
ON 		e.EmployeeID = p.EmployeeID
WHERE 	jobrole like '%manager%'
GROUP BY e.employeeid;


-- 7.What is the distribution of performance ratings (e.g., high, medium, low)?
SELECT 	CASE WHEN Performancerating >= 4 THEN 'High'
			 WHEN Performancerating = 3 THEN 'Medium'
             ELSE 'Low' END AS preformance_level,
        COUNT(DISTINCT employeeid) AS distribution
FROM 	performancerating
GROUP BY preformance_level;


-- 8. What is the performance trend over time (e.g., quarterly or yearly)?

SELECT 	CONCAT('Q ', QUARTER(ReviewDate)) AS `Quarter`, 
		AVG(CASE WHEN YEAR(ReviewDate) = '2020' THEN performancerating END) AS Year_20,
        AVG(CASE WHEN YEAR(ReviewDate) = '2021' THEN performancerating END) AS Year_21,
        AVG(CASE WHEN YEAR(ReviewDate) = '2022' THEN performancerating END )AS Year_22
FROM performancerating
GROUP BY CONCAT('Q ', QUARTER(ReviewDate));


-- ----------------------------------------------------Employee Sentiment Analysis-------------------------------------------------
SELECT * FROM performancerating;

-- 1.What is the Average employee satisfaction score?
SELECT AVG(jobsatisfaction) AS avg_satisfaction_score
FROM performancerating;

-- 2.How does satisfaction vary by department
SELECT 	department,
		AVG(jobsatisfaction) AS avg_satisfaction_score
FROM 	employees e JOIN performancerating p 
ON 		e.EmployeeID = p.EmployeeID
GROUP BY department;


-- 3.How does satisfaction vary by gender ?
SELECT 	gender,
		AVG(jobsatisfaction) AS avg_satisfaction_score
FROM 	employees e JOIN performancerating p
ON 		e.EmployeeID = p.EmployeeID
GROUP BY gender;

-- 3.How does satisfaction vary by gender ?
WITH Age_group AS (
SELECT  attrition, jobsatisfaction,
		CASE WHEN age BETWEEN 18 AND 20  THEN '18-20'
			 WHEN age BETWEEN 21 AND 25  THEN '21-25'
             WHEN age BETWEEN 26 AND 30  THEN '26-30'
             WHEN age BETWEEN 31 AND 35  THEN '31-35'
             WHEN age BETWEEN 36 AND 40  THEN '36-40'
             WHEN age BETWEEN 41 AND 45  THEN '41-45'
             WHEN age BETWEEN 46 AND 50  THEN '46-50'
             ELSE '50+' END AS age_group
FROM 	employees e JOIN performancerating p
ON 		e.EmployeeID = p.EmployeeID)
SELECT  age_group,
		AVG(jobsatisfaction) AS avg_jobsatisfaction
FROM age_group
GROUP BY age_group
ORDER BY age_group;


-- 4.What is the satisfaction trend over time?

SELECT 	CONCAT('Q ', QUARTER(ReviewDate)) AS `Quarter`, 
		AVG(CASE WHEN YEAR(ReviewDate) = '2020' THEN jobsatisfaction END) AS Year_20,
        AVG(CASE WHEN YEAR(ReviewDate) = '2021' THEN jobsatisfaction END) AS Year_21,
        AVG(CASE WHEN YEAR(ReviewDate) = '2022' THEN jobsatisfaction END )AS Year_22
FROM performancerating
GROUP BY CONCAT('Q ', QUARTER(ReviewDate));

-- 5.How does satisfaction correlate with attrition or performance?
SELECT  Attrition, 
		AVG(performancerating) AS AVG_performance,
        AVG(JobSatisfaction) AS AVG_jobsatisfaction
FROM 	employees e JOIN performancerating p
ON 		e.EmployeeID = p.EmployeeID
GROUP BY Attrition;

-- 6.What are the top factors affecting employee satisfaction (salary, work-life balance, Job Role)?
SELECT max(salary), min(salary) FROM employees;

SELECT 	
		CASE WHEN salary < '50000' THEN 'Low'
			 WHEN salary BETWEEN 50000 AND 100000 THEN 'Medium'
             ELSE 'High' END AS salary_group,
             AVG(jobSatisfaction) AS AVG_jobsatisfaction
FROM 	employees e JOIN performancerating p
ON 		e.EmployeeID = p.EmployeeID
GROUP BY salary_group;

SELECT 	WorkLifeBalance,	
		AVG(jobSatisfaction) AS AVG_jobsatisfaction
FROM 	employees e JOIN performancerating p
ON 		e.EmployeeID = p.EmployeeID
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance DESC;


SELECT 	JobRole,	
		AVG(jobSatisfaction) AS AVG_jobsatisfaction
FROM 	employees e JOIN performancerating p
ON 		e.EmployeeID = p.EmployeeID
GROUP BY JobRole
ORDER BY JobRole DESC;


-- 7.job satisfactions by employees and job title
select jobrole, 
		COUNT(CASE when JobSatisfaction = 1 then e.employeeid end )as 's1' ,
		COUNT(case when JobSatisfaction = 2 then e.employeeid end) as 's2',
        COUNT(case when JobSatisfaction = 3 then e.employeeid end) as 's3',
		COUNT(case when JobSatisfaction = 4 then e.employeeid end) as 's4',
		COUNT(case when JobSatisfaction = 5 then e.employeeid end )as 's5'
from employees e join performancerating p
on e.EmployeeID = p.EmployeeID
group by JobRole;


