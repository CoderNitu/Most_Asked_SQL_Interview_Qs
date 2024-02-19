------------------------------------    SQL INTERVIEW QUESTION  -----------------------------------------------

SELECT * FROM travel

--- Q1. Filter out the similar data into single specific data from the travel table 
--- Method 1: (using greatest and least function)

--- # The greatest function in SQL returns the greatest value from a list of values. 
--- # Conversely, The least function returns the least value from a list of values.

SELECT GREATEST(source,destination) source, LEAST(source,destination) destination, MAX(distance) distance
FROM travel
GROUP BY GREATEST(source,destination), LEAST(source,destination);

---OR---

SELECT DISTINCT GREATEST(source,destination) source, LEAST(source,destination) destination, distance 
FROM travel


--- Q1. Filter out the similar data into single specific data from the travel table 
--- Method 2: (using SELF JOIN and ranking function)

--- # The most easiest way to use/define unique identifiers in SQL is by using row number

WITH cte AS(
   SELECT *, ROW_NUMBER() OVER() AS SL_No
   FROM travel
)

SELECT t1.source,t1.destination,t1.distance
FROM cte AS t1
JOIN cte AS t2
ON t1.source=t2.destination
WHERE t1.sl_no<t2.sl_no;

--- Q1. Filter out the similar data into single specific data from the travel table 
--- Method 3: (using sub query)

--- EXISTS VS NOT EXISTS (mainly used as an alternative of joins)

--- # (Exists is a logical operator that is used to check for existance of data from a list of data.It returns true 
--- if the subquery returns atleast one or more data/records, otherwise false. In contra to it, NOT EXISTS operator
--- returns TRUE if the result of the subquery does not contain any rows based on the specified conditions.In case 
--- a single record in a table matches the subquery, the NOT EXISTS returns FALSE, and the execution of the subquery 
--- is stopped for a particular row in the table. The Boolean value is used to narrow down the rows from the outer 
--- select statement.In simple words, the subquery with NOT EXISTS checks every row from the outer query, returns 
--- TRUE or FALSE, and then sends the value to the outer query to use. In even simpler words, when you use SQL 
--- NOT EXISTS, the query returns all the rows that don’t satisfy the EXISTS condition. Just remember that for both
--- exists and not exists operator/clause, only when the we get true as a return from the subquery for each row from
--- the table,then only the data goes to the outer query for the filteration part, where if the true data is present
--- in the other query, we get that data as a output). 

SELECT * FROM 
travel t1
WHERE NOT EXISTS (SELECT * FROM travel t2
                  WHERE t1.source=t2.destination
                  AND t1.destination=t2.source
				  AND t1.destination>t2.destination);
				 
				   
---OR---

SELECT * FROM 
travel t1
WHERE EXISTS (SELECT * FROM travel t2
              WHERE t1.source=t2.destination
              AND t1.destination=t2.source
			  AND t1.destination<t2.destination);



-- Q2. Find the details of customer who has the 3rd highest age from the customer table. 

--- # This following query works only if we have unique data in the age cloumn or even if we have same value after  
---   the 3rd highest row. But, if we have duplicate/same value before that in the beginning 
---   or the middle, it doesn't work, for that we have to handle ties.

SELECT * FROM customer

SELECT * FROM customer 
ORDER BY age DESC
LIMIT 1 OFFSET 2;

--- # Handling ties refers to dealing with situations where multiple rows have the same value in the column used for
---  ordering. In the context of finding the customer with the 3rd highest age, ties occur when two or more customers
---  have the same age.Since in our case, two customers both with the age of 27, without handling ties, it might not
---  be clear which one should be considered the 3rd highest when ordering by age. The DENSE_RANK() window function 
---  is one way to handle ties by assigning the same rank to rows with the same age and give us the 3rd highest 
--   distinct age.

SELECT n.* FROM 
(SELECT *, DENSE_RANK() OVER(ORDER BY age DESC) AS SL_No
FROM customer) n
WHERE sl_no=3;







			  




