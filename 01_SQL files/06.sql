
--PRACTICE

--NVL()
--MOD()
--FLOOR()
--CEIL()
--ROUND()
--SQRT()
--POWER()
--NVL2()
--NULLIF()

--ANALYTIC FUNCTION

------- PRACTICE --------------

SELECT EMPLOYEE_ID,COMMISSION_PCT,SALARY,(SALARY+ SALARY*(NVL(COMMISSION_PCT,0)/100))"TOTAL SALARY" 
FROM HR.EMPLOYEES;

--- create replica of table
CREATE TABLE DEPARTMENT_1
AS SELECT * FROM HR.DEPARTMENTS;

SELECT * FROM DEPARTMENT_4;

CREATE TABLE DEPARTMENT_4
AS SELECT * FROM HR.DEPARTMENTS
WHERE department_id = 10;

CREATE TABLE DEPARTMENT_2
AS SELECT * FROM HR.DEPARTMENTS
WHERE 1 = 1 --ALWAYS TRUE CONDITION--TABLE IS CREATED WITH ALL DATA

SELECT * FROM DEPARTMENT_2

CREATE TABLE DEPARTMENT_3
AS SELECT * FROM HR.DEPARTMENTS
WHERE 1 = 2 -- EMPTY TABLE IS CREATED--ALWAYS FALSE CONDITION. but maintains the fields of the table

SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID)
FROM HR.EMPLOYEES
GROUP BY DEPARTMENT_ID;

SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID)
FROM HR.EMPLOYEES
WHERE SALARY>2500
GROUP BY DEPARTMENT_ID;

SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID)
FROM HR.EMPLOYEES
GROUP BY DEPARTMENT_ID  
HAVING COUNT(EMPLOYEE_ID)>3;

--how many employees are working under each manager
SELECT MANAGER_ID, COUNT(EMPLOYEE_ID)
FROM HR.EMPLOYEES
GROUP BY MANAGER_ID;

select department_id, first_name,
count(*) over (partition by department_id)
from hr.employees;--count(*) includes null value

select department_id, first_name,
count(*) over (partition by department_id)
from hr.employees
GROUP BY department_id, first_name;

select department_id, first_name,
count(employee_id) over (partition by department_id)
from hr.employees;
-----------------------------------------------------------------------------
--MOD()
SELECT mod(9,5) from dual; -- gives reminder of 9%5

--FLOOR()
SELECT FLOOR(10.51) FROM DUAL; --10

--CEIL()
SELECT CEIL(10.51) FROM DUAL;  --11

--ROUND()
SELECT ROUND(10.51) FROM DUAL;  --11
SELECT ROUND(10.49) FROM DUAL;  --10
SELECT ROUND(10.49,1) FROM DUAL; --10.5
SELECT ROUND(10.49123,2) FROM DUAL;  --10.49
SELECT ROUND(101.49,1) FROM DUAL;  --101.5
SELECT ROUND(101.49) FROM DUAL;  --101
SELECT ROUND(101.49,-1) FROM DUAL;  --100
SELECT ROUND(10111.99,-2) FROM DUAL; --10100
SELECT ROUND(10111.23,-2) FROM DUAL; --10100
SELECT ROUND(10111.49,-2) FROM DUAL; --10100
SELECT ROUND(10199.99,-1) FROM DUAL; --10200
SELECT ROUND(10199.99,-2) FROM DUAL; --10200
SELECT ROUND(10139.99,-1) FROM DUAL; --10140
SELECT ROUND(10193.99,-1) FROM DUAL; --10190
SELECT ROUND(10133.99,-1) FROM DUAL; --10130
SELECT ROUND(-5.79) FROM DUAL;--(-6)
SELECT ROUND(-5.79,1) FROM DUAL;--(-5.8)
SELECT ROUND(-5.79,-1) FROM DUAL;--(-10)
SELECT ROUND(5.79,-1) FROM DUAL;--10
SELECT ROUND(4.79,-1) FROM DUAL;--0

--SQRT() --gives square root
SELECT SQRT(9) FROM DUAL;
SELECT SQRT(10) FROM DUAL;

--POWER()
SELECT POWER(9,2) FROM DUAL;--81
SELECT POWER(2,9) FROM DUAL;--512

--NVL2()
--if 1st parameter is null then it returns 3rd parameter
--if 1st parameter is not null then it returns 2nd parameter
-- used to replace null and not null values
SELECT NVL2(NULL,1,2) "NVL2" FROM DUAL;
SELECT NVL2(1,2,3) "NVL2" FROM DUAL;
SELECT NVL2(NULL,1,null) "NVL2" FROM DUAL;

--NULLIF()
--if 1st and 2nd values are same then it returns null
--if both values are different then it returns first value
SELECT NULLIF(1,1)"Nullif" FROM DUAL;
SELECT NULLIF(1,2)"Nullif" FROM DUAL;


--ANALYTIC FUNCTION (WINDOW function)

SELECT DEPARTMENT_ID, FIRST_NAME, 
COUNT(*) OVER (PARTITION BY DEPARTMENT_ID) 
FROM HR.EMPLOYEES;

SELECT DEPARTMENT_ID, FIRST_NAME, 
COUNT(*) OVER (PARTITION BY DEPARTMENT_ID) 
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID =100;

SELECT DEPARTMENT_ID, FIRST_NAME,SALARY, 
COUNT(*) OVER (PARTITION BY DEPARTMENT_ID),
SUM(SALARY)OVER(PARTITION BY DEPARTMENT_ID) 
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID = 100;

SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID) AS TOTAL_EMPLOYEES
FROM HR.EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING COUNT TOTAL_EMPLOYEES > 5; --error--we cannot compare alias name 
--HAVING is included in the select procedure(i.e. HAVING is executed before SELECT)


SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID) AS TOTAL_EMPLOYEES
FROM HR.EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY TOTAL_EMPLOYEES;--we can order by alias name
--ORDER BY is executed after select statement
--ORDER BY executs the last

SELECT first_name,last_name,department_id,
MIN(salary) OVER (PARTITION BY department_id) minimum_salary,
MAX(salary) OVER (PARTITION BY department_id) maximum_salary,
SUM(salary) OVER (PARTITION BY department_id) total_salary,
AVG(salary) OVER (PARTITION BY department_id) average_salary
FROM Hr.employees;

SELECT first_name,last_name,department_id,
MIN(salary) OVER (PARTITION BY department_id) minimum_salary,
MAX(salary) OVER (PARTITION BY department_id) maximum_salary,
SUM(salary) OVER (PARTITION BY department_id) total_salary,
ROUND(AVG(salary) OVER (PARTITION BY department_id)) average_salary--observe parenthesis
FROM Hr.employees;
------------------------------------
SELECT SALARY, E.* FROM HR.EMPLOYEES E;
--OBSERVER CAREFULLY (but why use?)
--refer CASE expression ORDER BY clause to find usecase
SELECT  * FROM HR.EMPLOYEES; 
------------------------------------







