
-- 1 --
--Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. 
--Your result cannot contain duplicates.

SELECT DISTINCT City FROM STATION
WHERE City LIKE 'A%' OR City LIKE 'E%' OR City LIKE 'I%' OR City LIKE 'O%' OR City LIKE 'U%' ;
-- why capital letters



/*(leetcode)
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
id is the primary key for this table.
id is an autoincrement column. 
Write an SQL query to find all numbers that appear at least three times consecutively.
Return the result table in any order.
The query result format is in the following example.
Example 1:

Input: 
Logs table:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
Output: 
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
Explanation: 1 is the only number that appears consecutively for at least three times.
*/

SELECT 
    distinct A.num as ConsecutiveNums 
FROM
    logs a
INNER JOIN logs b
    on a.id=b.id+1
INNER join logs c
    on b.id=c.id+1
WHERE a.num=b.num AND a.num=c.num
;


select * from hr.employees;

select sum(1) from hr.employees

select count(department_id) from hr.employees





create table qwerty123 (
col1 int
);

select * from qwerty123;

alter table qwerty123 
add column col2

ALTER TABLE qwerty123
ADD col2 int;

ALTER TABLE qwerty124
ADD col2 int;


insert into qwerty123 values (1,1);
insert into qwerty123 values (1,0);
insert into qwerty123 values (2,1);
insert into qwerty123 values (3,1);
insert into qwerty123 values (NULL,null);
insert into qwerty123 values (null, null); -- address method


create table qwerty124 (
col1 int
);

select * from qwerty124;

insert into qwerty124 values (1,1);
insert into qwerty124 values (1,null);
insert into qwerty124 values (0,2);
insert into qwerty124 values (3,3);
insert into qwerty124 values (2,null);
insert into qwerty124 values (null,1);


truncate table qwerty123;
truncate table qwerty124;


select ceil(-10.9) from dual;

select * from qwerty123;
select * from qwerty124;

select * from qwerty123
union
select * from qwerty124;

select * from qwerty123
union all
select * from qwerty124;

select * from qwerty123
minus
select * from qwerty124;

select * from qwerty123
intersect
select * from qwerty124;

select rowid from qwerty123;
select rowid from qwerty124;


select * from qwerty123;
select * from qwerty124;


select * from qwerty123 a
inner join qwerty124 b on a.col1=b.col1;

select * from qwerty123 a
LEFT join qwerty124 b on a.col1=b.col1;

select * from qwerty123 a
RIGHT join qwerty124 b on a.col1=b.col1;

select * from qwerty123 a
FULL join qwerty124 b on a.col1=b.col1;

select replace('pavan','van',1) from dual;


select * from qwerty123;
select * from qwerty124;
select avg(col2) from qwerty123;


select length('pavan') - length(replace('pavan','a','')) from dual; -- no of 'a' in 'pavan'


select * from hr.employees 
where mod(employee_id,2) = 0;

select * from hr.employees 
where mod(employee_id,2) = 1;



------------------------
 
create table asdfg(
abc char(10)
);

create table asdfg1(
abc varchar(10)
);

create table asdfg2(
abc varchar2(10)
);


insert into asdfg values ('xcvb ');
insert into asdfg values ('');
insert into asdfg values (null);

insert into asdfg1 values ('xcvb ');
insert into asdfg1 values ('');
insert into asdfg1 values (null);


insert into asdfg2 values ('xcvb ');
insert into asdfg2 values ('');
insert into asdfg2 values (null);


select * from asdfg;
select * from asdfg1;
select * from asdfg2;

select * from asdfg where abc is null;
select * from asdfg1 where abc is null;
select * from asdfg2 where abc is null;

select length(abc) from asdfg;
select length(abc) from asdfg1;
select length(abc) from asdfg2;

 


select length(rowid) from dual;


-- Create Employees table
CREATE TABLE Employees11 (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT,
    Salary NUMBER
);

-- Insert some values into Employees table
INSERT INTO Employees11 VALUES (1, 'John', 'Doe', 101, 60000);
INSERT INTO Employees11 VALUES (2, 'Jane', 'Smith', 102, 70000);
INSERT INTO Employees11 VALUES (3, 'Bob', 'Johnson', 101, 55000);
INSERT INTO Employees11 VALUES (4, 'Alice', 'Williams', 103, 75000);

-- Create Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

-- Insert some values into Departments table
INSERT INTO Departments VALUES (101, 'HR');
INSERT INTO Departments VALUES (102, 'Finance');
INSERT INTO Departments VALUES (103, 'IT');

select * from employees11;
select * from departments;
select * from EmployeesView;
select * from SalarySummary;
select * from EmployeeCountByDepartment;

-- SIMPLE VIEW
create view emp1121 as 
select employeeid from employees11

select * from emp1121;

UPDATE emp1121
SET employeeid = 5
WHERE EmployeeID = 3;

-- Complex view: EmployeesView
CREATE VIEW EmployeesView AS
SELECT EmployeeID, FirstName, LastName, DepartmentName
FROM Employees11
JOIN Departments ON Employees11.DepartmentID = Departments.DepartmentID;


-- Complex View with group by: SalarySummary
CREATE VIEW SalarySummary AS
SELECT DepartmentName, AVG(Salary) AS AvgSalary, MAX(Salary) AS MaxSalary
FROM Employees11
JOIN Departments ON Employees11.DepartmentID = Departments.DepartmentID
GROUP BY DepartmentName;


-- Materialized View: EmployeeCountByDepartment
CREATE MATERIALIZED VIEW EmployeeCountByDepartment AS
SELECT DepartmentID, COUNT(EmployeeID) AS EmployeeCount
FROM Employees11
GROUP BY DepartmentID;


select * from employees11;
select * from departments;
select * from EmployeesView;
select * from SalarySummary;
select * from EmployeeCountByDepartment;
select * from emp1121;

delete from departments 
where departmentid = 103;

-- Insert into EmployeesView (automatically affects Employees table)
INSERT INTO EmployeesView (EmployeeID, FirstName, LastName, DepartmentName)
VALUES (5, 'Eva', 'Miller', 'Finance');
-- error cannot modify view with more than one base table

-- Update EmployeesView (automatically affects Employees table)
UPDATE EmployeesView
SET DepartmentName = 'IT'
WHERE EmployeeID = 3;

-- Delete from EmployeesView (automatically affects Employees table)
DELETE FROM EmployeesView
WHERE EmployeeID = 1;

delete from salarysummary 
where departmentname = 'HR';


delete from EmployeeCountByDepartment
where departmentid = 101;

-- Refresh the materialized view
BEGIN
DBMS_SNAPSHOT.REFRESH('EmployeeCountByDepartment');
END;



commit;



-- surrogate key
CREATE TABLE Customers11 (
    customer_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    customer_name VARCHAR(100),
    email VARCHAR(100)
);


--composite key
CREATE TABLE Orders121 (
    order_id NUMBER,
    customer_id NUMBER,
    order_date DATE,
    product_id NUMBER,
    quantity NUMBER,
    PRIMARY KEY (order_id, customer_id)
);

select * from orders121;

-- Inserting values with a unique combination of order_id and customer_id
INSERT INTO Orders121 (order_id, customer_id, order_date, product_id, quantity)
VALUES (1, 101, TO_DATE('2022-01-15', 'YYYY-MM-DD'), 1001, 5);

INSERT INTO Orders121 (order_id, customer_id, order_date, product_id, quantity)
VALUES (2, 102, TO_DATE('2022-01-16', 'YYYY-MM-DD'), 1002, 3);

INSERT INTO Orders121 (order_id, customer_id, order_date, product_id, quantity)
VALUES (1, 103, TO_DATE('2022-01-17', 'YYYY-MM-DD'), 1003, 2);


-- Attempting to insert a duplicate combination of order_id and customer_id will result in an error
-- Uncommenting the following line will result in a unique constraint violation
-- INSERT INTO Orders121 (order_id, customer_id, order_date, product_id, quantity)
-- VALUES (1, 101, TO_DATE('2022-01-17', 'YYYY-MM-DD'), 1003, 2);


-- Creates a table named Student.
-- StudentId will have surrogate values that are auto-number.
CREATE TABLE Student (
	StudentId INT IDENTITY(1,1) PRIMARY KEY,
	Class INT,
	Marks INT,
);

-- Inserts two rows into the Student table.
INSERT INTO Student VALUES (9, 97);
INSERT INTO Student VALUES (9, 88);
GO

-- Displays the Student data.
SELECT * FROM Student;




-------------------------------------------------------------------------------------------
CREATE TABLE ExampleTable (
    id INT,
    name VARCHAR(50),
    age INT,
    email VARCHAR(100),
    salary DECIMAL(10,2)
);


ALTER TABLE ExampleTable
ADD phone VARCHAR(15);


SELECT * FROM ExampleTable;


INSERT INTO ExampleTable (id, name, age, email, salary, phone) VALUES (1, 'John', 30, 'john@example.com', 50000.00, '123-456-7890');
INSERT INTO ExampleTable (id, name, age, email, salary, phone) VALUES (2, 'Jane', 28, 'jane@example.com', 55000.00, '987-654-3210');
INSERT INTO ExampleTable (id, name, age, email, salary, phone) VALUES (3, 'Alice', 35, 'alice@example.com', 60000.00, '555-555-5555');
INSERT INTO ExampleTable (id, name, age, email, salary, phone) VALUES (4, 'Bob', 40, 'bob@example.com', 65000.00, '111-222-3333');
INSERT INTO ExampleTable (id, name, age, email, salary, phone) VALUES (5, 'Eve', 25, 'eve@example.com', 70000.00, '999-888-7777');


DELETE FROM ExampleTable
WHERE id = 5;


INSERT INTO ExampleTable (id, name, age, email, salary, phone) VALUES (6, 'Michael', 45, 'michael@example.com', 75000.00, '444-333-2222');
INSERT INTO ExampleTable (id, name, age, email, salary, phone) VALUES (7, 'Sarah', 32, 'sarah@example.com', 60000.00, '777-777-7777');
INSERT INTO ExampleTable (id, name, age, email, salary, phone) VALUES (8, 'David', 38, 'david@example.com', 80000.00, '888-999-1111');



SELECT * FROM ExampleTable;

ALTER TABLE ExampleTable
ADD phone1 VARCHAR(15);

ROLLBACK;

-------------------------------------------------------------------------------------------


--- SCD TYPE-2


create TABLE scd2Demo(
  pk1 NUMBER,
  pk2 VARCHAR2(30),
  dim1 NUMBER,
  dim2 NUMBER,
  dim3 NUMBER,
  dim4 NUMBER,
  active_status VARCHAR2(30) DEFAULT 'Y',
  start_date DATE DEFAULT SYSDATE,
  end_date DATE DEFAULT TO_DATE('31-12-9999','DD-MM-YYYY')
);

--DROP TABLE SCD2DEMO;

insert into scd2Demo values (111,'unit1',200,500,800,400,'Y',SYSDATE,TO_DATE('31-12-9999','DD-MM-YYYY'));
insert into scd2Demo values (222,'unit2',900,null,700,100,'Y',SYSDATE,TO_DATE('31-12-9999','DD-MM-YYYY'));
insert into scd2Demo values (333,'unit3',300,900,250,600,'Y',SYSDATE,TO_DATE('31-12-9999','DD-MM-YYYY'));

SELECT * FROM SCD2DEMO;

--TRUNCATE TABLE SCD2DEMO;

-- COMMIT;

create TABLE scd2Demo2(
  pk1 NUMBER,
  pk2 VARCHAR2(30),
  dim1 NUMBER,
  dim2 NUMBER,
  dim3 NUMBER,
  dim4 NUMBER,
  active_status VARCHAR2(30) DEFAULT 'Y',
  start_date DATE DEFAULT SYSDATE,
  end_date DATE DEFAULT TO_DATE('31-12-9999','DD-MM-YYYY')
);

SELECT * FROM SCD2DEMO2;

INSERT INTO SCD2DEMO2(PK1,PK2,DIM1,DIM2,DIM3,DIM4) VALUES (111, 'unit1', 200, 500, 800, 400);
INSERT INTO SCD2DEMO2 (PK1,PK2,DIM1,DIM2,DIM3,DIM4) VALUES (222, 'unit2', 800, 1300, 800, 500);
INSERT INTO SCD2DEMO2 (PK1,PK2,DIM1,DIM2,DIM3,DIM4) VALUES (444, 'unit4', 100, NULL, 700, 300);

SELECT * FROM SCD2DEMO;
SELECT * FROM SCD2DEMO2;


MERGE INTO SCD2DEMO tgt
USING (
        SELECT E.PK1 AS MERGE_KEY, E.* FROM SCD2DEMO E
        WHERE PK1 IN (SELECT PK1 FROM(
        SELECT NULL AS MERGE_KEY,G.* FROM SCD2DEMO F RIGHT JOIN SCD2DEMO2 G
        ON F.PK1 = G.PK1
        WHERE  F.DIM1 <> G.DIM1
        OR F.DIM2 <> G.DIM2
        OR F.DIM3 <> G.DIM3
        OR F.DIM4 <> G.DIM4 ))
        UNION ALL
        SELECT NULL AS MERGE_KEY,G.* FROM SCD2DEMO F RIGHT JOIN SCD2DEMO2 G
        ON F.PK1 = G.PK1
        WHERE  F.DIM1 <> G.DIM1
        OR F.DIM2 <> G.DIM2
        OR F.DIM3 <> G.DIM3
        OR F.DIM4 <> G.DIM4
        UNION
        SELECT NULL AS MERGE_KEY,G.* FROM SCD2DEMO2 G
        WHERE PK1 NOT IN (SELECT PK1 FROM SCD2DEMO)
) src
ON (tgt.PK1 = src.MERGE_KEY)
WHEN MATCHED THEN
    UPDATE SET tgt.active_status = CASE WHEN tgt.active_status = 'Y' THEN 'N' ELSE tgt.active_status END, 
               tgt.end_date = src.start_date
    WHERE tgt.active_status = 'Y'
WHEN NOT MATCHED THEN
    INSERT (
        PK1, PK2, DIM1, DIM2, DIM3, DIM4, active_status, start_date, end_date
    )
    VALUES (
        src.PK1, src.PK2, src.DIM1, src.DIM2, src.DIM3, src.DIM4,
        src.active_status, src.start_date, src.end_date
    );
    
    
    
SELECT * FROM SCD2DEMO;
SELECT * FROM SCD2DEMO2;






