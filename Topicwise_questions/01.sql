-- Q1: Show all records from student info table
SELECT * FROM stu_info1;

-- Q2: Insert a student record into stu_info1
INSERT INTO stu_info1 VALUES (156, 'abc', 45612385, TO_DATE('11-05-2000', 'dd-mm-yyyy'));

-- Q3: Find student(s) with name = 'abc'
SELECT * FROM stu_info1 WHERE name = 'abc';

-- Q4: Create persons4 table with constraints
CREATE TABLE persons4 (
    id INT PRIMARY KEY,
    lastname VARCHAR(255) NOT NULL,
    firstname VARCHAR(255) NOT NULL,
    age INT,
    city VARCHAR(255) DEFAULT 'pune'
);

-- Q5: Insert record into persons4
INSERT INTO persons4 (id, lastname, firstname, age) VALUES (1, 'abc', 'sum', 22);

-- Q6: View all records from persons4
SELECT * FROM persons4;

-- Q7: Alter order02 table to change default city
ALTER TABLE order02 MODIFY city DEFAULT 'mumbai';

-- Q8: Alter order02 table to make city unique
ALTER TABLE order02 MODIFY city UNIQUE;

-- Q9: Truncate persons4 table
TRUNCATE TABLE persons4;

-- Q10: Create order08 table with foreign key referencing persons4
CREATE TABLE order08 (
    orderid INT PRIMARY KEY,
    ordernumber INT NOT NULL,
    id INT,
    FOREIGN KEY (id) REFERENCES persons4(id)
);

-- Q11: Insert into order08 (expect integrity constraint error if parent id missing)
INSERT INTO order08 VALUES (123, 450, 28938);

-- Q12: Insert valid record into order08
INSERT INTO order08 VALUES (15, 45, 1);

-- Q13: Create persons7 table with CHECK constraint
CREATE TABLE persons7 (
    id INT PRIMARY KEY,
    lastname VARCHAR(255) NOT NULL,
    firstname VARCHAR(255) NOT NULL,
    age INT CHECK (age >= 18),
    collegename VARCHAR2(255) DEFAULT 'cvb'
);

-- Q14: Insert record violating CHECK constraint
INSERT INTO persons7 VALUES (7, 'asd', 'ghj', 16, 'ssa');

-- Q15: Create persons8 table with NOT NULL, CHECK, and DEFAULT constraints
CREATE TABLE persons8 (
    id INT PRIMARY KEY,
    lastname VARCHAR2(255) NOT NULL,
    firstname VARCHAR(255) NOT NULL,
    age INT CHECK (age >= 18),
    collegename VARCHAR2(255) DEFAULT 'cvb'
);

-- Q16: Insert valid record into persons8
INSERT INTO persons8 VALUES (6, 'asd', 'ghj', 55, 'ssa');

-- Q17: Show salary + commission using NVL
SELECT employee_id, first_name, last_name, job_id, salary, commission_pct,
       (salary + NVL(commission_pct, 0)) AS "total salary"
FROM hr.employees;

-- Q18: Select the first row from employees using ROWNUM
SELECT * FROM hr.employees WHERE ROWNUM = 1;

-- Q19: Select the alphabetically first employee
SELECT *
FROM (
    SELECT first_name
    FROM hr.employees
    ORDER BY first_name
)
WHERE ROWNUM = 1;

-- Q20: Commit and rollback transactions
COMMIT;
ROLLBACK;

-- Q21: Delete vs Truncate on persons7
DELETE FROM persons7;
TRUNCATE TABLE persons7;

-- Q22: Create stu_info2 table
CREATE TABLE stu_info2 (
    stu_id NUMBER(3,1) PRIMARY KEY,
    name VARCHAR2(30),
    contact_no NUMBER,
    dob DATE
);

-- Q23: Insert records into stu_info2
INSERT INTO stu_info2 VALUES (2, 'a', 789456, TO_DATE('12-06-1999', 'dd-mm-yyyy'));
INSERT INTO stu_info2 VALUES (33, 'a', 789456, '1-jan-2010');

-- Q24: Show all stu_info2 records
SELECT * FROM stu_info2;

-- Q25: Select employees whose names start with S, A, or R
SELECT first_name
FROM hr.employees
WHERE first_name LIKE 'S%'
   OR first_name LIKE 'A%'
   OR first_name LIKE 'R%';
