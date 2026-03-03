use EmployeeAnalytics;
--Create Department Table
create Table Departments(
dept_id INT PRIMARY KEY,
dept_name VARCHAR(50) NOT NULL
);

-- Create Location Table
create Table Locations(
location_id INT PRIMARY KEY,
location_name VARCHAR(50) NOT NULL
);
-- Create Job_roles
Create Table Job_roles(
role_id INT PRIMARY KEY,
role_name VARCHAR(50) NOT NULL,
min_salary DECIMAL(10,2),
max_salary DECIMAL(10,2)
);

--create Employees Table
Create Table Employees(
emp_id INT PRIMARY KEY,
emp_name VARCHAR(100) NOT NULL,
gender VARCHAR(10),
dept_id INT,
role_id INT,
location_id INT,
join_date DATE,
status varchar(20) default 'ACTIVE',
FOREIGN KEY(dept_id) REFERENCES Departments(dept_id),
FOREIGN KEY(role_id) REFERENCES Job_roles(role_id),
FOREIGN KEY(location_id) REFERENCES Locations(location_id),
);

--Create Salary Table
create table Salary(
salary_id INT PRIMARY KEY,
emp_id INT,
salary DECIMAL(10,2),
effective_date Date,
FOREIGN KEY(emp_id) REFERENCES Employees(emp_id),
);

--create Performance_Review
create Table Performance_Review(
review_id INT PRIMARY KEY,
emp_id INT,
review_year INT,
rating DECIMAL(2,1) CHECK (rating BETWEEN 1 AND 5),
FOREIGN KEY(emp_id) REFERENCES Employees(emp_id),
);

-- Inserting from the csv files data into all the tables
BULK INSERT Departments
FROM 'C:\sqldata\Departments.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '\n',    
    FIRSTROW = 2           
);
BULK INSERT Locations
FROM 'C:\sqldata\Locations.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '\n',    
    FIRSTROW = 2           
);
BULK INSERT Job_roles
FROM 'C:\sqldata\Job_roles.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '\n',    
    FIRSTROW = 2           
);
BULK INSERT Employees
FROM 'C:\sqldata\Employees.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '\n',    
    FIRSTROW = 2           
);
BULK INSERT Salary
FROM 'C:\sqldata\Salary.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '\n',    
    FIRSTROW = 2           
);
BULK INSERT Performance_Review
FROM 'C:\sqldata\Performance_Review.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '\n',    
    FIRSTROW = 2           
);

--SELECT * FROM Departments;
--SELECT * FROM Locations;
--SELECT * FROM Job_roles;
--SELECT * FROM Employees;
--SELECT * FROM Salary;
--SELECT * FROM Performance_Review;

--PERFORMANCE ANALYTICS
--1. Top 10 High-performance employee
SELECT TOP 10 
E.emp_id,E.emp_name,PR.review_year,PR.rating
FROM Performance_Review PR JOIN Employees E ON E.emp_id = PR.emp_id
ORDER BY PR.rating DESC;
--2. Average Rating per department
SELECT D.dept_name,AVG(PR.rating) AS avg_rating
FROM Performance_Review PR JOIN Employees E ON E.emp_id = PR.emp_id
JOIN Departments D ON D.dept_id = E.dept_id
GROUP BY D.dept_name
ORDER BY avg_rating DESC;
--3.Employees Eligible for Promotion (rating > 4 and 2+ years of service)
SELECT E.emp_id,E.emp_name,E.join_date,PR.rating,
    DATEDIFF(YEAR, E.join_date, GETDATE()) AS years_with_company FROM 
    Performance_Review PR JOIN Employees E ON E.emp_id = PR.emp_id
WHERE PR.rating > 4.4 AND DATEDIFF(YEAR, E.join_date, GETDATE()) >= 2
ORDER BY PR.rating DESC;
--4. Performance Trends Over the Year
SELECT PR.review_year, AVG(PR.rating) AS avg_rating
FROM Performance_Review PR
GROUP BY PR.review_year
ORDER BY PR.review_year;

-- Salary Analytics 
--5. Salary DIstribution Per department
select sum(s.salary) as Total_salary ,d.dept_name 
from Salary s JOIN Employees E ON E.emp_id = s.emp_id
JOIN Departments D ON D.dept_id = E.dept_id
Group By d.dept_name
--6. Highest & Lowest Salary per role
SELECT JR.role_name,MIN(S.salary) AS lowest_salary,MAX(S.salary) AS highest_salary  
FROM Salary S JOIN Employees E ON E.emp_id = S.emp_id
JOIN Job_roles JR ON JR.role_id = E.role_id
GROUP BY JR.role_name
ORDER BY highest_salary DESC;

--7. Salary vs Performance Correlation
SELECT E.emp_id,E.emp_name,S.salary,PR.rating AS performance_rating
FROM Employees E JOIN Salary S ON E.emp_id = S.emp_id
JOIN Performance_Review PR ON E.emp_id = PR.emp_id
WHERE PR.review_year = 2023  
ORDER BY S.salary DESC;

--8. Employees Below Department Average Salary
SELECT E.emp_id,E.emp_name ,E.dept_id,S.salary,D.dept_name
FROM Employees E JOIN Salary S ON E.emp_id = S.emp_id
JOIN Departments D ON E.dept_id = D.dept_id
WHERE S.salary < (SELECT AVG(S1.salary) FROM Salary S1 JOIN Employees E1 ON S1.emp_id = E1.emp_id
					WHERE E1.dept_id = E.dept_id)
ORDER BY S.salary;
--Department Growth
--9. Hiring Trend per Year
SELECT YEAR(join_date) AS hire_year,COUNT(emp_id) AS number_of_employees_hired
FROM Employees
GROUP BY YEAR(join_date)
ORDER BY hire_year DESC;
--10 HeadCount growth by department 
SELECT D.dept_name,YEAR(E.join_date) AS hire_year,COUNT(E.emp_id) AS headcount
FROM Employees E JOIN Departments D ON E.dept_id = D.dept_id
GROUP BY D.dept_name, YEAR(E.join_date)
ORDER BY YEAR(E.join_date) DESC, D.dept_name;

--11 Attrition rate by department skip insuffient data((exit year)
--12 Employees Overdue for Promotion
SELECT E.emp_id,E.emp_name,E.join_date, PR.rating AS performance_rating,
    DATEDIFF(YEAR, E.join_date, GETDATE()) AS years_with_company,JR.role_name
FROM Performance_Review PR JOIN Employees E ON E.emp_id = PR.emp_id
JOIN Job_roles JR ON JR.role_id = E.role_id
WHERE PR.rating > 4.0  AND DATEDIFF(YEAR, E.join_date, GETDATE()) > 2 
    AND JR.role_name NOT LIKE '%Lead' and JR.role_name NOT LIKE '%manager'
ORDER BY PR.rating DESC;
--13 High Salary but Low Performance Cases
SELECT E.emp_id,E.emp_name, S.salary, PR.rating AS performance_rating
FROM Employees E JOIN Salary S ON E.emp_id = S.emp_id
JOIN Performance_Review PR ON E.emp_id = PR.emp_id
WHERE S.salary > 100000  AND PR.rating <= 3.8 
ORDER BY S.salary DESC;

--14. Most Stable Department (Lowest Attrition) skipped
--15. Attendance vs Performance Analysis skipped
--16. Location-Wise Salary Comparison
SELECT L.location_name,AVG(S.salary) AS avg_salary,MIN(S.salary) AS min_salary,MAX(S.salary) AS max_salary
FROM Salary S JOIN Employees E ON E.emp_id = S.emp_id JOIN Locations L ON L.location_id = E.location_id
GROUP BY L.location_name
ORDER BY avg_salary DESC;
--17. Gender Diversity Ratio (if added)
SELECT E.gender,COUNT(E.emp_id) AS gender_count,(COUNT(E.emp_id) * 100.0) / (SELECT COUNT(*) FROM Employees) AS gender_ratio
FROM Employees E GROUP BY E.gender;
--18. Median Salary Calculation
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) OVER () AS median_salary
FROM Salary;
--19.Employees with multiple promotions
--20. Identify leadership pipeline candidates
SELECT E.emp_id,E.emp_name,E.join_date,PR.rating AS performance_rating,
    DATEDIFF(YEAR, E.join_date, GETDATE()) AS years_with_company,JR.role_name 
	FROM Performance_Review PR JOIN 
    Employees E ON E.emp_id = PR.emp_id JOIN Job_roles JR ON JR.role_id = E.role_id
WHERE PR.rating > 4.5  
    AND DATEDIFF(YEAR, E.join_date, GETDATE()) > 3  
    AND JR.role_name NOT LIKE '%Lead' and JR.role_name NOT LIKE '%manager'
ORDER BY PR.rating DESC;