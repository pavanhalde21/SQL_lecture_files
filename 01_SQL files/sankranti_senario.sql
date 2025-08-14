
SELECT * FROM v$version;
-- to check version of oracle

--------------------------------------------------------------------------------------

-- Create a table named 'PERSONS12'
CREATE TABLE PERSONS12
(
    id INT PRIMARY KEY,
    lastname VARCHAR(20) NOT NULL,
    firstname CHAR(20) NOT NULL, 
    age INT CHECK (age >= 18), -- Check constraint
    city VARCHAR(255) DEFAULT 'pune', -- Default constraint
    dob DATE 
);

--select
SELECT * FROM PERSONS12;

-- Insert values into the 'PERSONS12' table
INSERT INTO PERSONS12(id, lastname, firstname, age, dob) 
VALUES (1, 'Smith', 'John', 25, TO_DATE('15-05-1997', 'DD-MM-YYYY'));  
  
INSERT INTO PERSONS12(id, lastname, firstname, age, dob) 
VALUES (2, 'Johnson', 'Anna', 30, TO_DATE('22-08-1992', 'DD-MM-YYYY'));
    
INSERT INTO PERSONS12(id, lastname, firstname, age, dob) 
VALUES (3, 'Williams', 'Michael', 22, TO_DATE('10-01-2000', 'DD-MM-YYYY'));

INSERT INTO PERSONS12(id, lastname, firstname, age, dob, city) 
VALUES (4, 'Brown', 'Emily', 28, TO_DATE('05-03-1994', 'DD-MM-YYYY'), 'New York');

INSERT INTO PERSONS12(id, lastname, firstname, age, dob, city) 
VALUES (5, 'Jones', 'Daniel', 35, TO_DATE('20-11-1986', 'DD-MM-YYYY'), 'London');
--------------------------------------------------------------------------------------
--COMMIT
COMMIT; -- saves the changes

INSERT INTO PERSONS12(id, lastname, firstname, age, dob, city) 
VALUES (6, 'Miller', 'Sophia', 22, TO_DATE('15-09-2000', 'DD-MM-YYYY'), 'Paris');

INSERT INTO PERSONS12(id, lastname, firstname, age, dob, city) 
VALUES (7, 'Taylor', 'William', 40, TO_DATE('03-07-1982', 'DD-MM-YYYY'), 'Berlin');

--ROLLBACK
ROLLBACK;  -- undo the changes

-- Delete records where the city is 'Mumbai'
DELETE FROM PERSONS12
WHERE city = 'mumbai';

-- create savepoint
SAVEPOINT my_savepoint_1; -- have to run this 

-- update
UPDATE PERSONS12
SET city = 'Banglore'
WHERE city = 'New York';

-- use savepoint
ROLLBACK TO SAVEPOINT my_savepoint_1;
--------------------------------------------------------------------------------------
-- create new table
CREATE TABLE PERSONS21
(
    id INT
);

SELECT * FROM PERSONS21;

INSERT INTO PERSONS21 VALUES (1);
INSERT INTO PERSONS21(id) VALUES (1);
INSERT INTO PERSONS21 VALUES (1);
INSERT INTO PERSONS21 VALUES (1);

-- truncate
TRUNCATE TABLE PERSONS21;

--drop 
DROP TABLE PERSONS21;

-- Length for char, varchar
SELECT length(lastname), length(firstname) FROM PERSONS12;

-- change constraint
ALTER TABLE PERSONS12
MODIFY city DEFAULT 'mumbai';

INSERT INTO PERSONS12(id, lastname, firstname, age, dob) 
VALUES (5, 'Jones', 'Daniel', 35, TO_DATE('20-11-1986', 'DD-MM-YYYY'));

-- change constraint
ALTER TABLE PERSONS12
MODIFY city UNIQUE;  -- here if dublicate values are present then we cannot apply this constraint

-- change datatype
ALTER TABLE PERSONS12
MODIFY city CHAR(20);

-- Add column to existing table
ALTER TABLE PERSONS12
add EMP_ID NUMBER;

-- Drop column from existing table
ALTER TABLE emp1234
DROP COLUMN emp_id;

SELECT length(city) FROM PERSONS12;
--------------------------------------------------------------------------------------
-- Create a table named 'order008' with foreign key constraint
CREATE TABLE ORDER008
(
    orderid INT PRIMARY KEY, 
    ordernumber INT NOT NULL,
    ide INT,
    FOREIGN KEY (ide) REFERENCES PERSONS12(id)  -- foreign key
);

-- Create source table
CREATE TABLE source_table (
    id INT PRIMARY KEY,
    value VARCHAR(50)
);

-- Insert some data into source table
INSERT INTO source_table (id, value)
VALUES (1, 'Value1');
INSERT INTO source_table (id, value)
VALUES (2, 'Value2');
INSERT INTO source_table (id, value)
VALUES (3, 'Value3');

-- Create target table
CREATE TABLE target_table (
    id INT PRIMARY KEY,
    value VARCHAR(50)
);

-- Insert some initial data into target table
INSERT INTO target_table (id, value)
VALUES (1, 'InitialValue1');
INSERT INTO target_table (id, value)
VALUES (2, 'InitialValue2');

SELECT * FROM target_table;
SELECT * FROM source_table;

--how to check constraint is present or not
select * from user_constraints
where table_name = 'SALESPEOPLE';

-- Use MERGE statement to synchronize data
MERGE INTO target_table t
USING source_table s
ON (t.id = s.id)
WHEN MATCHED THEN
    UPDATE SET t.value = s.value
WHEN NOT MATCHED THEN
    INSERT (id, value) VALUES (s.id, s.value);
-- this is kinda SDC type-1 -- overwrites the changes

TRUNCATE TABLE source_table;
TRUNCATE TABLE target_table;
--------------------------------------------------------------------------------------
-- JOIN --

SELECT * FROM HR.DEPARTMENTS;
SELECT * FROM HR.EMPLOYEES;
SELECT * FROM HR.LOCATIONS;

SELECT* FROM customer2;
SELECT* FROM vendors2;
SELECT* FROM employees_table;
SELECT* FROM separepart_table;
SELECT* FROM purchase_table;
SELECT* FROM ser_det_table;

--Inner Join
SELECT * FROM t1 INNER JOIN t2 ON t1.id = t2.id;

SELECT * FROM t1, t2 WHERE t1.id = t2.id;

-- get department name
SELECT * FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id;

-- Left Join
SELECT * FROM t1, t2 WHERE t1.id = t2.id(+);

SELECT * FROM t1 LEFT JOIN t2 ON t1.id = t2.id;

-- find customers who are not serviced
SELECT c.cname FROM customer2 c
LEFT JOIN ser_det_table s ON c.cid = s.cid
MINUS
SELECT c.cname FROM customer2 c
INNER JOIN ser_det_table s ON c.cid = s.cid;

-- Right Join
SELECT * FROM t1, t2 WHERE t1.id(+) = t2.id;

SELECT * FROM t1 RIGHT JOIN t2 ON t1.id = t2.id;

-- Self Join
-- below query is for who is the manager of whom
SELECT a.first_name as employee, a.manager_id, b.First_name as manager
FROM hr.employees a, hr.employees b 
WHERE a.manager_id = b.employee_id
ORDER BY b.employee_id;

-- Natural Join
SELECT employees.employee_id, employees.first_name, departments.department_name
FROM hr.employees
NATURAL JOIN hr.departments;

-- Full Join
SELECT e.employee_id, e.first_name, d.department_name
FROM hr.employees e
FULL JOIN hr.departments d ON e.department_id = d.department_id;

-- Non-Equi Join ???meaning????
select distinct a.first_name,a.salary from emp a, emp b 
where a.salary=b.salary and a.first_name!=b.first_name;

SELECT e.employee_id, e.first_name, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id <> d.department_id;

-- Cross Join ???meaning????
SELECT e.employee_id, e.first_name, d.department_name
FROM hr.employees e
CROSS JOIN hr.departments d;

-- Cartisian Join ???meaning????
SELECT e.employee_id, e.first_name, d.department_name
FROM hr.employees, hr.epartments;
--------------------------------------------------------------------------------------
--Self Join
--table
--ID  Name    MGRID
--1   a       2
--2   b       3
--3   c       null
--
--output
--EmpName     MgrName
--a           b
--b           c
--c           null
create table eg1(
id number(10),
name varchar(10),
mgrid number (10)
);

insert into eg1 values(1,'a',2);
insert into eg1 values(2,'b',3);
insert into eg1 values(3,'c',Null);

select * from eg1;

select b.name as empname, a.name as mgrname from eg1 a 
right outer join eg1 b 
on a.id=b.mgrid;

--------------------------------------------------------------------------------------
-- COUNT JOINS

-- Table 't1'
CREATE TABLE t1 (
    col NUMBER(10)
);

INSERT INTO t1 VALUES (1);
INSERT INTO t1 VALUES (1);
INSERT INTO t1 VALUES (NULL);

SELECT * FROM t1;

-- Table 't2'
CREATE TABLE t2 (
    col NUMBER(10)
);

INSERT INTO t2 VALUES (1);
INSERT INTO t2 VALUES (1);
INSERT INTO t2 VALUES (NULL);
INSERT INTO t2 VALUES (NULL);

SELECT * FROM t2;
SELECT * FROM t1;

-- Inner Join Count = 4
SELECT t1.col, t2.col FROM t1 INNER JOIN t2 ON t1.col = t2.col;

-- Left Outer Join Count = 5
SELECT t1.col, t2.col FROM t1 LEFT OUTER JOIN t2 ON t1.col = t2.col;

-- Right Outer Join Count = 6
SELECT t1.col, t2.col FROM t1 RIGHT OUTER JOIN t2 ON t1.col = t2.col;

-- Full Outer Join Count = 7
SELECT t1.col, t2.col FROM t1 FULL OUTER JOIN t2 ON t1.col = t2.col;

--------------------------------------------------------------------------------------
**NUMBER FUNCTION**
--------------------------------------------------------------------------------------

----- Q..
-- given input                      required output
--col1   col2  col3                 col
-- a     null  null                 a
--null   b     null                 b
--null   null  c                    c

-- Table 'tt3'
CREATE TABLE tt3 (
    col1 VARCHAR(10),
    col2 VARCHAR(10),
    col3 VARCHAR(10)
);

INSERT INTO tt3 VALUES ('a', '', '');
INSERT INTO tt3 VALUES ('', 'b', '');
INSERT INTO tt3 VALUES ('', '', 'c');

SELECT * FROM tt3;

-- COALESCE
SELECT COALESCE(col1, col2, col3) AS col FROM tt3;
SELECT COALESCE(NULL, NULL, 476.73, 455, NULL, -2, 3, 86, 35) FROM dual;

-- ABS
SELECT ABS(12.5) FROM dual;

-- SQRT
SELECT SQRT(4) FROM dual;

-- MOD
SELECT MOD(13, 5) FROM dual;

-- REMAINDER
SELECT REMAINDER(13, 5) FROM dual;
SELECT REMAINDER(12, 7) FROM dual;

-- CEIL
SELECT CEIL(4.4) FROM dual;

-- FLOOR
SELECT FLOOR(4.9) FROM dual;

-- ROUND
SELECT ROUND(476.73455, -2) FROM dual;
SELECT ROUND(476.73455, 2) FROM dual;
SELECT ROUND(-191.6) FROM dual;
SELECT ROUND(12.53) FROM dual;
SELECT ROUND(45.923, 0), ROUND(45.923, 2), ROUND(454.923, -2) FROM dual;

-- TRUNC
SELECT TRUNC(476.3455, 2) FROM dual;
SELECT TRUNC(12.53) FROM dual;
SELECT TRUNC(45.923, 0), TRUNC(45.923, 2), TRUNC(492.923, -2) FROM dual;
-- trunc always gives the smaller value

-- GREATEST
SELECT GREATEST(476.73455, -2, 3, 86, 35) FROM dual;

-- LEAST
SELECT LEAST(476.73455, -2, 3, 86, 35) FROM dual;

--------------------------------------------------------------------------------------

-- NVL
SELECT (NVL(col1, '') || NVL(col2, '') || NVL(col3, '')) AS col FROM tt3;

SELECT (salary+NVL(commission_pct,0)) "total salary" FROM hr.employees;
SELECT NVL(NULL,1) FROM Dual;
SELECT NVL(2,1) FROM Dual;
SELECT NVL(null,3) from dual;

--NVL2
SELECT NVL2(COMMISSION_PCT,3,1) FROM emp;
SELECT NVL2(NULL,1,2)"NVL2" FROM dual;
SELECT NVL2(1,2,3)"NVL2" FROM dual;
SELECT NVL2(1,NULL,3)"NVL2" FROM dual;
SELECT NVL2(1,2,NULL)"NVL2" FROM dual;
SELECT NVL2(NULL,2,NULL)"NVL2" FROM dual;

--nullif
SELECT NULLIF (1,2) from dual;

--------------------------------------------------------------------------------------
--decode
select decode(2,3,4,6,2,4,3,4,3) from dual;

select decode(1,2,3) from dual;

select decode(a,null,'sum',a) from t;

select decode(b,null,(select sum(b) from t),b) b) from t;

select decode(a,null,'sum',a) ,sum(b) from t group by decode(a,null,'sum',a) ;

select decode(a,null,'sum',a) from t;

select decode('gender','male','female','female','male') from HR.EMPLOYEES;

--------------------------------------------------------------------------------------
**STRING FUNCTION**
--------------------------------------------------------------------------------------
-- INITCAP
SELECT INITCAP('hrutUja') FROM dual;

-- UPPER
SELECT UPPER('hrutUja') FROM dual;

-- LOWER
SELECT LOWER('hrutUja') FROM dual;

-- LENGTH
SELECT LENGTH('hrutUja') FROM dual;

-- RPAD
SELECT RPAD('hrutUja', 15, '#') FROM dual;

-- LPAD
SELECT LPAD('hrutUja', 15, '#') FROM dual;

-- RTRIM
SELECT RTRIM('hrutUja') FROM dual;

-- TRANSLATE
SELECT TRANSLATE('hrutuja', 'ut', 'xz') FROM dual;

-- REPLACE
SELECT REPLACE('hrutuja', 'ut', 'xz')

--------------------------------------------------------------------------------------
**DATE FUNCTION**
--------------------------------------------------------------------------------------

-- sysdate
SELECT SYSDATE FROM dual;

-- current_date
SELECT CURRENT_DATE FROM dual;

-- to_date
SELECT TO_DATE(SYSDATE) FROM dual;

-- to_char
SELECT TO_CHAR(SYSDATE, 'DAY') FROM dual;

-- add_months
SELECT ADD_MONTHS(TO_DATE(SYSDATE, 'DD-MM-YYYY'), 3) FROM dual;

-- months_between
SELECT MONTHS_BETWEEN(TO_DATE('12-05-22', 'DD-MM-YYYY'), TO_DATE('12-02-22', 'DD-MM-YYYY')) AS date1 FROM dual;

-- next_day
SELECT NEXT_DAY(TO_DATE(SYSDATE, 'DD-MM-YYYY'), 'SUN') FROM dual;

-- last_day
SELECT LAST_DAY(TO_CHAR(TO_DATE('22-03-2022', 'DD-MM-YYYY'), 'SUN')) FROM dual;

-- convert date into number
SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMMDD')) AS num FROM dual;

-- convert number into word form
SELECT TO_CHAR(TO_DATE(1234, 'J'), 'JSP') FROM dual;

-- fetching odd dates from record
SELECT * FROM HR.EMPLOYEES WHERE MOD(TO_NUMBER(TO_CHAR(hire_date, 'DD')), 2) <> 0;

-- fetching even dates from record
SELECT * FROM emp WHERE MOD(TO_NUMBER(TO_CHAR(hire_date, 'DD')), 2) = 0;

-- find first day of year
SELECT TO_CHAR(TRUNC(SYSDATE, 'YEAR'), 'DAY') AS first_day FROM dual;

-- find first DATE of year
SELECT TRUNC(SYSDATE, 'YEAR') FROM dual;

-- find last day of year
SELECT TO_CHAR(ROUND(SYSDATE, 'YEAR') - 1, 'DAY') AS last_day FROM dual;

SELECT TO_CHAR(LAST_DAY(TO_DATE('01-01-23', 'DD-MM-YY')), 'DAY') FROM dual;

-- find number of months from birthdate
SELECT ROUND(MONTHS_BETWEEN(SYSDATE, TO_DATE('19-09-1996'))) AS "months" FROM dual;

-- find number of years from birthdate
SELECT TRUNC(TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE('19-09-1996')))/12) AS "year" FROM dual;

-- find number of days from birthdate
SELECT ROUND((SYSDATE - TO_DATE('19-09-1996'))) FROM dual;

-- find last day of month
SELECT TRUNC(TO_CHAR(LAST_DAY(SYSDATE, 'YEAR'))) FROM dual;

SELECT SYSDATE, TRUNC(SYSDATE, 'DAY') AS first_of_month FROM dual;

-- find employee who has completed above 20 years in the company
SELECT EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM hire_date) AS exp FROM emp WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM hire_date) > 20;

-- convert date into string
SELECT REPLACE(TO_CHAR(TO_DATE('11-09-2021', 'DD-MM-YYYY'), 'FMDdspth MONTH YEAR'), '-', ' ') AS spdt FROM dual;

SELECT REPLACE(TO_CHAR(SYSDATE, 'FMDdspth MONTH YEAR'), '-', ' ') AS spdt FROM dual;

SELECT TO_CHAR(TO_DATE('07-12-23', 'DD-MM-YY'), 'YEAR') FROM dual;

-- day
SELECT TO_CHAR(ROUND(SYSDATE, 'MM'), 'DAY') FROM dual;
SELECT * FROM emp;

-- create table tbl1
CREATE TABLE tbl1(gender VARCHAR(10));

-- insert into tbl1
INSERT INTO tbl1 VALUES ('M');
INSERT INTO tbl1 VALUES ('F');
INSERT INTO tbl1 VALUES ('S');
INSERT INTO tbl1 VALUES ('P');
INSERT INTO tbl1 VALUES ('M');
INSERT INTO tbl1 VALUES ('F');

-- select from tbl1
SELECT * FROM tbl1;

-- extract month from hire_date
SELECT hire_date, EXTRACT(MONTH FROM hire_date) FROM emp WHERE EXTRACT(MONTH FROM hire_date) = 2;

-- convert month to char
SELECT e.*, TO_CHAR(hire_date, 'MM') FROM emp e WHERE TO_CHAR(hire_date, 'MM') = 2;

-- last_day
SELECT LAST_DAY(TO_CHAR(hire_date, 'MM')) FROM emp e WHERE TO_CHAR(hire_date, 'MM') = 2;

-- months between
SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)/12) AS "Exp_years" FROM emp;
SELECT NEXT_DAY('13/APR/2020', 'THURSDAY') FROM dual;

------------------------
-- AGGREGATE FUNCTION 
------------------------
-- getting nulls at first from record
SELECT * FROM emp
ORDER BY commission_pct NULLS FIRST;

-- getting nulls at last from record
SELECT * FROM emp
ORDER BY commission_pct NULLS LAST;

-----------------------
-- ANALYTIC FUNCTION
-----------------------

-- lead
SELECT lead(salary, 1) OVER (ORDER BY salary) AS rn FROM HR.EMPLOYEES;

-- lag
SELECT salary, lag(salary, 1) OVER (ORDER BY salary) AS rn FROM hr.employees;

-- CTE with row_number
WITH CTE AS (
  SELECT id, city, row_number() OVER (PARTITION BY city ORDER BY id) AS duplicatecnt
  FROM info
)
SELECT * FROM CTE
WHERE duplicatecnt > 1;

-- rank
SELECT id, city, RANK() OVER (PARTITION BY city ORDER BY id) AS wf FROM info;

--------------------------------------------------------------------------------------
-- ANY & ALL

-- using IN
SELECT last_name, job_id, salary FROM emp 
WHERE salary IN (SELECT salary FROM emp WHERE department_id IN (90, 50));

-- < ANY, values < max value
SELECT employee_id, salary FROM emp 
WHERE salary < ANY (3000, 4000, 8000);

SELECT employee_id, salary, department_id FROM emp 
WHERE salary < ANY (SELECT salary FROM emp WHERE department_id = 20);

-- < ALL
SELECT employee_id, salary FROM emp 
WHERE salary < ALL (3000, 4000, 8000);

SELECT salary FROM emp WHERE salary > ALL (SELECT salary - 1 FROM emp);

--------------------------------------------------------------------------------------
-- COMPARISON OPERATOR
--------------------------------------------------------------------------------------

-- comparison op
SELECT * FROM emp
WHERE salary <= 20000;

-- between & not between
SELECT * FROM emp
WHERE salary BETWEEN 10000 AND 15000;

SELECT * FROM emp
WHERE employee_id NOT BETWEEN 100 AND 115;

SELECT * FROM (
  SELECT e.*, row_number() OVER (ORDER BY employee_id) AS rn FROM emp e
) WHERE rn BETWEEN 10 AND 20;

-- in & not in
SELECT * FROM emp
WHERE employee_id IN (100, 101);

SELECT * FROM emp
WHERE employee_id NOT IN (100, 101);

-- null, not null
SELECT * FROM emp
WHERE department_id IS NULL;

SELECT * FROM emp
WHERE department_id IS NOT NULL;

-- and
SELECT * FROM emp
WHERE employee_id = 100 AND first_name = 'Steven';

SELECT * FROM emp
WHERE employee_id = 100 OR employee_id = 110;

-- like
SELECT * FROM emp
WHERE first_name LIKE 'A%';

SELECT * FROM emp
WHERE first_name LIKE '%a';

SELECT * FROM emp
WHERE first_name LIKE '%p%';

SELECT * FROM emp
WHERE first_name LIKE 'A%a';

SELECT * FROM emp
WHERE first_name LIKE 'A_____%';

--------------------------------------------------------------------------------------
-- CASE
--------------------------------------------------------------------------------------
-- strings(null) compared
SELECT CASE 
         WHEN NULL IS NULL THEN '1' 
         ELSE '0' 
       END
FROM dual;

--------------------------------------------------------------------------------------
-- values of null at backend are compared
SELECT CASE 
         WHEN NULL=NULL THEN '1' 
         ELSE '0' 
       END
FROM dual;

--------------------------------------------------------------------------------------
SELECT CASE 
         WHEN commission_pct IS NULL THEN '1' 
         ELSE '0' 
       END
FROM emp;

--------------------------------------------------------------------------------------
-- count of gender using case
SELECT 
   COUNT(CASE WHEN gender='M' THEN 1 END) AS male_cnt,
   COUNT(CASE WHEN gender='F' THEN 1 END) AS female_cnt,
   COUNT(*) AS total_cnt
FROM employees;	

--------------------------------------------------------------------------------------
-- Example on CASE WHEN
SELECT 
   employee_id,
   salary,
   CASE 
      WHEN salary = 10000 THEN 'low'
      WHEN salary = 20000 THEN 'high'
      ELSE 'medium'
   END AS grade
FROM emp;

--------------------------------------------------------------------------------------
-- Example on CASE WHEN for grading students
CREATE TABLE stud (name VARCHAR(40), marks INT);

INSERT INTO stud VALUES ('Rahul Prabhakar Jondhale', 20);
INSERT INTO stud VALUES ('Rahul pawar', 53);
INSERT INTO stud VALUES ('peter james smith', 90);
INSERT INTO stud VALUES ('sachin ramesh tenulkar', 33);
INSERT INTO stud VALUES ('Rahul Prabhakar Jondhale', 25);
INSERT INTO stud VALUES ('Rahul Prabhakar Jondhale', 45);
INSERT INTO stud VALUES ('Rahul Prabhakar Jondhale', 60);

SELECT 
   name, 
   marks,
   CASE
      WHEN marks < 35 THEN 'fail'
      WHEN marks >= 35 AND marks < 40 THEN 'pass'
      WHEN marks >= 40 AND marks <= 60 THEN 'second class'
      WHEN marks > 60 THEN 'first_class'
   END AS grade
FROM stud;

--------------------------------------------------------------------------------------
--table 
--gender
--Male
--Female
--
--output
--gender      short
--Male        M
--Female      F
-- Create table and insert data
CREATE TABLE eg2 (
    gender VARCHAR(10)
);

INSERT INTO eg2 VALUES ('Male');
INSERT INTO eg2 VALUES ('Female');

SELECT * FROM eg2;

-- Case statement to convert gender to short form
SELECT 
    gender,
    CASE gender
        WHEN 'Male' THEN 'M'
        WHEN 'Female' THEN 'F'
    END AS short
FROM eg2;

--------------------------------------------------------------------------------------
-- SUBQUERY, INLINE QUERY, CORELATED QUERY
--------------------------------------------------------------------------------------
-- Using correlated subquery to fetch employees with salary greater than max(salary) per department
SELECT * 
FROM emp e1
WHERE salary > (SELECT MAX(salary) FROM emp e2 WHERE e2.department_id = e1.department_id);

-- Alternative query using count(distinct(salary))
SELECT * 
FROM emp a
WHERE 2 = (SELECT COUNT(DISTINCT salary) FROM emp b WHERE b.salary >= a.salary);

-- Fetch top 10% of employees
SELECT * 
FROM emp
WHERE ROWNUM <= (SELECT COUNT(*) FROM emp) * 10 / 100;

-- Alternative way to fetch top 10% of employees
SELECT * 
FROM emp 
WHERE ROWNUM <= (SELECT COUNT(*) * 0.1 FROM emp);

-- Using EXISTS to check if there are any departments
SELECT * 
FROM emp e 
WHERE EXISTS (SELECT * FROM depts d);

-- Using EXISTS to check if there are any corresponding departments
SELECT * 
FROM emp e 
WHERE EXISTS (SELECT * FROM dept d WHERE e.department_id = d.department_id);

-- Using NOT EXISTS to find records in tab1 that do not exist in tab2
SELECT * 
FROM tab1 
WHERE NOT EXISTS (SELECT * FROM tab2 WHERE tab1.c1 = tab2.c1);

-- Using NOT EXISTS to find departments without employees
SELECT * 
FROM dept 
WHERE NOT EXISTS (SELECT 1 FROM emp WHERE dept.department_id = emp.department_id);

-- Using NOT EXISTS to find employees without corresponding departments
SELECT * 
FROM emp 
WHERE NOT EXISTS (SELECT department_id FROM dept WHERE emp.department_id = dept.department_id);

-- Using EXISTS to find salespeople with corresponding customers
SELECT * 
FROM salespeople s 
WHERE EXISTS (SELECT c.snum FROM customers1 c WHERE s.snum = c.snum);


--------------------------------------------------------------------------------------
--INLINE QUERY
SELECT *
FROM (SELECT first_name FROM HR.EMPLOYEES ORDER BY first_name)
WHERE ROWNUM = 1;
--------------------------------------------------------------------------------------
-- SELECT first_name FROM HR.EMPLOYEES ORDER BY first_name WHERE ROWNUM = 1;
-- error because order by executes last 
-- WHERE executes before ORDER BY 

--------------------------------------------------------------------------------------
-- SET OPERATOR
--------------------------------------------------------------------------------------
-- Extract extra records from tb2
SELECT * FROM info
MINUS
SELECT * FROM demo;

-- Alter table to remove duplicate rows based on rowid
CREATE TABLE info_temp AS
SELECT * FROM info a
WHERE 3 = (SELECT COUNT(rowid) FROM info b
           WHERE a.rowid >= b.rowid);

-- Drop original table
DROP TABLE info;

-- Rename temp table to original table
ALTER TABLE info_temp RENAME TO info;

-- Set operators example
SELECT * FROM demo
UNION
SELECT * FROM info;

SELECT * FROM demo
UNION ALL
SELECT * FROM info;

SELECT * FROM demo
INTERSECT
SELECT * FROM info;

SELECT * FROM demo
MINUS
SELECT * FROM info;

-- Transpose table using set operators
SELECT col_1, col_2 FROM test3
UNION
SELECT col_1, col_3 FROM test3
ORDER BY col_1 DESC;

SELECT col_1, col_2 FROM test3
UNION
SELECT col_1, col_3 FROM test3;

--------------------------------------------------------------------------------------
-- CONNECT BY LEVEL 
--------------------------------------------------------------------------------------
SELECT LEVEL + 5
FROM dual
CONNECT BY LEVEL <= 9;

SELECT SUBSTR('rutuja', LEVEL, 1) AS result
FROM dual
CONNECT BY LEVEL <= LENGTH('rutuja');

SELECT LPAD(' ', LEVEL + 1, '*') AS pattern
FROM dual
CONNECT BY LEVEL <= 6;

SELECT REVERSE('vaibhav sontakke') AS rev FROM dual;

-- OR --

SELECT SUBSTR('vaibhav', LEVEL * -1, 1) AS rev
FROM dual
CONNECT BY LEVEL <= LENGTH('vaibhav');

-- OR --

SELECT SUBSTR(REVERSE('pallavi'), LEVEL, 1) AS result
FROM dual
CONNECT BY LEVEL <= LENGTH('pallavi');


SELECT REPLACE(123456, 4, 7) AS replaced_number FROM dual;


--------------------------------------------------------------------------------------
-- STAR PATTERN
--------------------------------------------------------------------------------------
--pattern
--*
--**
--***
--****
--*****
select lpad('*',level,'*') from dual connect by level <=5;
--------------------------------------------------------------------------------------
--*****
--****
--***
--**
--*

select lpad('*',5-level+1,'*') from dual connect by level <=5;

select lpad('VAIBHAV',level) from dual
connect by level <= length('VAIBHAV');

select lpad('WELCOME', length('WELCOME')-level+1) from dual 
connect by level<= length('WELCOME');
--------------------------------------------------------------------------------------
--    *
--   ** 
--  ***
-- ****
--*****

select lpad(' ',5-level,' ') || lpad('*',level,'*') pattern from dual
connect by level<=5;

--------------------------------------------------------------------------------------
**REGULAR EXP**
--------------------------------------------------------------------------------------
--count all charatcter instring

select char1,count(*) from 
(select regexp_substr('ananda','.',1,level) as char1 from dual 
connect by level <= length('ananda')) group by char1;

select char1,count(*) from 
(select regexp_substr('vaibhav','.',1,level) as char1 from dual
connect by level <= length('vaibhav')) group by char1;
--------------------------------------------------------------------------------------
--count selected charachter

select LENGTH('maharashtra') - length(replace('maharashtra','a')) as count_a,
length('maharashtra') - length(replace('maharashtra','h')) as count_h
from dual;

select regexp_count('maharashtra','a') as count_a,
regexp_count('maharashtra','h') as count_h from dual;
--------------------------------------------------------------------------------------
-- split your full name in to different columns

select trim(substr(name,1,instr(name,' ')-1)) f_name,
        trim(substr(name,instr(name,' ',1,1)+1, instr(name,' ',1,2)- instr(name,' ',1,1))) m_name,
        trim(substr(name,instr(name,' ',1,2)+1,length(name)-instr(name,' ',1,2))) l_name
        from stud;	
        
select regexp_substr(name,'[^ ]+',1,1) as f_name,
        regexp_substr(name,'[^ ]+',1,2) as m_name,
        regexp_substr(name,'[^ ]+',1,3) as l_name from stud;
        
select regexp_substr('vaibhav vasantrao sontakke','[^ ]+',1,1) f_name,
        regexp_substr('vaibhav vasantrao sontakke','[^ ]+',1,2) m_name,
        regexp_substr('vaibhav vasantrao sontakke','[^ ]+',1,3) l_name
        from dual;
    
--------------------------------------------------------------------------------------
**SENARIONS**
--------------------------------------------------------------------------------------

select '1'+1 from dual;

-- first record from a table
SELECT * FROM HR.EMPLOYEES
WHERE ROWNUM=1;

SELECT * FROM HR.EMPLOYEES
WHERE ROWNUM=2;  -- for anyother value except 1. it gives empty result set.
--------------------------------------------------------------------------------------
--find max salary 
Rank
rownum
row_number()

select max(salary) from emp;
corelated

select * from(select salary from emp order by salary desc)
where rownum = 1;

select * from (select salary,
                row_number() over (order by (salary) desc)r
                from emp)
                where r=1;

select * from(select salary,
                rank() over (order by salary desc)r
                from emp)
                where r =1;
--------------------------------------------------------------------------------------
--max salary without max and any window function
select * from emp                    
where salary > all (select salary-1 from emp);
--------------------------------------------------------------------------------------
--find nth highest salary
select * from (
        select e.*,
        dense_rank() over (order by salary desc)r
        from emp e)
        where r = 3;
        
select * from emp a 
where 2 = (select count(distinct(salary)) from emp b
        where b.salary>= a.salary);
        
select e.*,nth_value(salary,3) over(order by salary desc)as third_highest,
nth_value(salary,5) over(order by salary desc )as fifth_highest from emp e;
--------------------------------------------------------------------------------------
--maximum salary department wise
select max(salary), department_id from emp
group by department_id;
--------------------------------------------------------------------------------------
--Nth highest salary department wise
select salary, a.department_id from emp a 
where 2 = (select count(distinct(salary)) from emp b
        where b.salary>= a.salary
        and b.department_id=a.department_id);     
--------------------------------------------------------------------------------------
--find 2nd and 3rd highest salary
select * from(select distinct(salary) from emp order by salary desc) where rownum<=4
minus
select * from(select distinct(salary) from emp order by salary desc) where rownum<2;
--------------------------------------------------------------------------------------
--fetching first n records from table 

select * from emp
where rownum <= 5;

--by using analytical functions
select * from (
                select employee_id,first_name,last_name,salary,
                row_number() over (order by employee_id)rn
                from emp)
                where rn<=5
                order by rn;
                
select * from (
                select * from emp)
                where rownum <= 10
                order by rownum;
--------------------------------------------------------------------------------------
--fetching last nth record from table
select * from (
                select * from emp
                order by employee_id desc)rn
                where rownum <=5
                order by rownum desc;  
select * from (
                select employee_id,first_name,last_name,
                row_number () over (order by employee_id desc)r
                from emp)
                where r<=5
                order by r desc;
                
SELECT * FROM HR.EMPLOYEES
WHERE ROWNUM >= 5; -- if we use greater than equal to then it gives null values

SELECT *
FROM (SELECT first_name FROM HR.EMPLOYEES ORDER BY first_name desc)
WHERE ROWNUM <= 5;

-- select 5th record from table
select * from comm where rownum <= 5
minus
select * from comm where rownum <=4;

SELECT ROWID FROM hr.employees;

--------------------------------------------------------------------------------------
--find record in range
select * from (
                select e.*,rownum rn from(
                select * from emp e
                order by employee_id)e
                where rownum <=20)
                where rn >=10;
                
--------------------------------------------------------------------------------------
--find exact middle record from table 
select * from emp 
where rownum <= (select case mod(count(1),2)
                when 0 then (count(1)/2) + 1
                else round(count(1)/2) 
                end from emp)
                minus
                select * from emp 
                where rownum < (select (count(1)/2) from emp);
                
select * from emp where rownum <=(select round(count(*)/2) from emp)
minus
select * from emp where rownum <>(select round(count(*)/2) from emp);
--------------------------------------------------------------------------------------
select * from (select e.* , rownum from emp e)
where rownum =(select round(count(*)/2) from emp);
--------------------------------------------------------------------------------------
--get first 50% record from table
select * from emp
where rownum <=(select count(*)/2 from emp);
--------------------------------------------------------------------------------------
--get last 50% record from table 
select * from (
                select * from emp order by rownum desc)
                where rownum <=(select count(*)/2 from emp);

select * from emp
minus
select * from emp
where rownum<= (select count(*)/2 from emp);

--------------------------------------------------------------------------------------
--how to fetch odd number of record
select * from (
                select employee_id, first_name,last_name, salary, rownum rn from emp 
                order by employee_id)
                where mod(rn,2)<>0;
--------------------------------------------------------------------------------------
--how to fetch even number of record from table 
select * from (
                select employee_id,first_name,last_name, rownum rn from emp
                order by employee_id)
                where mod(rn,2)=0;
--------------------------------------------------------------------------------------
create table testing(
a_id number(10),
salary number(10)
);

insert into testing values(1,1000);
insert into testing values(3,4000);
insert into testing values(2,2000);
insert into testing values(1,1000);
insert into testing values(4,12000);
insert into testing values(5,11000);
insert into testing values(1,1000);
insert into testing values(2,2000);

select * from testing;
--------------------------------------------------------------------------------------
--Finding duplicate records
select a_id,salary,count(*) from testing
group by a_id,salary
having count(*)>1;

select t.*, count(*) over (partition by a_id,salary) c
from testing t;

select * from(
select t.*,
        count(*) over (partition by a_id, salary) c
        from testing t)
        where c > 1;
--------------------------------------------------------------------------------------
--deleting duplicate record
select * from testing;

delete from testing 
where rowid not in (
                    select min(rowid) from testing
                    group by a_id,salary);
                    
delete from testing 
where rowid not in (
                    select max(rowid) from testing
                    group by a_id,salary);

rollback;
--------------------------------------------------------------------------------------
----- Q..
-- given input                      required output
--col1   col2  col3                 col1  col2  col3
-- a     null  null                  a     b     c
--null   b     null                 
--null   null  c                    

select * from tt3;

select max(col1) as col1 ,max(col2) as col2, max(col3) as col3 from tt3;
--------------------------------------------------------------------------------------
--table 
--eid     city
--1       pune
--2       mumbai
--3       mumbai
--4       mumbai
--5       pune
--6       pune
--7       pune
--
--output
--
--pune        mumbai
--4           3

select * from adds
pivot (count(eid) for city in ('pune' , 'mumbai'));

select sum(regexp_count(city,'pune')) pune ,sum(regexp_count(city,'mumbai')) mumbai from adds;

select count(eid) as ed, city from adds
group by city;
--------------------------------------------------------------------------------------

create table adds(
Eid number(10),
city varchar(20)
);

insert into adds values(1,'pune');
insert into adds values(2,'mumbai');
insert into adds values(2,'mumbai');
insert into adds values(3,'mumbai');
insert into adds values(4,'mumbai');
insert into adds values(5,'pune');
insert into adds values(6,'pune');
insert into adds values(7,'pune');


select * from adds;
--------------------------------------------------------------------------------------
truncate table adds;
--------------------------------------------------------------------------------------
--deleting duplicate record from tabel 

delete from adds
where rowid not in(select min(rowid) from adds
group by Eid,city);
--------------------------------------------------------------------------------------
--how to delete nth record from table 

delete from adds a
where 4 = (select count(rowid) from adds b
where a.rowid >= b.rowid);

delete from adds
where rowid = (
select rowid FROM adds
where rownum <=4
minus
select rowid FROM adds
where rownum < 4);

select * from adds;
--------------------------------------------------------------------------------------
create table comm (cid int, ccomm decimal(10) ,cdate date);

insert into comm values (100,1000,to_date('01-12-2022','dd-mm-yyyy'));
insert into comm values (200,5000,to_date('02-12-2022','dd-mm-yyyy'));
insert into comm values (300,6000,to_date('02-12-2022','dd-mm-yyyy'));
insert into comm values (400,2000,to_date('13-12-2022','dd-mm-yyyy'));
insert into comm values (500,1000,to_date('01-12-2022','dd-mm-yyyy'));
insert into comm values (800,5000,to_date('02-12-2022','dd-mm-yyyy'));
insert into comm values (900,6000,to_date('02-12-2022','dd-mm-yyyy'));
insert into comm values (700,2000,to_date('13-12-2022','dd-mm-yyyy'));


create table premium (pid int, pcomm decimal(10) ,pdate date);

insert into premium values (100,1000,to_date('01-12-2022','dd-mm-yyyy'));
insert into premium values (500,200,to_date('02-12-2022','dd-mm-yyyy'));
insert into premium values (600,3000,to_date('06-12-2022','dd-mm-yyyy'));
insert into premium values (300,8000,to_date('13-12-2022','dd-mm-yyyy'));

select * from comm;

select * from premium;
--------------------------------------------------------------------------------------
--- find permium and comm which is on 02-12-2022

select sum(p.pcomm) from comm c
inner join premium p
on c.cdate=p.pdate
where p.pdate = '02-12-22';

select sum(pcomm)+sum(ccomm) from premium p
inner join comm c
on p.pdate=c.cdate
where pdate= '02-12-22';

select sum(ccomm) from 
(select * from comm
union all
select * from premium)where cdate ='02-12-22';


with tb10 as
 (select * from comm union all select * from premium)
select sum(ccomm)
  from tb10
 where to_char(cdate, 'dd-mm-yyyy') = '02-12-2022';
--------------------------------------------------------------------------------------
--input
--col1
--a
--a
--a
--b
--b
--b
--b
--
--o/p
--col1
--3
--4
create table t10 (
col_1 varchar (10));

insert into t10 values('a');

insert into t10 values('b');

select * from t10;

select sum(regexp_count(col_1,'a')) count_a ,sum(regexp_count(col_1,'b')) count_b from t10;

select char1,count(*) from 
(select regexp_substr('vaibhav','.',1,level) as char1 from dual
connect by level <= length('vaibhav')) group by char1;

--Que1:How to select UNIQUE records from a table using a SQL Query?

select distinct employee_id from emp;
---
select employee_id from emp 
group by employee_id
having count(employee_id)=1;
---
SELECT employee_id, COUNT(*)   FROM emp
GROUP BY employee_id;
---
SELECT employee_id,first_name
FROM (
    SELECT employee_id,first_name, ROW_NUMBER() OVER (PARTITION BY employee_id
    ORDER BY employee_id) as row_num
    FROM emp ) 
WHERE row_num = 1;
----
select * from customers;
SELECT cnum,snum
FROM (
SELECT snum,cnum, ROW_NUMBER() OVER (PARTITION BY cnum
ORDER BY cnum) as row_num
FROM customers ) 
WHERE row_num = 1;
---
WITH CTE AS (
    SELECT column1, column2, ROW_NUMBER() OVER (PARTITION BY column1, column2 ORDER BY column1) as row_num
    FROM your_table
)
SELECT column1, column2
FROM CTE
WHERE row_num = 1;
--------------------------------------------------------------------------------------
--QUE2:How to delete DUPLICATE records from a table using a SQL Query?

select * from testing;

delete from testing
where rowid not in(select min(rowid) from testing 
group by A_ID,salary);
rollback;
---
WITH Duplicates AS (
    SELECT column1, column2, COUNT(*) AS count
    FROM your_table
    GROUP BY column1, column2
    HAVING COUNT(*) > 1
)
DELETE FROM your_table
WHERE (column1, column2) IN (SELECT column1, column2 FROM Duplicates);

-----
DELETE FROM your_table
WHERE (column1, column2) IN (
    SELECT column1, column2
    FROM your_table
    GROUP BY column1, column2
    HAVING COUNT(*) > 1
);
---
DELETE FROM emp
WHERE (employee_id) IN (
select * from(
select e.*,row_number() over (partition by employee_id order by employee_id)rn
from emp e)
where rn>1);
---
delete from emp where rowid in 
(select  r from 
(select rowid r ,row_number() over 
(partition by employee_id order by employee_id) r1
from emp) 
where r1<1);
---
DELETE t1 FROM emp t1 INNER JOIN emp t2 
ON t1.employee_id = t2.employee_id 
WHERE t1.employee_id > t2.employee_id;
--------------------------------------------------------------------------------------
--Qwe 6:give example on merge statement?

SELECT column_name AS new_name
FROM table_name;
--------------------------------------------------------------------------------------
--qwe 13:a null null
--null b null
--null null c
--op:a
--b
--c

create table sabc(c1 varchar(10) ,c2 varchar(10),c3 varchar(10));

insert into sabc values('a',null,null);
insert into sabc values(null,'b',null);
insert into sabc values(null,null,'c');

select * from sabc;

select coalesce(c1,c2,c3)a from sabc;
--------------------------------------------------------------------------------------
--listagg
select * from abpq;
select sno,listagg(snm,',') within group (order by sno )  from abpq group by sno;

--------------------------------------------------------------------------------------
--Qwe 14:same as 13
--op:a b c
with ru as
(select coalesce(c1,c2,c3)a from sabc )
select listagg(a,'')within group (order by a) as op from ru;

CREATE TABLE q10 (a number,b number,c number);

insert into q10 values (10,20,30);
insert into q10 values (40,50,60);
insert into q10 values (70,80,90);

select * from q10;

select least(min(a),min(b),min(c)) as min1,
greatest(max(a),max(b),max(c)) as max1 from q10;

--------------------------------------------------------------------------------------
--qwe 8:Suppose a Student column has two columns, Name and Marks. 
--How to get names and marks of the top three students??

select * from(
select * from students
order by marks desc)
where rownum>4;

select * from(
select  s.*, dense_rank() over (order by marks desc)rn
from student s)
where rn = 1 or rn = 2 or rn = 3;

select * from(
select  e.*, rank() over (order by salary desc)rn
from emp e )
where rn = 1 ;or rn = 2 or rn = 3;
--------------------------------------------------------------------------------------
--qwe 16:write a SQL query to find employees with same salary

select * from emp where salary in(
select count(*) from emp 
group by salary 
having count(*) > 1);

select e.*,dense_rank();

SELECT e.* FROM emp e
WHERE salary IN (
    SELECT salary FROM emp
    GROUP BY salary
    HAVING COUNT(*) > 1
);
----
SELECT e1.* FROM emp e1 JOIN emp e2 ON e1.salary = e2.salary 
AND e1.employee_id <> e2.employee_id
ORDER BY e1.salary, e1.employee_id;
----
--------------------------------------------------------------------------------------
--qwe17: Write a SQL query to fetch departments along with the total salaries
--paid for each of them??

select sum(salary),department_id from emp 
group by department_id;

---
SELECT d.department_name,
       (SELECT SUM(salary) FROM emp e WHERE e.department_id = d.department_id) AS total_salary
FROM hr.departments d;
---
select distinct d.department_name ,
sum(salary) over (partition by e.department_id order by salary ) as rn
from emp e
JOIN hr.departments d ON e.department_id = d.department_id;
--------------------------------------------------------------------------------------
--qwe 18:Write a SQL query to show all departments along with the number of people working there.

select department_id,count(*) from emp 
group by department_id;
--------------------------------------------------------------------------------------
--factorial in sql
--------------------------------
with cte (num,fact) as (
select 1,1 from dual
union all
select num+1,(num+1)*fact from cte
where num<=5
)
select * from cte
where num<=5;
------------------------
select trunc(exp(sum(ln(level)))) as fact from dual connect by level <=5;

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
**VIEW**
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--simple view
CREATE VIEW EMP1 as select *  from emp where department_id =50;

create view view_new as (select * from  salesman where city =' New York');

create view view_new as (select salesperson ID, name, and city from  salesman );

create view view_new as (select count(customer_id) from  salesman group by grade );
--------------------------------------------------------------------------------------
--complex view
create view view_new as (select o.order date, s.salesman_ID, s.name from salesman s,orders o
where s.salesman_ID=o.salesman_ID  and purch_amt =max(purch_amt) from orders c where c.ord_date=o.ord_date;)
--------------------------------------------------------------------------------------
--materialized view
create materialized view select * from emp where department_id =60; 
select mod(employee_id,2) from emp

--------------------------------------------------------------------------------------


