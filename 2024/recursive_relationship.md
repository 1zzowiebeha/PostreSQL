https://learnsql.com/blog/illustrated-guide-sql-self-join/
# self joins
# ------------

```sql
create table employee (
   employee_id bigint generated always as identity,
   name text not null,
   salary int not null,
   -- many (or zero) employees to one (or zero) manager
   manager bigint null references employee(employee_id),

   -- one employee to one manager
   -- manager bigint not null references employee(employee_id),
   primary key(employee_id)
);

insert into employee (name, salary, manager) values
('jack', 5200, null),
('tony', 5200, 1),
('balogne', 5200, 1),
('duptar', 5200, 2),
('menma', 5200, null);
```