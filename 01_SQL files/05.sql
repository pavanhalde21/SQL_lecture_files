
-- 1  SYSDATE
-- 2 CURRENT_DATE
-- 3 CURRENT_TIMESTAMP
-- 4 SYSTIMESTAMP
-- 5 LOCALTIMESTAMP
-- 6 ADD_MONTHS
-- 7 MONTHS_BETWEEN
-- 8 NEXT_DAY()
-- 9 LAST_DAY()
-- 10 EXTRACT
-- 11 To_char
-- 12 TO_DATE 
-- 13 GREATEST
-- 14 LEAST
-- 15 ROUND
-- 16 TRUNC



-----------------------------------------------------------------------------------------------------------------------------
-- 1  SYSDATE: it returns the date of "system" in oracle date format
SELECT SYSDATE FROM DUAL;  --mm/dd/yyyy hh:mm:ss am/pm

-- 2 CURRENT_DATE: it returns current date of "server/sessions timezone"
SELECT CURRENT_DATE FROM DUAL;  --mm/dd/yyyy hh:mm:ss am/pm
--in actual scenerio the database may be located any where.
--ex:you may be using America based server

-- 3 CURRENT_TIMESTAMP: it returns current timestamp with active time zone information 
SELECT CURRENT_TIMESTAMP FROM DUAL;  --dd-mon-yy hh.mm.ss.xxxxx am/pm timezone

-- 4 SYSTIMESTAMP: this returns the sysdate, including fractional seconds and timezone
SELECT SYSTIMESTAMP FROM DUAL;   --dd-mon-yy hh.mm.ss.xxxxx am/pm timezone

-- 5 LOCALTIMESTAMP: this will return local timestamp with active timezone infromation 
SELECT LOCALTIMESTAMP FROM DUAL;  --dd-mon-yy hh.mm.ss.xxxxx am/pm 

-- 6 ADD_MONTHS: it is used to 'add or remove no. of months' from specified date
SELECT ADD_MONTHS(SYSDATE,5) FROM DUAL;
SELECT ADD_MONTHS(SYSDATE,-2) FROM DUAL;
SELECT ADD_MONTHS(to_date('1-jan-2010'),5) FROM DUAL; --default date format
SELECT ADD_MONTHS(to_date('01-02-2010','dd-mm-yyyy'),-2) FROM DUAL;
SELECT ADD_MONTHS(to_date('27/02/2010','dd/mm/yyyy'),5) FROM DUAL;
SELECT ADD_MONTHS(hire_date,12) FROM Hr.employees;

-- 7 MONTHS_BETWEEN: it is used to give the difference between two dates
SELECT MONTHS_BETWEEN(to_date('27/02/2010','dd/mm/yyyy'),to_date('20/03/2009','dd/mm/yyyy'))"months" 
FROM DUAL;
SELECT MONTHS_BETWEEN(to_date('1-jan-2010'),to_date('1-feb-2010')) "months" FROM DUAL;
SELECT MONTHS_BETWEEN(to_date('1-jan-2010'),to_date('1-feb-2010'))/12 "yrs"FROM DUAL;
SELECT MONTHS_BETWEEN(to_date('1-jan-2020'),to_date('1-feb-2010'))/12 "yrs"FROM DUAL;
SELECT MONTHS_BETWEEN('1-jan-2010','1-feb-2010')/12 "yrs"FROM DUAL;--observe date formats

SELECT TRUNC(MONTHS_BETWEEN(to_date('1-jan-2020'),to_date('1-feb-2010'))/12) "yrs"FROM DUAL;

-- 8 NEXT_DAY()
SELECT next_day('13/april/2020','thursday') from dual;
--weekely execute something??

-- 9 LAST_DAY()
SELECT last_day(SYSDATE) FROM DUAL;
SELECT last_day('12/mar/2020') FROM DUAL;

-- 10 EXTRACT: this is used to extract a portion of the date value.
-- SYNTAX -- EXTRACT(YEAR/MONTH/DAY/HOUR/MINUTE) FROM DUAL ;
SELECT EXTRACT(YEAR FROM SYSDATE) "year" FROM DUAL;--double inverted comma "" why??
SELECT EXTRACT(MONTH FROM SYSDATE) "MONTH" FROM DUAL;
SELECT EXTRACT(MONTH FROM hire_date) "MONTH" FROM employees;

-- 11 To_char: it is used to extract various date formates.
--the available date formates are:
D:- No. of days IN a week.
DD:- No. of days IN MONTHS
DDD:- No. of days IN YEAR
MM:- No. of MONTHS
MON:- three letter abbreviation of MONTH
MONTH:- fully spelled out MONTH
DY:- three letter abbreviation of DAY
DAY:- fully spelled out DAY
Y:- last one digit of YEAR
YY:- last two digits of YEAR
YYY:- last three digits of year
YYYY:- last four digits of year
SYYYY:-signed year
IYYY:-four digit year form iso standard 
Y,YYY:-year with comma
YEAR:-fully spelled out year
CC:-centuri
W:-no. of weeks in a month
HH:- hours
MI:- minutes
SS:- seconds
TH:- suffix to a number
FF:- fraction of second
--SYNTAX -- TO_CHAR(DATE,FORMAT);
--Ex:
         SELECT sysdate,to_char(SYSDATE,'DAY/MONTH/YEAR') FROM DUAL;
         SELECT to_char(SYSDATE,'MONTH') FROM DUAL;
         SELECT to_char(SYSDATE,'MON') FROM DUAL;
         SELECT to_char(hire_date,'DAY/YYYY') FROM employees;
         
--display the employee who are joined in december month from employees table
SELECT * FROM employees WHERE to_char(hire_date,'MON') = 'DEC';


-- 12 TO_DATE : it is used to convert string date into oracle date format
SELECT to_date('27/march/2020') FROM DUAL;
--to add five days from sysdate
SELECT to_date(SYSDATE)+5 FROM DUAL;

-- 13 GREATEST
SELECT GREATEST(DATE'2020-01-01',DATE'2021-01-01') FROM DUAL;
-- 14 LEAST
SELECT LEAST(DATE'2020-01-01',DATE'2021-01-01') FROM DUAL; 
--------------------------------------------------------------------------------------------------
--15 ROUND: it rounds the date to which it was equal to or greater than the given date
--SYNTAX: ROUND(DATE,(DATE/MONTH/YEAR));

/* rules for ROUND in date function 
1) if the second parameter is "year" then round will check the month of the given date
in the following ranges:

                           JAN ---- JUN
                           JUL ---- DEC
                           
--if the months fall between JAN and JUN then it returns the first day of the current year.
--if the months fall between JUL and DEC then it returns the first day of the next year. */
SELECT ROUND(SYSDATE,'year'), ROUND(to_date('24/JUL/2004'),'year'),ROUND(to_date('11/JUN/2006'),'year') FROM DUAL;

/* 2) if the second paremeter was month then ROUND will check the day of the given date 
in the following ranges:
                              1 -- 15
                             16 -- 31
--if the day falls between 1 and 15 then it returns the first day of the current month
--if the day falls between 16 and 31 then it returns the first day of the next month */
SELECT SYSDATE, ROUND(to_date('24/JUL/2004'),'month'),ROUND(to_date('11/JUN/2006'),'month') FROM DUAL;
 
/* 3) if the second paremeter was a day then ROUND will check the week day of the given date 
in the following ranges:
                              SUN -- WED
                             THUR -- SAT
--if the day falls between SUN and WED then it returns the previous sunday
--if the day falls between THUR and SAT then it returns the next sunday */
SELECT SYSDATE, ROUND(to_date('24/JUL/2004'),'day'),ROUND(to_date('11/JUN/2006'),'day') FROM DUAL;


/* 4) if the second parameter is null then it returns nothing */

/*### 5)if you do not specify the second parameter then round will reset the time to the beginning 
of the day in case of user specified date */

/*### 6)if you are not specifying the second parameter then round will reset the time to the beginning 
of the next day in case of sysdate */

-------------------------------------------------------------------------------------------------

-- 16 TRUNC : will chop off the date to which it was equal to or less than the given date
--SYNTAX : TRUNC(DATE,(DAY/MONTH/YEAR));
--rules for TRUNC in date function:
/*
1) if the second parameter is the YEAR then TRUNC returns first day of the current year.
2) if the second parameter is the MONTH then TRUNC returns first day of the current month.
3) if the second parameter is the DAY then TRUNC returns the previous sunday.
4) if the second parameter was NULL then TRUNC returns the same date.
5) if you  not specify the second parameter then TRUNC will reset time to the beginning 
of the current date
*/

SELECT TRUNC(to_date('24/dec/2004'),'year'), TRUNC(to_date('11/mar/2006'),'year') FROM DUAL;
SELECT TRUNC(to_date('11/jan/2004'),'MONTH'), TRUNC(to_date('18/jan/2004'),'MONTH') FROM DUAL;
SELECT TRUNC(to_date('26/dec/2006'),'DAY'), TRUNC(to_date('29/dec/2006'),'DAY') FROM DUAL;
SELECT CURRENT_DATE, TRUNC(to_date('24/dec/2004')), TRUNC(to_date('11/mar/2006')) FROM DUAL;

-- NEW_TIME: this will give the desired timezone's date and time






