create table user (
	user_id uuid not null generated always as (gen_random_uuid()) stored,
	creation_date date not null default(CURRENT_DATE), -- [?] use trigger to prevent modification (on first assign/further)
	last_online timestamptz not null default (now()), -- new logout should update
	is_online boolean not null default (true), -- new login/logout should update
	email varchar(100) not null unique check, -- check for length
	banned boolean not null default (false), -- admin panel affects this
    
    primary key (user_id)
);

create table privilege (
	p_id bigint generated always as identity,
	p_name text not null,
);

-- junction
create table user_privilege (
	user_id uuid references user(user_id),
	privilege_id bigint references privilege(p_id)
	
	primary key (user_id, role_id) -- ensure unique, not null, indexed
);

create table item (
	item_id uuid generated always as (gen_random_uuid()) stored,
	item_name text not null,
	
);

create table inventory (
	user_id uuid references user(user_id) not null,
	item_name text not null,
	quantity int not null,
    primary key (player_id, item)
);

---------------------------
create table users (
	user_id bigint not null generated always as identity,
    user_name text not null,
	creation_date date not null default (CURRENT_DATE), -- should not be written to
	last_online timestamptz not null, -- new logout should update with now()
	is_online boolean not null, -- new login/logout should update
	banned boolean not null default (false), -- admin panel affects this
    
    primary key (user_id)
);

insert into users (user_name, last_online, is_online, banned)
values ('bob', now(), true, false);

select * from user;

update users 
set is_online = false
where user_id = 1;

select * from users;

