/*
571. Find Median Given Frequency of Numbers
Hard
SQL Schema
The Numbers table keeps the value of number and its frequency.

+----------+-------------+
|  Number  |  Frequency  |
+----------+-------------|
|  0       |  7          |
|  1       |  1          |
|  2       |  3          |
|  3       |  1          |
+----------+-------------+
In this table, the numbers are 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, so the median is (0 + 0) / 2 = 0.

+--------+
| median |
+--------|
| 0.0000 |
+--------+
Write a query to find the median of all numbers and name the result as median.





# Write your MySQL query statement below
select avg(number) as median 
from (
    select l.number
    from numbers l join numbers r
    group by 1
    having abs(sum(sign(l.number - r.number) * r.frequency)) <= max(l.frequency)
) t
;






with t as (select *, sum(frequency) over(order by number) freq, (sum(frequency) over())/2 median_num
           from numbers)
           
select avg(number) as median
from t
where median_num between (freq-frequency) and freq



select avg(number) as median 
from (
    select l.number
    from numbers l join numbers r
    group by 1
    having abs(sum(sign(l.number - r.number) * r.frequency)) <= max(l.frequency)
) t
;
Key is to understand the having clause:

having abs(sum(sign(l.number - r.number) * r.frequency)) <= max(l.frequency)
Explain:
If a number is a median, it's frequency must be greater or equal than the diff of total frequency of numbers greater or less than itself.

Examples for the sub/inner query:






solution, I think, is super simple.

select  avg(n.Number) median
from Numbers n
where n.Frequency >= abs((select sum(Frequency) from Numbers where Number<=n.Number) -
                         (select sum(Frequency) from Numbers where Number>=n.Number))
Explanation:
Let's take all numbers from left including current number and then do same for right.
(select sum(Frequency) from Numbers where Number<=n.Number) as left
(select sum(Frequency) from Numbers where Number<=n.Number) as right
Now if difference between Left and Right less or equal to Frequency of the current number that means this number is median.
Ok, what if we get two numbers satisfied this condition? Easy peasy - take AVG(). Ta-da!






The idea is that the natural index of the median should be within the range of frequency intervals of each value. Also as the intervals are inclusive [start, end] and neighboring intervals share borders, the avg() function will help return the median as the mean of two different numbers.
image

with t as (select *, sum(frequency) over(order by number) freq, (sum(frequency) over())/2 median_num
           from numbers)
           
select avg(number) as median
from t
where median_num between (freq-frequency) and freq