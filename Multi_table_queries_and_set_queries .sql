/*

Multi-table queries and set queries 

*** ***

*/

-- Question #1

SELECT ip.partnumber,

       ip.partdescription,

       ROUND(AVG(col.orderquantity), 1) AS AvgQty

FROM inventorypart ip

INNER JOIN custorderline col ON col.partnumber = ip.partnumber

WHERE ip.categoryid = 'ACCESS'

GROUP BY ip.partnumber, ip.partdescription

ORDER BY AvgQty DESC;

/* Q1 Query Results
PARTNUMBER PARTDESCRIPTION                                        AVGQTY

---------- -------------------------------------------------- ----------

MOD-001    PCI DATA/FAX/VOICE MODEM                                  8.3

MOD-002    112K DUAL MODEM                                           5.1

PRT-006    SINGLEHEAD THERMAL INKJET PRINTER                         3.8

PRT-004    3-IN-1 COLOR INKJET PRINTER                               3.6

SCN-002    SCANJET BUSINESS SERIES COLOR SCANNER                     3.5

PRT-003    LASER JET 2500SE                                          3.4

MOD-005    V.90/K56 FLEX 56K FAX MODEM                               3.1

PRT-001    LASER JET 1999SE                                          2.9

MOD-003    PCI MODEM                                                 2.4

PRT-002    LASER JET 2000SE                                          2.3

SCN-001    SCANJET CSE COLOR SCANNER                                 1.8



PARTNUMBER PARTDESCRIPTION                                        AVGQTY

---------- -------------------------------------------------- ----------

MOD-004    PCI V.90 DATA/FAX/VOICE MODEM                             1.6
*/

-- Question #2a

SELECT EXTRACT(MONTH FROM co.orderdate) AS order_month,

       EXTRACT(YEAR  FROM co.orderdate) AS order_year,

       ROUND(AVG(col.orderquantity), 1)  AS avg_qty

FROM custorderline col

JOIN custorder co  ON co.orderid = col.orderid

WHERE col.partnumber = 'DVD-001'

GROUP BY EXTRACT(YEAR  FROM co.orderdate),

          EXTRACT(MONTH FROM co.orderdate)

ORDER BY order_year, order_month;
/* Q2a Query Results



ORDER_MONTH ORDER_YEAR    AVG_QTY

----------- ---------- ----------

          7       2010        1.5

          9       2010          4

         10       2010          1

         11       2010          2

         12       2010          1

          1       2011          1

          2       2011          8

          3       2011          1

*/
-- Question #3a
SELECT TO_CHAR(co.orderdate, 'MM-YYYY') AS month_year,

       ROUND(SUM(col.orderquantity), 1)  AS total_qty

FROM custorderline col

JOIN custorder co ON co.orderid = col.orderid

WHERE col.partnumber = 'DVD-001'

GROUP BY TO_CHAR(co.orderdate, 'MM-YYYY'),

          EXTRACT(YEAR  FROM co.orderdate),

          EXTRACT(MONTH FROM co.orderdate)

ORDER BY EXTRACT(YEAR  FROM co.orderdate),

          EXTRACT(MONTH FROM co.orderdate);

/* Q3 Query Results

MONTH_Y  TOTAL_QTY

------- ----------

07-2010          3

09-2010         12

10-2010          1

11-2010          4

12-2010          3

01-2011          1

02-2011         16

03-2011          1
*/

-- Question #4

SELECT EXTRACT(MONTH FROM co.orderdate) AS order_month,

       EXTRACT(YEAR  FROM co.orderdate) AS order_year,

       COUNT(DISTINCT co.orderid) AS orders_placed

FROM custorderline col

JOIN custorder     co ON co.orderid = col.orderid

WHERE col.partnumber = 'DVD-001'

GROUP BY EXTRACT(YEAR  FROM co.orderdate),

          EXTRACT(MONTH FROM co.orderdate)

ORDER BY order_year, order_month;

/* Q4 Query Results

ORDER_MONTH ORDER_YEAR ORDERS_PLACED

----------- ---------- -------------

          7       2010             2

          9       2010             3

         10       2010             1

         11       2010             2

         12       2010             3

          1       2011             1

          2       2011             2

          3       2011             1

*/

/* Q5 Results



5a Q2, Q3, and Q4, all explore demand over time for the same part., how much is bought per order, how many orders occur, and what the total volume is each month. 



5b. Combine Q2-Q4 to infer whether changes in totals come from more orders or bigger orders



5c: If trends align, that increases confidence, contradictions decrease it.

*/
-- Question #6a
SELECT sh.orderid,

       sh.shipmentid,

       ps.packagenumber,

       ps.shippeddate,

       sh.shipname,

       sh.shipaddress

FROM shipment sh

LEFT JOIN packingslip ps ON ps.shipmentid = sh.shipmentid

WHERE sh.orderid = '2000000007'

ORDER BY sh.shipmentid, ps.packagenumber;


/* Q6 Query Results
ORDERID    SHIPMENTID PACKAGENUMBER SHIPPEDDA SHIPNAME             SHIPADDRESS                             

---------- ---------- ------------- --------- -------------------- ----------------------------------------

2000000007 H003                   1 05-JUL-10 Evelyn Cassens       6094 Pearson Ave.                       

2000000007 H003                   2 05-JUL-10 Evelyn Cassens       6094 Pearson Ave.                       

2000000007 H003                   3 05-JUL-10 Evelyn Cassens       6094 Pearson Ave.                       



Q6b

When I ran the query for order 2000000007, I found that the order was broken into 2 shipments total. The first shipment had 2 packages, both shipped out on the same date. The second shipment had 1 package, shipped on a later date. 

So overall, this order did not go out in a single shipment, but instead was split into multiple shipments and packages, with more than one shipping date involved.

*/

-- Question #7a
SELECT c.custlastname || ', ' || c.custfirstname AS name,

       c.customerid,

       co.orderid

FROM customer c

LEFT JOIN custorder co ON co.customerid = c.customerid

WHERE c.state = 'PA' AND c.companyname IS NULL

ORDER BY name, co.orderid;

-- Question #7b
SELECT c.custlastname || ', ' || c.custfirstname AS name,

       c.customerid,

       co.orderid

FROM custorder co

RIGHT JOIN customer c ON co.customerid = c.customerid

WHERE c.state = 'PA' AND c.companyname IS NULL

ORDER BY name, co.orderid;

/* 

Q7a Query Results

NAME                                  CUSTOMERID ORDERID   

------------------------------------- ---------- ----------

Kaleta, Don                           I-300028             

Wolfe, Thomas                         I-300149   2000000497

Wolfe, Thomas                         I-300149   2001000670

Wolfe, Thomas                         I-300149   2001000736

Wolfe, Thomas                         I-300149   2001000751

Wolfe, Thomas                         I-300149   2001000768



Q7b Query Results

NAME                                  CUSTOMERID ORDERID   

------------------------------------- ---------- ----------

Kaleta, Don                           I-300028             

Wolfe, Thomas                         I-300149   2000000497

Wolfe, Thomas                         I-300149   2001000670

Wolfe, Thomas                         I-300149   2001000736

Wolfe, Thomas                         I-300149   2001000751

Wolfe, Thomas                         I-300149   2001000768
*/
-- Question #8

SELECT ip.partnumber,

       cat.categoryname

FROM inventorypart ip

FULL OUTER JOIN category cat

       ON cat.categoryid = ip.categoryid

ORDER BY ip.partnumber NULLS LAST, cat.categoryname;

/* Q8 Query Results

PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

ADT-001    Storage                       

ADT-002    Cables                        

ADT-003    Cables                        

ADT-004    Cables                        

ADT-005    Cables                        

ADT-006    Cables                        

ADT-007    Cables                        

BB-001     Basics                        

BB-002     Basics                        

BB-003     Basics                        

BB-004     Basics                        
PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

BB-005     Basics                        

BRK-001    Cables                        

BRK-002    Cables                        

BRK-003    Cables                        

BRK-004    Cables                        

BRK-005    Cables                        

BRK-006    Cables                        

BRK-007    Cables                        

BRK-008    Cables                        

BRK-009    Cables                        

BRK-010    Cables                        



PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

BRK-011    Cables                        

C-001      Basics                        

C-002      Basics                        

C-003      Basics                        

CAB-001    Cables                        

CAB-002    Cables                        

CAB-003    Cables                        

CAB-004    Cables                        

CAB-005    Cables                        

CAB-006    Cables                        

CAB-007    Cables                        

PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

CAB-008    Cables                        

CAB-009                                  

CAB-010                                  

CAB-011                                  

CAB-012                                  

CAB-013                                  

CAB-014                                  

CAB-015                                  

CAB-016                                  

CAB-017                                  

CAB-018                                  



PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

CAB-019                                  

CAB-020                                  

CAB-021                                  

CAB-022                                  

CAB-023                                  

CAB-024                                  

CAB-025                                  

CAB-026                                  

CAB-027                                  

CAB-028                                  

CD-001     Storage                       



PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

CD-002     Storage                       

CD-003     Storage                       

CD-004     Storage                       

CF-001     Processors                    

CF-002     Processors                    

CF-003     Processors                    

CF-004     Processors                    

CF-005     Processors                    

CF-006     Processors                    

CF-007     Processors                    

CF-008     Processors                    



PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

CF-009     Processors                    

CRD-001                                  

CRD-002                                  

CRD-003                                  

CRD-004                                  

CRD-005                                  

CRD-006                                  

CRD-007                                  

CRD-008                                  

CRD-009                                  

CTR-001    Computers                     



PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

CTR-002    Computers                     

CTR-003    Computers                     

CTR-004    Computers                     

CTR-005    Computers                     

CTR-006    Computers                     

CTR-007    Computers                     

CTR-008    Computers                     

CTR-009    Computers                     

CTR-010    Computers                     

CTR-011    Computers                     

CTR-012    Computers                     



PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

CTR-013    Computers                     

CTR-014    Computers                     

CTR-015    Computers                     

CTR-016    Computers                     

CTR-017    Computers                     

CTR-018    Computers                     

CTR-019    Computers                     

CTR-020    Computers                     

CTR-021    Computers                     

CTR-022    Computers                     

CTR-023    Computers                     



PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

CTR-024    Computers                     

CTR-025    Computers                     

CTR-026    Computers                     

CTR-027    Computers                     

CTR-028    Computers                     

CTR-029    Computers                     

DVD-001    Storage                       

DVD-002    Storage                       

ICAB-001   Cables                        

ICAB-002   Cables                        

ICAB-003   Cables                        



PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

ICAB-004   Cables                        

ICAB-005   Cables                        

ICAB-006   Cables                        

ICAB-007   Cables                        

ICAB-008   Cables                        

KEY-001    Basics                        

KEY-002    Basics                        

KEY-003    Basics                        

KEY-004    Basics                        

KEY-005    Basics                        

KEY-006    Basics                        



PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

KEY-007    Basics                        

KEY-008    Basics                        

KEY-009    Basics                        

MEM-001    Storage                       

MEM-002    Storage                       

MEM-003    Storage                       

MEM-004    Storage                       

MEM-005    Storage                       

MEM-006    Storage                       

MEM-007    Storage                       

MEM-008    Storage                       



PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

MEM-009    Storage                       

MEM-010    Storage                       

MEM-011    Storage                       

MEM-012    Storage                       

MIC-001    Basics                        

MIC-002    Basics                        

MIC-003    Basics                        

MIC-004    Basics                        

MIC-005    Basics                        

MIC-006    Basics                        

MIC-007    Basics                        



PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

MIC-008    Basics                        

MIC-009    Basics                        

MIC-010    Basics                        

MIC-011    Basics                        

MIC-012    Basics                        

MOD-001    Accessories                   

MOD-002    Accessories                   

MOD-003    Accessories                   

MOD-004    Accessories                   

MOD-005    Accessories                   

MOM-001    Basics                        



PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

MOM-002    Basics                        

MOM-003    Basics                        

MOM-004    Basics                        

MON-001    Basics                        

MON-002    Basics                        

MON-003    Basics                        

MON-004    Basics                        

MON-005    Basics                        

MON-006    Basics                        

MON-007    Basics                        

MON-008    Basics                        



PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

P-001      Processors                    

P-002      Processors                    

P-003      Processors                    

P-004      Processors                    

P-005      Processors                    

P-006      Processors                    

P-007      Processors                    

P-008      Processors                    

P-009      Processors                    

P-010      Processors                    

POW-001    Cables                        



PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

POW-002    Cables                        

POW-003    Cables                        

PRT-001    Accessories                   

PRT-002    Accessories                   

PRT-003    Accessories                   

PRT-004    Accessories                   

PRT-005    Accessories                   

PRT-006    Accessories                   

PS-001     Power                         

PS-002     Power                         

PS-003     Power                         



PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

PS-004     Power                         

SCN-001    Accessories                   

SCN-002    Accessories                   

SCN-003    Accessories                   

SFT-001    Software                      

SFT-002    Software                      

SFT-003    Software                      

SFT-004    Software                      

SFT-005    Software                      

SFT-006    Software                      

SFT-007    Software                      



PARTNUMBER CATEGORYNAME                  

---------- ------------------------------

SFT-008    Software                      

SFT-009    Software                      

SP-001     Basics                        

SP-002     Basics                        

SP-003     Basics                        

           Tablets                       





*/



-- Question #9a

SELECT c.custfirstname || ' ' || c.custlastname AS customer_name,

       c.customerid,

       co.orderdate,

       sh.shipmentid,

       ps.packagenumber,

       sh.shipname,

       ps.shippeddate

FROM custorder co

JOIN customer c ON c.customerid = co.customerid

LEFT JOIN shipment sh ON sh.orderid = co.orderid

LEFT JOIN packingslip ps ON ps.shipmentid = sh.shipmentid

WHERE co.orderid = '2001000807'

ORDER BY sh.shipmentid, ps.packagenumber;



--Question #9b



SELECT c.custfirstname || ' ' || c.custlastname AS customer_name,

       c.customerid,

       co.orderdate,

       sh.shipmentid,

       sh.shipname

FROM custorder co

JOIN customer  c  ON c.customerid = co.customerid

LEFT JOIN shipment   sh ON sh.orderid    = co.orderid

LEFT JOIN packingslip ps ON ps.shipmentid = sh.shipmentid

WHERE ps.shippeddate IS NULL

ORDER BY co.orderdate, c.customerid, sh.shipmentid;



/* 

Q9a Query Results



CUSTOMER_NAME                        CUSTOMERID ORDERDATE SHIPMENTID SHIPNAME            

------------------------------------ ---------- --------- ---------- --------------------

Zack Hill                            I-300120   23-FEB-11 M129       Zack Hill           

Joan Hedden                          I-300024   01-MAR-11 M137       Joan Hedden         

Louise Cool                          I-300044   13-MAR-11 M147       Louise Cool         

Verna McGrew                         I-300069   27-MAR-11 L257       Verna McGrew        

Steven Yaun                          I-300147   27-MAR-11 L258       Michelle Oakley     

Archie Doremski                      C-300032   29-MAR-11 H380       Archie Doremski     

Karen Mangus                         I-300015   29-MAR-11 M160       Karen Mangus        

Tom Baker                            I-300134   29-MAR-11 L259       Tom Baker           

Phil Reece                           I-300154   29-MAR-11 M159       Phil Reece          

Larry Osmanova                       C-300026   30-MAR-11 H382       Larry Osmanova      

Orville Gilliland                    C-300069   30-MAR-11 H381       Orville Gilliland   



Q9b Query Results



CUSTOMER_NAME                        CUSTOMERID ORDERDATE SHIPMENTID SHIPNAME            

------------------------------------ ---------- --------- ---------- --------------------

Shirley Osborne                      I-300013   30-MAR-11 M161       Shirley Osborne     

Charles Jones                        I-300087   30-MAR-11 L260       Charles Jones       

Mary Jo Wales                        I-300125   30-MAR-11 L261       Mary Jo Wales       

Cecil Scheetz                        C-300003   31-MAR-11 H384       Cecil Scheetz       

Marjorie Vandermay                   C-300045   31-MAR-11 H383       Marjorie Vandermay  

Daniel Rodkey                        I-300141   31-MAR-11 L262       Daniel Rodkey       

Andy Huegel                          I-300151   31-MAR-11 M162       Andy Huegel  

*/



-- Question #10



-- Q10a:

SELECT customerid FROM customer WHERE state = 'PA'

INTERSECT

SELECT customerid FROM custorder;



-- Q10b:

SELECT customerid FROM customer WHERE state = 'PA'

MINUS

SELECT customerid FROM custorder;



-- Q10c:

SELECT customerid FROM customer WHERE state = 'PA'

INTERSECT

SELECT customerid

FROM custorder

WHERE EXTRACT(YEAR FROM orderdate) = 2011;



-- Q10d:

SELECT customerid FROM customer WHERE state = 'PA'

MINUS

SELECT customerid

FROM custorder

WHERE EXTRACT(YEAR FROM orderdate) = 2011;





/*

Q10a Query Results

CUSTOMERID

----------

C-300006

C-300040

C-300062

I-300149



Q10b Query Results

CUSTOMERID

----------

I-300028



Q10c Query Results

CUSTOMERID

----------

C-300006

C-300040

I-300149



Q10d Query Results

CUSTOMERID

----------

C-300062

I-300028





*/



-- Question #11



-- Q11a: Cable parts ordered at least once

SELECT partnumber

FROM   inventorypart

WHERE  categoryid = 'CAB'

INTERSECT

SELECT DISTINCT partnumber FROM custorderline;



-- Q11b: Cable parts never ordered

SELECT partnumber

FROM   inventorypart

WHERE  categoryid = 'CAB'

MINUS

SELECT DISTINCT partnumber FROM custorderline;



-- Q11c: Cable parts ordered at least once since 2010-01-01

SELECT partnumber

FROM   inventorypart

WHERE  categoryid = 'CAB'

INTERSECT

SELECT DISTINCT col.partnumber

FROM   custorderline col

JOIN   custorder    co  ON co.orderid = col.orderid

WHERE  co.orderdate >= DATE '2010-01-01';



-- Q11d: Cable parts never ordered since 2010-01-01

SELECT partnumber

FROM   inventorypart

WHERE  categoryid = 'CAB'

MINUS

SELECT DISTINCT col.partnumber

FROM   custorderline col

JOIN   custorder    co  ON co.orderid = col.orderid

WHERE  co.orderdate >= DATE '2010-01-01';







/* Q11a Query Results3

PARTNUMBER

----------

ADT-003

ADT-004

ADT-005

ADT-006

ADT-007

BRK-001

BRK-002

BRK-003

BRK-004

BRK-005

BRK-007



Q11b Query Results

PARTNUMBER

----------

BRK-008

BRK-009

BRK-010

BRK-011

CAB-001

CAB-003

CAB-005

CAB-006

CAB-007

CAB-008

ICAB-001





PARTNUMBER

----------

ICAB-002

ICAB-003

ICAB-004

ICAB-005

ICAB-006

ICAB-007

ICAB-008

POW-002

POW-003



31 rows selected. 



Q11c Query Results

PARTNUMBER

----------

ADT-002

BRK-006

CAB-002

CAB-004

POW-001





PARTNUMBER

----------

ADT-003

ADT-004

ADT-005

ADT-006

ADT-007

BRK-001

BRK-002

BRK-003

BRK-004

BRK-005

BRK-007



PARTNUMBER

----------

BRK-008

BRK-009

BRK-010

BRK-011

CAB-001

CAB-003

CAB-005

CAB-006

CAB-007

CAB-008

ICAB-001



PARTNUMBER

----------

ICAB-002

ICAB-003

ICAB-004

ICAB-005

ICAB-006

ICAB-007

ICAB-008

POW-002

POW-003



31 rows selected. 



Q11d Query Results

PARTNUMBER

----------

ADT-002

BRK-006

CAB-002

CAB-004

POW-001





*/



-- Question #12 DISTINCT (UNION)

SELECT custfirstname AS firstname, custlastname AS lastname

FROM   customer

WHERE  state = 'FL'

UNION

SELECT firstname, lastname

FROM   employee

ORDER  BY firstname, lastname;



-- Q12b: Allow repeats (UNION ALL)

SELECT custfirstname AS firstname, custlastname AS lastname

FROM   customer

WHERE  state = 'FL'

UNION ALL

SELECT firstname, lastname

FROM   employee

ORDER  BY firstname, lastname;







/* Q12a Query Results



FIRSTNAME       LASTNAME            

--------------- --------------------

Allison         Roland              

Austin          Ortman              

Beth            Zobitz              

Calie           Zollman             

Charles         Jones               

David           Deppe               

David           Keck                

Edna            Lilley              

Gabrielle       Stevenson           

Gary            German              

Gregory         Hettinger           



FIRSTNAME       LASTNAME            

--------------- --------------------

Jack            Barrick             

Jack            Brose               

Jamie           Osman               

Jason           Krasner             

Jason           Wendling            

Jim             Manaugh             

Joanne          Rosner              

Joseph          Platt               

Karen           Mangus              

Kathleen        Xolo                

Kathryn         Deagen              



FIRSTNAME       LASTNAME            

--------------- --------------------

Kathy           Gunderson           

Kelly           Jordan              

Kristen         Gustavel            

Kristey         Moore               

Kristy          Moore               

Laura           Rodgers             

Marla           Reeder              

Meghan          Tyrie               

Melissa         Alvarez             

Michael         Abbott              

Michael         Emore               



FIRSTNAME       LASTNAME            

--------------- --------------------

Michelle        Nairn               

Nicholas        Albregts            

Patricha        Underwood           

Paul            Eckelman            

Phil            Reece               

Rita            Bush                

Ronald          Day                 

Ryan            Stahley             

Sherman         Cheswick            

Steve           Cochran             

Steve           Hess                



FIRSTNAME       LASTNAME            

--------------- --------------------

Steven          Hickman             

Tina            Yates               

Todd            Vigus               



47 rows selected. 



Q12b Query Results

FIRSTNAME       LASTNAME            

--------------- --------------------

Allison         Roland              

Allison         Roland              

Austin          Ortman              

Beth            Zobitz              

Calie           Zollman             

Charles         Jones               

Charles         Jones               

David           Deppe               

David           Keck                

Edna            Lilley              

Gabrielle       Stevenson           



FIRSTNAME       LASTNAME            

--------------- --------------------

Gary            German              

Gregory         Hettinger           

Jack            Barrick             

Jack            Brose               

Jamie           Osman               

Jason           Krasner             

Jason           Wendling            

Jim             Manaugh             

Jim             Manaugh             

Joanne          Rosner              

Joseph          Platt               



FIRSTNAME       LASTNAME            

--------------- --------------------

Karen           Mangus              

Kathleen        Xolo                

Kathryn         Deagen              

Kathy           Gunderson           

Kelly           Jordan              

Kristen         Gustavel            

Kristey         Moore               

Kristy          Moore               

Laura           Rodgers             

Marla           Reeder              

Meghan          Tyrie               



FIRSTNAME       LASTNAME            

--------------- --------------------

Melissa         Alvarez             

Michael         Abbott              

Michael         Emore               

Michelle        Nairn               

Nicholas        Albregts            

Patricha        Underwood           

Paul            Eckelman            

Phil            Reece               

Phil            Reece               

Rita            Bush                

Ronald          Day                 



FIRSTNAME       LASTNAME            

--------------- --------------------

Ryan            Stahley             

Ryan            Stahley             

Sherman         Cheswick            

Steve           Cochran             

Steve           Hess                

Steven          Hickman             

Tina            Yates               

Todd            Vigus   



*/



-- Question #13



-- Q13a: Using UNION (include customers with no orders)

SELECT (c.custfirstname || ' ' || c.custlastname || ', residential') AS display_name,

       c.customerid,

       co.orderid,

       co.orderdate

FROM customer c

LEFT JOIN custorder co ON co.customerid = c.customerid

WHERE c.state = 'PA' AND c.companyname IS NULL

UNION

SELECT (c.custfirstname || ' ' || c.custlastname || ', ' || c.companyname) AS display_name,

       c.customerid,

       co.orderid,

       co.orderdate

FROM customer c

LEFT JOIN custorder co ON co.customerid = c.customerid

WHERE c.state = 'PA' AND c.companyname IS NOT NULL

ORDER BY customerid, orderid;



-- Q13b: Same result, NO UNION (CASE)

SELECT CASE

         WHEN c.companyname IS NULL

           THEN c.custfirstname || ' ' || c.custlastname || ', residential'

         ELSE c.custfirstname || ' ' || c.custlastname || ', ' || c.companyname

       END AS display_name,

       c.customerid,

       co.orderid,

       co.orderdate

FROM customer c

LEFT JOIN custorder co ON co.customerid = c.customerid

WHERE c.state = 'PA'

ORDER BY c.customerid, co.orderid;
/* 



Q13a Query Results

DISPLAY_NAME                                                                   CUSTOMERID ORDERID    ORDERDATE

------------------------------------------------------------------------------ ---------- ---------- ---------

George Purcell, BMA Advertising Design                                         C-300006   2000000050 26-JUL-10

George Purcell, BMA Advertising Design                                         C-300006   2000000083 10-AUG-10

George Purcell, BMA Advertising Design                                         C-300006   2000000110 20-AUG-10

George Purcell, BMA Advertising Design                                         C-300006   2000000130 27-AUG-10

George Purcell, BMA Advertising Design                                         C-300006   2000000355 01-DEC-10

George Purcell, BMA Advertising Design                                         C-300006   2001000643 17-FEB-11

George Purcell, BMA Advertising Design                                         C-300006   2001000729 07-MAR-11

Mildred Jones, Computer Consultants                                            C-300040   2000000012 06-JUL-10

Mildred Jones, Computer Consultants                                            C-300040   2000000284 02-NOV-10

Mildred Jones, Computer Consultants                                            C-300040   2001000721 03-MAR-11

Mildred Jones, Computer Consultants                                            C-300040   2001000782 23-MAR-11
DISPLAY_NAME                                                                   CUSTOMERID ORDERID    ORDERDATE

------------------------------------------------------------------------------ ---------- ---------- ---------

Scott Gray, Security Installation                                              C-300062   2000000361 01-DEC-10

Scott Gray, Security Installation                                              C-300062   2000000421 10-DEC-10

Scott Gray, Security Installation                                              C-300062   2000000440 14-DEC-10

Scott Gray, Security Installation                                              C-300062   2000000496 17-DEC-10

Don Kaleta, residential                                                        I-300028                       

Thomas Wolfe, residential                                                      I-300149   2000000497 17-DEC-10

Thomas Wolfe, residential                                                      I-300149   2001000670 23-FEB-11

Thomas Wolfe, residential                                                      I-300149   2001000736 08-MAR-11

Thomas Wolfe, residential                                                      I-300149   2001000751 13-MAR-11

Thomas Wolfe, residential                                                      I-300149   2001000768 20-MAR-11

21 rows selected. 



Q13b Query Results

DISPLAY_NAME                                                                   CUSTOMERID ORDERID    ORDERDATE

------------------------------------------------------------------------------ ---------- ---------- ---------

George Purcell, BMA Advertising Design                                         C-300006   2000000050 26-JUL-10

George Purcell, BMA Advertising Design                                         C-300006   2000000083 10-AUG-10

George Purcell, BMA Advertising Design                                         C-300006   2000000110 20-AUG-10

George Purcell, BMA Advertising Design                                         C-300006   2000000130 27-AUG-10

George Purcell, BMA Advertising Design                                         C-300006   2000000355 01-DEC-10

George Purcell, BMA Advertising Design                                         C-300006   2001000643 17-FEB-11

George Purcell, BMA Advertising Design                                         C-300006   2001000729 07-MAR-11

Mildred Jones, Computer Consultants                                            C-300040   2000000012 06-JUL-10

Mildred Jones, Computer Consultants                                            C-300040   2000000284 02-NOV-10

Mildred Jones, Computer Consultants                                            C-300040   2001000721 03-MAR-11

Mildred Jones, Computer Consultants                                            C-300040   2001000782 23-MAR-11



DISPLAY_NAME                                                                   CUSTOMERID ORDERID    ORDERDATE

------------------------------------------------------------------------------ ---------- ---------- ---------

Scott Gray, Security Installation                                              C-300062   2000000361 01-DEC-10

Scott Gray, Security Installation                                              C-300062   2000000421 10-DEC-10

Scott Gray, Security Installation                                              C-300062   2000000440 14-DEC-10

Scott Gray, Security Installation                                              C-300062   2000000496 17-DEC-10

Don Kaleta, residential                                                        I-300028                       

Thomas Wolfe, residential                                                      I-300149   2000000497 17-DEC-10

Thomas Wolfe, residential                                                      I-300149   2001000670 23-FEB-11

Thomas Wolfe, residential                                                      I-300149   2001000736 08-MAR-11

Thomas Wolfe, residential                                                      I-300149   2001000751 13-MAR-11

Thomas Wolfe, residential                                                      I-300149   2001000768 20-MAR-11

*/



-- Question #14



--Q14a

BEGIN

  EXECUTE IMMEDIATE 'DROP TABLE lab2_contact PURGE';

EXCEPTION

  WHEN OTHERS THEN NULL;

END;



BEGIN

  EXECUTE IMMEDIATE 'DROP TABLE pool_fn PURGE';

  EXECUTE IMMEDIATE 'DROP TABLE pool_ln PURGE';

  EXECUTE IMMEDIATE 'DROP TABLE pool_city PURGE';

  EXECUTE IMMEDIATE 'DROP TABLE pool_state PURGE';

EXCEPTION

  WHEN OTHERS THEN NULL;

END;

/



CREATE TABLE pool_fn AS

SELECT firstname FROM employee

UNION

SELECT custfirstname FROM customer;



CREATE TABLE pool_ln AS

SELECT lastname FROM employee

UNION

SELECT custlastname FROM customer;



CREATE TABLE pool_city AS

SELECT city FROM customer

UNION

SELECT city FROM employee;



CREATE TABLE pool_state AS

SELECT state FROM customer

UNION

SELECT state FROM employee;



CREATE TABLE lab2_contact (

  firstname VARCHAR2(50),

  lastname  VARCHAR2(50),

  city VARCHAR2(50),

  state VARCHAR2(2)

) NOLOGGING;





INSERT INTO lab2_contact (firstname, lastname, city, state)

SELECT fn.firstname,

       ln.lastname,

       ci.city,

       st.state

FROM pool_fn fn

CROSS JOIN pool_ln ln

CROSS JOIN pool_city ci

CROSS JOIN pool_state st

WHERE ROWNUM <= 5000000;



COMMIT;

--Part B

SELECT COUNT(*) AS total_rows FROM lab2_contact;

-- Uniques by column

SELECT COUNT(DISTINCT firstname) AS uniq_first FROM lab2_contact;

SELECT COUNT(DISTINCT lastname)  AS uniq_last  FROM lab2_contact;

SELECT COUNT(DISTINCT city) AS uniq_city  FROM lab2_contact;

SELECT COUNT(DISTINCT state) AS uniq_state FROM lab2_contact;

/*

Results 

UNIQ_FIRST

----------

        88

 UNIQ_LAST

----------

       253

 UNIQ_CITY

----------

       225


*/
