In the previous sections we created tables without specifying any schema names. By default such tables (and other objects) are automatically put into a schema named “public”. Every new database contains such a schema. 


 Every new database contains such a schema.
 Every new database contains its own public schema.
 
 https://www.dbi-services.com/blog/the-postgresql-shared-global-catalog/


Often you will want to create a schema owned by someone else (since this is one of the ways to restrict the activities of your users to well-defined namespaces). The syntax for that is:

CREATE SCHEMA schema_name AUTHORIZATION user_name;
You can even omit the schema name, in which case the schema name will be the same as the user name. See Section 5.9.6 for how this can be useful.

Schema names beginning with pg_ are reserved for system purposes and cannot be created by users.

---------------------------------------------------------------------------

Qualified names are tedious to write, and it's often best not to wire a particular schema name into applications anyway.
Therefore tables are often referred to by unqualified names, which consist of just the table name.

But this runs the risk of accidental or malicious use of other schemas?
It depends on system state which is not good. Explicit is better than implicit.

The ability to create like-named objects in different schemas complicates writing a query that references precisely 
the same objects every time. It also opens up the potential for users to change the behavior 
of other users' queries, maliciously or accidentally.

> simple is better than complex.

When you run an ordinary query, a malicious user able to create objects in a schema of
 your search path can take control and execute arbitrary SQL functions as though you executed them.

How could a malicious user execute functions as though you executed them?






When referencing objects, the first schema of search_path is used
search_path resets every session.

> how to set a session default search_path?
> Answer: That is a secure schema usage pattern! modify postgresql.conf or alter role and set search_path = "$user"

pg_catalog  is part of the search path
Operators exist in pg_catalog/public (searched in search_path).
If it is not named explicitly in the path then it is implicitly searched before searching the path's schemas.
This ensures that built-in names will always be findable.
However, you can explicitly place pg_catalog at the end of your search path if you prefer to
have user-defined names override built-in names.

Since system table names begin with pg_, it is best to avoid such names to ensure that you won't suffer a
 conflict if some future version defines a system table named the same as your table.
 (With the default search path, an unqualified reference to your table name would then be resolved as the system table instead.)

SELECT 3 OPERATOR(pg_catalog.+) 4;
In practice one usually relies on the search path for operators, so as not to have to write anything so ugly as that.

---------


secure schema usage pattern:
	 prevents untrusted users from changing the behavior of other users' queries


When a database does not use a secure schema usage pattern:
	Users would begin each session by setting search_path to an empty string
	(so that functions don't resolve to malicious ones)

Pattern 1:
	Constrain ordinary users to user-private schemas.
	Ensure that no schemas have public CREATE privileges:
		REVOKE CREATE ON SCHEMA public FROM PUBLIC
	Then, for every user needing to create non-temporary objects, create a schema with the same name as that user

	This pattern is secure unless an untrusted user is the database owner or
	has been granted ADMIN OPTION on a relevant role, in which case no secure schema usage pattern exists.

	PG15+ automatically follows this pattern. For versions prior, you will need to revoke public priviliges,
	and audit the public schema for objects beginning with pg_ (as they might be malicious replacements)

Pattern 2:
	Remove the public schema from the default search path

	Modify postgresql.conf or by issue
	ALTER ROLE ALL SET search_path = "$user"

	Then, grant privileges to create in the public schema.

	Only qualified names will choose public schema objects.
	While qualified table references are fine, calls to functions in the public schema will be unsafe or unreliable.

	If you create functions or extensions in the public schema, use the first pattern instead.
	Otherwise, like the first pattern, this is secure unless an untrusted user is the database owner or
	has been granted ADMIN OPTION on a relevant role.
	
	
Pattern 3: (insecure, poor pattern)
	Keep the default search path, and
	grant privileges to create in the public schema (PG15+).

	All users access the public schema implicitly.

	This simulates the situation where schemas are not available at all,
	giving a smooth transition from the non-schema-aware world.
	However, this is never a secure pattern.

	It is acceptable only when the database has a single user or a few mutually-trusting users.
	In databases upgraded from PostgreSQL 14 or earlier, this is the default.

For any pattern, to install shared applications (tables to be used by everyone, additional functions provided by third parties, etc.),
put them into separate schemas.

Remember to grant appropriate privileges to allow the other users to access them.

Users can then refer to these additional objects by qualifying the names with a schema name,
or they can put the additional schemas into their search path, as they choose.

------------
Portability:
In the SQL standard, the notion of objects in the same schema being owned by different users does not exist.
Some implementations do not allow you to create schemas that have a different name than their owner
The concepts of schema and user are nearly equivalent in a database system that
	.. implements only the basic schema support specified in the standard. 

Therefore, many users consider qualified names to really consist of user_name.table_name.
This is how PostgreSQL will effectively behave if you create a per-user schema for every user.

There is no concept of a public schema in the SQL standard.
For maximum conformance to the standard, you should not use the public schema.
