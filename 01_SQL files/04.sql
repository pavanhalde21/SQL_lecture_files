---STRING FUNCTION
-- 1 UPPER()
-- 2 LOWER()
-- 3 INITCAP()
-- 4 LENGTH() 
-- 5 SUBSTR()
-- 6 INSTR()
-- 7 TRANSLATE()
-- 8 REPLACE()
-- 9 RTRIM()
-- 10 LTRIM()
-- 11 TRIM()
-- 12 LPAD() and RPAD()
-- 13 CHR() and ASCII()
-- 14 -- || = CONCAT OPERATOR 
-- 15 LISTAGG


-------STRING FUNCTION-------

-- 1 UPPER() 
SELECT first_name, UPPER(first_name) FROM Hr.employees;--converts into capital letters

-- 2 LOWER() 
SELECT first_name, LOWER(first_name) FROM Hr.employees;--converts into small letters

-- 3 INITCAP() 
SELECT INITCAP('xyz') FROM DUAL;--first letter capital others small
SELECT INITCAP('XYZ') FROM DUAL;--first letter capital others small
SELECT INITCAP('this is a test') FROM DUAL;--first letter of each word becomes capital letter

-- 4 LENGTH() 
SELECT first_name, LENGTH(first_name) FROM Hr.employees;
--if we had used CHAR(20) while creating first_name column
--then the length would have been 20 for each record

-- 5 SUBSTR()
--   SUBSTR (string, start_position [, length])
SELECT SUBSTR('This is a Test', 6,2) AS "SUBSTRING" FROM DUAL;
SELECT SUBSTR('This is a Test', 1) AS "SUBSTRING" FROM DUAL;--shows whole sentence
SELECT SUBSTR('This is a Test', 6) AS "SUBSTRING" FROM DUAL;
SELECT SUBSTR('This is a Test', -9,6) AS "SUBSTRING" FROM DUAL;--counting starts from end
SELECT SUBSTR('This is a Test', -9,-5) AS "SUBSTRING" FROM DUAL;--null value
SELECT SUBSTR('This is a Test', 9,-5) AS "SUBSTRING" FROM DUAL;--null value
SELECT SUBSTR('This is a Test', -6) AS "SUBSTRING" FROM DUAL;
SELECT SUBSTR('This is a Test', -1) AS "SUBSTRING" FROM DUAL;
SELECT SUBSTR('This is a Test', -1,-3) AS "SUBSTRING" FROM DUAL;--null
SELECT SUBSTR('This is a Test', 0,2) AS "SUBSTRING" FROM DUAL;--
SELECT SUBSTR('This is a Test', 1,2) AS "SUBSTRING" FROM DUAL;-- 1 means start from first letter 
SELECT first_name, SUBSTR(first_name, 1,2) AS "SUBSTRING" FROM Hr.employees;
SELECT SUBSTR('9112471660',8 ) AS "SUBSTRING" FROM DUAL;

-- 6 INSTR()
SELECT INSTR('This is a Test','is') FROM DUAL;--searches for first occurance
SELECT INSTR('This is a Test','is',1,2) FROM DUAL;--searches for secound occurance
SELECT INSTR('This is a Test','is',1,3) FROM DUAL;--searches for third occurance (gives 0 )
SELECT INSTR('This is a Playlist','is',1,3) FROM DUAL;--searches for third occurance
SELECT INSTR('This is a Playlist','is',-1) FROM DUAL;--searches from backward (but gives the indexing from forward)
SELECT INSTR('This is a Playlist','is',-1,2) FROM DUAL;
SELECT INSTR('This is a Playlist','is',-3,2) FROM DUAL;--searches from 3rd letter from backward but gives the number from forward
SELECT INSTR('Hi, How is you Haland? ','H',2,2) FROM DUAL;--searches for secound 'H' after second letter
SELECT INSTR('Hi, How is you Haland? Ha ','H',3,2) FROM DUAL;---observe carefully it's correct
SELECT INSTR('Hi, How is you Haland? Ha Ha ','H',11,3) FROM DUAL;---observe carefully it's correct

-- 7 TRANSLATE()
-- replaces character by character
SELECT TRANSLATE('1tech23','123','456') FROM DUAL;
SELECT TRANSLATE('1tech23','123',9) FROM DUAL;

SELECT TRANSLATE('1tech23','123','45') FROM DUAL;
SELECT TRANSLATE('1tech2a3','123','45') FROM DUAL;

SELECT TRANSLATE('222tech','2ec','456') FROM DUAL;
SELECT TRANSLATE('2tech','2','4') FROM DUAL;

-- 8 REPLACE()
-- replaces substring with another string
SELECT REPLACE('123123tech','123','456') FROM DUAL;
SELECT REPLACE('123tech123','123') FROM DUAL;
SELECT REPLACE('12312tech3','123','456') FROM DUAL; -- observe result
SELECT REPLACE('123tech321','123') FROM DUAL;
SELECT REPLACE('123tech321','te','pavan') FROM DUAL;


-- 9 RTRIM()
SELECT 'tech   ', RTRIM('tech   '), LENGTH('tech   '), length(RTRIM('tech   ')) FROM DUAL; -- space is removed
SELECT RTRIM('tech   ',''),LENGTH('tech   '), length(RTRIM('tech   ','')) FROM DUAL; 
SELECT RTRIM('tech   ',0),LENGTH('tech   '), length(RTRIM('tech   ',0)) FROM DUAL;
SELECT RTRIM('tech000',0), length(RTRIM('tech000',0)) FROM DUAL;
SELECT RTRIM('123tech123',123), length(RTRIM('123tech123',123)) FROM DUAL; -- removes only from right side
SELECT RTRIM('123tech321',123), length(RTRIM('123tech321',123)) FROM DUAL; -- observe
SELECT RTRIM('techxyxzy','xyz'), length(RTRIM('techxyxzy','xyz')) FROM DUAL; -- observe
-- seems to work like translate. the thing is instead of replacing char with another char, it simple replaces with nothing.

-- 10 LTRIM()
SELECT '   tech', LTRIM('   tech'), LENGTH('   tech'),LENGTH(LTRIM('   tech')) FROM DUAL;
SELECT LTRIM('123tech123',123), length(RTRIM('123tech123',123)) FROM DUAL;
SELECT LTRIM('AAMACHIMUMBAI','AAMACH') FROM DUAL;--
SELECT LTRIM('AAMACHIMUMBAI','AAMACHI') FROM DUAL;--but what if i want to remove only aamchi???? (use replace)
--
SELECT REPLACE('aamchimumbai','aamchi') FROM DUAL;
SELECT REPLACE('aamchimumbaiaamchi','aamchi') FROM DUAL;
--but what if i want to remove aamchi from only left side? 

-- 11 TRIM()
SELECT '   tech   ', LTRIM('   tech   '), LENGTH('   tech   '),LENGTH(LTRIM('   tech   ')) FROM DUAL;
SELECT TRIM(' 'FROM '  tech'),LENGTH('  tech'),LENGTH(TRIM(' 'FROM '  tech')) FROM DUAL;
SELECT TRIM(LEADING 0 FROM '00012') FROM DUAL;
SELECT TRIM(TRAILING 'a' FROM 'techa') FROM DUAL;
SELECT TRIM(BOTH '1' FROM '1tech123111') FROM DUAL;-- observe

-- 12 LPAD() and RPAD()
SELECT LPAD('Oracle',2,'*') FROM DUAL;
SELECT LPAD('Oracle',6,'*') FROM DUAL;--
SELECT RPAD('Oracle',10,'*') FROM DUAL;
SELECT First_name, LPAD(First_name,10,'*') FROM Hr.employees;
SELECT First_name, RPAD(First_name,10,'*') FROM Hr.employees;
SELECT LPAD(SUBSTR('9112471660',8 ),10,'*') AS "SUBSTRING" FROM DUAL;

-- 13 CHR() and ASCII()
--The Oracle CHR() function converts an ASCII code
SELECT CHR(32) FROM DUAL;
SELECT ASCII(' ') FROM DUAL;

SELECT ASCII('a') FROM DUAL;
SELECT CHR(97) FROM DUAL;

SELECT ASCII(97) FROM DUAL;--
SELECT CHR(57) FROM DUAL;-- may be it works for char v/s int only.

-- 14 -- || = CONCAT OPERATOR 
SELECT first_name || '               ' || last_name  ||
CHR(32) || 'Joined on' || CHR(32) ||
to_date(hire_date,'DD-MM-YYYY') employees_dtl--
FROM
Hr.employees
ORDER BY
Hire_date;
--|| operator can join more than two strings


SELECT CONCAT('Happy','coding') FROM DUAL; -- CONCAT can join two strings only
SELECT CONCAT(CONCAT('Happy','coding'), 'together') FROM DUAL;-- to join 3 strings
SELECT CONCAT(CONCAT(first_name    ,Last_name    ),     employee_id)
FROM HR.EMPLOYEES;
SELECT CONCAT(CONCAT(CONCAT(first_name,Last_name    ),'     '),employee_id)
FROM HR.EMPLOYEES;

-- 15 LISTAGG()
SELECT department_id, LISTAGG(First_name, ', ') WITHIN GROUP (ORDER BY first_name) "Employee_Listing"
FROM Hr.employees e
GROUP BY department_id; 

/*  SELECT LISTAGG(First_name,Employee_id) WITHIN GROUP (ORDER BY first_name) "Employee_Listing"
FROM Hr.employees;
error  */


select trim(translate('xxx0x123x0xxx','x0','  ')) from dual;





select count(null) from dual;


