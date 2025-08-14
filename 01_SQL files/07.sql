
--DECODE()
--CASE()
--SUB_QUERY
--INLINE_QUERY




-----------------------DECODE()------------------------------

SELECT DECODE(1,1,'One') FROM DUAL;
SELECT DECODE(1,2,'One') FROM DUAL;
SELECT DECODE(2,1,'One',2,'Two',3,'Three') FROM DUAL;
SELECT DECODE(4,1,'One',2,'Two',3,'Three','if there is no match then this gets printed') FROM DUAL;
SELECT DECODE(4,1,'One',2,'Two',3,'Three') FROM DUAL; -- null
SELECT DECODE(NULL,NULL,'TRUE') FROM DUAL;--here it is true.elsewhere null is not equal to null

SELECT COUNTRY_ID, DECODE(COUNTRY_ID,'AR','Argentina','AU','Austrilia','BE','Belgium','IN','INDIA') 
FROM HR.COUNTRIES;


SELECT country_id, DECODE(country_id, 'AU', 'Austrilia','BR', 'Brazil', 
'CN', 'China', 'CA', 'Canada', 'CH', 'Switzerland', 'IT', 'Italy') country,--
COUNT(*)
FROM LOCATIONS 
GROUP BY country_id
HAVING COUNT(*) >=1 ORDER BY country_id;


-- Oracle DECODE with ORDER BY example

SELECT first_name, last_name, job_title
FROM employees
ORDER BY DECODE('J','F', first_name, 'L', last_name, 'J', job_title);

--
SELECT category_name, 
GREATEST(List_price,0), LEAST(List_price,1000) "<1000"
FROM Products
INNER JOIN product_categories USING (category_id) --USING
GROUP BY category_name,list_price;

select decode(1,0,3,true,true,false) from dual;

--Oracle DECODE() function with SUM() example
SELECT category_name,
SUM(DECODE(GREATEST(list_price,0), LEAST(list_price,1000),1,0)) "<1000",
SUM(DECODE(GREATEST(list_price,1001), LEAST(list_price,2000),1,0)) "1001-2000",
SUM(DECODE(GREATEST(list_price,2001), LEAST(list_price,3000),1,0)) "2001-3000",
SUM(DECODE(GREATEST(list_price,3001), LEAST(list_price,8999),1,0)) "3001-8999"
FROM products
INNER JOIN product_categories USING (category_id)--we can use USING instead of ON when both tables have the same column name and datatype
GROUP BY category_name;

--understand the code carefully

--discount
SELECT category_id, product_name, list_price,
       DECODE(category_id, 1, ROUND(list_price * 0.05,2), 2,ROUND(list_price * 0.1,2),category_id,ROUND(list_price * 0.08,2) ) discount
FROM products
ORDER BY product_name;
--observe how the substitute for ELSE is used

-------------------------------------------------------------------------------------------------------------------------


------------------CASE-------------------------------
--in DECODE() we allow only equality operator
--CASE can be used for a range

--CASE SYNTAX 
CASE e WHEN e1 THEN r1
       WHEN e2 THEN r2
       WHEN en THEN rn
       [ELSE e_else]
END

--discount
SELECT category_id, product_name, list_price,
       CASE category_id
         WHEN 1 THEN ROUND(list_price * 0.05,2)
         WHEN 2 THEN ROUND(list_price * 0.1,2)
           ELSE ROUND(list_price * 0.08,2)
         END discount
FROM products
ORDER BY product_name;

SELECT category_id, product_name, list_price,
       CASE category_id
         WHEN 1 THEN ROUND(list_price * 0.05,2)
         WHEN 2 THEN ROUND(list_price * 0.1,2)
         END discount   --- if we do not use else condition then we get null values by default
FROM products
ORDER BY product_name;

--discounted price
SELECT category_id, product_name, list_price, 
       CASE category_id
         WHEN 1 THEN (list_price + list_price * ROUND(list_price * 0.05,2))
         WHEN 2 THEN (list_price + list_price * ROUND(list_price * 0.1,2))
           ELSE (list_price + list_price * ROUND(list_price * 0.08,2))
         END total_price
FROM products
ORDER BY product_name;
-- can we add two columns in CASE. ex: discount, total_price ----HOW???????

--range case
SELECT product_name, list_price,
       CASE 
         WHEN list_price > 0 AND list_price <600
           THEN 'Mass'
         WHEN list_price >= 600 AND list_price <1000
           THEN 'Economy'
         WHEN list_price >= 1000 AND list_price <2000
           THEN 'Luxury'
         ELSE 'Grand Luxury'
         END product_group
FROM products
WHERE category_id = 1
ORDER BY product_name;

--using CASE expression in an ORDER BY clause
SELECT * FROM locations
WHERE country_id in ('US','CA','UK')
ORDER BY country_id,
         CASE country_id
           WHEN 'US' THEN state
           ELSE city
         END;
--        
SELECT CASE country_id
           WHEN 'US' THEN state
           ELSE city
         END, l. * FROM locations l
WHERE country_id in ('US','CA','UK')
ORDER BY 
         CASE country_id
           WHEN 'US' THEN state
           ELSE city
         END;--refer last query of 06.sql         
--
SELECT category_id, product_name, list_price, 
       CASE category_id
         WHEN 1 THEN (list_price + list_price * ROUND(list_price * 0.05,2))
         WHEN 2 THEN (list_price + list_price * ROUND(list_price * 0.1,2))
           ELSE (list_price + list_price * ROUND(list_price * 0.08,2))
         END total_price
FROM products
ORDER BY CASE category_id
         WHEN 1 THEN (list_price + list_price * ROUND(list_price * 0.05,2))
         WHEN 2 THEN (list_price + list_price * ROUND(list_price * 0.1,2))
           ELSE (list_price + list_price * ROUND(list_price * 0.08,2))
         END;--you need not mention the name of column in ORDER BY clause stop at END itself.

--using CASE expression in HAVING clause
SELECT product_name, category_id, COUNT(product_id)
FROM order_items
INNER JOIN products USING (product_id)--do not forget parenthesis ()
GROUP BY product_name, category_id
HAVING COUNT(CASE WHEN category_id =1 THEN product_id ELSE NULL END) > 5 
     OR COUNT(CASE WHEN category_id =2 THEN product_id ELSE NULL END) > 2
ORDER BY product_name;                       

--using CASE expression in an UPDATE statement

SELECT product_name, list_price, standard_cost,
       ROUND((list_price - standard_cost)*100 / list_price,2) gross_margin
FROM products
WHERE ROUND((list_price - standard_cost)*100 / list_price,2) < 12;
--
UPDATE products
SET list_price = CASE WHEN ROUND((list_price - standard_cost)*100 / list_price,2) < 12
                        THEN (standard_cost + 1)*12
                 END
WHERE  ROUND((list_price - standard_cost)*100 / list_price,2) < 12;

ROLLBACK



-- DECODE -- FUNCTION
-- CASE -- STATEMENT

--DECODE function can not work with the sub-queries and predicates
--CASE function can work with the sub-queries and predicates
--DECODE can only be used in function inside sql only
--CASE statement can be used in plsql blocks
--you can not use DECODE function in stored procedures call
--you can use CASE statement in procedure calls


SELECT CASE NULL WHEN NULL THEN 'equal' ELSE 'not equal' END
FROM DUAL;--null is not equal to null

SELECT CASE WHEN NULL IS NULL THEN 'equal' ELSE 'not equal' END
FROM DUAL;--

--Q. find employee details of IT department using hr.departments, hr.employees
select * from hr.employees e --using * we get columns from both tables
inner join hr.departments d
on e.department_id = d.department_id
where department_name = 'IT';
--
select e.* from hr.employees e --using e.* we get columns from hr.employees table only
inner join hr.departments d
on e.department_id = d.department_id
where department_name = 'IT';
--
select * from hr.employees e, hr.departments d
where e.department_id = d.department_id
and department_name = 'IT';

---------------------------------------------------------------------------------------------------------


------------SUB_QUERY-------------------------
--SUB_QUERY can be a substitute for JOIN 


SELECT * FROM hr.employees 
WHERE department_id IN (
      SELECT department_id FROM hr.departments
      WHERE department_name = 'IT'
);
--
SELECT * FROM hr.employees 
WHERE department_id IN 
(
      SELECT department_id FROM hr.departments
      WHERE department_name = 
      (
            SELECT department_name FROM hr.locations
            WHERE city = 'Bombay'
      )
);
------
SELECT * FROM hr.employees 
WHERE department_id = -- here we can not use = because there are more than one departments in bombay. so, use IN
(
      SELECT department_id FROM hr.departments
      WHERE department_name = 
      (
            SELECT department_name FROM hr.locations
            WHERE city = 'Bombay'
      )
);
--------------------------

select a.* from hr.employees a 
where 2 = 
(select count(distinct(salary)) from hr.employees b where b.salary>=a.salary); -- second highest salary

select a.* from hr.employees a 
where 2 = 
(select count(distinct(salary)) from hr.employees b where b.salary>a.salary); -- third highest salary

select a.* from hr.employees a 
where 1 = 
(select count(distinct(salary)) from hr.employees b where b.salary>=a.salary); -- highest salary

--------------------------
--Q. details of employee having maximum salary
SELECT * FROM hr.employees
WHERE salary = (SELECT MAX(salary) FROM hr.employees);--we cannot compare directly by a function like WHERE salary = MAX(salary)

SELECT * FROM hr.employees e
WHERE salary = MAX(salary) ;-- error -- we can not do this. so, the above method

-------------------
select * from hr.employees e
inner join hr.departments d
on e.department_id = d.department_id
where department_name = 'IT';
/* in this case i just wanted information of only one department i.e. IT-department
 suppose there are 10lakh employees in hr.employees table
then the JOIN query will check for join on each employee record and then return the result */ 

SELECT * FROM hr.employees 
WHERE department_id IN 
(
      SELECT department_id FROM hr.departments
      WHERE department_name = 'IT'
);
/* where as here in SUB_QUERY inner query is executed and then the results are passed to outer query
 this makes the SUB_QUERY more efficient */ 

-- if we want department name along with employee details then in that case join will be better

----------------------------------------------------------------------------------------------------------------



-------------------INLINE_QUERY---------------------
SELECT * FROM 
(
       SELECT e.*, RANK() OVER(ORDER BY salary desc) abc 
       FROM hr.employees e
)
WHERE abc =2;



/* comment */

--using ') something is happening???
')

dgshjaaaabjdsafssssss
SELECT category_id, product_name, list_price,































 
