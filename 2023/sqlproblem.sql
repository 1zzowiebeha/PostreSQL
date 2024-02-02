-- # = number of

-- Select names, and inside a group of distinct names, 
-- select the number (count) of names in that group.
select first_name, count(id) -- But how is the id parameter relevant?
from person
group by first_name;



-- Select distinct names, and inside a group of distinct names,
-- select the number (count) of names in that group.
-- Order by number (count) of names in that group descending.
select distinct first_name, count(first_name)
from person
group by first_name
order by count desc;

-- distinct names may have colliding product_ids, however products
--      .. may not have the same product_id as another product name.
-- Select distinct names, and inside a group of distinct names,
-- select the number of distinct product_ids of a distinct name
-- select the number of product_ids attached to a distinct name
select distinct first_name, count(distinct product_id), count(product_id)
from products
group by first_name
order by 1 asc; -- order by column 1

-- Example table:
-- id |   first_name
--  1 |   Bob
--  1 |   Bob
--  2 |   Schlavana
--  3 |   Simka

-- Example output:
-- first_name,  ids
-- Bob           2
-- Schlavana     1
-- Simka         1