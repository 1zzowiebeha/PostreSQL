-- Table car must be defined above any references.
create table car (
	id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY,
	make VARCHAR NOT NULL,
	model VARCHAR NOT NULL,
	price NUMERIC(19, 2) NOT NULL
);
create table person (
    id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	email VARCHAR,
	date_of_birth DATE NOT NULL,
	country_of_birth VARCHAR NOT NULL,
	-- Null because some people can only have a car at 14-16+
	-- References is a foreign key term
	-- Since this is a one-to-one relationship, 
	--   only one unique car may belong to a person.
	
	car_id BIGINT REFERENCES car(id),
	UNIQUE(car_id)
);

insert into person (first_name, last_name, gender, email, date_of_birth, country_of_birth) values ('Fernanda', 'Beardon', 'Female', 'fernandab@is.gd', '1953-10-28', 'Comoros');
insert into person (first_name, last_name, gender, email, date_of_birth, country_of_birth) values ('Omar', 'Colmore', 'Male', null, '1921-04-03', 'Finland');
insert into person (first_name, last_name, gender, email, date_of_birth, country_of_birth) values ('John', 'Matuschek', 'Male', 'john@feedburner.com', '1965-02-28', 'England');

insert into car (make, model, price) values ('Land Rover', 'Sterling', '87665.38');
insert into car (make, model, price) values ('GMC', 'Acadia', '17662.69');