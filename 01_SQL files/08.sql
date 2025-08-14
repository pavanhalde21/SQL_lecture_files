
-- CO-RELATED SUB QUERY 




-----------------------------------------------------------------------------------------
--12. find a list of all employees who are earning more than
--the avg salary of employees of the department
/*
SELECT * FROM HR.EMPLOYEES WHERE salary > (SELECT AVG(salary) FROM hr.employees group by department_id);
*/ -----error
---- we may solve this problem by using CO-RELATED SUB QUERY
-- use CO-RELATED SUB QUERY the least because it hampers the performance

SELECT round(avg(e2.salary)),e1.salary, (e1.first_name || ' '|| e1.last_name) as employee_details, d.department_id, department_name
FROM hr.employees e1 
inner join hr.departments d on e1.department_id = d.department_id 
inner join hr.employees e2 on e1.department_id = e2.department_id
group by e1.employee_id, e1.salary, (e1.first_name || ' '|| e1.last_name), d.department_id, department_name 
having e1.salary >= round(avg(e2.salary))
order by e1.salary;

-- CO-RELATED SUB QUERY 
SELECT a.employee_id, a.first_name, a.last_name, a.salary, a.department_id
FROM hr.employees a 
WHERE a.salary > (SELECT avg(b.salary) FROM hr.employees b 
                         WHERE a.department_id=b.department_id GROUP BY b.department_id)
ORDER BY a.department_id;

SELECT * FROM hr.EMPLOYEES A WHERE ROWID!=
(SELECT MAX(ROWID) FROM hr.EMPLOYEES B WHERE A.EMPLOYEE_ID = B.EMPLOYEE_ID);-- selects only dublicate records

select count(*) from hr.employees;

SELECT count(*) FROM hr.EMPLOYEES A WHERE ROWID!=
(SELECT MAX(ROWID) FROM hr.EMPLOYEES B); 

--is used to delete dublicate records. here there is no dublicate record, the query is just to understand


--deletes recent records
DELETE FROM EMPLOYEES A WHERE ROWID!=
(SELECT MAX(ROWID) FROM EMPLOYEES B WHERE A.EMPLOYEE_ID = B.EMPLOYEE_ID);


--deletes old record
DELETE FROM EMPLOYEES A WHERE ROWID!=
(SELECT MIN(ROWID) FROM EMPLOYEES B WHERE A.EMPLOYEE_ID = B.EMPLOYEE_ID);


delete from employees 
where rowid not in
(
select min(rowid) from employees group by eid, salary;
);


---------------------------

select a.* from hr.employees a 
where 2 = 
(select count(distinct(salary)) from hr.employees b where b.salary>=a.salary); -- second highest salary

select a.* from hr.employees a 
where 2 = 
(select count(distinct(salary)) from hr.employees b where b.salary>a.salary); -- third highest salary

select a.* from hr.employees a 
where 1 = 
(select count(distinct(salary)) from hr.employees b where b.salary>=a.salary); -- highest salary


SELECT * FROM EMPLOYEES
ROLLBACK
------------------------------------------------------------------------------------------------------------------
--no. of male and female
SELECT SUM(DECODE(sex,'male',1,0)) as no_of_males, SUM(DECODE(sex,'female',1,0)) as no_of_females  FROM CUSTOMER2

--INLINE QUERY
--SUB QUERY
SELECT MIN(SALARY) FROM (SELECT DISTINCT SALARY FROM HR.EMPLOYEES ORDER BY SALARY DESC)
WHERE ROWNUM<=2;

--inline query
SELECT * FROM(SELECT EMPLOYEE_ID, FIRST_NAME ||' '|| LAST_NAME, JOB_ID, SALARY,
ROW_NUMBER() OVER(ORDER BY SALARY DESC) rk
FROM HR.EMPLOYEES)
WHERE RK = 2;

--------------------------------------------------------------------------
--LEVEL
SELECT LEVEL FROM DUAL
CONNECT BY LEVEL <= 20;

--2 ka table
SELECT LEVEL*2 FROM DUAL
CONNECT BY LEVEL <= 10;

select substr("pavan", level, 1) from dual 
connect by level <= length("pavan"); -- error " " ---> ' '

SELECT SUBSTR('pavan', LEVEL, 1) AS Character
FROM dual
CONNECT BY LEVEL <= LENGTH('pavan');


select substr('pavan', level, 1)  from dual
connect by level <= length('pavan');

--how to find out manager name and employee name from same table
SELECT e.first_name as employee, m.first_name as manager 
FROM hr.employees e, hr.employees m
WHERE e.manager_id = m.employee_id;

select * from hr.employees;

SELECT first_name as employee, employee_id, prior first_name as manager,
prior employee_id as mgrno
FROM hr.employees
start with manager_id is null
connect by manager_id = prior employee_id;

-------------------------------------------------------------
--how to fetch maximum salary of employee and minimum salary of employee together from hr.employees
SELECT MAX(salary) FROM hr.employees
UNION
SELECT MIN(salary) FROM hr.employees;

--what is query to display odd records from student table
SELECT * FROM (SELECT ROWNUM as rno,S.* FROM Student S) WHERE MOD(rno,2)=1;

select * from student;

--query to find second highest salary for employee?
--INLINE QUERY
SELECT MIN(SALARY) FROM
(SELECT DISTINCT salary FROM hr.employees ORDER BY salary desc)
WHERE rownum<=2;

SELECT * FROM (SELECT DISTINCT First_NAME, JOB_ID, SALARY,
ROW_NUMBER() OVER (ORDER BY salary desc) rk
FROM Hr.employees)
WHERE rk = 2;



select * from hr.employees order by commission_pct nulls first;
select * from hr.employees order by commission_pct desc;
select * from hr.employees order by department_id desc;

select salary, lead(salary,1) over (order by salary) as rn from hr.employees;
select salary, lag(salary,1) over (order by salary) as rn from hr.employees;

select substr('H_Rutuja_B',1,instr('H_Rutuja_B','_',1,1)) as c1, substr('H_Rutuja_B',1,instr('H_Rutuja_B','_',1,1)) as c1
from dual;

select round(-5.4) from dual;

