select * from v$version;
--------------------------------------------------------------------------------------
**DDL** & DML;-----------------------
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
--------------------------------------------------------------------------------------
--select
SELECT * FROM PERSONS12;
--------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------
--ROLLBACK
ROLLBACK;  -- undo the changes
--------------------------------------------------------------------------------------
-- Delete records where the city is 'Mumbai'
DELETE FROM PERSONS12
WHERE city = 'mumbai';
--------------------------------------------------------------------------------------
-- create savepoint
SAVEPOINT my_savepoint_1; -- have to run this 
--------------------------------------------------------------------------------------
-- update
UPDATE PERSONS12
SET city = 'Banglore'
WHERE city = 'New York';
--------------------------------------------------------------------------------------
-- use savepoint
ROLLBACK TO SAVEPOINT my_savepoint_1;
--------------------------------------------------------------------------------------
-- create new table
CREATE TABLE PERSONS21
(
    id INT
);

SELECT * FROM PERSONS21;
--------------------------------------------------------------------------------------
INSERT INTO PERSONS21 VALUES (1);
INSERT INTO PERSONS21(id) VALUES (1);
INSERT INTO PERSONS21 VALUES (1);
INSERT INTO PERSONS21 VALUES (1);
--------------------------------------------------------------------------------------
-- truncate
TRUNCATE TABLE PERSONS21;
--------------------------------------------------------------------------------------
--drop 
DROP TABLE PERSONS21;
--------------------------------------------------------------------------------------
-- Length for char, varchar
SELECT length(lastname), length(firstname) FROM PERSONS12;
--------------------------------------------------------------------------------------
-- change constraint
ALTER TABLE PERSONS12
MODIFY city DEFAULT 'mumbai';
--------------------------------------------------------------------------------------
INSERT INTO PERSONS12(id, lastname, firstname, age, dob) 
VALUES (5, 'Jones', 'Daniel', 35, TO_DATE('20-11-1986', 'DD-MM-YYYY'));
--------------------------------------------------------------------------------------
-- change constraint
ALTER TABLE PERSONS12
MODIFY city UNIQUE;  -- here if dublicate values are present then we cannot apply this constraint
--------------------------------------------------------------------------------------
-- change datatype
ALTER TABLE PERSONS12
MODIFY city CHAR(20);
--------------------------------------------------------------------------------------
-- Add column to existing table
ALTER TABLE PERSONS12
add EMP_ID NUMBER;
--------------------------------------------------------------------------------------
-- Drop column from existing table
ALTER TABLE emp1234
DROP COLUMN emp_id;
--------------------------------------------------------------------------------------
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
----------------------------------------------------------------------------------
-- Create source table
CREATE TABLE source_table (
    id INT PRIMARY KEY,
    value VARCHAR(50)
);
--------------------------------------------------------------------------------------
-- Insert some data into source table
INSERT INTO source_table (id, value)
VALUES (1, 'Value1');
INSERT INTO source_table (id, value)
VALUES (2, 'Value2');
INSERT INTO source_table (id, value)
VALUES (3, 'Value3');
--------------------------------------------------------------------------------------
-- Create target table
CREATE TABLE target_table (
    id INT PRIMARY KEY,
    value VARCHAR(50)
);
--------------------------------------------------------------------------------------
-- Insert some initial data into target table
INSERT INTO target_table (id, value)
VALUES (1, 'InitialValue1');
INSERT INTO target_table (id, value)
VALUES (2, 'InitialValue2');
--------------------------------------------------------------------------------------
SELECT * FROM target_table;
SELECT * FROM source_table;
--------------------------------------------------------------------------------------
--how to check constraint is present or not
select * from user_constraints
where table_name = 'SALESPEOPLE';
--------------------------------------------------------------------------------------
-- Use MERGE statement to synchronize data
MERGE INTO target_table t
USING source_table s
ON (t.id = s.id)
WHEN MATCHED THEN
    UPDATE SET t.value = s.value
WHEN NOT MATCHED THEN
    INSERT (id, value) VALUES (s.id, s.value);
--------------------------------------------------------------------------------------    
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
--------------------------------------------------------------------------------------
--Inner Join
SELECT * FROM t1 INNER JOIN t2 ON t1.id = t2.id;

SELECT * FROM t1, t2 WHERE t1.id = t2.id;
--------------------------------------------------------------------------------------
-- get department name
SELECT * FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id;
--------------------------------------------------------------------------------------
-- Left Join
SELECT * FROM t1, t2 WHERE t1.id = t2.id(+);

SELECT * FROM t1 LEFT JOIN t2 ON t1.id = t2.id;
--------------------------------------------------------------------------------------
-- find customers who are not serviced

SELECT c.cname FROM customer2 c
LEFT JOIN ser_det_table s ON c.cid = s.cid
MINUS
SELECT c.cname FROM customer2 c
INNER JOIN ser_det_table s ON c.cid = s.cid;
--------------------------------------------------------------------------------------
-- Right Join
SELECT * FROM t1, t2 WHERE t1.id(+) = t2.id;

SELECT * FROM t1 RIGHT JOIN t2 ON t1.id = t2.id;
--------------------------------------------------------------------------------------
-- Self Join
-- below query is for who is the manager of whom
SELECT a.first_name as employee, a.manager_id, b.First_name as manager
FROM hr.employees a, hr.employees b 
WHERE a.manager_id = b.employee_id
ORDER BY b.employee_id;
--------------------------------------------------------------------------------------
-- Natural Join
SELECT employees.employee_id, employees.first_name, departments.department_name
FROM hr.employees
NATURAL JOIN hr.departments;
--------------------------------------------------------------------------------------
-- Full Join
SELECT e.employee_id, e.first_name, d.department_name
FROM hr.employees e
FULL JOIN hr.departments d ON e.department_id = d.department_id;
--------------------------------------------------------------------------------------
-- Non-Equi Join ???meaning????
select distinct a.first_name,a.salary from emp a, emp b 
where a.salary=b.salary and a.first_name!=b.first_name;

SELECT e.employee_id, e.first_name, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id <> d.department_id;
--------------------------------------------------------------------------------------
-- Cross Join ???meaning????
SELECT e.employee_id, e.first_name, d.department_name
FROM hr.employees e
CROSS JOIN hr.departments d;
--------------------------------------------------------------------------------------
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
--count joins
create table t1(
col number(10));

insert into t1 values(1);
insert into t1 values(1);
insert into t1 values(Null);

select * from t1;
--------------------------------------------------------------------------------------
create table t2(
col number(10));

insert into t2 values(1);
insert into t2 values(1);
insert into t2 values(Null);
insert into t2 values(Null);

select * from t2;
select count(1) from emp;
--------------------------------------------------------------------------------------
--inner join count = 4
select t1.col, t2.col from t1 inner join t2 on t1.col=t2.col;
--------------------------------------------------------------------------------------
--left outer join count = 5
select t1.col, t2.col from t1 left outer join t2 on t1.col=t2.col;
--------------------------------------------------------------------------------------
--right outer join count = 6
select t1.col,t2.col from t1 right outer join t2 on t1.col=t2.col;
--------------------------------------------------------------------------------------
--full outer join coount = 7
select t1.col,t2.col from t1 full outer join t2 on t1.col=t2.col;

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
**NUMBER FUNCTION**
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
----- Q..
-- given input                      required output
--col1   col2  col3                 col
-- a     null  null                 a
--null   b     null                 b
--null   null  c                    c

create table tt3( col1 varchar(10),col2 varchar(10),col3 varchar(10) );

insert into tt3 values ('a','','');
insert into tt3 values ('','b','');
insert into tt3 values ('','','c');

select * from tt3;
--------------------------------------------------------------------------------------
--abs
select abs(12.5) from dual;
--------------------------------------------------------------------------------------
--sqrt
select sqrt(4) from dual;
--------------------------------------------------------------------------------------
--mod
select mod(13,5) from dual;
select mod(12,7) from dual;
--------------------------------------------------------------------------------------
--rem
select remainder(13,5) from dual;
select remainder(12,7) from dual;
--------------------------------------------------------------------------------------
--ceil
select ceil(4.4) from dual;
--------------------------------------------------------------------------------------
--floor
select floor(4.9) from dual;
--------------------------------------------------------------------------------------
--round
select round(476.73455,-2) from dual;
select round(476.73455,-2) from dual;
select round(-191.6) from dual;
select round(12.53) from dual;
SELECT Round(45.923,0),Round(45.923,2),Round(454.923,-2)
From dual;
--------------------------------------------------------------------------------------
--trunc
select trunc(476.3455,2) from dual;
select trunc(12.53) from dual;
SELECT Trunc(45.923,0),Trunc(45.923,2),trunc(492.923,-2 )
From dual;
--------------------------------------------------------------------------------------
--greatest
select greatest(476.73455,-2,3,86,35) from dual;
--------------------------------------------------------------------------------------
--least
select least(476.73455,-2,3,86,35) from dual;
--------------------------------------------------------------------------------------
--coalesce
select coalesce(col1,col2,col3) col from tt3;
select coalesce(null,null,476.73,455,null,-2,3,86,35) from dual;
--------------------------------------------------------------------------------------
--nvl
select (nvl(col1,'')||nvl(col2,'')||nvl(col3,'')) col from tt3;

SELECT (salary+NVL(commission_pct,0)) "total salary" FROM hr.employees;
SELECT NVL(NULL,1) FROM Dual;
SELECT NVL(2,1) FROM Dual;
select nvl(null,3) from dual;

--------------------------------------------------------------------------------------
--NVL2
select nvl2(COMMISSION_PCT,3,1) from emp;
SELECT NVL2(NULL,1,2)"NVL2" FROM dual;
SELECT NVL2(1,2,3)"NVL2" FROM dual;
SELECT NVL2(1,NULL,3)"NVL2" FROM dual;
SELECT NVL2(1,2,NULL)"NVL2" FROM dual;
--------------------------------------------------------------------------------------
--nullif
select nullif (1,2) from dual;
--------------------------------------------------------------------------------------
--decode
select decode(2,3,4,6,2,4,3,4,3) from dual;

select decode(1,2,3) from dual;

select decode(a,null,'sum',a) from t;

select decode(b,null,(select sum(b) from t),b) b) from t;

select decode(a,null,'sum',a) ,sum(b) from t group by decode(a,null,'sum',a) ;

select decode(a,null,'sum',a) from t;

select decode('gender','male','female','female','male') from emp;

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
**STRING FUNCTION**
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--initcap
select initcap('hrutUja') from dual;
--------------------------------------------------------------------------------------
--upper
select upper('hrutUja') from dual;
--------------------------------------------------------------------------------------
--lower
select lower('hrutUja') from dual;
--------------------------------------------------------------------------------------
--length
select length('hrutUja') from dual;
--------------------------------------------------------------------------------------
--rpad
select rpad('hrutUja',15,'#') from dual;
--------------------------------------------------------------------------------------
--lpad
select lpad('hrutUja',15,'#') from dual;
--rtrim
select rtrim(   'hrutUja'   ) from dual;
--translate
select translate('hrutuja','ut','xz') from dual;
--------------------------------------------------------------------------------------
--replace
select replace('hrutuja','ut','xz') from dual;
--------------------------------------------------------------------------------------
--concat
select concat('hrutuja','belge') from dual;

select ('hrutuja'||''||'belge'||''||'ss') from dual;
--------------------------------------------------------------------------------------
--substr
select substr('hrutuja',2,4) from dual;
--------------------------------------------------------------------------------------
--instr
select instr('hrutuja','u',1,1) from dual;
--------------------------------------------------------------------------------------
--substr & instr

select instr('hrutuja','u',0,0) from dual;

select instr('hrutuja','u',3,1) from dual;

select substr('H_Rutuja_B',1,instr('H_Rutuja_B','_',1,1)) as c1,
substr('H_Rutuja_B',instr('H_Rutuja_B','_',1,1)+1,instr('H_Rutuja_B','_',1,2)-instr('H_Rutuja_B','_',1,1)) as c2,
substr('H_Rutuja_B',instr('H_Rutuja_B','_',-1,1)+1) as c3 from dual;
--------------------------------------------------------------------------------------
-- find length of string

select length('vaibhav') from dual;

select count(substr('vaibhav',level,1)) from dual
connect by level<=10;
--------------------------------------------------------------------------------------
--count u
select length('rutuja')-length(replace('rutuja','u',''))count_u from dual;
--------------------------------------------------------------------------------------
--transalte and replace
select translate('hrutuja','aeiouAEIOU',' ') from dual;

select translate('adani','d','xyz') from dual;

select replace('adani','d','xyz') from dual;
--------------------------------------------------------------------------------------
--Qwe 11:separete name and surname from your name??

select substr('rutuja belge',1,instr('rutuja belge',' ',1,1)) name1,
substr('rutuja belge',instr('rutuja belge',' ',1,1)) sur_name from dual;
--------------------------------------------------------------------------------------
--how to add '*' after and before the string

select lpad('RUTUJA',length('RUTUJA')+3,'*') from dual;

select rpad('RUTUJA',length('RUTUJA')+3,'*') from dual;
--------------------------------------------------------------------------------------
--get @gmail.com from email

select substr('rutujabelge1234@gmail.com', -length('@gmail.com')) from dual;
--------------------------------------------------------------------------------------
--get domain from email address (in this vaibhavsontakke is domain)

select substr('rutujabelge1234@gmail.com',1,instr('rutujabelge1234@gmail.com','@')-1)
from dual;
--------------------------------------------------------------------------------------
--put M insted of F and F instead of M

select translate(gender,'MF','FM') from tbl1;
--------------------------------------------------------------------------------------
select decode(gender,'M','F','M') from tbl1;

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
**DATE FUNCTION**
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--sysdate
select sysdate from dual;
--------------------------------------------------------------------------------------
--current_date
select current_date from dual;
--------------------------------------------------------------------------------------

select to_date(sysdate) from dual;

select to_char(sysdate,'day') from dual;
--------------------------------------------------------------------------------------
--add months
select add_months(to_date(sysdate,'dd-mm-yyyy'),3) from dual;
--------------------------------------------------------------------------------------
--months_between
select months_between(to_date('12-5-22','dd-mm-yyyy'),to_date('12-2-22','dd-mm-yyyy')) as date1 from dual;
--------------------------------------------------------------------------------------
--next_day
select next_day(to_date(sysdate,'dd-mm-yyyy'),'sun') from dual;
--------------------------------------------------------------------------------------
--last_day
select last_day(to_char(to_date('22-03-2022','dd-mm-yyyy'),'sun')) from dual;
--------------------------------------------------------------------------------------

--how to convert date into number
select to_number(to_char(sysdate,'yyyymmdd')) num from dual;
--------------------------------------------------------------------------------------
--how to conert number into word form
select to_char(to_date(1234,'j'),'JSP') from dual;
--------------------------------------------------------------------------------------
--fetching odd dates from record
select * from emp
where mod(to_number(to_char(hire_date,'dd')),2)<>0;
--------------------------------------------------------------------------------------
--fetching even dates from record
select * from emp
where mod(to_number(to_char(hire_date,'dd')),2)=0;
--------------------------------------------------------------------------------------
--find first day of year
select to_char(trunc(sysdate,'year'),'day') first_day from dual;
--------------------------------------------------------------------------------------
--find first DATE of year
select trunc(sysdate,'year') from dual;
--------------------------------------------------------------------------------------
--find last day of year
select to_char(round(sysdate,'year')-1,'day') last_day from dual;

select to_char(last_day(to_date('01-01-23','dd-mm-yy')),'day') from dual;
--------------------------------------------------------------------------------------
--find number of months from birthdate

select round(months_between(sysdate,'19-09-1996')) "months" from dual;
--------------------------------------------------------------------------------------
--find number of years from birthdate

select trunc(trunc(months_between(sysdate,'19-09-1996'))/12) "year" from dual;
--------------------------------------------------------------------------------------
--find number of days from birthdate

select round((sysdate - to_date('19-09-1996'))) from dual;
--------------------------------------------------------------------------------------
--find last day of month
select trunc(to_char(last_day(sysdate,'year'))) from dual;

select sysdate,trunc(sysdate,'day') first_of_month from dual;
--------------------------------------------------------------------------------------
--find employee who is completed above 20 years in comp. 
select extract(year from sysdate)-extract(year from hire_date) as exp from emp 
where extract(year from sysdate)-extract(year from hire_date)>20;
--------------------------------------------------------------------------------------    
--convert date into string
SELECT REPLACE (TO_CHAR (TO_DATE ('11-09-2021', 'dd-mm-yyyy'),'fmddspth month year'),'-',' ') spdt FROM DUAL;

SELECT REPLACE (TO_CHAR (sysdate,'FMDdspth Month Year'),'-',' ') spdt FROM DUAL;

select to_char(to_date('07-12-23','dd-mm-yy'),'year') from dual;

--------------------------------------------------------------------------------------
--day
select to_char(round(sysdate,'mm'),'day') from dual;
select * from emp;
--------------------------------------------------------------------------------------s
create table tbl1(gender varchar(10));

insert into tbl1 values ('M');
insert into tbl1 values ('F');
insert into tbl1 values ('S');
insert into tbl1 values ('P');
insert into tbl1 values ('M');
insert into tbl1 values ('F');

select * from tbl1;
--------------------------------------------------------------------------------------
select hire_date,extract(month from hire_date) from emp 
where extract(month from hire_date)=2;
--------------------------------------------------------------------------------------
select e.*,to_char(hire_date,'mm') from emp e 
where to_char(hire_date,'mm')=2;
--------------------------------------------------------------------------------------
select last_day(to_char(hire_date,'mm') )from emp e 
where to_char(hire_date,'mm')=2;
--------------------------------------------------------------------------------------
--months between
SELECT TRUNC(months_between(SYSDATE,hire_date)/12) "Exp_years"FROM emp;
SELECT next_day('13/apr/2020','Thursday') FROM dual;

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
**AGGREGATE FUNCTION**
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

--getting nulls at first from record
select * from emp
order by commission_pct nulls first;
--------------------------------------------------------------------------------------
--getting nulls at last from record
select * from emp
order by commission_pct nulls last;

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
**ANALYTIC FUNCTION**
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--lead
select lead(salary,1) over (order by salry) rn from emp;
SELECT salary,lag(salary, 1) OVER (ORDER BY salary) AS rn FROM emp;
--------------------------------------------------------------------------------------
with CTE
as (select id,city,row_number() over(partition by city order by id) as duplicatecnt from info)
select * from CTE
where duplicatecnt >1;
                    
select id, city, rank() over(partition by city order by id)as wf from info;

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
ANY & ALL
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

------using IN-----
select last_name,job_id,salary from emp 
where salary in(select salary from emp where department_id in(90,50));

----< any----all values < max value----------------------
select employee_id,salary from emp 
where salary<any(3000,4000,8000);

select employee_id,salary,department_id from emp 
where salary<any(select salary from emp where department_id=20);

-------< all---------
select employee_id,salary from emp 
where salary<all(3000,4000,8000);

select salary from emp where salary > all (select salary-1 from emp );
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
comparison operator
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--comparison op

select * from emp
where salary <= 20000;
--------------------------------------------------------------------------------------
--between & not between

select * from emp
where salary between 10000 and 15000;
--------------------------------------------------------------------------------------
select * from emp
where employee_id not between 100 and 115;
--------------------------------------------------------------------------------------
select * from 
(select e.* ,row_number() over (order by employee_id) rn from emp e)
where rn between 10 and 20;
--------------------------------------------------------------------------------------
--in not in

select * from emp
where employee_id in (100,101);
--------------------------------------------------------------------------------------
select * from emp
where employee_id not in (100,101);
--------------------------------------------------------------------------------------
--null,not null
select * from emp
where department_id is null; 
--------------------------------------------------------------------------------------
select * from emp
where department_id is not null; 
--------------------------------------------------------------------------------------
--and
select * from emp
where employee_id = 100 and first_name = 'Steven' ; 
--------------------------------------------------------------------------------------
select * from emp
where employee_id = 100 or employee_id = 110 ; 
--------------------------------------------------------------------------------------
--like
select * from emp
where first_name like 'A%'; 

select * from emp
where first_name like '%a'; 

select * from emp
where first_name like '%p%'; 

select * from emp
where first_name like 'A%a'; 

select * from emp
where first_name like 'A_____%'; 

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
**case**;
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

select case 
when null is null then '1' else'0'
end from dual;

--strings(null) compared-----------
--------------------------------------------------------------------------------------
select case 
when null=null then '1' else'0'
end from dual;
--values of null at backend are compared----
--------------------------------------------------------------------------------------
select case 
when commission_pct is null then '1' else'0'
end from emp;
--------------------------------------------------------------------------------------
--count of gender using case---------------
select 
   count(case when gender='M' then 1 end)as male_cnt,
   count(case when gender='F' then 1 end)as female_cnt,
   count(*) as total_cnt
from employees;	
--------------------------------------------------------------------------------------
--qwe 15:give example on case when ??

select employee_id,salary,
case 
when salary = 10000 then 'low'
when salary = 20000 then 'high'
else 'medium'
end as grade
from emp;
--------------------------------------------------------------------------------------
create table stud (name varchar(40), marks int);

insert into stud values ('Rahul Prabhakar Jondhale',20);
insert into stud values ('Rahul pawar',53);
insert into stud values ('peter james smith',90);
insert into stud values ('sachin ramesh tenulkar',33);
insert into stud values ('Rahul Prabhakar Jondhale',25);
insert into stud values ('Rahul Prabhakar Jondhale',45);
insert into stud values ('Rahul Prabhakar Jondhale',60);

select * from stud;

--- """ from stud table mark below 35 'fail', 35-40 'pass', 
----- 40-60 'secondclass' above 60 'firstclass' (using case) """

select name, marks,
case
    when marks<35 then 'fail'
        when marks >= 35 and marks < 40 then'pass'
            when marks >= 40 and marks <= 60 then 'second class'
                when marks > 60 then 'first_class'
                    end grade
                        from stud;
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

create table eg2 (
gender varchar(10));

insert into eg2 values('Male');
insert into eg2 values('Female');

select * from eg2;

select gender,
case gender
        when 'Male' then 'M'
        when 'Female' then 'F'
        end short
    from eg2;
    

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
**SUBQUERY, INLINE QUERY, CORELATED QUERY**
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

--CORELATED QUERY
--fetch the employees details who are having salary greater than max(salary) per department
-- using correlated subquery
select * from emp e1
where salary > (select avg(salary) from emp e2 where e2.department_id=e1.department_id);

select * from emp a where 2=(select count(distinct(salary)) from emp b 
where b.salary>=a.salary);

select * from emp
where rownum <= (select count(*) from emp) * 10/100;
select * from emp where rownum<=(select count(*)*0.1 from emp);
--------------------------------------------------------------------------------------
--exists
select * from emp e where exists (select * from depts d);
select * from emp e where exists (select * from dept d where e.department_id=d.department_id);
select * from tab1 where  not exists (select * from tab2 where tab1.c1=tab2.c1 );
SELECT * from dept where not exists (select 1 from emp where dept.department_id=emp.department_id);
select * from emp where not exists (select DEPARTMENT_ID from dept where emp.department_id=dept.department_id);
select * from salespeople s where  exists(select c.snum from customers1 c
where s.snum=c.snum);

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
--------------------------------------------------------------------------------------
**SET OPERATOR**;
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--- tb1 having 100 records & tb2 having 105 records how to extract extra records from tb2
select * from tbl1
minus 
select * from tbl;
--------------------------------------------------------------------------------------alter
create table demo(id int, name varchar(20));

create table info(id int, city varchar(20));

create table info_d(id int, city varchar(20),ddate date);

insert into demo values (1,'ravi');
insert into demo values (2,'madan');
insert into demo values (3,'peter');
insert into demo values (4,'sam');


insert into info values (1,'mumbai');
insert into info values (2,'ahmedabad');
insert into info values (5,'haidrabad');
insert into info values (6,'mumbai');
insert into info values (6,'mumbai');

delete FROM info a
WHERE 3 = (SELECT COUNT(rowid) from info b
WHERE a.rowid >= b.rowid);

select * from info;
insert into info_d values (1, 'mumbai', to_date('22-jul-2022','dd-mon-yyyy'));
insert into info_d values (2, 'ahmedabad', to_date('10-jul-2022','dd-mon-yyyy'));
insert into info_d values (5, 'haidrabad', to_date('08-jul-2021','dd-mon-yyyy'));
insert into info_d values (6, 'mumbai', to_date('22-aug-2022','dd-mon-yyyy'));

insert into info_d values (7, 'pune', to_date('20-jul-2022','dd-mon-yyyy'));
insert into info_d values (8, 'ahmedabad', to_date('10-sep-2022','dd-mon-yyyy'));
insert into info_d values (9, 'patna', to_date('28-jul-2021','dd-mon-yyyy'));
insert into info_d values (10, 'mumbai', to_date('12-jan-2022','dd-mon-yyyy'));

insert into info_d values (10, 'mumbai', to_date('12-jan-2022','dd-mon-yyyy'));

select * from demo;

select * from info;

select * from info_d;

--------SET OPERATORS------

select * from demo
union
select * from info;

select * from demo
union all
select * from info;

select * from demo
intersect
select * from info;

select * from demo
minus
select * from info;
--------------------------------------------------------------------------------------
--input
--col1    col2     col3
--A       B         C
--X       Y         Z
--1       2         3
--100     200       300
--P       Q         R

--output
--col1    col2
--X       Y
--X       Z
--P       Q
--P       R
--A       B
--A       C
--100     200
--100     300
--1       2
--1       3

CREATE TABLE test3(
col_1 varchar(10),
col_2 varchar(10),
col_3 varchar(10)
);

insert into test3 values('A','B','C');
insert into test3 values('X','Y','Z');
insert into test3 values('1','2','3');
insert into test3 values('100','200','300');
insert into test3 values('P','Q','R');

select * from test3;

--character first
select col_1, col_2 from test3
UNION
select col_1,col_3 from test3
order by col_1 desc;

--number first
select col_1, col_2 from test3
union
select col_1,col_3 from test3;

select * from test11;

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
CONNECT BY LEVEL 
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

select level+5
from dual
connect by level<=9;

--find row foramt of string

select substr('rutuja',level,1) from dual
connect by level<= length('rutuja');
--------------------------------------------------------------------------------------
select lpad(' ',level+1,'*')
from dual
connect by level<=6;
--------------------------------------------------------------------------------------
--reverse the given string

select reverse('vaibhav sontakke') rev from dual;

select substr('vaibhav',level *-1,1) rev from dual
connect by level <=length('vaibhav');

select substr(reverse('pallavi'),level,1) from dual
connect by level<= length('pallavi');

select replace(123456,4,7) from dual;

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
**STAR PATTERN**;
--------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------
**REGULAR EXP**
--------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------
**SENARIONS**
--------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
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


