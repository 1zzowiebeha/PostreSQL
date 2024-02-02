When inserting, if you want to 
reuse a query, be explicit.
Include all columns for the row you are inserting data into

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

[!] UNION removes duplicate rows, while `UNION ALL` does not. Use `UNION ALL` by default, unless you care about duplicate results. 


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
The grouped columns will, by definition, be the same value so we don’t have to decide how to combine (aggregate) them. Multiple same countrycode values will all merge together into the same value.

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

schema - a term used for a logical grouping of related information in the database.

Generally speaking, for non-throwaway queries it's considered desirable to specify the names of the columns you want in your queries rather than using *. This is because your application might not be able to cope if more columns get added into the table.

The SQL standard will not define a key word that contains digits or starts or ends with an underscore, so identifiers of this form are safe against possible conflict with future extensions of the standard.

deliminated identifier - "column_identifier"
    always an identifier, not a keyword. best to asign aliases like this in order to avoid conflicting with a keyword.
identifier - table1, column2

Quoted identifiers can contain any character, except the character with code zero (UNICODE code 0 is a NUL). (To include a double quote, write two double quotes.) 
Quoting an identifier also makes it case-sensitive, whereas unquoted names are always folded to lower case. 

The folding of unquoted names to lower case in PostgreSQL is incompatible with the SQL standard, which says that unquoted names should be folded to upper case. Thus, foo should be equivalent to "FOO" not "foo" according to the standard. If you want to write portable applications you are advised to always quote a particular name or never quote it
^ Don't do this #3.2


(an expert) My rule of thumb for search_path is pretend it doesn’t exist/only contains pg_catalog (and never use public).