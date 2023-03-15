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
DROP DATABASE <db_name>; - Delete database

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






