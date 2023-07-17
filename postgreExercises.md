The `IN` operator is a good early demonstrator of the elegance of the relational model. The argument it takes is not just a list of values - `it's actually a table with a single column`.

```sql
SELECT
    *
FROM
    cd.facilities f
WHERE
    f.facid IN (
        select facid from cd.facilities
    );
```
 
CASES [!]

This is our first look at SQL timestamps. They're formatted in descending order of magnitude:
`YYYY-MM-DD`
`HH:MM:SS.nnnnnn`. 

The `UNION` operator does what you might expect: combines the results of two SQL queries into a single table. The caveat is that both results from the two queries must have the same number of columns and compatible data types. 

UNION removes duplicate rows, while `UNION ALL` does not. Use `UNION ALL` by default, unless you care about duplicate results. 


---------
```sql
SELECT max(joindate) as latest
FROM cd.members;
```

* is better than

```sql
SELECT joindate as latest
FROM cd.members
ORDER BY joindate desc
LIMIT 1;
```
=======
=======

```sql
SELECT firstname, surname, joindate
FROM cd.members
WHERE memid = (SELECT max(memid) FROM cd.members);
```
( max(memid) or max(joindate) )?

* is better than

```sql
SELECT firstname, surname, joindate
FROM cd.members
ORDER BY memid DESC
LIMIT 1;
```



USE SUBQUERIES
USE AGGREGATE FUNCTIONS (no groupby needed if the only thing being selected)






### group  by
The grouped columns will, by definition, be the same value so we don’t have to decide how to combine (aggregate) them. Multiple countrycode values will all merge together into the same value.

The remaining, ungrouped columns will need to use an aggregate function so they know how to be merged together. 

Group by groups distinct columns/column combinations, and allows an aggregate function to be performed on these groups.


#############################


Joins / subqueries

Think of joins as a virtual table (one copy table in memory that gets modified during joins). 
It's handled more intelligently under the hood.

```sql
SELECT bk.starttime, fac.name
FROM cd.bookings as bk
INNER JOIN cd.facilities as fac
ON bk.facid = fac.facid
WHERE fac.name LIKE 'Tennis Court _%' -- at least one digit
AND bk.starttime >= '2012-09-21' -- more efficient to directly compare, than a conversion and single compare?
AND bk.starttime < '2012-09-22' -- date format is yyyy-mm-dd
                                -- better than between, as between has some issues
ORDER BY bk.starttime;
```