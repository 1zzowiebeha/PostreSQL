cluster:
    * 1 or more databases
    * roles (and some other objects) are shared throughout the cluster
        - can't have duplicate role names
    
    * a client connection can only access date in 1 db at a time (the one specified in the connection request)
        - can configure which dbs a role may access
    

schema:
    * contain tables, named objects like data types, functions, operators...
    * same object name can be used in different schemas without conflict.
    * a user can access objects in any schema within the db they are connected to, if they have the privileges to do so.
    
    Benefits of using schemas:
        $ Allows many users to use one db without interfering with each other
        $ Organize objects into logical groups and make them more manageable
        $ Third-party apps can be placed into separate schemas so they do not collide with the names of other objects
        
    An analogy: schemas are like OS directories, but cannot be nested
    

# Create a schema
> CREATE SCHEMA myschema;

Qualified object access:
> SELECT * FROM myschema.table;

More general syntax (must be connected to the same database):
> SELECT * FROM database.myschema.table;

[at present this is just for Pro Forma compliance with the sql standard?]

```sql
CREATE TABLE myschema.mytable (
    ...
);

-- drop a schema if it is empty:
DROP SCHEMA myschema;

-- drop a schema including all contained objects:
--  See Section 5.14 for a description of the general mechanism behind this.
DROP SCHEMA myschema CASCADE;


-- create a schema owned by someone else. schema_name defaults to user_name
CREATE SCHEMA [schema_name] AUTHORIZATION user_name;
```

Schema names beginning with `pg_` are reserved for system purposes. They cannot be created by users.


# The Public Schema
By default, if you create objects without a schema name, such objects will be placed into a schema named "public". Each new database contains its own public schema.

> CREATE TABLE products (...);
> CREATE TABLE [db.]public.products (...);

These two statements are equal if you have public  as the FIRST schema on your search_path.

[!] By default, the search_path is '$user', public.
There is not a $user schema by default, so unqualified objects are created in public.

Unqualified objects are always placed in the first
existing schema found in the search path.
The search will search the search_path via strings split on the "," deliminator, from left to right.

# The schema Search Path

Qualified names are tedious to write.
It is often best not to wire a particular schema into applications.

When using unqualified names, the system will search the search_path to see if those schemas exist in the CURRENT database. If they do not, an error will be reported.

Unqualified names are prevalent in PostgreSQL internals & user queries.

If a schema is on the search_path, it effectively trusts all users having CREATE priviliges on that schema with implicit access to the schema.

("... adding a schema to search_path effectively trusts all users having CREATE privilege on that schema")

[?] Is this saying that to add a schema onto a search_path, we trust users with implicit access to the schema if they have the CREATE privilege?

[?] I also have a semantic question, why does it say 'the search_path', as if it were one singular path? As all user roles have their own individual search_path, and there is a search_path per database, as well as a search_path per role+database..

...... ASK ON IRC

A malicious user could create objects in that schema, and change functions to do bad things when run by another user.

[?] Couldn't they do that even without implicit access? Via a qualified name? 

....... FIND ANSWER FROM DISC/WEBCHAT PICTURE OR ASK ON IRC

The first schema in the search_path is called the current schema.
Unqualified objects will be created in the current schema.
It is the first schema searched too.

> SHOW search_path;

search_path
-----------------
"$user", public

[
    from stack overflow:
--------------------
    if the schema has an unconventional? name, use double quotes.
]

If a schema doesn't exist, the entry is ignored.
"$user" specifies that a schema with the same name as the current user is to be searched.

[!] In contexts other than creation (table modification, data modification, query commands),
the search_path is traversed until a matching object is found.

In the default configuration, any unqualified access can only refer to the public schema (since there is no $user schema by default).

> SET search_path TO myschema, public;
> SET search_path = myschema, public;

> DROP TABLE mytable;
    will drop any table named "mytable" found in myschema or public.

> CREATE TABLE bob(number int);
    will create a table in myschema
    
[!!] There is nothing special about the public schema except that it exists by default. It can be dropped, too.

Operators:
To write qualified operator names, you must write
> OPERATOR(schema.operator)

This is needed to avoid syntatic ambiguity. e.g
> SELECT 3 OPERATOR(pg_catalog.+) 4;

But that is ugly. So use the search_path please.
[?] Is pg_catalog a system schema? Is it on the search_path?
    [answer]: Each database contains a pg_catalog schema. It is implicitly searched before searching other entries on search_path. See "The System Catalog Schema" for more info..

# Schemas and Privileges
[!] By default, users cannot access objects in schemas they do not own.

To allow access, the owner of the schema must grant USAGE on the schema to a user.

To allow users to make USE of the objects, additional privileges will need to be granted.

[?] What is the different between USAGE and using an object?

Grant CREATE on a schema to let other users create in another user's schema.

[!] PG14 and prior, everyone has that privilege on every database's public schema by default.

Some usage patterns call for revoking that privilege:
> REVOKE CREATE ON SCHEMA public FROM PUBLIC;
public: the schema
PUBLIC: every user

[?] Is public inherited by roles, or does it mean the same thing as * (all roles)? Does it override individual role privileges if inherited?

# The system catalog schema
Each database also contains a `pg_catalog` schema.
This contains all built-in data types, system tables, functions, and operators.

It is aways part of the search_path, and if not explicitly in the path, it is implicitly searched before all other entries.
You can reorder this so that your names are found before built-in names. (by placing pg_catalog at the end of your search_path).

System tables begin with `pg_`. It's best to avoid such names to avoid name conflicts if future versions define the same pg_ name as your table.

With the default search path, unqualified references to your table would resolve as the system table. So no pg_ names please.

# Usage Patterns
secure schema usage pattern:
    prevent untrusted users from changing the behavior of other users' queries.
    
    Without a secure schema pattern, users must take protective action at the beginning of each session like so:

> SET search_path = '' | "$user"

    [!!] Users would need to set search_path to an empty string, or remove schemas that are WRITABLE by non-superusers from search_path.

Here are a FEW usage patterns easily supported by the default configuration:

1. Constrain ordinary users to user-private schemas.
    To implement:
        1. Ensure that no schemas have public CREATE privileges.
            [?] Does this mean the PUBLIC role, or the public schema? Since it says schema`s`, I think all schemas, not just public. idk

        2. For users needing to create non-temporary objects, create a schema with the same name as that user.
        3. Set the user's search_path to `"$user"`
        
        [!] This is secure unless an untrusted user is the db owner, or has been granted ADMIN OPTION on a relevant role. If they have that power, then no secure schema pattern exists.

        [!] In PG15 and beyond, the default configuration supports this pattern.  In prior versions / a backup from a prior version / a db upgraded from a prior version, you will need to remove the public CREATE privilege from the public schema.

> REVOKE CREATE ON SCHEMA public FROM PUBLIC;

        Then, consider auditing the `public` schema for objects named like objects in schema pg_catalog

--------

2. Remove the public schema from the default search path.
    To implement:
        1. modify `postgresql.conf`, or issue:

> ALTER ROLE ALL SET search_path = "$user"

        2. Grant privileges to create in the public schema. Only qualified names will choose public schema objects. 
        
        NOTE: while qualified table references are fine, calls to FUNCTIONS in the public schema will be unsafe or unreliable.
        
        If you create functions/extensions in the public schema, use the first pattern instead.
        
        ^ Otherwise if you aren't creating functions/extensions in the public schema, this pattern is secure unless and untrusted user is the db owner or has been granted ADMIN OPTION on a relevant role.
        If they have that power, then no secure pattern exists.

3. Keep the default search path, and grant privileges to create in the public schema.
    All users access the public schema implicitly.
    Simulates a non-schema-aware db.
    
    This is NEVER a secure pattern.
    It's acceptable only when the db has a single user, or a few mutally-trusting users.

    In DBs upgraded (backedup / upgrade tooled) from PG14 or earlier, this is the default.

Shared applications / extensions / tables / functions:
    For any pattern, to install shared applications (tables to be used by everyone, additional functions provided by third parties, extensions, etc.) put these objects into separate schemas.

    Grant appropriate privileges to allow other users to access them.

    Users can refer to these objects by qualifying the names. Or they can put the additional schemas into their search path as they choose.
    
# Portability
    In the SQL Standard, the notion of
    objects
    in the same schema
    owned by different users does NOT exist.
    
    Some implementations of the standard
    Don't allow you to
    create schemas with a name other than their owner.
    
    In fact, SCHEMA and USER are nearly equivalent in a db system that implements only basic schema support speficied in the standard.

    Therefore, many users consider qualified names to really consist of `user_name.table_name`
    
    This is how Postgres behaves if you use the first schema usage pattern ($user schemas only for every user)
    
    ---

Also, there is no concept of a `public` schema in the sql standard.

For maximum conformance to the standard, you should not use the `public` schema.

> for a django test db that is automatically deleted, and which does not easily create $user schemas, it is find to not conform in this case.

Of course, some db systems may not implement schemas at all, or will provide namespace support via (possibly limited) cross-database access.
If you need to work with those systems, maximum portability = not using schemas at all.


# The Problem:
Django cannot easily use $user schema for test database.

Is it safe to use the public schema?
Is it a secure usage pattern for a third party app?

# Possible solution
        
        [!] This is secure unless an untrusted user is the db owner, or has been granted ADMIN OPTION on a relevant role. If they have that power, then no secure schema pattern exists.
        
        Nobody is going to use the test db except the test runner, so it can do whatever it wants to that db. That's the only thing it owns so there's no risks involved at all.
        

Set the search_path for all databases to none,
Set the search_path for all users to "$user",
Revoke access to all schemas & contained objects
except for those owned by the user,
Set the search_path for the test_runner user to public,
Which allows unqualified access to public schema in databases created by test_runner!!!

Question: can those "$user" search_path users access their own public schema? Since they all are only allowed to use the django_poll_app database, I can revoke their priviliges to that [django_poll_app.]public schema.


This single testrunner user will only be allowed to access the public schema of databases it creates. It will be the only user with public on its search_path.

 Therefore, no users can access public except the testrunner role, and the testrunner role can only access public schemas of its own databases.
 
 
Notes:
Check all schema permissions (including public schemas)
Check role permissions (including the PUBLIC role)
[?] PUBLIC = ALL?
Check db permissions
Check PUBLIC permissions