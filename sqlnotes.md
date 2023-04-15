Stuff I would like to learn more about:
Db design
FAQ
Postgresql exercises
Postgresql in aws
Postgresql in django
"Relational Algebra" ( it should go first before SQL ), the Entity Relationship model, DB Normalization, and how to translate that into an Object and Class Oriented model ... 
https://towardsdatascience.com/explain-sql-joins-the-right-way-f6ea784b568b?gi=534a4c8cd7da


Stuff I will need to know:

Views
Joins
one-to-one
one-to-many
many-to-many
Schemas
Postgres in AWS
Postgres in Django

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
    first_name VARCHAR(),
    last_name VARCHAR(),
    gender VARCHAR(20),
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

But use Not Exists instead of Not in.

# where between

SELECT * FROM person
WHERE date_joined
BETWEEN DATE '2000-02-23' AND '2023-02-17';

Don't use between. Use greater than/less than operators.

# Like and iLike

SELECT * from person where email like '%@google.@';
SELECT * from person where email like '%@%.___';

ILike is case-insensitive like

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

[!] PSA: when reading Postgres documentation, assume each paragraph
    .. is its own self contained piece of info. (i.e don't assume it is
    ..      referencing any previous content.)
    
# arithmetic
select (expression);
select 1+2;
select 5^2;
select 6*2;
select factorial(bigint) -> numeric;
select 10 % 3; -> 1

# rounding
round(numeric/double precision) -> numberic/double precision

# Coalesce (handling non-existant variables)
Coalesce will go down the parameter list
    until a non-null is given.

# Nullif (handling equal values/div by 0)



select coalesce( (10 / nullif( 10, 0))::text, 'Balance empty.' );

# timestamps
now()


select now();
select now()::date;
select now()::time;

casting.

select (now() - interval '9 months')::date;

# extraction

select extract(month from now());

DAY
DOW - day of week
CENTURY

# age function

select age(now(), '2002-08-21');

[!] Daily reminder. Never drop a table in production.
[!] And also, Never rebase on a remote, or remote-based code.

# Adding / removing constraints
alter table if exists people
drop constraint if exists pk_...;

alter table if exists people
add primary key (column);

[!!!!!] ALWAYS select before you delete. Save yourself.
Don't do it in production. But also don't delete your entire
local db.

#### pgdump
pg_dump -d test -U postgres -h localhost -p 5432 -f C:\Users\z\Downloads\test_db_dump_ya.sql -v
###

# Unique

alter table people add constraint <optional_name> <constraint> (id);

How is it different from a primary key?
A primary key is used for relational actions (joins,views). It ensures it is unique for this purpose.
It is the equivalent of NOT NULL UNIQUE. There can only be one primary key (however that key can span multiple columns!!!). A unique b-tree index is created.
Unique ensures the column is unique (that's it).

# Check constraint
Check cheeeck!!!

alter table <table>
add constraint <constraint_name>
check (<conditional>);

Can be used for instance to check that product value should be > 0.

* is implicit in DELETE FROM <table>.

# delete

[!] Never EVER use this in a production database. Never. You will get into massive trouble. Legal trouble if there are no backups.

DML - Database Management Language (insert update delete replace)
DQL - Database Query Language (select)
DDL - Database Definition Language (create drop)

[!] Always have a WHERE clause for UPDATE and DELETE. Otherwise you may delete the entire table.


# Duplicate keys / Conflict do nothing
INSERT INTO table (id, name) VALUES (0, 'hello')
ON CONFLICT (id) DO NOTHING;

if there is an error/collision, do nothing.

Column parameters can only be Unique or Primary Key. You can specify multiple columns.

# Upsert
INSERT INTO table (id, name) VALUES (0, 'hello')
ON CONFLICT (id) DO UPDATE
SET email=EXCLUDED.email,
last_name = EXCLUDED.last_name;

#### schema
Note that, by default, every user has the CREATE and USAGE on the public schema.
####
[?] When to use SET CONSTRAINT <constraint_name> DEFERRED,...;
####

# Relationships
Many-to-One
One-to-One
Many-to-Many

[!!!!!] You can perform table queries on multiple tables.

# One-to-One
	car_id BIGINT REFERENCES car(id),
	UNIQUE(car_id)
    
UPDATE person SET car_id = 2 WHERE id = 1;

# Inner join
Inner join takes what is common to both tables.
One foreign key present in both tables will be selected.

If primary key & foreign key are not present in both tables,
    that row will not be selected.
    
SELECT * FROM person
JOIN car ON person.car_id = car.id;

(You can select from multiple tables too!)
select * from person,car
where person.car_id = car.id;


Awesome equivalent queries!
SELECT p.first_name, c.make, c.model, c.price
FROM person p, car c
WHERE p.car_id = c.id;

SELECT p.first_name, c.make, c.model, c.price
FROM person p
INNER JOIN car c ON p.car_id = c.id;

## Expanded display mode
\x
##

(You can also select specific columns from each table)
select person.first_name, car.make, car.model, car.price
from person
join car on person.car_id = car.id;

# Left Join

All rows specific to left table, and all rows common to both tables.

Not equivalent to a `select * from person,car;`, as
    that statement would not show you relationships.
    
`select * from person where car_id is null;`
(Left join without relationships. (null foreign key))
```sql
select * from person
left join car on car.id = person.car_id
where car.* is null;
```

* There exists the table.* column, which can be used for comparisons.

[!] NULL does not equal NULL. NULL is not a value.
    It cannot be compared to another value.
    `where x is null` checks whether x is a null value.
    `where x = null`  checks whether x equals null.
                        But NULL doesn't equal NULL.
                        So it is never true, never false.

You can't delete a foreign key relationship, without
    1. Delete the parent row containing the foreign key reference
    2. Setting the parent's foreign key reference to null
    3. Delete the child row
    
Delete a child row in a one-to-one?
```sql
BEGIN;
UPDATE person SET car_id = null WHERE id = 9000;
DELETE FROM car WHERE id = 12;
COMMIT;
```

### Transactions ####
A transaction either happens completely or not at all.

All the updates made by a transaction are logged in permanent storage (i.e., on disk) before the transaction is reported complete.

Updates made by an open transaction are invisible to other transactions, until the transaction is complete, whereupon
all the updates become visible simultaneously.

Single statements are implicitely made into a transaction in Postgres. If the statement is successfull, it is COMMIT ted.
This is called a transaction block.

[!!!!!] Some client libraries issue BEGIN and COMMIT commands automatically, so you get this without asking. Check the documentation for the interface you are using!

We can ROLLBACK during a commit to undo our changes (maybe we see someone's balance goes negative when we try to debit money.)

You can also ROLLBACK TO <savepoint> if you have a SAVEPOINT <savepoint> defined in the transaction block.

Changes after the savepont will be discarded once rolled back. After rolling back,
you may continue to roll back to it, since it remains defined.

When the transaction is committed, rolled-back actions never become visible at all.

```sql
BEGIN;
UPDATE accounts SET balance = balance - 100.00
    WHERE name = 'Alice';
SAVEPOINT my_savepoint;
UPDATE accounts SET balance = balance + 100.00
    WHERE name = 'Bob';
-- oops ... forget that and use Wally's account
ROLLBACK TO my_savepoint;
UPDATE accounts SET balance = balance + 100.00
    WHERE name = 'Wally';
COMMIT;
```

`ROLLBACK TO` is the only way to regain control of a transaction block that was put in aborted state by the system due to an error, short of rolling it back completely and starting again.
###### END Transaction info

##### VIEWS !!!! #####
Making liberal use of views is a key aspect of good SQL database design. Views allow you to encapsulate the details of the structure of your tables, which might change as your application evolves, behind consistent interfaces.

Views can be used in almost any place a real table can be used. Building views upon other views is not uncommon.

```sql
CREATE VIEW basic_patient_data AS
    SELECT p.name, pd.temperature, pd.is_sick, pd.date, pd.location
    FROM patient as p, patient_data as pd
    WHERE pd.data_id = p.id;

-- or
CREATE VIEW basic_patient_data AS
    SELECT p.name, pd.temperature, pd.is_sick, pd.date, pd.location
    FROM patient p
    INNER JOIN patient_data pd ON pd.data_id = p.id;
```

#### END (basic) VIEW OVERVIEW ####