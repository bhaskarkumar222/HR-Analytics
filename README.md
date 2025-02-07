# HR Analytics Employee Attrition Dashboard 
![image alt](https://github.com/bhaskarkumar222/HR-Analytics/blob/1aa0c9e6534d2f707a52b7bff27a5b9016bcf372/HR-Analytics-1170x630.jpg)

## Situation  
Employee attrition is a major challenge for organizations, leading to increased hiring costs, reduced productivity, and lower employee morale. HR teams need data-driven insights to understand **why employees leave, which departments are affected the most, and what factors contribute to attrition**.  

To address this, we developed an **HR Analytics Dashboard** that provides insights into **attrition rates, job satisfaction, performance and salary trends** using **Power BI and SQL**.

## Tools & Skills Used
* **SQL** – Querying and analyzing HR databases for attrition trends
* **Power BI** – Interactive dashboards for insights & trend analysis.

## Task  
The objective was to **Analyse employee attrition trends** and derive actionable insights. This involved identifying **key factors** influencing turnover, such as age, job role, salary, and performance. The findings aim to support strategic decision-making to enhance employee retention.

## Action
### Here are key problem questions to achieve the goal using SQL:

#### Attrition Analysis

1. What is the overall attrition rate?
``` sql
SELECT 
      SUM(CASE WHEN attrition = "yes" THEN 1 END) / COUNT(employeeid)*100 AS attrition_rate
FROM 	employees;
```

2. What is the attrition rate by department?
```sql
SELECT   department,
         SUM(CASE WHEN attrition = 'yes' THEN 1 END) / COUNT(employeeid)*100 attrition_rate
FROM      employees
GROUP BY department;
```
3. What is the attrition rate by job role?
```sql
SELECT   jobrole,
         SUM(CASE WHEN attrition = 'yes' THEN 1 END)/ COUNT(employeeid)* 100 AS attrition_rate
FROM     employees
GROUP BY jobrole
ORDER BY attrition_rate DESC;
```
4. What is the average tenure of employees who left vs. those who stayed?
```sql
SELECT   attrition,
         AVG(yearsatcompany) AS average_tenure
FROM     employees
GROUP BY attrition;
```
5. What is the attrition rate by gender?
```sql
SELECT   gender,
         SUM(CASE WHEN attrition = 'yes' THEN 1 END)/ COUNT(employeeid)* 100 AS attrition_rate
FROM     employees
GROUP BY gender;

```
6. What is the average salary of employees who left vs. those who stayed?
```sql
SELECT   attrition,
         AVG(salary) AS AVG_salary
FROM     employees
GROUP BY attrition; 
```
7. How does attrition vary by performance rating?
```sql
SELECT   Performancerating,
         COUNT(e.employeeid) AS total_employees,
         SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS EmployeesWhoLeft
FROM     employees e JOIN Performancerating p
ON       e.employeeid = p.employeeid
GROUP BY Performancerating;
```
8. What is the attrition rate for employees who worked overtime vs. those who didn’t?
```sql
SELECT   overtime,
         SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)/ COUNT(Employeeid)*100 AS attrition_rate
FROM     employees
GROUP BY overtime;
```
9.  What is the attrition rate by age group?
```sql
WITH Age_group AS (
SELECT   attrition, employeeid,
         CASE WHEN age BETWEEN 18 AND 20  THEN '18-20'
              WHEN age BETWEEN 21 AND 25  THEN '21-25'
              WHEN age BETWEEN 26 AND 30  THEN '26-30'
              WHEN age BETWEEN 31 AND 35  THEN '31-35'
              WHEN age BETWEEN 36 AND 40  THEN '36-40'
              WHEN age BETWEEN 41 AND 45  THEN '41-45'
              WHEN age BETWEEN 46 AND 50  THEN '46-50'
              ELSE '50+' END AS age_group
FROM 	   employees)
SELECT   age_group,
         SUM(CASE WHEN attrition = 'yes' THEN 1 END)/ COUNT(employeeid)*100  AS attrition_rate
FROM 	   age_group
GROUP BY age_group
ORDER BY age_group;
```
#### Performance Analysis

1.	What is the average performance rating by department or job role?
```sql
SELECT   department,
         AVG(Performancerating) AS Performance_rating
FROM     employees e JOIN Performancerating p 
ON       e.employeeid = p.employeeid
GROUP BY department;
```
2.	How does performance vary by tenure?
```sql
SELECT   yearsatcompany,
         AVG(performancerating) AS Avg_performance_rating
FROM     employees e JOIN Performancerating p 
ON       e.employeeid = p.employeeid
GROUP BY yearsatcompany
ORDER BY yearsatcompany;
```
3.	What is the distribution of performance ratings (e.g., high, medium, low)?
```sql
SELECT   CASE WHEN Performancerating >= 4 THEN 'High'
              WHEN Performancerating = 3 THEN 'Medium'
         ELSE 'Low' END AS preformance_level,
         COUNT(DISTINCT employeeid) AS distribution
FROM     performancerating
GROUP BY preformance_level;
```
4.	What is the performance trend over time (e.g., quarterly or yearly)?
```sql
SELECT   CONCAT('Q ', QUARTER(ReviewDate)) AS `Quarter`, 
         AVG(CASE WHEN YEAR(ReviewDate) = '2020' THEN performancerating END) AS Year_20,
         AVG(CASE WHEN YEAR(ReviewDate) = '2021' THEN performancerating END) AS Year_21,
         AVG(CASE WHEN YEAR(ReviewDate) = '2022' THEN performancerating END )AS Year_22
FROM     performancerating
GROUP BY CONCAT('Q ', QUARTER(ReviewDate));
```
5.	How does performance vary by gender?
```sql
SELECT   gender, 
         AVG(performancerating) AS avg_performance_rating
FROM     employees e JOIN performancerating p
ON       e.employeeid = p.employeeid
GROUP BY gender;
```
6.	How does performance vary by age group?
```sql
WITH Age_group AS (
SELECT   attrition, performancerating,
         CASE WHEN age BETWEEN 18 AND 20  THEN '18-20'
              WHEN age BETWEEN 21 AND 25  THEN '21-25'
              WHEN age BETWEEN 26 AND 30  THEN '26-30'
              WHEN age BETWEEN 31 AND 35  THEN '31-35'
              WHEN age BETWEEN 36 AND 40  THEN '36-40'
              WHEN age BETWEEN 41 AND 45  THEN '41-45'
              WHEN age BETWEEN 46 AND 50  THEN '46-50'
              ELSE '50+' END AS age_group
FROM     employees e JOIN performancerating p
ON       e.EmployeeID = p.EmployeeID)
SELECT   age_group,
         AVG(performancerating) AS avg_performance_rating
FROM     age_group
GROUP BY age_group
ORDER BY age_group;
```
7.	What is the performance of employees who left vs. those who stayed?
```sql
SELECT   attrition,
         AVG(performancerating) AS avg_performance_rating
FROM     employees e JOIN performancerating p
ON       e.EmployeeID = p.EmployeeID
GROUP BY attrition;
```
8.	What is the performance of employees by manager?
```sql
SELECT   e.employeeid as Manager_ID, 
         Avg(Performancerating) AS avg_performance_rating
FROM     employees e JOIN performancerating p 
ON       e.EmployeeID = p.EmployeeID
WHERE    jobrole like '%manager%'
GROUP BY e.employeeid;
```

#### Employee Sentiment Analysis

1.	What is the overall employee satisfaction score?
```sql
SELECT   AVG(jobsatisfaction) AS avg_satisfaction_score
FROM    performancerating;
```
2.	How does satisfaction vary by department?
```sql
SELECT   department,
         AVG(jobsatisfaction) AS avg_satisfaction_score
FROM     employees e JOIN performancerating p 
ON       e.EmployeeID = p.EmployeeID
GROUP BY department;
```
3.	What is the satisfaction trend over time?
```sql
SELECT   CONCAT('Q ', QUARTER(ReviewDate)) AS `Quarter`, 
         AVG(CASE WHEN YEAR(ReviewDate) = '2020' THEN jobsatisfaction END) AS Year_20,
         AVG(CASE WHEN YEAR(ReviewDate) = '2021' THEN jobsatisfaction END) AS Year_21,
         AVG(CASE WHEN YEAR(ReviewDate) = '2022' THEN jobsatisfaction END )AS Year_22
FROM     performancerating
GROUP BY CONCAT('Q ', QUARTER(ReviewDate));
```
4.	How does satisfaction correlate with attrition or performance?
```sql
SELECT   Attrition, 
         AVG(performancerating) AS AVG_performance,
         AVG(JobSatisfaction) AS AVG_jobsatisfaction
FROM     employees e JOIN performancerating p
ON       e.EmployeeID = p.EmployeeID
GROUP BY Attrition;
```
5.	What are the top factors affecting employee satisfaction (e.g., salary, work-life balance and Job role)?
```sql
SELECT 	
         CASE WHEN salary < '50000' THEN 'Low'
              WHEN salary BETWEEN 50000 AND 100000 THEN 'Medium'
         ELSE 'High' END AS salary_group,
         AVG(jobSatisfaction) AS AVG_jobsatisfaction
FROM     employees e JOIN performancerating p
ON       e.EmployeeID = p.EmployeeID
GROUP BY salary_group;
```
```sql
SELECT   WorkLifeBalance,	
         AVG(jobSatisfaction) AS AVG_jobsatisfaction
FROM     employees e JOIN performancerating p
ON       e.EmployeeID = p.EmployeeID
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance DESC;
```
```sql
SELECT   JobRole,	
         AVG(jobSatisfaction) AS AVG_jobsatisfaction
FROM     employees e JOIN performancerating p
ON       e.EmployeeID = p.EmployeeID
GROUP BY JobRole
ORDER BY JobRole DESC;
```
6.	How does satisfaction vary by gender?
```sql
SELECT   gender,
         AVG(jobsatisfaction) AS avg_satisfaction_score
FROM     employees e JOIN performancerating p
ON       e.EmployeeID = p.EmployeeID
GROUP BY gender;
```
7.    How does satisfaction vary by age group?
```sql
WITH Age_group AS (
SELECT   attrition, jobsatisfaction,
         CASE WHEN age BETWEEN 18 AND 20  THEN '18-20'
              WHEN age BETWEEN 21 AND 25  THEN '21-25'
              WHEN age BETWEEN 26 AND 30  THEN '26-30'
              WHEN age BETWEEN 31 AND 35  THEN '31-35'
              WHEN age BETWEEN 36 AND 40  THEN '36-40'
              WHEN age BETWEEN 41 AND 45  THEN '41-45'
              WHEN age BETWEEN 46 AND 50  THEN '46-50'
         ELSE '50+' END AS age_group
FROM    employees e JOIN performancerating p
ON      e.EmployeeID = p.EmployeeID)
SELECT   age_group,
         AVG(jobsatisfaction) AS avg_jobsatisfaction
FROM     age_group
GROUP BY age_group
ORDER BY age_group;
```
8.	What job satisfactions by employees and job title?
```sql
select   jobrole, 
         COUNT(CASE when JobSatisfaction = 1 then e.employeeid end )as 's1' ,
         COUNT(case when JobSatisfaction = 2 then e.employeeid end) as 's2',
         COUNT(case when JobSatisfaction = 3 then e.employeeid end) as 's3',
         COUNT(case when JobSatisfaction = 4 then e.employeeid end) as 's4',
         COUNT(case when JobSatisfaction = 5 then e.employeeid end )as 's5'
FROM     employees e join performancerating p
ON       e.EmployeeID = p.EmployeeID
GROUP BY JobRole;
```

#### Dashboard Development: 
   - Built an **interactive Power BI dashboard** featuring:
     - **Total Attrition, Attrition Rate & Average performancing Rating**
     - **Attrition by Age Group, Gender, Department, Salary, and Experience**
     - **Job Satisfaction Analysis**
     - Created visualizations using **Power BI** (bar charts, pie charts, Matrix).

![image alt](https://github.com/bhaskarkumar222/HR-Analytics/blob/88e939ef6611997413c2b87e7d8a02b034139717/HR%20Dashboard_SS.png)


## Key Findings & Insights of the HR Analytics Employee Attrition Project
The overall **attrition rate is 16.12%** which Requires HR intervention, with young employees age between 21-30 years and those with low salaries being most affected.
**Top Factors Influencing Attrition:**
- **Demographics & Experience** – Younger employees age between 21-30 years and those with **0-5 years of experience show the highest attrition**.
- **Job Role & Salary** – **Sales Executives and Data Scientists** experience the most turnover, especially among employees in the **low-salary category**.
- **Performance & Satisfaction** – Employees with **low performance ratings and poor job satisfaction** are more likely to leave, highlighting the need for better engagement strategies.
- **Gender-Based Trends** – **Male attrition rate is 52.29%** is slightly higher than female attrition, requiring further analysis to understand the reasons.

## Final Conclusion
This project highlights that **employee attrition is influenced by multiple factors**, including salary, job role, experience, performance and job satisfaction. By **analysing these insights and implementing strategic HR interventions**, organizations can **reduce turnover, improve workforce stability and create a more engaged and productive workforce**.




