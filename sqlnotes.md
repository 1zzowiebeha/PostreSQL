Stuff I would like to learn more about:
Db design
FAQ
Postgresql exercises
Postgresql in aws
Postgresql in django

# Hour 1:

How to design a database:
    1 table represents 1 real world object
    Columbs store 1 piece of information
    How do tables relate?
    Reduce Redundant Data
    
    
Plan when turning something into a database
ex. invoice into database

[!] If you ever aren't able to find a table in the browser,
    refresh your database.
    
Types:
    Characters:
        Char() : max of 5 chars
        Varchar : store any length of chars
        varchar(20) : store up to 20 chars
        Text : store any length of chars

    Numerical:
        Auto-incrementing whole numbers
        Always used for column ids
        Smallserial : 1 - 32,767
        Serial : 1 - 2147493647
        Bigserial : 1 - 9223372036854775807
    
    Integers : Whole nums only. Always use when you don't need a decimal    
        Smallint : -32,768 - 32,767
        Integer : -2billion to 2 billion
        Bigint : -Huge quadrillion to Huge quadrillion I ain't gonna type 
    
    Floats: decimals
        Decimal: 131072 whole digists and 16383 after decimal
        Numeric: 131072 whole digits and 16383 after decimal
        Real : 1E-37 to 1E37 (6 places of precision)
        Double Precision : 1E-307 to 1E308 (15 places of precision)
        Float : same as double
    
    Boolean:
        True, 1, t ,y ,yes, on
        False, 0, f, n, no, off
        null
    
    Date/time:
        Date: No matter what format you enter, you will get yyy-mm-dd
        Times:
            '1:30:30 PM'     has no timezone -> '13:30:30'
            '1:30 am est' -> '01:30-5:00' ( utc )
            '1:30 pm pst' -> '01:30-8:00'
            '01:30:30 pm est' time with time zone -> '13:30:30-5:00'
        Timestamp
            timestamp:
            'DEC-21-1974 1:30 PM EST' -> timestamp with timezone '1974-12-21 13:30-5:00'
            
            interval:
                duration of time
                '1 day' -> '01:00'
                '1 D 1H 1 M 1 S' -> 01:01:01:01
                You can add and subtract intervals.
        
    Other types:
        Currency
        Binary
        Json
        Range
        Geometric
        Arrays
        XML
        UUID
        Custom


# commands
Create table

Insert values
```sql
INSERT INTO customer(first_name, last_name, email, company,
					 street, city, state, zip, phone, birth_date,
					 sex, date_entered, id)

VALUES ('Chris', 'Grey', 'as@email.com', 'Blockford', '1234 Red Str.', 'Hilton', 'PA', 49932, '876-987-8472', '1954-04-28', 'M', current_timestamp);
```

Change column type
```sql
ALTER TABLE customer
ALTER COLUMN sex TYPE sex_type USING  sex::sex_type;
```

if you have multiple queries on the screen, just highlight the one you want and run

[!] can't have an ending comma if passing parameters for some reason.. kinda dumb stupid

######
######
######
# PostgreSQL CLI course by FreeCodeAcademy

the cli is the most effective way to learn any database
server.

psql sql shell windows
superuser and server password are created during install

\l - list all databases
CREATE DATABASE <db_name>; - create new database
\c <db_name> - connect to database

Arguments can be passed to psql.exe (psql shell) before it runs.
To view these flags and args, on windows type:
> psql --help

-p(ort) -h(ost) -U(sername)


[!!!!!!] NEVER RUN THIS COMMAND IN PRODUCTION
DROP DATABASE <db_name>;
^^ Delete database

[?] You can actually set up permissions so people in production
    can't do this + have data & user action monitoring.
    
# Section 2 42:00
Create a table with Postgres:

[!] Note: the last item when creating the table
    must not have a comma
    
```sql
CREATE TABLE <table_name> (
    Column name + data type + constraints if any,
    ...
)
CREATE TABLE person (
    id int,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(6),
    date_of_birth TIMESTAMP -- using a DATE might be better here 
                             -- since we don't need seconds & miliseconds
    ...
)
```

\d - Show tables & owned objects/sequences
\d <table_name> - Describe table 
\dt - Show tables without owned objects/sequences

Data Base Design Theory:
The majority of columns should be marked as not null.

🦘🦘🦘🦘🦘
Mockaroo is a test data generator!!

[!]
When using \i in psql, paths given as an arg must be in '<path>' quotes, and
    backslashes must be escaped.

Another reminder. NEVER USE THE DROP COMMAND IN PRODUCTION. DO NOT USE DROP!!! DO NOT!!!
 NEVER
!!!! !!!!!!!! !!!!
AND ALSO NEVER REBASE ON A REMOTE!!!!


# Selections:
select <column> from <table>;
select <column1>,<column2>,... from <table>;
* = all columns

if a column is null when selected,
    it will return a blank line.

# Ordering
1 2 3 4 5 Asc
5 4 3 2 1 Desc

Sorting by multiple columns sorts the first
    column, and any duplicates are sorted based on
        subsequent column orders, and this repeats
        for each column specified.
        
select <columns> from <table> order by <columns> <order>;
select <columns> from <table> order by <columns> <order>, <columns> <order>, ...;

# distinct
select distinct <column> from <table> order by

# where
SELECT * FROM person WHERE gender='male'
AND (country_of_birth ='poland' OR country_of_birth ='china')
AND last_name = 'james';

SELECT * FROM person WHERE gender='male' AND country_of_birth ='poland';

Boolean logic operators AND OR work here.

# comparison operators
SELECT 1 + 1;
SELECT 1 >= 88;

output:
?column?
----------
 t
 
SELECT 1 < 0;
output:
?column?
----------
 f
 
How to type a Not Equal sign?
<>

SELECT 1 <> 2;
output: t


select 'AMIGOSCODE' <> 'amigoscode';
t
select 'Hi' = 'Hi';
t

You can use these with any datatype. Use them to filter.

# limit, offset, & fetch
limit amount of selected rows:
SELECT * FROM person LIMIT 10;

offset (jump to int exclusive) rows:
SELECT * FROM person OFFSET 6 LIMIT 2;

[!!!!] Offset selects at n+1 and forward.
offset 5 will select row 6 and onward.

[!] Officially, limit isn't in the sql standard.
The official way to limit is by using FETCH.

select * from person fetch first 5 row only;
select * from person fetch first 1 row only;
same as:
select * from person fetch first row only;

# in

IN reduces redundant or chains.
SELECT * FROM person WHERE country_of_birth IN ('UK','US','FR','DE','IR');

# where between

SELECT * FROM person
WHERE date_joined
BETWEEN DATE '2000-02-23' AND '2023-02-17';

# Like and iLike

SELECT * from person where email like '%@google.@';
SELECT * from person where email like '%@%.___';

# Group by & Having

Group by allows you to group columns and functions within the same selection.

SELECT country_of_birth, COUNT(5) FROM person
GROUP BY country_of_birth HAVING COUNT(*) > 5
ORDER BY country_of_birth ASC;


----
side note:
Don't use NOT IN with null values.
Use NOT EXISTS or specify NOT NULL in the WHERE clause.
[?] Lookup why once u are a professional
[?] Big questions

[?] Console Code chars 1252
Why doesn't it appear in ms documentation?
Warning: console code.... 437
[?] Group By algorithm???
----


# min max average

MIN()
MAX()
AVERAGE()
ROUND()
SELECT make,model,MAX(price) FROM car GROUP BY make,model ORDER BY MAX(price) LIMIT 1;