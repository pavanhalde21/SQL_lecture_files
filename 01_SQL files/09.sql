

--REGULAR EXPRESSIONS
-- WITH

/*
REGULAR EXPRESSIONS are very powerfull text processing components in oracle
usages of regular expression in oracle:
there are so many usages of regular expression. there are following usages of regular expression

--validation purpose:
there are so many scenarios where user needs to check a certain pattern.
example:
in email validation, check user needs to add only mails, which has '@' symbol.

--avoid sensetive string:
by centralizing the pattern, matching logic user can be able to avoid the sensitive string.

--avoid dupliacte validation logic:
by using the server side regular expression, you can avoid duplicating validation logic.

--search pattern in string:
regular expression are used to search the specific pattern from the string.

oracle regular epression examples with different functions:
1. REGEXP_LIKE():-
the REGEXP_LIKE function is very important regular expression function that is used in validation...... 
--SYNTAX: REGEXP_LIKE(source string, pattern, match-parameter);
source string: the source string is any string from which user needs to grab the specific pattern.
pattern: the pattern is any pattern which user needs to match.
match parameter:
match_parameter is nothing but a text literal which is used to change the matching behaviour.....

following are some matching patterns:
i : i specifies the case insensitive match of the string.
c : if user wants the case sensitive match then needs to use the c matching pattern.
m : 'm' treats the source string as multiple lines. oracle interprets ^ and $ as the start....

ex_1:
if user wants to find the employees whose first_name begins with A and ends with t
to achieve this following query is used : */
select * from employee where regexp_like(name,'^A(mi|mee|)t$');
--the above query fetches the records of the employees whose first name is amit or ameet.

--ex_2:
--if user wants to find the employees who has double vowel in its first_name. 
  SELECT first_name
  FROM employees
  WHERE REGEXP_LIKE(first_name,'([aeiou])\1','i');
/*
REGEXP_COUNT:
the regexp_count() function is used to count the specified pattern. these kind of cond....
--SYNTAX: REGEXP_COUNT(source string, pattern to match, position, match_parameter);

ex_1:
if user wants to calculate how many time a is used in string after 2 positions. */
  SELECT REGEXP_COUNT('Amit Shiravadekar', 'a',2,'c') FROM DUAL;
/*  the above query will return the count as 3 as it calculates the count of letter 'a' which...

ex_2: 
if user wantsto find out the '@' character from the string. the following query is useful */
SELECT REGEXP_COUNT('ASaaaa@gmail.com','@') FROM DUAL;
/*if the count of '@' is more than one then the email validation fails in that case.

REGEXP_REPLACE:
the REGEXP_REPLACE function returns the string. which replaces the occurances of given pattern 
--SYNTAX : REGEXP_REPLACE(source_string, pattern, replace_string);

example:
this function invocation puts a space after each character in the column name: */
SELECT REGEXP_REPLACE('Ayan','(.)','\1  ') FROM DUAL;
/*the REGEXP_REPLACE function used above is used to insert the space between the string.
REGEXP_SUBSTR:
just like a substring REGEXP_SUBSTRING function is used to check the given pattern in to given...

syntax :
          REGEXP_SUBSTR(source_string, pattern, start_position,end_position, option);
ex: */

SELECT REGEXP_SUBSTR('This is a regexp_substr demo','[[:alpha:]]+',1,4) the_4th_word
FROM DUAL;

SELECT REGEXP_SUBSTR('This is a regexp_substr demo','[[:alpha:]]+',1,LEVEL) regexp_substr
FROM DUAL
CONNECT BY LEVEL <= REGEXP_COUNT('this is a regexp_substr demo',' ') +1;

SELECT product_id,product_name,description
FROM products
WHERE category_id = 4
ORDER BY product_name;

SELECT product_id, product_name,description, REGEXP_SUBSTR(description, '\d+(GB\TB)') max_ram
FROM products
WHERE category_id = 4;

------------------------------------------------------------

--WITH

WITH temp_table (average_salary) AS 
(
SELECT avg(salary) FROM hr.employees
)

SELECT emp_id, full_name, salary, 
FROM t101, temp_table
WHERE salary > temp_table.average_salary;

----------------
CREATE TABLE t101
(
emp_id number,
name varchar2(20),
salary number
)

insert into t101 values (103,'a',5000)


select * from t101
--
WITH cteEMP(employee_id, first_name, manager_id, emplevel)
AS (
     SELECT employee_id, first_name, manager_id, 1
     FROM hr.employees
     WHERE manager_id IS NULL
     UNION ALL
     SELECT e.employee_id, e.first_name, e.manager_id, r.emplevel + 1
     FROM hr.employees e 
     INNER JOIN cteEMP r 
     ON e.manager_id = r.employee_id
)
SELECT employee_id,first_name,manager_id, emplevel, 
FROM cteEMP 
ORDER BY emplevel;


--works
WITH tem AS (
SELECT * FROM HR.EMPLOYEES
)
SELECT * FROM tem;

--
WITH temp_emp AS 
(SELECT * FROM HR.EMPLOYEES),
temp_dep AS (SELECT * FROM HR.DEPARTMENTS)

SELECT employee_id, e.department_id, job_id, department_name
FROM temp_emp e, temp_dep d
WHERE e.department_id = d.department_id;


--- what is the diff b/w with and create view



select length(0.230) from dual;

select length(0.231) from dual;

select length(0.01) from dual;



with ste(rn) as
(
select lpad('pavan',10,'*') from dual
) 
select rpad(rn,15,'#') from ste;



