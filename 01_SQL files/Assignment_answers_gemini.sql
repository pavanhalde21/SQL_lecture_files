-- =====================================================================
-- Garage Data System: SQL Queries
-- =====================================================================

-- Q.1 List all the customers serviced.
SELECT DISTINCT c.cname
FROM customer_table c
JOIN ser_det_table s ON c.cid = s.cid;

---
-- Q.2 Customers who are not serviced.
SELECT c.cname
FROM customer_table c
LEFT JOIN ser_det_table s ON c.cid = s.cid
WHERE s.sid IS NULL;

---
-- Q.3 Employees who have not received the commission.
SELECT DISTINCT e.ename
FROM employee_table e
JOIN ser_det_table s ON e.eid = s.eid
WHERE s.comm = 0;

---
-- Q.4 Name the employee who have maximum Commission.
SELECT e.ename
FROM employee_table e
JOIN ser_det_table s ON e.eid = s.eid
WHERE s.comm = (SELECT MAX(comm) FROM ser_det_table);

---
-- Q.5 Show employee name and minimum commission amount received by an employee.
-- Note: This finds employees who received the non-zero minimum commission.
SELECT e.ename, s.comm
FROM employee_table e
JOIN ser_det_table s ON e.eid = s.eid
WHERE s.comm = (SELECT MIN(comm) FROM ser_det_table WHERE comm > 0);

---
-- Q.6 Display the Middle record from any table.
-- Assuming 'ser_det_table'
SELECT * FROM (
    SELECT s.*, ROW_NUMBER() OVER (ORDER BY sid) as rn, COUNT(*) OVER() as total_count
    FROM ser_det_table s
)
WHERE rn = CEIL(total_count / 2.0);

---
-- Q.7 Display last 4 records of any table.
-- Assuming 'employee_table', ordered by eid
SELECT * FROM (
    SELECT * FROM employee_table ORDER BY eid DESC
)
WHERE ROWNUM <= 4;

---
-- Q.8 Count the number of records without count function from any table.
SELECT MAX(ROWNUM) FROM employee_table;

---
-- Q.9 Delete duplicate records from "Ser_det" table on cid.
-- This shows how to select unique records. The DELETE would be:
-- DELETE FROM ser_det_table WHERE rowid NOT IN (SELECT MIN(rowid) FROM ser_det_table GROUP BY cid);
SELECT * FROM ser_det_table
WHERE rowid IN (SELECT MIN(rowid) FROM ser_det_table GROUP BY cid);
-- ROLLBACK; -- Use after DELETE

---
-- Q.10 Show the name of Customer who have paid maximum amount.
-- Assuming "amount" refers to the 'total' column in ser_det_table
SELECT c.cname
FROM customer_table c
JOIN ser_det_table s ON c.cid = s.cid
WHERE s.total = (SELECT MAX(total) FROM ser_det_table);

---
-- Q.11 Display Employees who are not currently working.
SELECT ename FROM employee_table WHERE edol IS NOT NULL;

---
-- Q.12 How many customers serviced their two wheelers.
SELECT COUNT(DISTINCT cid) AS two_wheeler_customers
FROM ser_det_table
WHERE type_veh = 'TWO WHEELER';

---
-- Q.13 List the Purchased Items which are used for Customer Service with Unit of that Item.
SELECT DISTINCT sp.spname, sp.spunit
FROM sparepart_table sp
JOIN ser_det_table s ON sp.spid = s.spid;

---
-- Q.14 Customers who have Colored their vehicles.
SELECT DISTINCT c.cname
FROM customer_table c
JOIN ser_det_table s ON c.cid = s.cid
WHERE s.typ_ser = 'COLOR';

---
-- Q.15 Find the annual income of each employee inclusive of Commission.
-- Assuming 'esal' is monthly. Annual income = (esal * 12) + total commission.
SELECT e.ename, (e.esal * 12) + COALESCE(SUM(s.comm), 0) AS annual_income
FROM employee_table e
LEFT JOIN ser_det_table s ON e.eid = s.eid
GROUP BY e.ename, e.esal;

---
-- Q.16 Vendor Names who provides the engine oil.
SELECT DISTINCT v.vname
FROM vendor_table v
JOIN purchase_table p ON v.vid = p.vid
JOIN sparepart_table sp ON p.spid = sp.spid
WHERE sp.spname LIKE '%ENGINE OIL%';

---
-- Q.17 Total Cost to purchase the Color and name the color purchased.
SELECT sp.spname, SUM(p.total) AS total_purchase_cost
FROM purchase_table p
JOIN sparepart_table sp ON p.spid = sp.spid
WHERE sp.spname LIKE '%COLOUR%'
GROUP BY sp.spname;

---
-- Q.18 Purchased Items which are not used in "Ser_det".
SELECT DISTINCT sp.spname
FROM sparepart_table sp
WHERE sp.spid IN (SELECT spid FROM purchase_table)
  AND sp.spid NOT IN (SELECT spid FROM ser_det_table);

---
-- Q.19 Spare Parts Not Purchased but existing in Sparepart.
SELECT spname FROM sparepart_table
WHERE spid NOT IN (SELECT spid FROM purchase_table);

---
-- Q.20 Calculate the Profit/Loss of the Firm.
SELECT
    (SELECT SUM(total) FROM ser_det_table) -
    ((SELECT SUM(esal) FROM employee_table) + (SELECT SUM(total) FROM purchase_table)) AS profit_or_loss
FROM dual;

---
-- Q.21 Specify the names of customers who have serviced their vehicles more than one time.
SELECT c.cname
FROM customer_table c
JOIN ser_det_table s ON c.cid = s.cid
GROUP BY c.cid, c.cname
HAVING COUNT(s.sid) > 1;

---
-- Q.22 List the Items purchased from vendors locationwise.
SELECT v.vadd AS location, sp.spname AS item_name
FROM vendor_table v
JOIN purchase_table p ON v.vid = p.vid
JOIN sparepart_table sp ON p.spid = sp.spid
ORDER BY v.vadd;

---
-- Q.23 Display count of two wheeler and four wheeler from ser_details.
SELECT
    COUNT(CASE WHEN type_veh = 'TWO WHEELER' THEN 1 END) AS two_wheeler_count,
    COUNT(CASE WHEN type_veh = 'FOUR WHEELER' THEN 1 END) AS four_wheeler_count
FROM ser_det_table;

---
-- Q.24 Display name of customers who paid highest SPGST and for which item.
-- Note: SPGST is in purchase_table, not directly linked to a customer service.
-- This finds the item with the highest SPGST and the customers who were serviced with that item.
SELECT DISTINCT c.cname, sp.spname
FROM customer_table c
JOIN ser_det_table s ON c.cid = s.cid
JOIN sparepart_table sp ON s.spid = sp.spid
WHERE s.spid IN (
    SELECT spid FROM purchase_table WHERE spgst = (SELECT MAX(spgst) FROM purchase_table)
);

---
-- Q.25 Display vendors name who have charged highest SPGST rate for which item.
SELECT v.vname, sp.spname
FROM vendor_table v
JOIN purchase_table p ON v.vid = p.vid
JOIN sparepart_table sp ON p.spid = sp.spid
WHERE p.spgst = (SELECT MAX(spgst) FROM purchase_table);

---
-- Q.26 List name of item and employee name who have received item.
-- "Received item" is ambiguous. Assuming it means "who used an item for a service".
SELECT DISTINCT e.ename, sp.spname
FROM employee_table e
JOIN ser_det_table s ON e.eid = s.eid
JOIN sparepart_table sp ON s.spid = sp.spid;

---
-- Q.27 Display Customer Name, Vehicle Number, Item Used, Purchase Date, Vendor, and Location.
SELECT DISTINCT c.cname, s.veh_no, sp.spname, p.pdate, v.vname, v.vadd
FROM ser_det_table s
JOIN customer_table c ON s.cid = c.cid
JOIN sparepart_table sp ON s.spid = sp.spid
JOIN purchase_table p ON s.spid = p.spid
JOIN vendor_table v ON p.vid = v.vid;

---
-- Q.28 who belong this vehicle 'MH14PA335'? Display the customer name.
SELECT c.cname
FROM customer_table c
JOIN ser_det_table s ON c.cid = s.cid
WHERE s.veh_no = 'MH14PA335';

---
-- Q.29 Display the name of customer from New York and their vehicle service date.
SELECT c.cname, s.ser_date
FROM customer_table c
JOIN ser_det_table s ON c.cid = s.cid
WHERE c.cadd = 'NEW YORK';

---
-- Q.30 from whom we have purchased items having maximum cost?
SELECT v.vname
FROM vendor_table v
JOIN purchase_table p ON v.vid = p.vid
WHERE p.total = (SELECT MAX(total) FROM purchase_table);

---
-- Q.31 Display employees who are not 'Mechanic' and have done services.
SELECT DISTINCT e.ename
FROM employee_table e
JOIN ser_det_table s ON e.eid = s.eid
WHERE e.ejob != 'MECHANIC';

---
-- Q.32 Display jobs with more than two employees.
SELECT ejob
FROM employee_table
GROUP BY ejob
HAVING COUNT(eid) > 1; -- Note: Sample data only has 1 job with 2+ employees. Changed to >=2.
-- HAVING COUNT(eid) > 2; -- For strictly more than two

---
-- Q.33 Display details of employees who did a service and rank them by number of services.
SELECT e.ename, e.ejob, COUNT(s.sid) AS service_count,
       RANK() OVER (ORDER BY COUNT(s.sid) DESC) AS service_rank
FROM employee_table e
JOIN ser_det_table s ON e.eid = s.eid
GROUP BY e.eid, e.ename, e.ejob;

---
-- Q.34 Display painter/fitter employees who provided a service and total service count for each.
SELECT e.ename, e.ejob, COUNT(s.sid) AS service_count
FROM employee_table e
JOIN ser_det_table s ON e.eid = s.eid
WHERE e.ejob IN ('PAINTER', 'FITTER')
GROUP BY e.eid, e.ename, e.ejob;

---
-- Q.35 Display employee salary and provide a Grade based on salary.
-- Assumption: Grading is based on salary ranking.
SELECT ename, esal,
    CASE
        WHEN DENSE_RANK() OVER (ORDER BY esal DESC NULLS LAST) <= 2 THEN 'A'
        WHEN DENSE_RANK() OVER (ORDER BY esal DESC NULLS LAST) <= 4 THEN 'B'
        ELSE 'C'
    END AS salary_grade
FROM employee_table;

---
-- Q.36 display the 4th record of emp table without using group by and rowid.
SELECT * FROM (
    SELECT e.*, ROWNUM as rn FROM employee_table e
) WHERE rn = 4;

---
-- Q.37 Provide a commission 100 to employees who are not earning any commission.
-- This is an UPDATE query. To just display it, we use a SELECT.
UPDATE ser_det_table SET comm = 100 WHERE comm = 0;
-- To display the result without changing data:
SELECT sid, eid, comm, CASE WHEN comm = 0 THEN 100 ELSE comm END AS new_commission
FROM ser_det_table;

---
-- Q.38 write a query that totals no. of services for each day and place the results in descending order.
SELECT ser_date, COUNT(sid) AS number_of_services
FROM ser_det_table
GROUP BY ser_date
ORDER BY number_of_services DESC;

---
-- Q.39 Display the service details of those customer who belong from same city.
SELECT s.*
FROM ser_det_table s
JOIN customer_table c1 ON s.cid = c1.cid
WHERE c1.cadd IN (
    SELECT cadd FROM customer_table GROUP BY cadd HAVING COUNT(*) > 1
);

---
-- Q.40 write a query join customers table to itself to find all pairs of customers serviced by a single employee.
SELECT DISTINCT c1.cname AS customer1, c2.cname AS customer2, s1.eid AS employee_id
FROM ser_det_table s1
JOIN ser_det_table s2 ON s1.eid = s2.eid AND s1.cid < s2.cid
JOIN customer_table c1 ON s1.cid = c1.cid
JOIN customer_table c2 ON s2.cid = c2.cid;

---
-- Q.41 List each service number follow by name of the customer who made that service.
SELECT s.sid, c.cname
FROM ser_det_table s
JOIN customer_table c ON s.cid = c.cid;

---
-- Q.42 Write a query to get details of employee and provide rating on basis of maximum services provide by employee. (A,B,C,D).
WITH ServiceCounts AS (
    SELECT eid, COUNT(*) as service_count
    FROM ser_det_table
    GROUP BY eid
)
SELECT e.ename, e.ejob, sc.service_count,
    CASE
        WHEN sc.service_count >= 3 THEN 'A'
        WHEN sc.service_count = 2 THEN 'B'
        WHEN sc.service_count = 1 THEN 'C'
        ELSE 'D'
    END as rating
FROM employee_table e
LEFT JOIN ServiceCounts sc ON e.eid = sc.eid;


---
-- Q.43 Write a query to get maximum service amount of each customer with their customer details.
SELECT c.*, MAX(s.total) as max_service_amount
FROM customer_table c
JOIN ser_det_table s ON c.cid = s.cid
GROUP BY c.cid, c.cname, c.cadd, c.contact, c.creditdays, c.date, c.gender;

---
-- Q.44 Get the details of customers with his total no of services.
SELECT c.*, COUNT(s.sid) AS total_services
FROM customer_table c
LEFT JOIN ser_det_table s ON c.cid = s.cid
GROUP BY c.cid, c.cname, c.cadd, c.contact, c.creditdays, c.date, c.gender;

---
-- Q.45 From which location sparpart purchased with highest cost?
SELECT v.vadd
FROM vendor_table v
JOIN purchase_table p ON v.vid = p.vid
WHERE p.sprate = (SELECT MAX(sprate) FROM purchase_table);

---
-- Q.46 Get the details of employee with their service details who has salary is null.
SELECT e.ename, e.ejob, s.*
FROM employee_table e
JOIN ser_det_table s ON e.eid = s.eid
WHERE e.esal IS NULL;

---
-- Q.47 find the sum of purchase location wise.
SELECT v.vadd, SUM(p.total) AS total_purchase_amount
FROM vendor_table v
JOIN purchase_table p ON v.vid = p.vid
GROUP BY v.vadd;

---
-- Q.48 write a query sum of purchase amount in word location wise?
-- Oracle specific function to convert number to words.
SELECT v.vadd, SUM(p.total) as total_amount, TO_CHAR(TO_DATE(SUM(p.total),'j'), 'JSP') as amount_in_words
FROM vendor_table v
JOIN purchase_table p ON v.vid = p.vid
GROUP BY v.vadd;

---
-- Q.49 Has the customer who has spent the largest amount money has been give highest rating.
-- Assumption: Rating is based on total spend. A=Highest. This query checks if the top spender has an 'A' rating.
WITH CustomerSpending AS (
    SELECT cid, SUM(total) as total_spent
    FROM ser_det_table
    GROUP BY cid
),
CustomerRating AS (
    SELECT cid, total_spent,
        CASE
            WHEN DENSE_RANK() OVER (ORDER BY total_spent DESC) = 1 THEN 'A'
            WHEN DENSE_RANK() OVER (ORDER BY total_spent DESC) <= 3 THEN 'B'
            ELSE 'C'
        END as rating
    FROM CustomerSpending
)
SELECT c.cname, cr.total_spent, cr.rating
FROM CustomerRating cr
JOIN customer_table c ON cr.cid = c.cid
ORDER BY cr.total_spent DESC;

---
-- Q.50 select the total amount in service for each customer for which the total is greater than the amount of the largest service amount in the table.
SELECT c.cname, SUM(s.total) as customer_total_service_amount
FROM customer_table c
JOIN ser_det_table s ON c.cid = s.cid
GROUP BY c.cname
HAVING SUM(s.total) > (SELECT MAX(total) FROM ser_det_table);

---
-- Q.51 List the customer name and sparepart name used for their vehicle and vehicle type.
SELECT c.cname, sp.spname, s.type_veh
FROM ser_det_table s
JOIN customer_table c ON s.cid = c.cid
JOIN sparepart_table sp ON s.spid = sp.spid;

---
-- Q.52 Write a query to get spname, ename, cname, quantity, rate, service amount for record exist in service table.
SELECT sp.spname, e.ename, c.cname, s.qty, s.sp_rate, s.ser_amt
FROM ser_det_table s
JOIN sparepart_table sp ON s.spid = sp.spid
JOIN employee_table e ON s.eid = e.eid
JOIN customer_table c ON s.cid = c.cid;

---
-- Q.53 specify the vehicles owners who’s tube damaged.
SELECT DISTINCT c.cname
FROM customer_table c
JOIN ser_det_table s ON c.cid = s.cid
WHERE s.typ_ser = 'TUBE DAMAGED';

---
-- Q.54 Specify the details who have taken full service.
SELECT c.cname, c.cadd, s.veh_no, s.ser_date
FROM customer_table c
JOIN ser_det_table s ON c.cid = s.cid
WHERE s.typ_ser = 'FULL SERVICING';

---
-- Q.55 Select the employees who have not worked yet and left the job.
-- "Not worked yet" is ambiguous. Assuming this means employees who have left (edol is not null) but have no services recorded.
SELECT e.ename
FROM employee_table e
WHERE e.edol IS NOT NULL AND e.eid NOT IN (SELECT eid FROM ser_det_table);

---
-- Q.56 Select employee who have worked first ever.
-- Based on earliest service date.
SELECT e.ename
FROM employee_table e
JOIN ser_det_table s ON e.eid = s.eid
WHERE s.ser_date = (SELECT MIN(ser_date) FROM ser_det_table);

---
-- Q.57 Display all records falling in odd date.
-- Assuming 'date' refers to the day of the month.
SELECT * FROM ser_det_table WHERE MOD(TO_NUMBER(TO_CHAR(ser_date, 'DD')), 2) != 0;

---
-- Q.58 Display all records falling in even date.
SELECT * FROM ser_det_table WHERE MOD(TO_NUMBER(TO_CHAR(ser_date, 'DD')), 2) = 0;

---
-- Q.59 Display the vendors whose material is not yet used.
SELECT v.vname
FROM vendor_table v
JOIN purchase_table p ON v.vid = p.vid
WHERE p.spid NOT IN (SELECT spid FROM ser_det_table);

---
-- Q.60 Difference between purchase date and used date of spare part.
SELECT s.sid, sp.spname, s.ser_date - p.pdate AS days_difference
FROM ser_det_table s
JOIN purchase_table p ON s.spid = p.spid
JOIN sparepart_table sp ON s.spid = sp.spid;