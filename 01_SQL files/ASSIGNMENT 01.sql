
SELECT* FROM customer2;
SELECT* FROM vendors2;
SELECT* FROM employees_table;
SELECT* FROM separepart_table;
SELECT* FROM purchase_table;
SELECT* FROM ser_det_table;


----------*Garage data System Questions.*������������------------------


--Q.1  List all the customers serviced.
SELECT CNAME FROM customer2 c
INNER JOIN ser_det_table s ON c.cid=s.cid;


SELECT CID,CNAME FROM CUSTOMER2
WHERE CID IN (SELECT CID FROM SER_DET_TABLE)


--Q.2  Customers who are not serviced.
select cname from customer2
minus
SELECT CNAME FROM customer2 c
INNER JOIN ser_det_table s ON c.cid=s.cid;

SELECT CID , CNAME FROM CUSTOMER2
WHERE CID NOT IN (SELECT CID FROM SER_DET_TABLE);


--Q.3  Employees who have not received the commission.
SELECT distinct ename FROM employees_table e
INNER JOIN ser_det_table s ON e.eid=s.eid
WHERE comm = 0;

SELECT EID,ENAME FROM EMPLOYEES_TABLE
WHERE EID IN (SELECT EID FROM SER_DET_TABLE WHERE COMM=0);


--Q.4  Name the employee who have maximum Commission.
SELECT DISTINCT  E.EID,E.ENAME,S.COMM FROM EMPLOYEES_TABLE E INNER JOIN SER_DET_TABLE S
ON E.EID=S.EID
WHERE S.COMM=(SELECT MAX(COMM) FROM SER_DET_TABLE);

SELECT EID,ENAME FROM EMPLOYEES_TABLE
WHERE EID IN (SELECT EID FROM SER_DET_TABLE 
WHERE COMM=(SELECT MAX(COMM) FROM SER_DET_TABLE));


--Q.5  Show employee name and minimum commission amount received by an employee.
SELECT DISTINCT  E.EID,E.ENAME,S.COMM FROM EMPLOYEES_TABLE E INNER JOIN SER_DET_TABLE S
ON E.EID=S.EID
WHERE S.COMM=(SELECT MIN(COMM) FROM SER_DET_TABLE);

SELECT EID,ENAME FROM EMPLOYEES_TABLE
WHERE EID IN (SELECT EID FROM SER_DET_TABLE 
WHERE COMM=(SELECT MIN(COMM) FROM SER_DET_TABLE));

--Q.6  Display the Middle record from any table.
SELECT * FROM SER_DET_TABLE
WHERE ROWNUM <=4
MINUS
SELECT * FROM SER_DET_TABLE
WHERE ROWNUM<=3;
--------------------
SELECT * FROM SER_DET_TABLE
WHERE ROWNUM < (SELECT COUNT(ROWNUM)/2+1 FROM SER_DET_TABLE)
MINUS
SELECT * FROM SER_DET_TABLE
WHERE ROWNUM<(SELECT COUNT(ROWNUM)/2 FROM SER_DET_TABLE);

(SELECT * FROM HR.EMPLOYEES
MINUS
SELECT * FROM HR.EMPLOYEES
WHERE ROWNUM < (SELECT (COUNT(*)/2) FROM HR.EMPLOYEES))
MINUS
(SELECT * FROM (SELECT * FROM HR.EMPLOYEES
ORDER BY ROWNUM DESC)
WHERE ROWNUM < (SELECT (COUNT(*)/2) FROM HR.EMPLOYEES));

SELECT * FROM(SELECT ROW_NUMBER() OVER (order by employee_id) rn, e.* FROM hr.employees e)
WHERE rn = (SELECT ROUND(count(*)/2) FROM hr.employees);



--Q.7  Display last 4 records of any table.
SELECT ROWNUM,E.* FROM EMPLOYEES_TABLE E
MINUS
SELECT ROWNUM,E.* FROM EMPLOYEES_TABLE E
WHERE ROWNUM<3;

SELECT * FROM 
(SELECT E.*,ROW_NUMBER() OVER( ORDER BY ROWNUM DESC) RN FROM EMPLOYEES_TABLE E)
WHERE RN<=4;

WITH LAST_4_EMP 
AS (SELECT E.*,ROW_NUMBER() OVER( ORDER BY ROWNUM DESC) RN FROM EMPLOYEES_TABLE E)
SELECT * FROM LAST_4_EMP
WHERE RN<=4;

SELECT * FROM (SELECT * FROM hr.employees ORDER BY employee_id desc)
WHERE ROWNUM <= 4;


--Q.8  Count the number of records without count function from any table.
SELECT MAX(ROWNUM) FROM (SELECT * FROM EMPLOYEES_TABLE);

WITH COUNT_EMP AS
 (SELECT * FROM EMPLOYEES_TABLE)
SELECT MAX(ROWNUM) FROM COUNT_EMP;

SELECT 
SUM(DECODE(eid,eid,1,0))
FROM employees_table;

SELECT COUNT(eid) FROM employees_table;


--*Q.9  Delete duplicate records from "Ser_det" table on cid.(note Please rollback after execution).
SELECT * FROM SER_DET_TABLE S
WHERE ROWID !=(SELECT MIN(ROWID) FROM SER_DET_TABLE S1 WHERE S.CID=S1.CID);

rollback
select * from ser_det_table;

--Q.10 Show the name of Customer who have paid maximum amount 
SELECT C.CNAME,S.SP_AMT FROM CUSTOMER C JOIN SER_DET S
ON C.CID=S.CID
WHERE SP_AMT=(SELECT MAX(SP_AMT) FROM SER_DET)

SELECT name FROM customers
WHERE credit_limit = (SELECT MAX(credit_limit) FROM CUSTOMERS);

SELECT count(*) FROM(SELECT name FROM customers
WHERE credit_limit = (SELECT MAX(credit_limit) FROM CUSTOMERS));

--Q.11 Display Employees who are not currently working.
SELECT * FROM EMPLOYEES_TABLE
WHERE edol is not null;

--Q.12 How many customers serviced their two wheelers.
SELECT count(cid) FROM ser_det_table
WHERE typ_veh = 'two wheeler' and typ_ser = 'full servicing';
select current_date from dual;


--Q.13 List the Purchased Items which are used for Customer Service with Unit of that Item.
SELECT DISTINCT S.SPNAME FROM ser_det_table t 
INNER JOIN separepart_table s
ON s.spid = t.spid;

SELECT DISTINCT SPNAME FROM separepart_table 
WHERE spid IN (SELECT spid from ser_det_table);

--Q.14 Customers who have Colored their vehicles.
SELECT c.cid,cname FROM ser_det_table s inner join customer2 c on s.cid = c.cid
WHERE typ_ser = 'color';



--Q.15 Find the annual income of each employee inclusive of Commission
SELECT e.ename, e.eid, (e.esal+(s.comm)*(e.esal))
FROM employees_table e 
INNER JOIN ser_det_table s ON s.eid = e.eid;


--Q.16 Vendor Names who provides the engine oil.
SELECT vname, v.vid, p.spid, s.spname FROM purchase_table p INNER JOIN separepart_table s on s.spid = p.spid
INNER JOIN vendors2 v on p.vid = v.vid 
WHERE s.spname like '%engine oil%' ;

--Q.17 Total Cost to purchase the Color and name the color purchased.
SELECT sum(sprate) FROM separepart_table t INNER JOIN ser_det_table s
ON t.spid=s.spid 
WHERE typ_ser = 'color';


--Q.18 Purchased Items which are not used in "Ser_det".
SELECT distinct p.spid, spname  FROM purchase_table p
inner join separepart_table s1 on p.spid=s1.spid
MINUS
SELECT distinct p.spid, spname  FROM purchase_table p
inner join ser_det_table s on p.spid = s.spid
inner join separepart_table s1 on p.spid=s1.spid;


--Q.19 Spare Parts Not Purchased but existing in Sparepart
SELECT distinct spid, spname FROM separepart_table
MINUS
SELECT distinct S1.spid, spname  FROM purchase_table p
inner join separepart_table s1 on p.spid=s1.spid

SELECT spid FROM separepart_table 
WHERE spid NOT IN (SELECT spid FROM purchase_table)

--Q.20 Calculate the Profit/Loss of the Firm. Consider one month salary of each employee for Calculation.
SELECT (SUM(s.total)-(sum(esal)+sum(p.total))) profit_loss FROM employees_table e, purchase_table p, ser_det_table s

--Q.21 Specify the names of customers who have serviced their vehicles more than one time.
SELECT cname FROM customer2 
WHERE cid = (SELECT cid FROM ser_det_table GROUP BY cid HAVING count(cid)>1)

--Q.22 List the Items purchased from vendors locationwise.
SELECT s.spname, v.vadd FROM purchase_table p
INNER JOIN separepart_table s ON p.spid = s.spid
INNER JOIN vendors2 v ON v.vid = p.vid;


--Q.23 Display count of two wheeler and four wheeler from ser_details
SELECT SUM(DECODE(TYP_VEH,'two wheeler',1,0)) TWO_WHEELER, 
SUM(DECODE(TYP_VEH,'four wheeler',1,0)) four_WHEELER
FROM ser_det_table;

SELECT COUNT(*),TYP_VEH FROM SER_DET
GROUP BY TYP_VEH;

--��������Q.24 Display name of customers who paid highest SPGST and for which item 
SELECT c.cname,s1.spname FROM ser_det_table s
INNER JOIN customer2 c ON c.cid=s.cid
INNER JOIN purchase_table p ON s.spid=p.spid
INNER JOIN separepart_table s1 ON s1.spid=s.spid
WHERE p.spgst = (SELECT max(spgst) FROM purchase_table)


--Q.25 Display vendors name who have charged highest SPGST rate for which item
SELECT vname, spname FROM purchase_table p
INNER JOIN separepart_table s ON s.spid=p.spid
INNER JOIN vendors2 v ON v.vid=p.vid
WHERE p.spgst = (SELECT max(spgst) FROM purchase_table);

SELECT vname,spname FROM (SELECT * FROM purchase_table
WHERE spgst = (SELECT max(spgst) FROM purchase_table)) a
INNER JOIN vendors2 v ON v.vid = a.vid
INNER JOIN separepart_table s ON a.spid = s.spid;

--Q.26   list name of item and employee name who have received item 
SELECT ename,spname FROM ser_det_table s 
INNER JOIN employees_table e ON e.eid=s.eid
INNER JOIN separepart_table s1 ON s1.spid=s.spid;

--Q.27 Display the Name and Vehicle Number of Customer who serviced his vehicle, 
       --And Name the Item used for Service, And specify the purchase date of that Item with his vendor 
       --and Item Unit and Location,     
SELECT c.cname,s.veh_no,s1.spname,p.pqty,p.pdate,v.vadd FROM ser_det_table s
INNER JOIN customer2 c ON s.cid=c.cid
INNER JOIN separepart_table s1 ON s1.spid=s.spid
INNER JOIN purchase_table p ON p.spid=s.spid
INNER JOIN vendors2 v ON v.vid=p.vid

--Q.28 who belong this vehicle  MH-14PA335" Display the customer name 
SELECT cname FROM ser_det_table s
INNER JOIN customer2 c ON c.cid=s.cid
WHERE veh_no = 'mh14pa335';

--Q.29 Display the name of customer who belongs to New York and when he /she service their 
       --vehicle on which date 
SELECT ser_date, cname FROM customer2 c
INNER JOIN ser_det_table s ON   c.cid=s.cid
WHERE cadd = 'new york';
        
--Q.30 from whom we have purchased items having maximum cost?
SELECT vname FROM (SELECT * FROM purchase_table
WHERE total = (SELECT max(total) FROM purchase_table)) p
INNER JOIN vendors2 v ON p.vid=v.vid;

SELECT vname FROM purchase_table p
INNER JOIN vendors2 v ON p.vid=v.vid
WHERE p.total = (SELECT max(total) FROM purchase_table)


--Q.31 Display the names of employees who are not working as Mechanic and that employee done services.
SELECT distinct ename FROM (SELECT * FROM employees_table
WHERE ejob != 'mechanic') e
INNER JOIN ser_det_table s ON e.eid = s.eid;

SELECT distinct ename FROM employees_table e
INNER JOIN ser_det_table s ON s.eid=e.eid
WHERE ejob != 'mechanic'

--Q.32 Display the various jobs along with total number of employees in each job. The output should
      --contain only those jobs with more than two employees.
SELECT distinct ejob FROM (SELECT COUNT(1) OVER(PARTITION BY ejob) a , ejob FROM employees_table)
WHERE a >= 2;     
      
--Q.33 Display the details of employees who done service  and give them rank according to their
      --no. of services.       
SELECT distinct(count(*) OVER(partition by s.eid)) a,s.eid,ename FROM ser_det_table s
INNER JOIN employees_table e ON e.eid=s.eid;
      
--Q.34 Display those employees who are working as Painter and fitter and who provide service 
    --and total count of service done by fitter and painter 
SELECT distinct(count(*) over(partition by s.eid)),ename FROM (SELECT eid,ename FROM employees_table
WHERE ejob = 'painter' OR ejob ='fitter') a 
INNER JOIN ser_det_table s ON a.eid=s.eid    
     
--Q.35 Display employee salary and as per highest  salary provide Grade to employee 


--Q.36  display the 4th record of emp table without using group by and rowid
SELECT * FROM employees_table
WHERE ROWNUM <= 4
MINUS
SELECT * FROM employees_table
WHERE ROWNUM <= 3;

--Q.37 Provide a commission 100 to employees who are not earning any commission.


--Q.38 write a query that totals no. of services  for each day and place the results
      --in descending order
      
      
--Q.39 Display the service details of those customer who belong from same city 
select count(distinct(salary)) from hr.employees

--Q.40 write a query join customers table to itself to find all pairs of
      --customers service by a single employee
SELECT * FROM customer a
INNER JOIN customer b ON 

--Q.41 List each service number follow by name of the customer who
      --made  that service
SELECT SID, CNAME FROM CUSTOMER2 c
INNER JOIN ser_det_table s ON  c.cid=s.cid;     
      
--Q.42 Write a query to get details of employee and provide rating on basis of  
       --maximum services provide by employee. Note (rating should be like A,B,C,D)
SELECT       
       
--Q.43 Write a query to get maximum service amount of each customer with their customer details ?
SELECT distinct c.cid, total,c.* FROM customer2 c 
INNER JOIN ser_det_table s ON s.cid=c.cid;

--Q.44 Get the details of customers with his total no of services ?
SELECT distinct c.cid, total,c.* FROM customer2 c 
INNER JOIN ser_det_table s ON s.cid=c.cid;

--Q.45 From which location sparpart purchased  with highest cost ?
SELECT vadd, a.* FROM (SELECT vid FROM purchase_table
WHERE sparate = (SELECT MAX(SPARATE) FROM purchase_table)) a
INNER JOIN vendors2 v ON v.vid=a.vid; 
 

--Q.46 Get the details of employee with their service details who has salary is null
SELECT * FROM employees_table E
INNER JOIN ser_det_table s ON e.eid=s.eid
WHERE ESAL IS NULL;

--Q.47 find the sum of purchase location wise 
SELECT DISTINCT(SUM(p.total) OVER (PARTITION BY VADD ORDER BY VADD)) TOTAL , vadd FROM purchase_table p
INNER JOIN vendors2 v ON  p.vid=v.vid ;


--Q.48 write a query sum of purchase amount in word location wise?



--Q.49 Has the customer who has spent the largest amount money has
      --been give highest rating
      

      
--Q.50 select the total amount in service for each customer for which
       --the total is greater than the amount of the largest service amount in the table
       


--Q.51  List the customer name and sparepart name used for their vehicle and  vehicle type



--Q.52 Write a query to get spname ,ename,cname quantity ,rate ,service amount for 
       --record exist in service table 
       
       
       
--Q.53 specify the vehicles owners who’s tube damaged.



--Q.54 Specify the details who have taken full service.



--Q.55 Select the employees who have not worked yet and left the job.



--Q.56  Select employee who have worked first ever.



--Q.57 Display all records falling in odd date



--Q.58 Display all records falling in even date



--Q.59 Display the vendors whose material is not yet used.



--Q.60 Difference between purchase date and used date of spare part.








