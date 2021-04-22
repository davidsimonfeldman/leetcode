/*
585. Investments in 2016
Medium
SQL Schema
Write a query to print the sum of all total investment values in 2016 (TIV_2016), to a scale of 2 decimal places, for all policy holders who meet the following criteria:

Have the same TIV_2015 value as one or more other policyholders.
Are not located in the same city as any other policyholder (i.e.: the (latitude, longitude) attribute pairs must be unique).
Input Format:
The insurance table is described as follows:

| Column Name | Type          |
|-------------|---------------|
| PID         | INTEGER(11)   |
| TIV_2015    | NUMERIC(15,2) |
| TIV_2016    | NUMERIC(15,2) |
| LAT         | NUMERIC(5,2)  |
| LON         | NUMERIC(5,2)  |
where PID is the policyholder's policy ID, TIV_2015 is the total investment value in 2015, TIV_2016 is the total investment value in 2016, LAT is the latitude of the policy holder's city, and LON is the longitude of the policy holder's city.

Sample Input

| PID | TIV_2015 | TIV_2016 | LAT | LON |
|-----|----------|----------|-----|-----|
| 1   | 10       | 5        | 10  | 10  |
| 2   | 20       | 20       | 20  | 20  |
| 3   | 10       | 30       | 20  | 20  |
| 4   | 10       | 40       | 40  | 40  |
Sample Output

| TIV_2016 |
|----------|
| 45.00    |
Explanation

The first record in the table, like the last record, meets both of the two criteria.
The TIV_2015 value '10' is as the same as the third and forth record, and its location unique.

The second record does not meet any of the two criteria. Its TIV_2015 is not like any other policyholders.

And its location is the same with the third record, which makes the third record fail, too.

So, the result is the sum of TIV_2016 of the first and last record, which is 45.




SELECT ROUND(SUM(TIV_2016),2) AS TIV_2016
FROM
(SELECT TIV_2015,TIV_2016,LAT, LON ,
COUNT(*) OVER(PARTITION BY TIV_2015) AS CNT1,
COUNT(*) OVER(PARTITION BY LAT, LON) AS CNT2
FROM INSURANCE
) AS TBL
WHERE CNT1 > =2 AND CNT2 =1


 
 
 
 SELECT SUM(insurance.TIV_2016) AS TIV_2016
FROM insurance
WHERE insurance.TIV_2015 IN -- meet the creteria #1
    (
       SELECT TIV_2015
        FROM insurance
        GROUP BY TIV_2015
        HAVING COUNT(*) > 1
        )
AND CONCAT(LAT, LON) IN -- meet the creteria #2
    (
      SELECT CONCAT(LAT, LON) -- trick to take the LAT and LON as a pair
      FROM insurance
      GROUP BY LAT , LON
      HAVING COUNT(*) = 1
)
;


select sum(TIV_2016) TIV_2016
from insurance a
where 1 = (select count(*) from insurance b where a.LAT=b.LAT and a.LON=b.LON) 
and 1 < (select count(*) from insurance c where a.TIV_2015=c.TIV_2015)  ;
 
 
 
 
 
 select sum ([TIV_2016]) TIV_2016 from 
(SELECT [PID] ,[TIV_2015] ,[TIV_2016] ,[LAT] ,[LON],
COUNT(*)over(partition by [TIV_2015])t,
COUNT(*)over(partition by lat,lon) l
  FROM  [insurance])s
  where l=1 and t>1
