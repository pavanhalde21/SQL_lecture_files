-- ==========================================
-- INDEX
-- ==========================================
-- 1. INNER JOIN
-- 2. LEFT JOIN
-- 3. SELF JOIN
-- 4. FULL OUTER JOIN
-- ==========================================

/*===============================================================
  1️⃣ Patients & Appointments Example
  Demonstrating INNER JOIN using both explicit JOIN syntax 
  and the older comma-separated style.
===============================================================*/

-- Create Patients table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    city VARCHAR(100)
);

-- Create Appointments table
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_name VARCHAR(100) NOT NULL,
    appointment_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- Insert data into Patients
INSERT INTO Patients (patient_id, name, age, city) VALUES
(1, 'Alice', 30, 'Delhi'),
(2, 'Bob', 25, 'Mumbai'),
(3, 'Carol', 40, 'Chennai'),
(4, 'Dave', 35, 'Kolkata'),
(5, 'Eve', 28, 'Bangalore');

-- Insert data into Appointments
INSERT INTO Appointments (appointment_id, patient_id, doctor_name, appointment_date) VALUES
(101, 1, 'Dr. Sharma', '2024-03-01'),
(102, 2, 'Dr. Gupta', '2024-03-02'),
(103, 4, 'Dr. Rao', '2024-03-05'),
(104, 5, 'Dr. Verma', '2024-03-07'); 

-- View data from both tables
SELECT * FROM Patients;
SELECT * FROM Appointments;

-- INNER JOIN using explicit JOIN syntax
SELECT p.patient_id, p.name, p.age, a.doctor_name, a.appointment_date
FROM Patients p
INNER JOIN Appointments a
    ON p.patient_id = a.patient_id;

-- INNER JOIN using old comma-separated syntax
SELECT p.patient_id, p.name, p.age, a.doctor_name, a.appointment_date
FROM Patients p, Appointments a
WHERE p.patient_id = a.patient_id;


/*===============================================================
  2️⃣ Employees & Salaries Example
  Demonstrating LEFT JOIN to show all employees with or without salary.
===============================================================*/

-- Drop tables if they already exist
DROP TABLE IF EXISTS Salaries;
DROP TABLE IF EXISTS Employees;

-- Create Employees table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL
);

-- Create Salaries table
CREATE TABLE Salaries (
    emp_id INT PRIMARY KEY,
    salary DECIMAL(10,2),
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

-- Insert into Employees
INSERT INTO Employees (emp_id, name, department) VALUES
(1, 'Alice', 'HR'),
(2, 'Bob', 'IT'),
(3, 'Carol', 'Finance'),
(4, 'Dave', 'IT'),
(5, 'Eve', 'HR');

-- Insert into Salaries
INSERT INTO Salaries (emp_id, salary) VALUES
(1, 50000),
(2, 60000),
(4, 55000);

-- View data
SELECT * FROM Salaries;
SELECT * FROM Employees;

-- LEFT JOIN: Show all employees even if they don't have salary records
SELECT e.emp_id, e.name, e.department, s.salary
FROM Employees e
LEFT JOIN Salaries s
    ON e.emp_id = s.emp_id;


/*===============================================================
  3️⃣ Self Join Example (Employees & Managers)
  Demonstrating various self-join queries.
===============================================================*/

-- Drop table if it already exists
DROP TABLE IF EXISTS Employees_SelfJoin;

-- Create table
CREATE TABLE Employees_SelfJoin (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    manager_id INT
);

-- Insert sample data
INSERT INTO Employees_SelfJoin (emp_id, name, manager_id) VALUES
(1, 'Alice', NULL),
(2, 'Bob', 1),
(3, 'Carol', 1),
(4, 'Dave', 2),
(5, 'Eve', 2),
(6, 'Frank', 3);

-- View all data
SELECT * FROM Employees_SelfJoin;

-- 1️⃣ LEFT JOIN: Show all employees with their managers (if any)
SELECT 
    e.emp_id   AS employee_id,
    e.name     AS employee_name,
    e.manager_id,
    m.name     AS manager_name
FROM Employees_SelfJoin e
LEFT JOIN Employees_SelfJoin m
    ON e.manager_id = m.emp_id;

-- 2️⃣ INNER JOIN: Show only employees who have managers
SELECT 
    e.emp_id   AS employee_id,
    e.name     AS employee_name,
    e.manager_id,
    m.name     AS manager_name
FROM Employees_SelfJoin e
INNER JOIN Employees_SelfJoin m
    ON e.manager_id = m.emp_id;

-- 3️⃣ WHERE clause self join (equivalent to INNER JOIN)
SELECT 
    e.emp_id   AS employee_id,
    e.name     AS employee_name,
    e.manager_id,
    m.name     AS manager_name
FROM Employees_SelfJoin e, Employees_SelfJoin m
WHERE e.manager_id = m.emp_id;

-- 4️⃣ Managers with the number of employees they manage
SELECT 
    m.name AS manager_name,
    COUNT(e.emp_id) AS num_employees
FROM Employees_SelfJoin m
JOIN Employees_SelfJoin e
    ON m.emp_id = e.manager_id
GROUP BY m.name;

-- 5️⃣ Top-level managers (no one manages them)
SELECT 
    e.emp_id,
    e.name AS top_manager
FROM Employees_SelfJoin e
WHERE e.manager_id IS NULL;

-- 6️⃣ Employees without subordinates
SELECT 
    e.emp_id,
    e.name AS employee_without_subordinates
FROM Employees_SelfJoin e
LEFT JOIN Employees_SelfJoin sub
    ON e.emp_id = sub.manager_id
WHERE sub.emp_id IS NULL;


/*===============================================================
  4️⃣ Full Outer Join Example (Employees & Departments)
  NOTE: FULL OUTER JOIN works in PostgreSQL / SQL Server. 
  MySQL requires UNION of LEFT + RIGHT JOIN.
===============================================================*/

-- Drop table if it already exists
DROP TABLE IF EXISTS Employees_FullJoin;

-- Create table
CREATE TABLE Employees_FullJoin (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    manager_id INT
);

-- Insert sample data
INSERT INTO Employees_FullJoin (emp_id, name, manager_id) VALUES
(1, 'Alice', NULL),   -- Top-level manager
(2, 'Bob', 1),
(3, 'Carol', 1),
(4, 'David', 2),
(5, 'Eve', 2),
(6, 'Frank', 3),
(7, 'Grace', NULL);   -- Another top-level manager

-- View all data
SELECT * FROM Employees_FullJoin;

-- Create first table for FOJ
CREATE TABLE Employees_FOJ (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id INT
);

-- Insert sample data into Employees_FOJ
INSERT INTO Employees_FOJ (emp_id, name, department_id) VALUES
(1, 'Alice', 101),
(2, 'Bob', 102),
(3, 'Charlie', 103),
(4, 'David', 104);

-- Create second table for FOJ
CREATE TABLE Departments_FOJ (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

-- Insert sample data into Departments_FOJ
INSERT INTO Departments_FOJ (department_id, department_name) VALUES
(101, 'HR'),
(102, 'Finance'),
(105, 'IT Support'),
(106, 'Marketing');

-- View data
SELECT * FROM Employees_FOJ;
SELECT * FROM Departments_FOJ;

-- FULL OUTER JOIN query
SELECT 
    e.emp_id,
    e.name AS employee_name,
    e.department_id,
    d.department_name
FROM Employees_FOJ e
FULL OUTER JOIN Departments_FOJ d
    ON e.department_id = d.department_id;
