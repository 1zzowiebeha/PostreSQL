create table if not exists employees (
  id bigint not null generated always as identity,
  fullname varchar not null,
  salary int not null,
  managerid bigint,
  foreign key (managerid) references employees(id),
  primary key (id)
);

insert into employees values
  (default, 'jim', 123000, null),
  (default, 'greg', 5000, 1),
  (default, 'pablo', 100000, 1),
  (default, 'schidelau', 105000, 2),
  (default, 'anya', 80000, null),
  (default, 'francis', 30000, 2);

-- all records in left table (related and unrelated)
select *
from employees e
left join employees m on e.managerid = m.id
order by e.id;

-- all records in right table (related and unrelated)
select *
from employees e
right join employees m on e.managerid = m.id
order by m.id asc;

-- all related records in both tables
select *
from employees e
join employees m on e.managerid = m.id
order by e.id;