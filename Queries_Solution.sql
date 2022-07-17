
--Display snum,sname,city and comm of all salespeople.
SELECT snum, sname, city, comm
FROM salespeople;

--Display all snum without duplicates from all orders.
SELECT DISTINCT snum
FROM  orders;

--Display names and commissions of all salespeople in london.
SELECT names, commissions
FROM salespeople
WHERE city = 'LONDON';

--All customers with rating of 100.
SELECT * 
FROM customers
WHERE rating = 100;

--Produce orderno, amount and date form all rows in the order table.
SELECT orderno, amount, date
FROM order;

--All customers in San Jose, who have rating more than 200.
SELECT *
FROM customers
WHERE city = 'San Jose' AND rating > 200;

--All customers who were either located in San Jose or had a rating above 200.
SELECT *
FROM customers
WHERE city = 'San Jose' OR  rating > 200;

--All orders for more than $1000.
SELECT *
FROM orders
WHERE amount > $1000;

--Names and cities of all salespeople in london with commission above 0.10.
SELECT sname, city, comm
FROM salespeople
WHERE city = 'london' AND comm > 0.10;

--All customers excluding those with rating < = 100 unless they are located in Rome.
SELECT *
FROM customers
WHERE rating > 100 OR city = 'Rome';

--All salespeople either in Barcelona or in london.
SELECT *
FROM salespeople
WHERE city IN ('Barcelona','london');

--All salespeople with commission between 0.10 and 0.12. (Boundary values should be excluded)
SELECT *
FROM salespeople
WHERE comm > 0.10 AND comm < 0.12;

--All customers with NULL values in city column.
SELECT *
FROM customers
WHERE city IS NULL;

--All orders taken on Oct 3Rd and Oct 4th 1994.
SELECT *
FROM orders
WHERE orderdate IN ('1994-10-03','1994-10-04');

--All customers serviced by peel or Motika
SELECT *
FROM customers, orders
WHERE orders.cname = customers.cname
AND orders.sname IN(SELECT sname FROM salespeople WHERE sname IN ('PEEL','MOTIKA'));

--All customers whose names begin with a letter from A to B.
SELECT *
FROM customers
WHERE cname LIKE 'A%' OR cname LIKE 'B%';

--All orders except those with 0 or NULL value in amt field.
SELECT *
FROM orders
WHERE amt != 0 OR amt IS NOT NULL;

--Count the number of salespeople currently listing orders in the order table
SELECT COUNT(DISTINCT snum) AS 'salespeople currently listing orders'
FROM orders;

--Largest order taken by each salesperson, datewise.
SELECT snum, odate, MAX(AMT) AS 'Largest order'
FROM orders
GROUP BY odate, snum
ORDER BY odate,snum;

--Largest order taken by each salesperson with order value more than $3000.
SELECT snum, odate, MAX(AMT) AS 'Largest order'
FROM orders
WHERE AMT > 3000
GROUP BY odate, snum
ORDER BY odate, snum;

--Which day had the hightest total amount ordered.
SELECT odate, AMT, snum, cnum
FROM orders
WHERE AMT = ( SELECT MAX(AMT) FROM Orders);


--Count all orders for Oct 3rd.
SELECT COUNT(*) AS 'Orders on Oct 3rd'
FROM orders
WHERE odate = '1994-OCT-03';


--Count the number of different non NULL city values in customers table.
SELECT COUNT(DISTINCT city)
FROM customers;


--Select each customer’s smallest order.
SELECT cnum, MIN(AMT)
FROM orders
GROUP BY cnum;
 

--First customer in alphabetical order whose name begins with G.
SELECT MIN(cname)
FROM customers
WHERE cname LIKE 'G%';


--Get the output like “ For dd/mm/yy there are ___ orders.
SELECT 'For'  (CONVERT(varchar(10), GETDATE(),120)) || 'there are' || COUNT(*) || 'Orders'
FROM orders
GROUP BY odate;


--Assume that each salesperson has a 12% commission. Produce order no., salesperson no., 
--and amount of salesperson’s commission for that order.
SELECT onum, snum, AMT, AMT * 0.12 AS 'Commission'
FROM orders
ORDER BY snum;


--Find highest rating in each city. Put the output in this form. For the city (city), 
--the highest rating is : (rating).
Select 'For the city (' || city || '), the highest rating is : (' || MAX(rating) || ')'
FROM customers
GROUP BY city;

--Display the totals of orders for each day and place the results in descending order.
SELECT odate, COUNT(onum) AS 'Total No of Orders'
FROM orders
GROUP BY odate
ORDER BY COUNT(onum) DESC;


--All combinations of salespeople and customers who shared a city. (ie same city).
SELECT sname, cname, S.City AS City
FROM salesPeople AS S, customers AS C
WHERE S.City = C.City;


--Name of all customers matched with the salespeople serving them
SELECT cname, sname 
FROM customers AS C, salesPeople AS S
WHERE C.Snum = S.Snum;


--List each order number followed by the name of the customer who made the order.
SELECT onum, cname
FROM customers AS C, orders AS O
WHERE O.cnum = C.cnum;


--Names of salesperson and customer for each order after the order number.
SELECT onum, sname, cname
FROM orders AS O, customers AS C, salesPeople AS S
WHERE O.cnum = C.cnum and O.snum = S.snum;


--Produce all customer serviced by salespeople with a commission above 12%.
SELECT cname, sname, comm
FROM customers AS C, salesPeople AS S
WHERE comm > 0.12 AND C.snum = S.snum;


--Calculate the amount of the salesperson’s commission on each order with a rating above 100.
SELECT sname, AMT*comm, rating
FROM customers AS C, salesPeople AS S, orders AS O
WHERE rating > 100 AND 
        S.snum = C.snum AND 
        S.snum = O.snum AND 
        O.cnum = C.cnum;


--Find all pairs of customers having the same rating.
SELECT a.cname, b.cname, a.rating
FROM customers a, customers b
WHERE a.rating = b.rating and a.cnum != b.cnum;


--Find all pairs of customers having the same rating, each pair coming once only.
SELECT a.cname, b.cname, a.rating
FROM customers a, customers b
WHERE a.rating = b.rating AND a.cnum != b.cnum AND a.cnum < b.cnum;


--Policy is to assign three salesperson to each customers. Display all such combinations.
Select cname, sname
FROM salesPeople, customers
WHERE sname IN  ( SELECT sname FROM salespeople WHERE rownum <= 3)
ORDER BY cname;

--Display all customers located in cities where salesman serres has customer.
SELECT cname
FROM customers
WHERE city IN ( SELECT city FROM customers AS C, orders AS O
                WHERE C.cnum = O.cnum AND 
                    O.snum IN ( SELECT snum FROM salesPeople 
                                WHERE sname = 'Serres'));


--Find all pairs of customers served by single salesperson.
SELECT DISTINCT a.cname
FROM customers a ,customers b
WHERE a.snum = b.snum and a.cnum != b.cnum;


--Produce all pairs of salespeople which are living in the same city. 
--Exclude combinations of salespeople with themselves as well as duplicates with the order reversed.
SELECT a.sname, b.sname
FROM salesPeople a, salesPeople b
WHERE a.snum > b.snum AND a.city = b.city;


--Produce all pairs of orders by given customer, names that customers and eliminates duplicates.
SELECT c.cname, a.onum, b.onum
FROM orders a, orders b, customers c
WHERE a.cnum = b.cnum AND 
        a.onum > b.onum AND 
        c.cnum = a.cnum;


--Produce names and cities of all customers with the same rating as Hoffman.
SELECT cname, city
FROM customers
WHERE rating = (SELECT rating FROM customers WHERE cname = 'Hoffman') AND cname != 'Hoffman';


--Extract all the orders of Motika.
SELECT onum
FROM orders
WHERE snum = ( SELECT snum FROM salesPeople WHERE sname = 'Motika');


--All orders credited to the same salesperson who services Hoffman
SELECT onum, sname, cname, AMT
from orders AS O, salesPeople AS S, customers C
where O.snum = S.snum AND O.cnum = C.cnum AND
          O.snum = ( SELECT snum FROM orders
                        WHERE cnum = ( SELECT cnum FROM customers
                                        WHERE cname = 'Hoffman'));


--All orders that are greater than the average for Oct 4.
SELECT *
FROM orders
WHERE AMT > ( SELECT AVG(AMT) FROM orders
                WHERE odate = '1994-OCT-03');


--Find average commission of salespeople in london.
SELECT AVG(comm)
FROM salesPeople
WHERE city = 'London';


--Find all orders attributed to salespeople servicing customers in london.
SELECT snum, cnum
FROM orders
WHERE cnum IN (SELECT cnum FROM customers WHERE city = 'London');


--Extract commissions of all salespeople servicing customers in London.
SELECT comm
FROM salesPeople
WHERE snum IN (SELECT snum FROM customers WHERE city = 'London');


--Find all customers whose cnum is 1000 above the snum of serres.
SELECT cnum, cname from customers
where cnum > ( SELECT snum + 1000
                FROM salesPeople
                WHERE sname = 'Serres');