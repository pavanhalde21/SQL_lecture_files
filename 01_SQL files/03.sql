 
--PRACTICE

--JOIN
--SET OPERATORS(UNION,  UNION ALL,  INTERSECT,  MINUS)
--AGGREGATE FUNCTIONS
--GROUP BY CLAUSE
--ROWNUM PSEUDO COLUMN
--WINDOWS FUNCTION (--RANKING(RANK, DENSE_RANK, ROW_NUMBER))
          

---PRACTICE----------------------------------------------------------------------------------------------------------------------------------------------
create table station
(
id number,
city varchar2(21),
state varchar2(2),
lat_n number,
long_n number
);

select * from station;

insert into station values(4,'wxy','of',133479,644385);

/* Query the two cities in STATION with the shortest and longest CITY names, 
as well as their respective lengths (i.e.: number of characters in the name). 
If there is more than one smallest or largest city, 
choose the one that comes first when ordered alphabetically. */

SELECT * FROM (SELECT city, length(city) FROM station ORDER BY length(city) asc, city asc)
WHERE ROWNUM =1;

SELECT * FROM (SELECT city, length(city) FROM station ORDER BY length(city) desc, city asc)
WHERE ROWNUM =1;
--by writing SELECT in SELECT statement we are including the order by 
--elsewise ORDER BY statement executes last hence does not get included

SELECT Employee_id, First_name, Last_name, Salary, ROWNUM,
MIN(salary) OVER (PARTITION BY salary ORDER BY salary) Second_heighest
FROM Hr.Employees
WHERE ROWNUM <=10
MINUS
SELECT Employee_id, First_name, Last_name, Salary, ROWNUM,
MIN(salary) OVER (PARTITION BY salary ORDER BY salary) Second_heighest
FROM Hr.Employees
WHERE ROWNUM =1;

--to find second highest salary
SELECT * FROM(SELECT salary, employee_id, first_name, Last_name FROM hr.employees ORDER BY salary desc)
WHERE ROWNUM <=2
MINUS
SELECT * FROM(SELECT salary,employee_id, first_name, Last_name 
FROM hr.employees ORDER BY salary desc, first_name asc)
WHERE ROWNUM =1;

SELECT * FROM(SELECT salary,employee_id, first_name, Last_name FROM hr.employees ORDER BY salary desc)
WHERE ROWNUM <=2
MINUS
SELECT * FROM(SELECT salary,employee_id, first_name, Last_name 
FROM hr.employees ORDER BY salary desc, first_name desc)
WHERE ROWNUM =1; -- note the small difference between the above two queries


-- other method for second heighest salary
select max(salary) 
from hr.employees 
where salary not in (select max(salary) from hr.employees);


select * from hr.employees
where hire_date between to_date('1-12-2001','dd-mm-yyyy') 
and to_date('1-12-2006','dd-mm-yyyy');


select * from hr.employees where commission_pct = null;-- empty table   
select * from hr.employees where commission_pct is null;



---------------------------------------------------------------------------------------------------------------------
---------JOIN() ---------
--INNER JOIN 
--LEFT JOIN 
--RIGHT JOIN
--FULL OUTER JOIN
--SELF JOIN(ex. of employee and his manager in same table)


select * from t1, t2 where t1.id = t2.id(+);--LEFT JOIN

select * from t1 LEFT JOIN t2 ON t1.id = t2.id;

select * from t2;

insert into t2 values (6);

COMMIT;

select sum(salary) from hr.employees;

select * from hr.locations;


--------joining 3 tables--

select * from hr.employees e
inner join hr.departments d on (e.department_id = d.department_id)
inner join hr.locations l on (d.location_id = l.location_id);

select employee_id, first_name, Last_name, salary, commission_pct, department_name,
(salary + nvl(commission_pct,0)) "total salary", street_address, city
from hr.employees e 
inner join hr.departments d on (e.department_id = d.department_id)
inner join hr.locations l on (d.location_id = l.location_id);

---- joining without using join statement

select * from hr.employees e, hr.departments d, hr.locations l 
where e.department_id = d.department_id 
and d.location_id = l.location_id;

select employee_id, first_name, Last_name, salary, commission_pct, department_name,
(salary + nvl(commission_pct,0))"total salary", street_address, city
from hr.employees e, hr.departments d, hr.locations l 
where e.department_id = d.department_id 
and d.location_id = l.location_id;
-------------------------------------------------------------------------------------------------------------------------------------------------



----- SET OPERATOR ---------

--    UNION            -- combines two select statements
--    UNION ALL    -- shows all records including dublicates
--    INTERSECT   -- displays only common records
--    MINUS            -- removes comman record and displays the remaining from first select statement

---different type of case regarding UNION is explained below -----------------------------------------------------------------------------------------
select * from t1
union
select first_name from hr.employees; -- error(expressions must have same datatype and same number of columns)

create table t5 
(
id int,
salary int
);

insert into t5 values(3,300);

select * from t5;

select to_char(id),salary from t5 ----if we don't use to_char(id) the datatype of id and 'total' does not match and it shows an error
union all
select 'total',sum(salary) as total from t5 -----'total' is assigned to new column in the same record of sum 


select id from t5; ---- the data in the record is displayed on the right side of the column

select to_char(id) from t5;-- the data in the record is displayed on the left side of the column
--this is just to know that we can recognize the datatype by looking at the position of the data



-- Creating a table
CREATE TABLE Employees4372 (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50)
);

select * from Employees4372;

-- Inserting records into the table
INSERT INTO Employees4372 (EmployeeID, FirstName, LastName, Department)
VALUES (1, 'John', 'Doe', 'IT');
INSERT INTO Employees4372 (EmployeeID, FirstName, LastName, Department)
VALUES  (2, 'Jane', 'Smith', 'HR');
INSERT INTO Employees4372 (EmployeeID, FirstName, LastName, Department)
VALUES  (3, 'Alice', 'Johnson', 'Marketing');


-- Creating a new table with columns in the desired order
CREATE TABLE Employees_New5678 (
    EmployeeID INT PRIMARY KEY,
    Department VARCHAR(50),
    LastName VARCHAR(50),
    FirstName VARCHAR(50)
);

-- Inserting data into the new table
INSERT INTO Employees_New5678 (EmployeeID, Department, LastName, FirstName)
VALUES (1, 'IT', 'Doe', 'John');
INSERT INTO Employees_New5678 (EmployeeID, Department, LastName, FirstName)
VALUES (2, 'HR', 'Smith', 'Jane');
INSERT INTO Employees_New5678 (EmployeeID, Department, LastName, FirstName)
VALUES (3, 'Marketing', 'Johnson', 'Alice');


select * from Employees_New5678;
union
select * from Employees4372;



CREATE TABLE Employees4373 (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50)
);

select * from Employees4373;
INSERT INTO Employees4373 (EmployeeID, FirstName, LastName, Department)
VALUES (1, 'John', 'Doe', 'IT');
INSERT INTO Employees4373 (EmployeeID, FirstName, LastName, Department)
VALUES  (2, 'pavan', 'halde', 'DE');
INSERT INTO Employees4373 (EmployeeID, FirstName, LastName, Department)
VALUES  (3, 'abcd', 'Johnsonnnnn', 'Marketinggggg');

INSERT INTO Employees4373 (EmployeeID, FirstName, LastName, Department)
VALUES  (4, 'abcdd', 'Johnsonnnnn',NULL);



select * from Employees4372;
select * from Employees4373;

select * from Employees4372
union
select * from Employees4373;

select * from Employees4372
union all
select * from Employees4373;

select * from Employees4372
minus
select * from Employees4373;

select * from Employees4372
intersect
select * from Employees4373;


-----------------------------------------------------------------------------------------------------------------------------------------------


-------- AGGREGATE FUNCTIONS -------------------------------------------------------
--MAX(),MIN(),COUNT(),SUM(),AVG(),

SELECT COUNT(EMPLOYEE_ID) FROM HR.EMPLOYEES 
WHERE DEPARTMENT_ID = 60;

SELECT SUM(SALARY) FROM HR.EMPLOYEES 
WHERE DEPARTMENT_ID = 60;

SELECT MAX(SALARY) FROM HR.EMPLOYEES 
WHERE DEPARTMENT_ID = 60;

SELECT AVG(SALARY) FROM HR.EMPLOYEES 
WHERE DEPARTMENT_ID = 60; 

--GROUP BY
SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID) FROM HR.EMPLOYEES 
GROUP BY DEPARTMENT_ID ORDER BY DEPARTMENT_ID ASC;

SELECT e.DEPARTMENT_ID, DEPARTMENT_NAME, SUM(SALARY), COUNT(EMPLOYEE_ID) 
FROM HR.EMPLOYEES e, HR.DEPARTMENTS d
WHERE e.department_id = d.department_id
GROUP BY e.DEPARTMENT_ID, DEPARTMENT_NAME --e.DEPARTMENT_ID, DEPARTMENT_NAME are both to be written as it is mentioned in the select statement column_name
ORDER BY e.DEPARTMENT_ID;


--
SELECT * FROM hr.employees;

SELECT DEPARTMENT_ID, COUNT(employee_id) DEPT_CPT
FROM HR.EMPLOYEES
GROUP BY DEPARTMENT_ID;

SELECT DEPARTMENT_ID, COUNT(*) DEPT_CPT
FROM HR.EMPLOYEES
GROUP BY DEPARTMENT_ID;

SELECT DEPARTMENT_ID,FIRST_NAME, COUNT(*) DEPT_CPT
FROM HR.EMPLOYEES
GROUP BY DEPARTMENT_ID, FIRST_NAME;--(gives the results where there is combination of department _id and first_name )
-- note the changes in the result 
--

select * from HR.EMPLOYEES
where first_name = 'James';


--HAVING
SELECT e.DEPARTMENT_ID, DEPARTMENT_NAME, SUM(SALARY), COUNT(EMPLOYEE_ID) 
FROM HR.EMPLOYEES e, HR.DEPARTMENTS d
WHERE e.department_id = d.department_id 
HAVING COUNT(EMPLOYEE_ID) > 10 -- for comparing aggregate functions we can not use WHERE clause we need to use HAVING
GROUP BY e.DEPARTMENT_ID, DEPARTMENT_NAME 
ORDER BY e.DEPARTMENT_ID;
-- because considering the order in which a sql query is executed WHERE is executed before GROUP BY


-----------**********************----------------------
SELECT DEPARTMENT_ID, SALARY, COUNT(SALARY)
FROM HR.EMPLOYEES
GROUP BY DEPARTMENT_ID, SALARY
HAVING DEPARTMENT_ID IS NOT NULL
AND SALARY > 20;  -- have a look --we can use having even for non-aggregate function 
-- and column "salary" exists in the select statement -- so we cannot use where for "salary" as where executes before group by
-----------**********************----------------------

SELECT AVG(SALARY) FROM HR.EMPLOYEES 
HAVING DEPARTMENT_ID = 60; -- error -- HAVING clause is used when GROUP BY is specified 

SELECT LOCATION_ID, DEPARTMENT_NAME FROM HR.DEPARTMENTS 
GROUP BY location_id, DEPARTMENT_NAME;
-------------------------------------------------------------------------------------------------------------------------------------------
SELECT COUNT (*) MANAG_ID FROM HR.EMPLOYEES --null values are also counted  

SELECT COUNT (MANAGER_ID) FROM HR.EMPLOYEES --null values are not counted

SELECT COUNT(10000) FROM HR.EMPLOYEES --any integer in the bracket of count is giving the value as given by COUNT(*)

--ROWNUM PSEUDO COLUMN

SELECT  ROWNUM, EMPLOYEE_ID, FIRST_NAME, LAST_NAME FROM HR.EMPLOYEES
WHERE ROWNUM < 10; -- gives predicted value

SELECT  EMPLOYEE_ID, FIRST_NAME, LAST_NAME FROM HR.EMPLOYEES
WHERE ROWNUM < 10; --not mentioning ROWNUM also works

SELECT  EMPLOYEE_ID, FIRST_NAME, LAST_NAME FROM HR.EMPLOYEES
WHERE ROWNUM > 1; --for greater than symbol it gives NULL value

SELECT ROWNUM, EMPLOYEE_ID, FIRST_NAME, LAST_NAME FROM HR.EMPLOYEES
WHERE ROWNUM = 1; -- gives predicted value

SELECT ROWNUM, EMPLOYEE_ID, FIRST_NAME, LAST_NAME FROM HR.EMPLOYEES
WHERE ROWNUM = 2; --gives null value
WHERE ROWNUM = 3; --gives null value 


-----------------------------------------------------------------------

SELECT * FROM HR.EMPLOYEES 
WHERE FIRST_NAME = 'Neena' --'NEENA' will show null result, because record data is case sensetive.

--shows salary of employees having salary same as Neena
select a.salary, b.first_name from hr.employees a , hr.employees b
where a.salary=b.salary and a.first_name = 'Neena';

--below query is for who is the manager of whom(SELF JOIN)
SELECT a.first_name as employee, a.manager_id, b.First_name as manager
from hr.employees a, hr.employees b 
where a.manager_id = b.employee_id
order by b.employee_id;

SELECT a.first_name as employee, a.manager_id, b.First_name as manager
from hr.employees a
join hr.employees b on a.manager_id = b.employee_id
order by b.employee_id;

select * from hr.employees;

SELECT * FROM HR.DEPARTMENTS;
SELECT * FROM HR.EMPLOYEES;

SELECT a.first_name as employee, a.manager_id, b.First_name as manager
from hr.employees a, hr.employees b 

--list of employees under executive department(department_id = 100)
SELECT FIRST_NAME, LAST_NAME, EMPLOYEE_ID, e.DEPARTMENT_ID, DEPARTMENT_NAME, d.MANAGER_ID 
FROM HR.EMPLOYEES e, HR.DEPARTMENTS d 
WHERE e.department_id = d.department_id and d.department_id = 100;

SELECT FIRST_NAME, LAST_NAME, EMPLOYEE_ID, e.DEPARTMENT_ID, DEPARTMENT_NAME, d.MANAGER_ID 
FROM HR.EMPLOYEES e INNER JOIN HR.DEPARTMENTS d 
ON e.department_id = d.department_id 
WHERE d.department_id  = 100;

-----
select unique salary from hr.employees;
select distinct salary from hr.employees;
--

SELECT * FROM USER_TABLES;

--below query is for heighest paid employee in different department

SELECT DEPARTMENT_NAME, E.FIRST_NAME, E.EMPLOYEE_ID, E.DEPARTMENT_ID, SALARY
FROM HR.EMPLOYEES E 
INNER JOIN  HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY DEPARTMENT_NAME, E.EMPLOYEE_ID, E.FIRST_NAME, E.DEPARTMENT_ID, SALARY --have a look
ORDER BY E.DEPARTMENT_ID;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------ WINDOWS FUNCTION ------------

-----RANK()--------
--below query ranks salary of each department from lowest to highest as 1,2,3... 
--if in a particular department two employee have the same salary then both the employee are given same rank(r) and the next employee is given rank(r+2)   
SELECT employee_id, department_id, SALARY,
RANK() OVER (PARTITION BY department_id order by salary) rk
FROM hr.employees;

SELECT employee_id, department_id, SALARY,
RANK() OVER (order by salary) rk  -- without partition by
FROM hr.employees;

--------------------------------------------------------------------
--below query gives the list of [having lowest salary] rank(1) employees of each department
SELECT * FROM
(SELECT employee_id, department_id, SALARY,
RANK() OVER (PARTITION BY department_id order by salary) rk
FROM hr.employees)
WHERE rk =1; --we took the SELECT query under bracket to compare with rank


--[having highest salary] rank(1)
SELECT * FROM(SELECT employee_id, department_id, SALARY,
RANK() OVER (PARTITION BY department_id order by salary DESC) rk --due to use of DESC
FROM hr.employees)
WHERE rk =1;
--we are using select in select statement to be able to use the alias name in where clause


----------------------------------------------------------------------------------------------------------------------------------------


--------DENSE_RANK()----------------
--if in a particular department two employee have the same salary then both the employee are given same rank(r) and the next employee is given rank(r+1)
SELECT employee_id, department_id, SALARY,
DENSE_RANK() OVER (PARTITION BY department_id order by salary) rk
FROM hr.employees;

------------compare the ranks given by rk, drk to understand better
SELECT employee_id, department_id, SALARY,
RANK() OVER (PARTITION BY department_id order by salary) rk,
DENSE_RANK() OVER (PARTITION BY department_id order by salary) drk
FROM hr.employees
WHERE department_id = 50;
--we need not use SELECT in SELECT as we are not comparing with rank but with department_id

------ROW_NUMBER()-----
SELECT employee_id, department_id, SALARY,
ROW_NUMBER() OVER (PARTITION BY department_id order by salary) rn
FROM hr.employees;--even if same salary is present it does not assign same rank to it

---compare ranks given by rk,drk,rn
SELECT employee_id, department_id, SALARY,
RANK() OVER (PARTITION BY department_id order by salary) rk,
DENSE_RANK() OVER (PARTITION BY department_id order by salary) drk,
ROW_NUMBER() OVER (PARTITION BY department_id order by salary) rn
FROM hr.employees
WHERE department_id = 50;

----nth highest salary of an employee from a particular department
SELECT * FROM (SELECT E.*, DENSE_RANK() OVER (PARTITION BY department_id order by salary) dk FROM HR.EMPLOYEES E)
WHERE dk =4;


--���� nth highest salary of an employee from a table
select * from(select e.*, dense_rank() over(order by salary) dk from hr.employees e)
where dk = 6;

select distinct salary from(select salary, dense_rank() over(order by salary) dk from hr.employees)
where dk = 6;

select distinct salary from(select salary, dense_rank() over(order by salary) dk from hr.employees) r
where dk = 6;
--here an alias is used for the select statement
--because for mysql it says(Every derived table must have its own alias.)


select * from hr.employees 
order by salary;


select e.first_name, m.first_name from hr.employees e 
join hr.employees m
on e.manager_id = m.employee_id
where e.first_name = 'Neena';

select * from HR.EMPLOYEES; -- 107 records
select * from HR.DEPARTMENTS; -- 27 records

SELECT *
FROM HR.EMPLOYEES
CROSS JOIN HR.DEPARTMENTS; -- 2889 records

SELECT *
FROM HR.EMPLOYEES E
CROSS JOIN HR.DEPARTMENTS D
WHERE e.department_id = d.department_id; -- seems to be same as inner join

SELECT *
FROM HR.EMPLOYEES E
INNER JOIN HR.DEPARTMENTS D
on e.department_id = d.department_id;

select * from hr.employees e
inner join hr.departments d on (e.department_id = d.department_id);


select  now from dual;











