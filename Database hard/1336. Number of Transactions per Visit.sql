/*
1336. Number of Transactions per Visit
Hard


SQL Schema
Table: Visits

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| visit_date    | date    |
+---------------+---------+
(user_id, visit_date) is the primary key for this table.
Each row of this table indicates that user_id has visited the bank in visit_date.
 

Table: Transactions

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| user_id          | int     |
| transaction_date | date    |
| amount           | int     |
+------------------+---------+
There is no primary key for this table, it may contain duplicates.
Each row of this table indicates that user_id has done a transaction of amount in transaction_date.
It is guaranteed that the user has visited the bank in the transaction_date.(i.e The Visits table contains (user_id, transaction_date) in one row)
 

A bank wants to draw a chart of the number of transactions bank visitors did in one visit to the bank and the corresponding number of visitors who have done this number of transaction in one visit.

Write an SQL query to find how many users visited the bank and didn't do any transactions, how many visited the bank and did one transaction and so on.

The result table will contain two columns:

transactions_count which is the number of transactions done in one visit.
visits_count which is the corresponding number of users who did transactions_count in one visit to the bank.
transactions_count should take all values from 0 to max(transactions_count) done by one or more users.

Order the result table by transactions_count.

The query result format is in the following example:

Visits table:
+---------+------------+
| user_id | visit_date |
+---------+------------+
| 1       | 2020-01-01 |
| 2       | 2020-01-02 |
| 12      | 2020-01-01 |
| 19      | 2020-01-03 |
| 1       | 2020-01-02 |
| 2       | 2020-01-03 |
| 1       | 2020-01-04 |
| 7       | 2020-01-11 |
| 9       | 2020-01-25 |
| 8       | 2020-01-28 |
+---------+------------+
Transactions table:
+---------+------------------+--------+
| user_id | transaction_date | amount |
+---------+------------------+--------+
| 1       | 2020-01-02       | 120    |
| 2       | 2020-01-03       | 22     |
| 7       | 2020-01-11       | 232    |
| 1       | 2020-01-04       | 7      |
| 9       | 2020-01-25       | 33     |
| 9       | 2020-01-25       | 66     |
| 8       | 2020-01-28       | 1      |
| 9       | 2020-01-25       | 99     |
+---------+------------------+--------+
Result table:
+--------------------+--------------+
| transactions_count | visits_count |
+--------------------+--------------+
| 0                  | 4            |
| 1                  | 5            |
| 2                  | 0            |
| 3                  | 1            |
+--------------------+--------------+
* For transactions_count = 0, The visits (1, "2020-01-01"), (2, "2020-01-02"), (12, "2020-01-01") and (19, "2020-01-03") did no transactions so visits_count = 4.
* For transactions_count = 1, The visits (2, "2020-01-03"), (7, "2020-01-11"), (8, "2020-01-28"), (1, "2020-01-02") and (1, "2020-01-04") did one transaction so visits_count = 5.
* For transactions_count = 2, No customers visited the bank and did two transactions so visits_count = 0.
* For transactions_count = 3, The visit (9, "2020-01-25") did three transactions so visits_count = 1.
* For transactions_count >= 4, No customers visited the bank and did more than three transactions so we will stop at transactions_count = 3

The chart drawn for this example is as follows:




# This t table calculates the number of transactions for each user, for each visit (including if the user had zero transactions for that visit)
WITH t AS (SELECT v.user_id as user_id, visit_date, IF(transaction_date is null, 0, count(*)) as transaction_count
            FROM Visits v LEFT JOIN Transactions t on v.visit_date = t.transaction_date and v.user_id=t.user_id
            GROUP BY 1, 2),
	# This simply generates a table with numbers from zero to [number of rows in Transactions table]
	# This will be necessary later to deal with edge cases for when there are zero of that number of transactions
	# but we still want to see that in the end result (eg there were zero cases of two-transactions but there were cases with three-transactions)
    row_nums AS (SELECT ROW_NUMBER() OVER () as rn 
                 FROM Transactions 
                 UNION 
                 SELECT 0) 
				 
# If transaction_count is null (due to the right join below), then insert a zero, otherwise simply count the times that number appears
SELECT rn as transactions_count, IF(transaction_count is null, 0, count(*)) as visits_count
# Right Join on row_nums (right join because we don't want to lose, for example, two-transactions being zero)
FROM t RIGHT JOIN row_nums ON transaction_count = rn
# We can remove excess transaction-numbers (eg if the max transaction-number is four, we don't need five+ in our end result)
WHERE rn <= (SELECT MAX(transaction_count) FROM t)
GROUP BY rn
ORDER BY 1














WITH a AS
(
    SELECT v.user_id, v.visit_date, 
    SUM(CASE WHEN t.transaction_date is not null THEN 1 ELSE 0 END) as transactions_count
    FROM Visits v
    LEFT JOIN Transactions t
    ON v.user_id = t.user_id AND v.visit_date = t.transaction_date
    GROUP BY visit_date, v.user_id
),

b AS
(
    SELECT transactions_count, COUNT(transactions_count) as visits_count
    FROM a
    GROUP BY transactions_count
),

c as
(
    SELECT 0 as transactions_count, max(transactions_count) as temp
    FROM b
	UNION ALL
    SELECT transactions_count + 1 , temp FROM c
    WHERE transactions_count < temp
)

SELECT c.transactions_count, isnull(b.visits_count, 0) as visits_count
FROM c
LEFT JOIN b
ON c.transactions_count = b.transactions_count










# Write your MySQL query statement below
WITH T AS (
SELECT ROW_NUMBER() OVER() row_num
FROM Transactions
UNION 
SELECT 0
), 
T1 as (
SELECT COUNT(transaction_date) transaction_count
FROM Visits v
LEFT JOIN Transactions t
ON v.user_id = t.user_id
AND v.visit_date = transaction_date
GROUP BY v.user_id, v.visit_date
)

SELECT row_num transactions_count, COUNT(transaction_count) visits_count
FROM T
LEFT JOIN T1
ON row_num = transaction_count
GROUP BY row_num
HAVING row_num <= (SELECT MAX(transaction_count) FROM T1)
ORDER BY row_num