https://learnsql.com/blog/what-is-dql-ddl-dml-in-sql/

* Check out the Learnsql.com course for ~$200. Lots of exercises/articles/videos just like this article!

* Data Query Language (DQL) for querying data. (Read)
    > SELECT
* Data Definition Language (DDL) for structuring data. (Tables)
    > CREATE TABLE
    > ALTER TABLE
    > DROP TABLE
* Data Manipulation Language (DML) for editing data. (Create Edit Delete)
    > INSERT
    > UPDATE
    > DELETE
* Data Control Language (DCL) for administering the database. (Administration)
    > GRANT
    > REVOKE
    > DENY
    > ...
    

* DQL:
=======
```sql
SELECT name
FROM accounts
WHERE balance > 1500;
```

* DML:
=======
```sql
INSERT INTO accounts 
    (name, balance)

VALUES ('Evan Johnson', 4000),
       ('David Bookelmorph', 9490);
       

-- $1000 withdraw
UPDATE accounts
SET balance = 3000
WHERE account_id = 1;


-- closed account
DELETE FROM accounts
WHERE account_id = 1;
```

* DDL:
=======
```sql

CREATE TABLE accounts (
    account_id BIGINT GENERATED ALWAYS AS IDENTITY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    balance BIGINT NOT NULL,
    
    PRIMARY KEY (account_id)
);


```