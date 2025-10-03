
/*
Loops, Procedures, Functions
*** ***
*/

SET SERVEROUTPUT ON;

-- Question 1a
SELECT JobTitle, COUNT(EmployeeID)
FROM Employee
GROUP BY JobTitle;

/*Q1a Results
JOBTITLE                            COUNT(EMPLOYEEID)
----------------------------------- -----------------
VP Finance                                          1
Sales                                               3
VP Information                                      1
Chief Information Officer                           1
Chief Sales Officer                                 1
VP Operations                                       1
Accountant                                          2
President                                           1
DBA                                                 1
Chief Financial Officer                             1
Engineer                                            5
Programmer Analyst                                  2
Operations Officer                                  2
Assembly                                           18

14 rows selected. 
*/

--Question 1b
DECLARE
    v_number_employees  NUMBER;
    v_jobtitle          VARCHAR2(50) := '&v_jobtitle';
BEGIN
    SELECT COUNT(employeeID)
        INTO v_number_employees
    FROM employee
    WHERE jobtitle = v_jobtitle;

    IF v_number_employees < 1 THEN
        DBMS_OUTPUT.PUT_LINE('There are no employees with the Job Title: ' || v_jobtitle);
    ELSIF v_number_employees < 4 THEN
        DBMS_OUTPUT.PUT_LINE('There are between 1 and 3 employees with the Job Title: ' || v_jobtitle);
    ELSIF v_number_employees < 7 THEN
        DBMS_OUTPUT.PUT_LINE('There are between 4 and 6 employees with the Job Title: ' || v_jobtitle);
    ELSE
        DBMS_OUTPUT.PUT_LINE('There are 7 or more employees with the Job Title: ' || v_jobtitle);
    END IF;
END;

/* Q1b Results
There are no employees with the Job Title: CIO
*/


/* Question 1c results
There are between 1 and 3 employees with the Job Title: Accountant
*/

/* Question 1d results
There are between 4 and 6 employees with the Job Title: Engineer
*/

/* Question 1e results
There are 7 or more employees with the Job Title: Assembly
*/

-- Question 2a
DECLARE
    v_number_employees NUMBER;
    v_jobtitle VARCHAR2(50) := '&v_jobtitle';
BEGIN
    SELECT COUNT(employeeID)
        INTO v_number_employees
    FROM employee
    WHERE jobtitle = v_jobtitle;

    CASE v_number_employees
        WHEN 0 THEN
            DBMS_OUTPUT.PUT_LINE('There are no employees with the Job Title: ' || v_jobtitle);
        WHEN 1 THEN
            DBMS_OUTPUT.PUT_LINE('There are between 1 and 3 employees with the Job Title: ' || v_jobtitle);
        WHEN 2 THEN
            DBMS_OUTPUT.PUT_LINE('There are between 1 and 3 employees with the Job Title: ' || v_jobtitle);
        WHEN 3 THEN
            DBMS_OUTPUT.PUT_LINE('There are between 1 and 3 employees with the Job Title: ' || v_jobtitle);
        WHEN 4 THEN
            DBMS_OUTPUT.PUT_LINE('There are between 4 and 6 employees with the Job Title: ' || v_jobtitle);
        WHEN 5 THEN
            DBMS_OUTPUT.PUT_LINE('There are between 4 and 6 employees with the Job Title: ' || v_jobtitle);
        WHEN 6 THEN
            DBMS_OUTPUT.PUT_LINE('There are between 4 and 6 employees with the Job Title: ' || v_jobtitle);
        ELSE
            DBMS_OUTPUT.PUT_LINE('There are 7 or more employees with the Job Title: ' || v_jobtitle);
    END CASE;
END;
/*Q2a - Again noting
There are no employees with the Job Title: CIO
*/

/* Q2b Results
There are between 1 and 3 employees with the Job Title: Accountant
*/

/* Q2c Results 
There are between 4 and 6 employees with the Job Title: Engineer
*/

/*Q2d Results 
There are 7 or more employees with the Job Title: Assembly
*/

-- Question 3 
DECLARE
    v_number_employees  NUMBER;
    v_jobtitle          employee.jobtitle%TYPE := '&v_jobtitle';
    v_staff_level       VARCHAR2(100);
BEGIN
    SELECT COUNT(employeeID)
    INTO v_number_employees
    FROM employee
    WHERE jobtitle = v_jobtitle;

    v_staff_level :=
        CASE
            WHEN v_number_employees = 0 THEN
                'There are no employees with the Job Title: '
            WHEN v_number_employees BETWEEN 1 AND 3 THEN
                'There are between 1 and 3 employees with the Job Title: '
            WHEN v_number_employees BETWEEN 4 AND 6 THEN
                'There are between 4 and 6 employees with the Job Title: '
            ELSE
                'There are 7 or more employees with the Job Title: '
        END;

    DBMS_OUTPUT.PUT_LINE(v_staff_level || v_jobtitle);
END;

/*Q3
There are between 4 and 6 employees with the Job Title: Engineer
*/

-- Question 4
DECLARE
    my_count INTEGER := &my_count;
    my_counter INTEGER := 1;
    my_number INTEGER;
BEGIN
    LOOP
        my_number := DBMS_RANDOM.VALUE(1, my_count);
        DBMS_OUTPUT.PUT(my_number || ', ');
        my_counter := my_counter + 1;
        EXIT WHEN my_counter > my_count;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');  
END;

/* Q4 Results - It like changes I think 
2, 3, 3, 4, 3, 
*/

/* Q4 b
The simple loop runs repeatedly until the counter (MY_COUNTER) becomes greater than the user-specified value (MY_COUNT). During each iteration of the loop, a random
integer between 1 and MY_COUNT is generated and immediately printed to the screen followed by a comma. After printing, the counter is increased by one, moving the loop 
closer to its stopping condition. In this way, the loop produces exactly MY_COUNT random integers, each within the range of 1 to MY_COUNT, and displays them in a single 
line separated by commas.
*/

--Question 4a (Feel like numbering is off but While loop)
DECLARE
    my_count INTEGER := &my_count;
    my_counter INTEGER := 1;
    my_number INTEGER;
BEGIN
    WHILE my_counter <= my_count LOOP
        my_number := TRUNC(DBMS_RANDOM.VALUE(1, my_count + 1));
        DBMS_OUTPUT.PUT(my_number || ', ');
        my_counter := my_counter + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('');
END;

/* Q4a results - also changes everytime I run it 
3, 1, 5, 5, 1, 
*/

--Question 5a 
DECLARE
    my_count   INTEGER := &my_count;
    my_number  INTEGER;
BEGIN
    FOR my_counter IN 1..my_count LOOP
        my_number := TRUNC(DBMS_RANDOM.VALUE(1, my_count + 1));
        DBMS_OUTPUT.PUT(my_number || ', ');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('');
END;

/* Q5b
3, 3, 1, 2, 2, 
*/

-- Table 2: Procedures and Functions 

-- Question 1a

CREATE OR REPLACE PROCEDURE hello_world AS
    v_output VARCHAR2(35) := 'Hello World';
BEGIN
    dbms_output.put_line(v_output);
END hello_world;

/* Q1a results - IT is printed on the scipt output not DBMS output 
Procedure HELLO_WORLD compiled
*/

--Question 1b 
BEGIN
    hello_world;
END;

/* 1c results
Hello World
*/

/*1d question 
Anonymous blocks are temporary and one-time, while named blocks are permanent, reusable, and stored in the database.
*/

/*Question 2
When I clicked format it changed the format of my code making my HELLO_WORLD into hello_workd and making all my names lowercase
*/

-- Question 3
CREATE OR REPLACE PROCEDURE HELLO_WORLD
(p_name IN VARCHAR2)
AS 
    v_output VARCHAR2(35);
BEGIN
    v_output := 'Hello ' ||  p_name;
    DBMS_OUTPUT.PUT_LINE (v_output);
END HELLO_WORLD;

/* 3 Resi;ts 
Procedure HELLO_WORLD compiled
*/

--Question 3a
BEGIN
    HELLO_WORLD('World');
END;

/* Q3a results 
Hello World
*/

--Question 3b
BEGIN
    HELLO_WORLD('Mark');
END;

/* Q3b results 
Hello Mark
*/

-- Question 3c

BEGIN
    HELLO_WORLD('World procedure. I have so much fun coding in SQL and PLSQL.');
END;

/* Q3c - Issue is max is 35 characters so it created an error
ERROR at line 1:
ORA-06502: PL/SQL: numeric or value error: character string buffer too small
ORA-06512: at "KODANIEL.HELLO_WORLD", line 6
ORA-06512: at line 2
*/

--Question 3d
CREATE OR REPLACE PROCEDURE HELLO_WORLD 
(p_name IN VARCHAR2)
AS
    v_output VARCHAR2(200); 
BEGIN
    v_output := 'Hello ' || p_name;
    DBMS_OUTPUT.PUT_LINE(v_output);
END HELLO_WORLD;

-- Question 3e
BEGIN
    HELLO_WORLD('World procedure. I have so much fun coding in SQL and PLSQL.');
END;

/*Question 3e results 
Hello World procedure. I have so much fun coding in SQL and PLSQL.
*/

-- Question 4
CREATE OR REPLACE PROCEDURE HELLO_WORLD
(
    p_greeting IN VARCHAR2,
    p_name IN VARCHAR2
)
AS
    v_output VARCHAR2(75);
BEGIN 
    v_output := p_greeting ||' '|| p_name;
    DBMS_OUTPUT.PUT_LINE(v_output);
END HELLO_WORLD;

-- Question 4a
BEGIN
    HELLO_WORLD('Hello','World');
END;

/*4a results 
Hello World
*/

-- Question 4b 
EXECUTE HELLO_WORLD ('World');

/* 4b Results 
BEGIN HELLO_WORLD ('World'); END;
      *
ERROR at line 1:
ORA-06550: line 1, column 7:
PLS-00306: wrong number or types of arguments in call to 'HELLO_WORLD'
ORA-06550: line 1, column 7:
PL/SQL: Statement ignored
*/

--Question 4c
BEGIN
    HELLO_WORLD('Goodbye','Hal');
END;

/* 4c
Goodbye Hal
*/

-- Question 4d 
BEGIN
    HELLO_WORLD('Hello', NULL);
END;

/*4d Results 
Hello
*/

-- Question 5
CREATE OR REPLACE FUNCTION NUMBER_OF_EMPLOYEES
  RETURN NUMBER
AS
  v_number_of_employees NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO v_number_of_employees
  FROM EMPLOYEE;        
  RETURN v_number_of_employees;
END NUMBER_OF_EMPLOYEES;

-- Question 5b 
SET SERVEROUTPUT ON
BEGIN
  DBMS_OUTPUT.PUT_LINE('Number of employees: ' || NUMBER_OF_EMPLOYEES);
END;

/* Question 5b results 
Number of employees: 40
*/
-- Question 6
DROP FUNCTION NUMBER_OF_EMPLOYEES;
CREATE OR REPLACE FUNCTION NUMBER_OF_EMPLOYEES
( p_jobtitle IN EMPLOYEE.JOBTITLE%TYPE )  
  RETURN NUMBER
AS
  v_number_of_employees NUMBER := 0;
BEGIN
  SELECT COUNT(*)
  INTO v_number_of_employees
  FROM EMPLOYEE 
  WHERE UPPER(TRIM(JOBTITLE)) = UPPER(TRIM(p_jobtitle));

  RETURN v_number_of_employees;
END NUMBER_OF_EMPLOYEES;

--Question 6a 
SELECT NUMBER_OF_EMPLOYEES('Engineer') AS cnt FROM dual;

/* 6a Results 
       CNT
----------
         5
*/

--Question 6b 
CREATE OR REPLACE FUNCTION NUMBER_OF_EMPLOYEES
( p_jobtitle IN EMPLOYEE.JOBTITLE%TYPE )  
  RETURN NUMBER
AS
  v_number_of_employees NUMBER := 0;
BEGIN
  SELECT COUNT(*)
    INTO v_number_of_employees
    FROM EMPLOYEE
   WHERE UPPER(TRIM(JOBTITLE)) = UPPER(TRIM(p_jobtitle)); 

  RETURN v_number_of_employees;
END NUMBER_OF_EMPLOYEES;

-- Question 6c
SELECT NUMBER_OF_EMPLOYEES('engineer') AS cnt FROM dual;

/* 6c 
       CNT
----------
         5
*/
    
-- Question 6d 
SELECT NUMBER_OF_EMPLOYEES('dba') AS cnt FROM dual;

/* Q6d Results 
       CNT
----------
         1
*/

--Question 6e 
SELECT NUMBER_OF_EMPLOYEES('DBA') AS cnt FROM dual;

/* 6e Results 
       CNT
----------
         1
*/

--Question 6f
SELECT NUMBER_OF_EMPLOYEES('chief sales officer') AS cnt FROM dual;

/* 6e Results 
JOBTITLE                            COUNT(EMPLOYEEID)
----------------------------------- -----------------
VP Finance                                          1
Sales                                               3
VP Information                                      1
Chief Information Officer                           1
Chief Sales Officer                                 1
VP Operations                                       1
Accountant                                          2
President                                           1
DBA                                                 1
Chief Financial Officer                             1
Engineer                                            5
Programmer Analyst                                  2
Operations Officer                                  2
Assembly                                           18

14 rows selected. 
*/

--Question 6g
SELECT NUMBER_OF_EMPLOYEES('   chief sales officer   ') AS cnt FROM dual;

/* Q6g Results 
JOBTITLE                            COUNT(EMPLOYEEID)
----------------------------------- -----------------
VP Finance                                          1
Sales                                               3
VP Information                                      1
Chief Information Officer                           1
Chief Sales Officer                                 1
VP Operations                                       1
Accountant                                          2
President                                           1
DBA                                                 1
Chief Financial Officer                             1
Engineer                                            5
Programmer Analyst                                  2
Operations Officer                                  2
Assembly                                           18

14 rows selected. 
--
*/

--Question 6h 
SELECT NUMBER_OF_EMPLOYEES('CEO') AS cnt FROM dual;

/* 6h Results 

       CNT
----------
         0
*/

--Question 7a - Function DAYS_AWAY compiled
CREATE OR REPLACE FUNCTION DAYS_AWAY (p_date IN DATE)
  RETURN NUMBER
AS
BEGIN
  RETURN TRUNC(p_date) - TRUNC(SYSDATE);
END DAYS_AWAY;

--Question 7b 
BEGIN
  DBMS_OUTPUT.PUT_LINE('Future ex: ' || DAYS_AWAY(DATE '2030-01-01')); 
  DBMS_OUTPUT.PUT_LINE('Past ex: ' || DAYS_AWAY(DATE '2000-01-01')); 
END;

/* Q7b Results 
Future ex: 1566
Past   ex: -9392
*/

--Question 8a 
CREATE OR REPLACE PROCEDURE DAY_OF_THE_WEEK (p_date IN DATE)
AS
  v_day VARCHAR2(20);
  v_before VARCHAR2(20);
  v_after VARCHAR2(20);
BEGIN
  -- Use FM to suppress padding; explicitly set language to avoid NLS surprises
  v_day := TO_CHAR(p_date, 'FMDay', 'NLS_DATE_LANGUAGE=English');
  v_before := TO_CHAR(p_date - 1, 'FMDay', 'NLS_DATE_LANGUAGE=English');
  v_after := TO_CHAR(p_date + 1, 'FMDay', 'NLS_DATE_LANGUAGE=English');

  DBMS_OUTPUT.PUT_LINE('Given date: ' || TO_CHAR(p_date, 'YYYY-MM-DD') || ' (' || v_day    || ')');
  DBMS_OUTPUT.PUT_LINE('Previous day: ' || TO_CHAR(p_date - 1, 'YYYY-MM-DD') || ' (' || v_before || ')');
  DBMS_OUTPUT.PUT_LINE('Next day: ' || TO_CHAR(p_date + 1, 'YYYY-MM-DD') || ' (' || v_after  || ')');
END DAY_OF_THE_WEEK;

-- Question 8b 
BEGIN
  DAY_OF_THE_WEEK(DATE '2025-12-31');
  DAY_OF_THE_WEEK(SYSDATE);
END;
/* Q8b Results 
Given date: 2025-12-31 (Wednesday)
Previous day: 2025-12-30 (Tuesday)
Next day: 2026-01-01 (Thursday)
Given date: 2025-09-18 (Thursday)
Previous day: 2025-09-17 (Wednesday)
Next day: 2025-09-19 (Friday)
*/

--Question 8a Ig
CREATE OR REPLACE PROCEDURE DAYS_FROM_WEEKEND (p_date IN DATE DEFAULT SYSDATE)
AS
  v_is_weekend BOOLEAN;
  v_days_until NUMBER;
BEGIN
  v_is_weekend := (TO_CHAR(p_date, 'DY', 'NLS_DATE_LANGUAGE=English') IN ('SAT','SUN'));

  IF v_is_weekend THEN
    DBMS_OUTPUT.PUT_LINE('Date: ' || TO_CHAR(p_date,'YYYY-MM-DD') || ' — Happy Weekend!');
  ELSE
    v_days_until := NEXT_DAY(TRUNC(p_date), 'SATURDAY') - TRUNC(p_date);
    DBMS_OUTPUT.PUT_LINE('Date: ' || TO_CHAR(p_date,'YYYY-MM-DD') ||
                         ' — Days until Saturday: ' || v_days_until);
  END IF;
END DAYS_FROM_WEEKEND;

--Question 8b 
BEGIN
  DAYS_FROM_WEEKEND(DATE '2025-07-04'); 
  DAYS_FROM_WEEKEND;                    
END;

/* 8b Results 
Date: 2025-07-04 — Days until Saturday: 1
Date: 2025-09-18 — Days until Saturday: 2
*/

--Table 3: Procedures and Functions 

--Question 1a
CREATE OR REPLACE PROCEDURE COUNT_SUPPLIERS
AS
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM Supplier;
  DBMS_OUTPUT.PUT_LINE('Suppliers: ' || v_cnt);
END COUNT_SUPPLIERS;

--Question 1b 
BEGIN
  COUNT_SUPPLIERS;
END;

/* Q1b 
Suppliers: 29
*/

/*Question 1c
Anonymous block: no name, not stored; one-off code you run ad-hoc.

Named block: stored program unit (procedure/function/package) with a name; reusable, grantable, callable anywhere in the schema.
*/

--Question 2 
/* Before
CREATE OR REPLACE PROCEDURE COUNT_SUPPLIERS
AS
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM Supplier;
  DBMS_OUTPUT.PUT_LINE('Suppliers: ' || v_cnt);
END COUNT_SUPPLIERS;

After:
CREATE OR REPLACE PROCEDURE count_suppliers AS
    v_cnt NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO v_cnt
    FROM
        supplier;

    dbms_output.put_line('Suppliers: ' || v_cnt);
END count_suppliers;
*/

--Question 3a 
CREATE OR REPLACE PROCEDURE COUNT_SUPPLIERS_BY_CITY
(p_city IN Supplier.City%TYPE)
AS
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*)
    INTO v_cnt
    FROM Supplier
   WHERE UPPER(TRIM(City)) = UPPER(TRIM(p_city));

  IF v_cnt = 0 THEN
    DBMS_OUTPUT.PUT_LINE('No suppliers found for city = "' || p_city ||
                         '". (Comparison is case-insensitive; leading/trailing spaces ignored.)');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Suppliers in ' || TRIM(p_city) || ': ' || v_cnt);
  END IF;
END COUNT_SUPPLIERS_BY_CITY;

--Question 3b 
SET SERVEROUTPUT ON
BEGIN
  COUNT_SUPPLIERS_BY_CITY('New York City'); 
END;

/* 3b Results
Suppliers in New York City: 1
*/

--Question 4a
CREATE OR REPLACE PROCEDURE COUNT_SUPPLIERS_BY_CITY_STATE
(
  p_city IN Supplier.City%TYPE,
  p_state IN Supplier.State%TYPE
)
AS
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*)
    INTO v_cnt
    FROM Supplier
   WHERE UPPER(TRIM(City)) = UPPER(TRIM(p_city))
     AND UPPER(TRIM(State)) = UPPER(TRIM(p_state));

  DBMS_OUTPUT.PUT_LINE('Suppliers in ' || TRIM(p_city) || ', ' || TRIM(p_state) || ': ' || v_cnt);
END COUNT_SUPPLIERS_BY_CITY_STATE;

-- Question 4b 
SET SERVEROUTPUT ON
BEGIN
  COUNT_SUPPLIERS_BY_CITY_STATE('New York City','NY'); 
END;

/* Q4b Results 
Suppliers in New York City, NY: 1
*/

--Question 4c
SET SERVEROUTPUT ON
BEGIN
  COUNT_SUPPLIERS_BY_CITY_STATE('NY'); 
END;

/* Q4c Results 
  COUNT_SUPPLIERS_BY_CITY_STATE('NY'); 
  *
ERROR at line 2:
ORA-06550: line 2, column 3:
PLS-00306: wrong number or types of arguments in call to 'COUNT_SUPPLIERS_BY_CITY_STATE'
ORA-06550: line 2, column 3:
PL/SQL: Statement ignored
*/

--Question 5a
CREATE OR REPLACE FUNCTION NUM_SUPPLIERS
  RETURN NUMBER
AS
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM Supplier;
  RETURN v_cnt;
END NUM_SUPPLIERS;

--Question 5b 
SELECT NUM_SUPPLIERS() AS supplier_count FROM dual;

/* Q5b 
SUPPLIER_COUNT
--------------
            29
*/

--Question 6a 
CREATE OR REPLACE FUNCTION NUM_SUPPLIERS_IN_CITY
(p_city IN Supplier.City%TYPE)
  RETURN NUMBER
AS
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*)
    INTO v_cnt
    FROM Supplier
   WHERE UPPER(TRIM(City)) = UPPER(TRIM(p_city));

  RETURN v_cnt;
END NUM_SUPPLIERS_IN_CITY;

--Question 6b
SELECT NUM_SUPPLIERS_IN_CITY('Dalton') AS dalton FROM dual;
SELECT NUM_SUPPLIERS_IN_CITY('SouthBend') AS southbend_1 FROM dual;
SELECT NUM_SUPPLIERS_IN_CITY('South Bend') AS southbend_2 FROM dual;
SELECT NUM_SUPPLIERS_IN_CITY('dalton') AS dalton_lc FROM dual;
SELECT NUM_SUPPLIERS_IN_CITY('DALTON') AS dalton_uc FROM dual;
SELECT NUM_SUPPLIERS_IN_CITY('Daton') AS daton_typo FROM dual; 

/*Question 6b results 
    DALTON
----------
         1

1 row selected. 


SOUTHBEND_1
-----------
          0

1 row selected. 


SOUTHBEND_2
-----------
          1

1 row selected. 


 DALTON_LC
----------
         1

1 row selected. 


 DALTON_UC
----------
         1

1 row selected. 


DATON_TYPO
----------
         0
*/

/* Q6c
Ignore spaces: compare REPLACE(UPPER(TRIM(City)),' ','') to REPLACE(UPPER(TRIM(p_city)),' ','').

For typos, phonetic or similarity matchin or provide a list of accepted aliases.
*/

--Question 7a 
CREATE OR REPLACE PROCEDURE ZIP_STATS_SIMPLE
AS
  v_d NUMBER := 0;
  v_sup NUMBER;
  v_zips NUMBER;
BEGIN
  LOOP
    SELECT COUNT(*), COUNT(DISTINCT PostalCode)
      INTO v_sup, v_zips
      FROM Supplier
     WHERE REGEXP_LIKE(PostalCode, '^\s*' || v_d);

    DBMS_OUTPUT.PUT_LINE('Digit ' || v_d || ' = suppliers: ' || v_sup || ', distinct zips: ' || v_zips);

    v_d := v_d + 1;
    EXIT WHEN v_d > 9;
  END LOOP;
END ZIP_STATS_SIMPLE;

--Question 7b 
BEGIN
  ZIP_STATS_SIMPLE;
END;

/* 7b resu;ts 
Digit 0 = suppliers: 2, distinct zips: 2
Digit 1 = suppliers: 4, distinct zips: 4
Digit 2 = suppliers: 3, distinct zips: 3
Digit 3 = suppliers: 2, distinct zips: 2
Digit 4 = suppliers: 6, distinct zips: 6
Digit 5 = suppliers: 0, distinct zips: 0
Digit 6 = suppliers: 0, distinct zips: 0
Digit 7 = suppliers: 2, distinct zips: 2
Digit 8 = suppliers: 7, distinct zips: 7
Digit 9 = suppliers: 3, distinct zips: 3
*/

--Question 8a
CREATE OR REPLACE PROCEDURE ZIP_STATS_WHILE
AS
  v_d NUMBER := 0;
  v_sup NUMBER;
  v_zips NUMBER;
BEGIN
  WHILE v_d <= 9 LOOP
    SELECT COUNT(*), COUNT(DISTINCT PostalCode)
      INTO v_sup, v_zips
      FROM Supplier
     WHERE REGEXP_LIKE(PostalCode, '^\s*' || v_d);

    DBMS_OUTPUT.PUT_LINE('Digit ' || v_d || ' = suppliers: ' || v_sup || ', distinct zips: ' || v_zips);

    v_d := v_d + 1;
  END LOOP;
END ZIP_STATS_WHILE;

--Question 8b 
BEGIN
  ZIP_STATS_WHILE;
END;

/* Q8b Results 
Digit 0 = suppliers: 2, distinct zips: 2
Digit 1 = suppliers: 4, distinct zips: 4
Digit 2 = suppliers: 3, distinct zips: 3
Digit 3 = suppliers: 2, distinct zips: 2
Digit 4 = suppliers: 6, distinct zips: 6
Digit 5 = suppliers: 0, distinct zips: 0
Digit 6 = suppliers: 0, distinct zips: 0
Digit 7 = suppliers: 2, distinct zips: 2
Digit 8 = suppliers: 7, distinct zips: 7
Digit 9 = suppliers: 3, distinct zips: 3
*/

--Question 9a
CREATE OR REPLACE PROCEDURE ZIP_STATS_FOR
AS
  v_sup NUMBER;
  v_zips NUMBER;
BEGIN
  FOR v_d IN 0..9 LOOP
    SELECT COUNT(*), COUNT(DISTINCT PostalCode)
      INTO v_sup, v_zips
      FROM Supplier
     WHERE REGEXP_LIKE(PostalCode, '^\s*' || v_d);

    DBMS_OUTPUT.PUT_LINE('Digit ' || v_d || ' = suppliers: ' || v_sup || ', distinct zips: ' || v_zips);
  END LOOP;
END ZIP_STATS_FOR;

--Question 9b 
BEGIN
  ZIP_STATS_FOR;
END;

/* 9b results
Digit 0 = suppliers: 2, distinct zips: 2
Digit 1 = suppliers: 4, distinct zips: 4
Digit 2 = suppliers: 3, distinct zips: 3
Digit 3 = suppliers: 2, distinct zips: 2
Digit 4 = suppliers: 6, distinct zips: 6
Digit 5 = suppliers: 0, distinct zips: 0
Digit 6 = suppliers: 0, distinct zips: 0
Digit 7 = suppliers: 2, distinct zips: 2
Digit 8 = suppliers: 7, distinct zips: 7
Digit 9 = suppliers: 3, distinct zips: 3
*/