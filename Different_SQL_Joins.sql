/*

Katie O'Daniel

Different SQL Joins 

*/



/*-- Question #1

5. SELECT NAME, COUNT(*), AVG(RATING) 

1. FROM BOOKSHELF 

2. WHERE RATING>1 

3. GROUP BY CATEGORY_NAME 

4. HAVING CATEGORY_NAME LIKE ‘A%’ 

6. ORDER BY COUNT(*); 

*/



-- Question #2

SELECT DISTINCT SUBSTR(Phone, 1, 3) AS Area_Code

FROM Customer

WHERE state = 'CO';

/* Q2 Query Results

ARE

---

719

970

728

644

720

*/



-- Question #3



SELECT SUBSTR(Phone, 1, 3) AS Area_Code, COUNT(*) AS Customer_Count

FROM Customer

WHERE State = 'CO'

GROUP BY SUBSTR(Phone, 1, 3)

ORDER BY Customer_Count DESC;



/* Q3 Query Results



ARE CUSTOMER_COUNT

--- --------------

719              4

970              2

644              1

720              1

728              1



*/



-- Question #4



SELECT SUBSTR(Phone, 1, 3) AS Area_code

FROM Customer

WHERE State = 'CO'

GROUP BY SUBSTR(Phone, 1, 3)

HAVING COUNT(*) = (

    SELECT MAX(cnt)

FROM (

SELECT COUNT(*) AS cnt

FROM Customer

WHERE State = 'CO'

GROUP BY SUBSTR(Phone, 1, 3)

  )

);

/* Q4 Query Results



ARE

---

719



*/



-- Question #5



SELECT CustLastName || ', ' || CustFirstName AS name, City, State, Phone

FROM Customer

WHERE State = 'CO' AND SUBSTR(Phone, 1, 3) IN (

    SELECT SUBSTR(Phone, 1, 3)

    FROM Customer

    WHERE State = 'CO'

    GROUP BY SUBSTR(Phone, 1, 3)

    HAVING COUNT(*) = (

      SELECT MAX(cnt)

      FROM (

        SELECT COUNT(*) AS cnt

        FROM Customer

        WHERE State = 'CO'

        GROUP BY SUBSTR(Phone, 1, 3)

      )

    )

  )

ORDER BY CustLastName, CustFirstName;





/* Q5 Query Results



NAME                                  CITY                 ST PHONE       

------------------------------------- -------------------- -- ------------

Kaakeh, Paul                          Gunnison             CO 719-750-4539

Rice, Paul                            Craig                CO 719-541-1837

Rodkey, Daniel                        Lamar                CO 719-748-3205

Smith, Matt                           Montrose             CO 719-822-8828





*/





/* Q6  Results

We want to know which area codes in CO have the most people, that would be 719

which has 4 people. This is helpful to know for a business knowing where the most 

common area codes lets marketing people know where a major amount of customers are

so they can plan where they might get the most sales or people





*/

--Where I left off

-- Question #7



SELECT CustomerID, COUNT(*) AS NumOrders

FROM CustOrder

WHERE OrderDate >= DATE '2010-08-01' AND OrderDate <  DATE '2010-09-01'

GROUP BY CustomerID

ORDER BY NumOrders DESC;



/* Q7 Query Results





CUSTOMERID NUMORDERS

---------- ----------

C-300006            3

I-300016            2

C-300041            2

C-300031            2

I-300015            2

C-300055            2

I-300010            2

C-300005            2

C-300027            2

I-300014            2

I-300070            1

C-300017            1

I-300031            1

I-300126            1

C-300001            1

I-300091            1

I-300020            1

C-300011            1

I-300069            1

C-300033            1

I-300024            1

I-300117            1

C-300002            1

I-300132            1

I-300005            1

C-300010            1

I-300122            1

C-300013            1

C-300053            1

I-300068            1

C-300020            1

I-300096            1

I-300120            1

I-300112            1

I-300115            1

I-300076            1

C-300035            1

I-300012            1

I-300095            1

I-300017            1

I-300026            1

I-300042            1

I-300097            1

I-300093            1

I-300102            1

I-300007            1

I-300138            1

I-300043            1

I-300108            1

I-300044            1

I-300110            1

C-300051            1

I-300009            1

C-300004            1

C-300026            1

C-300003            1

I-300004            1

I-300025            1

I-300129            1

I-300002            1

I-300011            1

I-300081            1

I-300088            1

I-300013            1

I-300061            1

I-300018            1

*/

-- Question #8



SELECT MAX(cnt) AS MaxOrdersInAug2010

FROM (SELECT CustomerID, COUNT(*) AS cnt

FROM CustOrder

WHERE OrderDate >= DATE '2010-08-01' AND OrderDate < DATE '2010-09-01'

GROUP BY CustomerID

);





/* Q8 Query Results



MAXORDERSINAUG2010

------------------

                 3



*/



-- Question 9



WITH counts AS (SELECT CustomerID, COUNT(*) AS cnt

FROM CustOrder 

WHERE OrderDate >= DATE '2010-08-01'AND OrderDate <  DATE '2010-09-01'

GROUP BY CustomerID

)

SELECT CustomerID, cnt

FROM counts

WHERE cnt = (SELECT MAX(cnt) FROM counts);





/* Q9 Query Results



CUSTOMERID        CNT

---------- ----------

C-300006            3



*/



-- Question #10



WITH counts AS (

SELECT CustomerID, COUNT(*) AS cnt

FROM CustOrder

WHERE OrderDate >= DATE '2010-08-01' AND OrderDate <  DATE '2010-09-01'

GROUP BY CustomerID

)

SELECT CustomerID, cnt AS NumOrders

FROM counts

WHERE cnt > (SELECT AVG(cnt) FROM counts)

ORDER BY NumOrders DESC;





/* Q10 Query Results



CUSTOMERID NUMORDERS

---------- ----------

C-300006            3

I-300016            2

C-300041            2

C-300031            2

I-300015            2

C-300055            2

I-300010            2

C-300005            2

C-300027            2

I-300014            2



*/



-- Question #11



WITH counts AS (SELECT CustomerID, COUNT(*) AS cnt

FROM CustOrder

WHERE OrderDate >= DATE '2010-08-01' AND OrderDate <  DATE '2010-09-01'

GROUP BY CustomerID

)

SELECT CustomerID, cnt AS NumOrders

FROM counts

WHERE cnt < (SELECT AVG(cnt) FROM counts)

ORDER BY NumOrders ASC;





/* Q11 Query Results





CUSTOMERID  NUMORDERS

---------- ----------

C-300006            3

I-300016            2

C-300041            2

C-300031            2

I-300015            2

C-300055            2

I-300010            2

C-300005            2

C-300027            2

I-300014            2

I-300070            1

C-300017            1

I-300031            1

I-300126            1

C-300001            1

I-300091            1

I-300020            1

C-300011            1

I-300069            1

C-300033            1

I-300024            1

I-300117            1

C-300002            1

I-300132            1

I-300005            1

C-300010            1

I-300122            1

C-300013            1

C-300053            1

I-300068            1

C-300020            1

I-300096            1

I-300120            1

I-300112            1

I-300115            1

I-300076            1

C-300035            1

I-300012            1

I-300095            1

I-300017            1

I-300026            1

I-300042            1

I-300097            1

I-300093            1

I-300102            1

I-300007            1

I-300138            1

I-300043            1

I-300108            1

I-300044            1

I-300110            1

C-300051            1

I-300009            1

C-300004            1

C-300026            1

C-300003            1

I-300004            1

I-300025            1

I-300129            1

I-300002            1

I-300011            1

I-300081            1

I-300088            1

I-300013            1

I-300061            1

I-300018            1



*/



/* Q12. Why would a business want Q10 & Q11?

For customers who are above average we would want to make sure that they stay giving them special treatment.

While customers who are below if cuts are to happen will be the first to go since they are the least



*/

-- Question #13



SELECT c.CustomerID,

       c.CompanyName,

       c.CustLastName || ', ' || c.CustFirstName AS ContactName, TO_CHAR(o.OrderDate, 'MM.DD.YYYY') AS OrderDate

FROM Customer c

JOIN CustOrder o ON o.CustomerID = c.CustomerID

WHERE c.State = 'IN' AND o.OrderDate >= DATE '2010-01-01' AND o.OrderDate <  DATE '2011-01-01'

ORDER BY o.OrderDate ASC;





/* Q13 Query Results



CUSTOMERID COMPANYNAME                              CONTACTNAME                           ORDERDATE 

---------- ---------------------------------------- ------------------------------------- ----------

C-300001   Baker and Company                        Abbott, Gregory                       07.08.2010

C-300001   Baker and Company                        Abbott, Gregory                       07.14.2010

C-300001   Baker and Company                        Abbott, Gregory                       08.13.2010

I-300030                                            Quintero, Eric                        09.15.2010

C-300014   R and R Air                              Bending, Cathy                        10.04.2010

C-300001   Baker and Company                        Abbott, Gregory                       12.02.2010

I-300147                                            Yaun, Steven                          12.07.2010

*/



-- Question #14



SELECT c.CompanyName,

       c.CustTitle || ' ' || SUBSTR(c.CustFirstName,1,1) || '. ' || c.CustLastName AS ContactName,

       o.OrderDate,

       o.RequiredDate

FROM Customer c

INNER JOIN CustOrder o ON o.CustomerID = c.CustomerID

WHERE c.CustomerID = 'C-300001'

ORDER BY o.OrderDate ASC;





/* Q14 Query Results



COMPANYNAME                              CONTACTNAME                   ORDERDATE REQUIREDD

---------------------------------------- ----------------------------- --------- ---------

Baker and Company                        Mr. G. Abbott                 08-JUL-10 12-JUL-10

Baker and Company                        Mr. G. Abbott                 14-JUL-10 15-JUL-10

Baker and Company                        Mr. G. Abbott                 13-AUG-10 20-AUG-10

Baker and Company                        Mr. G. Abbott                 02-DEC-10 08-DEC-10

Baker and Company                        Mr. G. Abbott                 27-JAN-11 03-FEB-11

Baker and Company                        Mr. G. Abbott                 24-FEB-11 03-MAR-11

Baker and Company                        Mr. G. Abbott                 10-MAR-11 15-MAR-11



*/



-- Question #15



SELECT o.ORDERID,

       ip.PARTNUMBER,

       ip.PARTDESCRIPTION,

       cl.UNITPRICE,

       cl.ORDERQUANTITY,

       cat.CATEGORYNAME

FROM   CUSTORDER o

INNER JOIN CUSTORDERLINE cl ON o.ORDERID = cl.ORDERID

INNER JOIN INVENTORYPART ip ON cl.PARTNUMBER = ip.PARTNUMBER

INNER JOIN CATEGORY cat ON ip.CATEGORYID = cat.CATEGORYID

WHERE  UPPER(ip.PARTDESCRIPTION) LIKE '%BOARD GAMES%'

ORDER  BY cl.ORDERQUANTITY DESC;







/* Q15 Query Results





ORDERID    PARTNUMBER PARTDESCRIPTION                                     UNITPRICE ORDERQUANTITY CATEGORYNAME                  

---------- ---------- -------------------------------------------------- ---------- ------------- ------------------------------

2001000536 SFT-005    BOARD GAMES                                              9.99            15 Software                      

2000000050 SFT-005    BOARD GAMES                                              9.99            14 Software                      

2000000279 SFT-005    BOARD GAMES                                              9.99            10 Software                      

2000000426 SFT-005    BOARD GAMES                                              9.99            10 Software                      

2000000139 SFT-005    BOARD GAMES                                              9.99             2 Software                      

2000000348 SFT-005    BOARD GAMES                                              9.99             2 Software                      

2000000436 SFT-005    BOARD GAMES                                              9.99             1 Software                      

2000000206 SFT-005    BOARD GAMES                                              9.99             1 Software                      

2001000600 SFT-005    BOARD GAMES                                              9.99             1 Software                      

2001000722 SFT-005    BOARD GAMES                                              9.99             1 Software                      

2000000005 SFT-005    BOARD GAMES                                              9.99             1 Software                      

2000000362 SFT-005    BOARD GAMES                                              9.99             1 Software                      

2000000040 SFT-005    BOARD GAMES                                              9.99             1 Software                      

2000000011 SFT-005    BOARD GAMES     



*/



-- Question #16



SELECT

  o.OrderID,

  ip.PartNumber,

  ip.PartDescription,

  cl.UnitPrice,

  cl.OrderQuantity

FROM CustOrder o

INNER JOIN CustOrderLine cl ON o.OrderID = cl.OrderID

INNER JOIN InventoryPart ip ON cl.PartNumber = ip.PartNumber

WHERE o.CustomerID = 'C-300001' AND o.OrderDate = DATE '2010-07-14'

ORDER BY cl.OrderQuantity DESC;





/* Q16 Query Results



ORDERID    PARTNUMBER PARTDESCRIPTION                                     UNITPRICE ORDERQUANTITY

---------- ---------- -------------------------------------------------- ---------- -------------

2000000032 BRK-011    2ND PARALLEL PORT                                        5.99            20

2000000032 CTR-019    FLY XPST                                              1717.99             9

2000000032 ADT-003    EXTERNAL SCSI-3 MALE TERMINATOR                         39.99             8

2000000032 CAB-027    2FT 3/1 SCSI CABLE                                      44.99             6

2000000032 SCN-002    SCANJET BUSINESS SERIES COLOR SCANNER                     249             4



*/



-- Question #17



SELECT TO_CHAR(o.OrderDate, 'MM.DD.YYYY') AS OrderDate,

  o.OrderID,

  ip.PartNumber,

  ip.PartDescription,

  cl.UnitPrice,

  cl.OrderQuantity

FROM Customer c

INNER JOIN CustOrder o ON c.CustomerID = o.CustomerID

INNER JOIN CustOrderLine cl ON o.OrderID    = cl.OrderID

INNER JOIN InventoryPart ip ON cl.PartNumber = ip.PartNumber

WHERE c.CompanyName = 'Bankruptcy Help' AND EXTRACT(YEAR FROM o.OrderDate) = 2011

ORDER BY o.OrderDate DESC, cl.OrderQuantity DESC;



/* Q17 Query Results



ORDERDATE  ORDERID    PARTNUMBER PARTDESCRIPTION                                     UNITPRICE ORDERQUANTITY

---------- ---------- ---------- -------------------------------------------------- ---------- -------------

03.22.2011 2001000778 BRK-002    1X4 USB CABLE AND BRACKET                                9.99            20

03.22.2011 2001000778 MEM-004    30.7GB HARD DRIVE                                      269.99            10

03.22.2011 2001000778 P-006      600 PENTIUM III PROCESSOR                              339.99             6

02.28.2011 2001000699 MOD-002    112K DUAL MODEM                                         89.99            16

02.28.2011 2001000699 MEM-001    2MB FLASH BUFFER MEMORY                                259.95            12

02.28.2011 2001000699 PRT-003    LASER JET 2500SE                                          699             3

02.24.2011 2001000676 MIC-009    WHEEL MOUSE                                              29.5            27

02.14.2011 2001000622 BB-004     SOCKET MINI BAREBONE                                   199.99             6

02.14.2011 2001000622 P-005      700 PENTIUM III PROCESSOR                              399.99             4



*/



-- Question #18



SELECT TO_CHAR(o.OrderDate, 'MM.DD.YYYY') AS OrderDate,

  o.OrderID,

  ip.PartNumber,

  ip.PartDescription,

  cl.UnitPrice,

  cl.OrderQuantity,

  (cl.UnitPrice * cl.OrderQuantity) AS LineTotal

FROM Customer c

INNER JOIN CustOrder o ON c.CustomerID = o.CustomerID

INNER JOIN CustOrderLine cl  ON o.OrderID = cl.OrderID

INNER JOIN InventoryPart ip  ON cl.PartNumber = ip.PartNumber

WHERE c.CompanyName = 'Bankruptcy Help' AND EXTRACT(YEAR FROM o.OrderDate) = 2011

ORDER BY o.OrderDate DESC, cl.OrderQuantity DESC;







/* Q18 Query Results



ORDERDATE  ORDERID    PARTNUMBER PARTDESCRIPTION                                     UNITPRICE ORDERQUANTITY  LINETOTAL

---------- ---------- ---------- -------------------------------------------------- ---------- ------------- ----------

03.22.2011 2001000778 BRK-002    1X4 USB CABLE AND BRACKET                                9.99            20      199.8

03.22.2011 2001000778 MEM-004    30.7GB HARD DRIVE                                      269.99            10     2699.9

03.22.2011 2001000778 P-006      600 PENTIUM III PROCESSOR                              339.99             6    2039.94

02.28.2011 2001000699 MOD-002    112K DUAL MODEM                                         89.99            16    1439.84

02.28.2011 2001000699 MEM-001    2MB FLASH BUFFER MEMORY                                259.95            12     3119.4

02.28.2011 2001000699 PRT-003    LASER JET 2500SE                                          699             3       2097

02.24.2011 2001000676 MIC-009    WHEEL MOUSE                                              29.5            27      796.5

02.14.2011 2001000622 BB-004     SOCKET MINI BAREBONE                                   199.99             6    1199.94

02.14.2011 2001000622 P-005      700 PENTIUM III PROCESSOR                              399.99             4    1599.96



*/



-- Question #19

SELECT

  c.CustomerID,

  c.CompanyName,

  c.CustLastName || ', ' || c.CustFirstName AS contact_name,

  COUNT(*) AS orders_placed

FROM Customer c

INNER JOIN CustOrder o ON c.CustomerID = o.CustomerID

WHERE c.State = 'IN' AND o.OrderDate >= DATE '2011-01-01' AND o.OrderDate <  DATE '2011-02-01'

GROUP BY c.CustomerID, c.CompanyName, c.CustLastName, c.CustFirstName

ORDER BY orders_placed ASC;





/* Q19 Query Results



CUSTOMERID COMPANYNAME                              CONTACT_NAME                          ORDERS_PLACED

---------- ---------------------------------------- ------------------------------------- -------------

C-300001   Baker and Company                        Abbott, Gregory                                   1

C-300014   R and R Air                              Bending, Cathy                                    1

I-300030       

Quintero, Eric                                    2

*/



-- Question 20 



SELECT cat.CategoryName, ROUND(AVG(ip.StockLevel), 2) AS AvgStock

FROM Category cat

INNER JOIN InventoryPart ip ON ip.CategoryID = cat.CategoryID

GROUP BY cat.CategoryName

ORDER BY AvgStock ASC;



/* Q20 Query Results



CATEGORYNAME                     AVGSTOCK

------------------------------ ----------

Computers                            2.45

Accessories                          9.21

Power                                10.5

Storage                             20.47

Basics                               20.5

Processors                          23.74

Software                            33.89

Cables                              35.86



*/



-- Question 21 



SELECT cat.CategoryName || ': ' || cat.Description AS CatDetail, COUNT(ip.PartNumber) AS NumPartTypes

FROM Category cat

LEFT JOIN InventoryPart ip ON ip.CategoryID = cat.CategoryID

GROUP BY cat.CategoryName, cat.Description

ORDER BY NumPartTypes ASC;



/* Q21 Query Results

CATDETAIL                                                                                                                            NUMPARTTYPES

------------------------------------------------------------------------------------------------------------------------------------ ------------

Tablets: Mobile Computers                                                                                                                       0

Power: Power Supplies                                                                                                                           4

Software: Games, maps                                                                                                                           9

Accessories: Scanners, Printers, Modems                                                                                                        14

Processors: Athlon, Celeron, Pentium, Fans                                                                                                     19

Storage: CD-ROM, DVD, Hard Drives, Memory                                                                                                      19

Computers: Assembled Computers                                                                                                                 29

Cables: Printer, Keyboard, Internal, SCSI, Connectors, Brackets                                                                                36

Basics: Casing, Barebone, Monitors, Keyboards, Mice                                                                                            44

*/



--Question 22



SELECT MAX(ip.Weight) AS HeaviestWeight

FROM InventoryPart ip

INNER JOIN Category cat ON ip.CategoryID = cat.CategoryID

WHERE cat.CategoryName = 'Software';



/* Q22 Query Results

HEAVIESTWEIGHT

--------------

          .438

*/



--Question 23



SELECT cat.CategoryName, MAX(ip.Weight) AS HeaviestWeight

FROM Category cat

INNER JOIN InventoryPart ip ON ip.CategoryID = cat.CategoryID

WHERE cat.CategoryName IN ('Power', 'Software', 'Storage')

GROUP BY cat.CategoryName

ORDER BY cat.CategoryName ASC;



/* Q23 Query Results

CATEGORYNAME                   HEAVIESTWEIGHT

------------------------------ --------------

Power                                       3

Software                                 .438

Storage                                     4

*/



-- Question 24

WITH MaxPerCat AS (

  SELECT

    cat.CategoryID,

    cat.CategoryName,

    MAX(ip.Weight) AS MaxWeight

  FROM Category cat

  INNER JOIN InventoryPart ip ON ip.CategoryID = cat.CategoryID

  WHERE cat.CategoryName IN ('Power', 'Software', 'Storage')

  GROUP BY cat.CategoryID, cat.CategoryName

)

SELECT

  m.CategoryName,

  m.MaxWeight AS HeaviestWeight,

  ip.PartDescription

FROM MaxPerCat m

INNER JOIN InventoryPart ip ON ip.CategoryID = m.CategoryID AND ip.Weight = m.MaxWeight

ORDER BY m.CategoryName ASC, ip.PartDescription;



/* Q24 Query Results

CATEGORYNAME                   HEAVIESTWEIGHT PARTDESCRIPTION                                   

------------------------------ -------------- --------------------------------------------------

Power                                       3 250 WATT POWER SUPPLY                             

Power                                       3 300 WATT POWER SUPPLY                             

Software                                 .438 BOARD GAMES                                       

Software                                 .438 DESKTOP PUBLISHER                                 

Storage                                     4 ETHERNET FIBER OPTIC MINI-TRANSCEIVER   

*/



/*--Question 25

Yes there are ways to make everything run faster, I do not know but after asking and looking around, the biggest thing is 

making sure you are only bring the necessary tables and data you need to use. Make sure to know what function to use.

Avoid functions on columns in WHERE unless using function-based indexes

*/
