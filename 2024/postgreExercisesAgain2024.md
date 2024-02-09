# Basic

* Select specific
    Generally speaking, for non-throwaway queries it's considered desirable to specify the names of the columns you want in your queries rather than using *. This is because your application might not be able to cope if more columns get added into the table.

* Where4
    The IN operator is a good early demonstrator of the elegance of the relational model. The argument it takes is not just a list of values - it's actually a table with a single column.
    
    Since queries also return tables, you can feed values into the IN
    .. operator if the query returns a single column. This is called a `subquery`!

```sql
SELECT *
FROM cd.facilities
WHERE
	facid IN (1, 5);
	
-- just an example of IN comparing a value to values within a subquery table
SELECT *
FROM cd.facilities
WHERE
    facid IN (
        select facid
        from cd.facilities;
    );
```

# Basic : Date
Timestamps are formatted in descending order of magnitude: YYYY-MM-DD   HH:MM:SS.nnnnnn
You can specify different formats/portions of a timestamp, and Postgre
    will cast it to a full timestamp:  2012-09-01 00:00:00

>= is important when comparing timestamps.
Ask yourself, do you want exclusive, or inclusive comparison?

# Basic : Unique

UNIQUE will only remove duplicates if ALL columns in a row are equal to
ALL columns in another row.

Additionally, UNIQUE is not free (in regards to performance) if you want to
remove duplicates from a large query result set.

LIMIT allows you to limit the # of rows that are returned.
OFFSET will let you paginate limited results. (though it is not performant
for true web-page pagination)

In other databases, LIMIT & OFFSET functionality may be more complicated than PostgreSQL's
implementation.

# Basic : Union

UNION combines two queries into a single table.
The caveat is, that they must have the same number of columns &
.. must have compatible datatypes.

UNION removes duplicate rows.
UNION ALL does not.

Use UNION ALL as a default, unless you want to remove duplicate rows :-]



-- What's the most expensive facility to maintain on a monthly basis?
-- Who has recommended the most new members?
-- How much time has each member spent at our facilities?