/*PL/SQL Cursors, Exceptions
*** ***
*/

--Option A

--Question 1a
SET SERVEROUTPUT ON SIZE UNLIMITED;

CREATE OR REPLACE PROCEDURE print_employee_roster
AS
  current_employeeid EMPLOYEE.employeeid%TYPE;
  current_lastname EMPLOYEE.lastname%TYPE;
  current_firstname EMPLOYEE.firstname%TYPE;

  CURSOR all_employees IS
    SELECT employeeid, lastname, firstname
    FROM EMPLOYEE;
BEGIN
  OPEN all_employees;

  FETCH all_employees
    INTO current_employeeid, current_lastname, current_firstname;

  WHILE all_employees%FOUND LOOP
    DBMS_OUTPUT.PUT( RPAD(current_employeeid, 15, ' ') );
    DBMS_OUTPUT.PUT( RPAD(current_lastname,   30, ' ') );
    DBMS_OUTPUT.PUT_LINE( current_firstname );

    FETCH all_employees
      INTO current_employeeid, current_lastname, current_firstname;
  END LOOP;

  CLOSE all_employees;
END;

--Question 1b 
BEGIN
  print_employee_roster;
END;

/* 1b Results
100001         Manaugh                       Jim
100101         Rosner                        Joanne
100103         Bush                          Rita
100104         Abbott                        Michael
100106         Eckelman                      Paul
100112         Hickman                       Steven
100120         Nairn                         Michelle
100125         Stevenson                     Gabrielle
100127         Wendling                      Jason
100200         Zobitz                        Beth
100204         Keck                          David
100206         Xolo                          Kathleen
100209         Yates                         Tina
100220         Vigus                         Todd
100330         Gustavel                      Kristen
100365         Cheswick                      Sherman
100399         Day                           Ronald
100475         Hess                          Steve
100488         Osman                         Jamie
100550         Roland                        Allison
100559         Tyrie                         Meghan
100600         Zollman                       Calie
100650         Lilley                        Edna
100700         Jones                         Charles
100880         German                        Gary
100892         Platt                         Joseph
100944         Stahley                       Ryan
100967         Albregts                      Nicholas
100989         Deagen                        Kathryn
101007         Krasner                       Jason
101030         Moore                         Kristey
101045         Ortman                        Austin
101066         Rodgers                       Laura
101088         Underwood                     Patricha
101089         Alvarez                       Melissa
101097         Brose                         Jack
101115         Cochran                       Steve
101135         Deppe                         David
101154         Hettinger                     Gregory
101166         Reece                         Phil
*/

--Question 2a
CREATE OR REPLACE PROCEDURE print_employee_roster
AS
  CURSOR all_employees IS
    SELECT employeeid, lastname, firstname
    FROM EMPLOYEE
    ORDER BY lastname, firstname;

  -- 2a: single local variable based on the cursor's row shape
  current_employee  all_employees%ROWTYPE;
BEGIN
  OPEN all_employees;

  FETCH all_employees INTO current_employee;

  WHILE all_employees%FOUND LOOP
    DBMS_OUTPUT.PUT( RPAD(current_employee.employeeid, 15, ' ') );
    DBMS_OUTPUT.PUT( RPAD(current_employee.lastname,   30, ' ') );
    DBMS_OUTPUT.PUT_LINE( current_employee.firstname );

    FETCH all_employees INTO current_employee;
  END LOOP;

  CLOSE all_employees;
END;

--Question 2b
BEGIN
  print_employee_roster;
END;

/*2b Results 
100104         Abbott                        Michael
100967         Albregts                      Nicholas
101089         Alvarez                       Melissa
101097         Brose                         Jack
100103         Bush                          Rita
100365         Cheswick                      Sherman
101115         Cochran                       Steve
100399         Day                           Ronald
100989         Deagen                        Kathryn
101135         Deppe                         David
100106         Eckelman                      Paul
100880         German                        Gary
100330         Gustavel                      Kristen
100475         Hess                          Steve
101154         Hettinger                     Gregory
100112         Hickman                       Steven
100700         Jones                         Charles
100204         Keck                          David
101007         Krasner                       Jason
100650         Lilley                        Edna
100001         Manaugh                       Jim
101030         Moore                         Kristey
100120         Nairn                         Michelle
101045         Ortman                        Austin
100488         Osman                         Jamie
100892         Platt                         Joseph
101166         Reece                         Phil
101066         Rodgers                       Laura
100550         Roland                        Allison
100101         Rosner                        Joanne
100944         Stahley                       Ryan
100125         Stevenson                     Gabrielle
100559         Tyrie                         Meghan
101088         Underwood                     Patricha
100220         Vigus                         Todd
100127         Wendling                      Jason
100206         Xolo                          Kathleen
100209         Yates                         Tina
100200         Zobitz                        Beth
100600         Zollman                       Calie
*/
/* 2c
current_employee is based on the all_employees cursor, not directly on the table.
*/

--Question 3a
CREATE OR REPLACE PROCEDURE print_employee_roster IS
  CURSOR emp_cur IS
    SELECT EmployeeID,
           FirstName || ' ' || LastName AS FullName
    FROM EMPLOYEE
    ORDER BY LastName, FirstName;

  rec emp_cur%ROWTYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE(RPAD('ID',6) || 'Full Name');
  DBMS_OUTPUT.PUT_LINE(RPAD('-',6,'-') || RPAD('-',30,'-'));

  OPEN emp_cur;
  LOOP
    FETCH emp_cur INTO rec;
    EXIT WHEN emp_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE( RPAD(rec.EmployeeID,6) || rec.FullName );
  END LOOP;
  CLOSE emp_cur;
END;

--Question 3b
BEGIN
  print_employee_roster;
END;

/*3b Results 
ID    Full Name
------------------------------------
100104Michael Abbott
100967Nicholas Albregts
101089Melissa Alvarez
101097Jack Brose
100103Rita Bush
100365Sherman Cheswick
101115Steve Cochran
100399Ronald Day
100989Kathryn Deagen
101135David Deppe
100106Paul Eckelman
100880Gary German
100330Kristen Gustavel
100475Steve Hess
101154Gregory Hettinger
100112Steven Hickman
100700Charles Jones
100204David Keck
101007Jason Krasner
100650Edna Lilley
100001Jim Manaugh
101030Kristey Moore
100120Michelle Nairn
101045Austin Ortman
100488Jamie Osman
100892Joseph Platt
101166Phil Reece
101066Laura Rodgers
100550Allison Roland
100101Joanne Rosner
100944Ryan Stahley
100125Gabrielle Stevenson
100559Meghan Tyrie
101088Patricha Underwood
100220Todd Vigus
100127Jason Wendling
100206Kathleen Xolo
100209Tina Yates
100200Beth Zobitz
100600Calie Zollman
*/
--Question 4a
CREATE OR REPLACE PROCEDURE print_employee_roster IS
  CURSOR emp_cur IS
    SELECT EmployeeID,
           FirstName || ' ' || LastName AS FullName
    FROM EMPLOYEE
    ORDER BY LastName, FirstName;
BEGIN
  DBMS_OUTPUT.PUT_LINE(RPAD('ID',6) || 'Full Name');
  DBMS_OUTPUT.PUT_LINE(RPAD('-',6,'-') || RPAD('-',30,'-'));

  FOR rec IN emp_cur LOOP
    DBMS_OUTPUT.PUT_LINE(RPAD(rec.EmployeeID,6) || rec.FullName);
  END LOOP;
END;

--Question 4b 
BEGIN
  print_employee_roster;
END;
/*4b Results 
ID    Full Name
------------------------------------
100104Michael Abbott
100967Nicholas Albregts
101089Melissa Alvarez
101097Jack Brose
100103Rita Bush
100365Sherman Cheswick
101115Steve Cochran
100399Ronald Day
100989Kathryn Deagen
101135David Deppe
100106Paul Eckelman
100880Gary German
100330Kristen Gustavel
100475Steve Hess
101154Gregory Hettinger
100112Steven Hickman
100700Charles Jones
100204David Keck
101007Jason Krasner
100650Edna Lilley
100001Jim Manaugh
101030Kristey Moore
100120Michelle Nairn
101045Austin Ortman
100488Jamie Osman
100892Joseph Platt
101166Phil Reece
101066Laura Rodgers
100550Allison Roland
100101Joanne Rosner
100944Ryan Stahley
100125Gabrielle Stevenson
100559Meghan Tyrie
101088Patricha Underwood
100220Todd Vigus
100127Jason Wendling
100206Kathleen Xolo
100209Tina Yates
100200Beth Zobitz
100600Calie Zollman
*/
--Question 5a
CREATE OR REPLACE PROCEDURE print_employee_roster(p_job_title IN VARCHAR2) IS
  CURSOR emp_cur IS
    SELECT EmployeeID,
           FirstName || ' ' || LastName AS FullName,
           JobTitle
    FROM EMPLOYEE
    WHERE UPPER(JobTitle) = UPPER(p_job_title)
    ORDER BY LastName, FirstName;
BEGIN
  DBMS_OUTPUT.PUT_LINE(RPAD('ID',6) || RPAD('Full Name',30) || 'Job Title');
  DBMS_OUTPUT.PUT_LINE(RPAD('-',6,'-') || RPAD('-',30,'-') || RPAD('-',20,'-'));

  FOR rec IN emp_cur LOOP
    DBMS_OUTPUT.PUT_LINE(
      RPAD(rec.EmployeeID,6) || RPAD(rec.FullName,30) || rec.JobTitle
    );
  END LOOP;
END;

--Question 5b
BEGIN
  print_employee_roster('sales');
END;
/* 5b Results 

ID    Full Name                     Job Title
--------------------------------------------------------
101007Jason Krasner                 Sales
101066Laura Rodgers                 Sales
100600Calie Zollman                 Sales
*/

--Question 5c
BEGIN
  print_employee_roster('assembly');
END;

/* 5c Results

ID    Full Name                     Job Title
--------------------------------------------------------
100967Nicholas Albregts             Assembly
101089Melissa Alvarez               Assembly
101097Jack Brose                    Assembly
101115Steve Cochran                 Assembly
100399Ronald Day                    Assembly
100989Kathryn Deagen                Assembly
101135David Deppe                   Assembly
100475Steve Hess                    Assembly
101154Gregory Hettinger             Assembly
100204David Keck                    Assembly
101030Kristey Moore                 Assembly
100120Michelle Nairn                Assembly
101045Austin Ortman                 Assembly
100892Joseph Platt                  Assembly
101166Phil Reece                    Assembly
100550Allison Roland                Assembly
100101Joanne Rosner                 Assembly
101088Patricha Underwood            Assembly
*/

--Question 6a
CREATE OR REPLACE PROCEDURE print_employee_roster
( p_job_title IN employee.jobtitle%TYPE )
IS
  CURSOR emp_cur IS
    SELECT employeeid,
           firstname || ' ' || lastname AS fullname,
           jobtitle
    FROM employee
    WHERE UPPER(TRIM(jobtitle)) = UPPER(TRIM(p_job_title))
    ORDER BY lastname, firstname;
BEGIN
  DBMS_OUTPUT.PUT_LINE(RPAD('ID', 6) || RPAD('Full Name', 30) || 'Job Title');
  DBMS_OUTPUT.PUT_LINE(RPAD('-', 6, '-') || RPAD('-', 30, '-') || RPAD('-', 20, '-'));

  FOR rec IN emp_cur LOOP
    DBMS_OUTPUT.PUT_LINE(
      RPAD(rec.employeeid, 6) || RPAD(rec.fullname, 30) || rec.jobtitle
    );
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT('Error ' || SQLCODE);
    DBMS_OUTPUT.PUT(': ');
    DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 100));
END;

-- Question 6b 
BEGIN
  print_employee_roster('assembly');
END;

/* 6b Results
ID    Full Name                     Job Title
--------------------------------------------------------
100967Nicholas Albregts             Assembly
101089Melissa Alvarez               Assembly
101097Jack Brose                    Assembly
101115Steve Cochran                 Assembly
100399Ronald Day                    Assembly
100989Kathryn Deagen                Assembly
101135David Deppe                   Assembly
100475Steve Hess                    Assembly
101154Gregory Hettinger             Assembly
100204David Keck                    Assembly
101030Kristey Moore                 Assembly
100120Michelle Nairn                Assembly
101045Austin Ortman                 Assembly
100892Joseph Platt                  Assembly
101166Phil Reece                    Assembly
100550Allison Roland                Assembly
100101Joanne Rosner                 Assembly
101088Patricha Underwood            Assembly
*/

--Question 7a
CREATE OR REPLACE PROCEDURE customer_roster
( p_state IN customer.state%TYPE )
IS
  CURSOR c_cust IS
    SELECT companyname,
           city,
           state,
           (custlastname || ', ' || custfirstname) AS contactname
    FROM customer
    WHERE UPPER(TRIM(state)) = UPPER(TRIM(p_state))
    ORDER BY companyname;

  v_company  customer.companyname%TYPE;
  v_city     customer.city%TYPE;
  v_state    customer.state%TYPE;
  v_contact  VARCHAR2(200);
BEGIN
  DBMS_OUTPUT.PUT_LINE(
    RPAD('Company',32) || RPAD('City',20) || RPAD('State',8) || 'Contact'
  );
  DBMS_OUTPUT.PUT_LINE(
    RPAD('-',32,'-') || RPAD('-',20,'-') || RPAD('-',8,'-') || RPAD('-',20,'-')
  );

  OPEN c_cust;
  FETCH c_cust INTO v_company, v_city, v_state, v_contact;

  WHILE c_cust%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE(
      RPAD(v_company,32) || RPAD(v_city,20) || RPAD(v_state,8) || v_contact
    );
    FETCH c_cust INTO v_company, v_city, v_state, v_contact;
  END LOOP;

  CLOSE c_cust;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error ' || SQLCODE || ': ' || SQLERRM);
END;

--Question 7b
BEGIN
  customer_roster('GA');
END;

/*7b Results 
Company                         City                State   Contact
--------------------------------------------------------------------------------
Down Deep Drilling Inc.         Elberton            GA      Torres, Don
Family Medical Center           Adel                GA      Strong, Susan
Nahunta             GA      Malady, Frank
Athens              GA      Thompson, Jamie
Swainsboro          GA      Osborne, Shirley
Macon               GA      Vanderhoff, Rosemary
*/

--Question 8a
CREATE OR REPLACE PROCEDURE customer_search
( p_name IN VARCHAR2 )
IS
  CURSOR c_s IS
    SELECT companyname,
           custfirstname,
           custlastname,
           custtitle
    FROM customer
    WHERE INSTR( UPPER(custlastname), UPPER(TRIM(p_name)) ) > 0
    ORDER BY custlastname, custfirstname;

  v_comp  customer.companyname%TYPE;
  v_fn    customer.custfirstname%TYPE;
  v_ln    customer.custlastname%TYPE;
  v_title customer.custtitle%TYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE(
    RPAD('Company',32) || RPAD('First',16) || RPAD('Last',16) || 'Title'
  );
  DBMS_OUTPUT.PUT_LINE(
    RPAD('-',32,'-') || RPAD('-',16,'-') || RPAD('-',16,'-') || RPAD('-',20,'-')
  );

  OPEN c_s;
  LOOP
    FETCH c_s INTO v_comp, v_fn, v_ln, v_title;
    EXIT WHEN c_s%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(
      RPAD(v_comp,32) || RPAD(v_fn,16) || RPAD(v_ln,16) || v_title
    );
  END LOOP;
  CLOSE c_s;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error ' || SQLCODE || ': ' || SQLERRM);
END;
--Question 8b 
BEGIN
  customer_search('NA');
END;

/* 8b Results

*/

--Question 8c
CREATE OR REPLACE PROCEDURE customer_search(p_name IN VARCHAR2) IS
  CURSOR c_s IS
    SELECT CompanyName,
           ContactFirstName,
           ContactLastName,
           ContactTitle
    FROM   CUSTOMER
    WHERE  INSTR(UPPER(ContactLastName), UPPER(TRIM(p_name))) > 0
        OR INSTR(UPPER(ContactFirstName), UPPER(TRIM(p_name))) > 0
    ORDER  BY ContactLastName, ContactFirstName;

  v_comp CUSTOMER.CompanyName%TYPE;
  v_fn CUSTOMER.ContactFirstName%TYPE;
  v_ln CUSTOMER.ContactLastName%TYPE;
  v_title CUSTOMER.ContactTitle%TYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE(
    RPAD('Company',32) || RPAD('First',16) || RPAD('Last',16) || 'Title'
  );
  DBMS_OUTPUT.PUT_LINE(
    RPAD('-',32,'-') || RPAD('-',16,'-') || RPAD('-',16,'-') || RPAD('-',20,'-')
  );

  OPEN c_s;
  LOOP
    FETCH c_s INTO v_comp, v_fn, v_ln, v_title;
    EXIT WHEN c_s%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(
      RPAD(v_comp,32) || RPAD(v_fn,16) || RPAD(v_ln,16) || v_title
    );
  END LOOP;
  CLOSE c_s;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error ' || SQLCODE || ': ' || SQLERRM);
END;
--Question 8d
BEGIN
  customer_search('na');
END;
/* 8d Results 
Company                         First           Last            Title
------------------------------------------------------------------------------------
Dorlan          Bresnaham       Dr.
Jay             Hanau           Mr.
Bobs Repair Service             Daniel          Hundnall        Mr.
Jim             Manaugh         Mr.
Automart                        Jessica         Nakamura        Ms.
Matt            Nakanishi       Mr.
*/

--Question 8e
CREATE OR REPLACE PROCEDURE customer_search (p_name IN VARCHAR2) IS
BEGIN
  DBMS_OUTPUT.PUT_LINE(
    RPAD('Company',32) || RPAD('First',16) || RPAD('Last',16) || 'Title'
  );
  DBMS_OUTPUT.PUT_LINE(
    RPAD('-',32,'-') || RPAD('-',16,'-') || RPAD('-',16,'-') || RPAD('-',20,'-')
  );

  FOR rec IN (
    SELECT companyname,
           custfirstname,
           custlastname,
           custtitle
    FROM customer
    WHERE INSTR(UPPER(custlastname),  UPPER(TRIM(p_name))) > 0
       OR INSTR(UPPER(custfirstname), UPPER(TRIM(p_name))) > 0
    ORDER BY custlastname, custfirstname
  ) LOOP
    DBMS_OUTPUT.PUT_LINE(
      RPAD(rec.companyname,32) ||
      RPAD(rec.custfirstname,16) ||
      RPAD(rec.custlastname,16) ||
      rec.custtitle
    );
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error ' || SQLCODE || ': ' || SQLERRM);
END;

--Question 8f
BEGIN
  customer_search('na');
END;

/*8f Results
Company                         First           Last            Title
------------------------------------------------------------------------------------
Nancy           Basham          Mrs.
Jonathon        Blanco          Mr.
Dorlan          Bresnaham       Dr.
Jay             Hanau           Mr.
Bobs Repair Service             Daniel          Hundnall        Mr.
Jim             Manaugh         Mr.
Anna            Mayton          Dr.
Verna           McGrew          Ms.
Ronald          Miller          Mr.
Automart                        Jessica         Nakamura        Ms.
Matt            Nakanishi       Mr.
Christina       Wilson          Mrs.
*/
