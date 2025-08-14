
-- some theoretical notes are skipped(refer w3 schools)

select * from stu_info1;

insert into stu_info1 values (156,'abc',45612385,to_date('11-05-2000','dd-mm-yyyy'));

select * from stu_info1 where name = 'abc';

create table persons4
(
 id int primary key,
 lastname varchar(255) not null,
 firstname varchar(255) not null,
 age int,
 city varchar(255) default 'pune'
);

-- Primary Key : uniquely identifies each record in a table as well as does not allow null value

insert into persons4( ide, lastname, name, age) values ( 01, 'abc', 'sum', 22 );
select * from persons4;
select * from order02;

alter table order02 
modify city default 'mumbai' -- used to edit constraints

alter table order02 
modify city unique

TRUNCATE TABLE persons4;

create table order08
(
orderid int primary key, 
ordernumber int not null,
ide int ,
foreign key (ide) references persons4(ide)
);

alter table order02
modify city default null;

select * from persons4;
select * from order08;

insert into order08 values (123,450,28938); -- integrity constraint error as 28938 is not present in parent table

insert into order08 values (15,45,11);

create table persons7
(
ide int primary key,
lastname varchar(255) not null,
firstname varchar(255) not null,
age int check (age>=18),
collegename varchar2(255) default 'cvb'
);

select * from persons7;
insert into persons7 values (7, 'asd', 'ghj',16,'ssa');  -- check constraint violeted

insert into persons8 values (6, 'asd', 'ghj',55,'ssa');


create table persons8
(
ide int primary key,
lastname varchar2(255) not null,   -- null
firstname varchar(255) not null,
age int check (age>=18),               -- check
collegename varchar2(255) default 'cvb' --default
);

insert into persons8 values (6, 'asd', 'ghj',55,'ssa');



--NVL()   -- replaces null with some other value
select employee_id, first_name, last_name, job_id, salary, commission_pct,
(salary+nvl(commission_pct,0)) "total salary" -- gives value 0 to null values
from hr.employees;


--------------OBSERVE
SELECT * FROM HR.EMPLOYEES
WHERE ROWNUM=1;
--------------
----------------OBSERVE
SELECT *
FROM (SELECT first_name FROM HR.EMPLOYEES ORDER BY first_name)
WHERE ROWNUM=1;
------------------
SELECT first_name FROM HR.EMPLOYEES ORDER BY first_name
WHERE ROWNUM = 1;-- error because order by executes last 
-- WHERE executes before ORDER BY 


commit;
rollback;


DELETE FROM PERSONS7;
TRUNCATE TABLE PERSONS7;
/* Both of these statements would result in all data from the customers table being deleted.
The main difference between the two is that you can roll back the DELETE statement if you choose,
but you cannot roll back the TRUNCATE TABLE statement.
because DELETE IS DML STATEMENT
and TRUNCATE is DDL statement. DDL statements are auto commited*/



create table stu_info2
(
stu_id number(3,1) primary key,
name varchar2(30),
contact_no number,
dob date
);

INSERT INTO stu_info2 values(2,'a',789456,to_date('12-06-1999','dd-mm-yyyy'))
-- INSERT INTO stu_info2 values(2.11,'a',789456,'06-06-1999') -- error -- not a valid month
INSERT INTO stu_info2 values(33,'a',789456,'1-jan-2010') 

select * from stu_info2;

select first_name from hr.employees
where first_name like 'S%' OR first_name LIKE 'A%' OR first_name LIKE 'R%';

select first_name from hr.employees
where first_name like 'S%' OR first_name LIKE 'A%' OR first_name LIKE 'R%';

-- ORDER OF EXECUTION OF SQL QUERY
1. FROM
2. WHERE
3. GROUP BY 
4. HAVING
5. SELECT
6. ORDER BY
7. LIMIT


