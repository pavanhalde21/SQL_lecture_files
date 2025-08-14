
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

COMMIT; -- saves the changes

INSERT INTO PERSONS12(id, lastname, firstname, age, dob, city) 
VALUES (6, 'Miller', 'Sophia', 22, TO_DATE('15-09-2000', 'DD-MM-YYYY'), 'Paris');

INSERT INTO PERSONS12(id, lastname, firstname, age, dob, city) 
VALUES (7, 'Taylor', 'William', 40, TO_DATE('03-07-1982', 'DD-MM-YYYY'), 'Berlin');

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

SELECT length(city) FROM PERSONS12;


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

-- Use MERGE statement to synchronize data
MERGE INTO target_table t
USING source_table s
ON (t.id = s.id)
WHEN MATCHED THEN
    UPDATE SET t.value = s.value
WHEN NOT MATCHED THEN
    INSERT (id, value) VALUES (s.id, s.value);
    
TRUNCATE TABLE source_table;
TRUNCATE TABLE target_table;

--------------------------------------------------------------------------------------

-- first record from a table
SELECT * FROM HR.EMPLOYEES
WHERE ROWNUM=1;

SELECT * FROM HR.EMPLOYEES
WHERE ROWNUM=2;  -- for anyother value except 1. it gives empty result set.

--INLINE QUERY
SELECT *
FROM (SELECT first_name FROM HR.EMPLOYEES ORDER BY first_name)
WHERE ROWNUM = 1;

-- SELECT first_name FROM HR.EMPLOYEES ORDER BY first_name WHERE ROWNUM = 1;
-- error because order by executes last 
-- WHERE executes before ORDER BY 

-- first 5 records
SELECT * FROM HR.EMPLOYEES
WHERE ROWNUM <= 5;

-- last 5 records
SELECT * FROM HR.EMPLOYEES
WHERE ROWNUM >= 5; -- if we use greater than equal to then it gives null values

SELECT *
FROM (SELECT first_name FROM HR.EMPLOYEES ORDER BY first_name desc)
WHERE ROWNUM <= 5;

SELECT ROWID FROM hr.employees;
-----------------------------------------------------------------------
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



-- NVL()
SELECT (salary+NVL(commission_pct,0)) "total salary" FROM hr.employees;
SELECT NVL(NULL,1) FROM Dual;
SELECT NVL(2,1) FROM Dual;

















