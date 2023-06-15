create table users {
    user_uuid UUID, -- pk enforces not null
    username varchar not null,
    p_hash varchar not null,
    salt varchar not null,
    email varchar,
    -- the current implementation ignores any supplied array size limits, i.e., the behavior is the same as for arrays of unspecified length.
    -- dimensions are merely documentation. [][][] or [] can both be triple nested
    recent_addr inet ARRAY, -- standard compliant
    
    primary key (user_uuid)
}
create table users {
    user_uuid UUID,
    username varchar not null,
    p_hash varchar not null,
    salt varchar not null,
    email varchar,
    recent_addr inet ARRAY[3], -- standard compliant (note that dimensions and sizes are ignored by postgres)
    
    primary key (user_uuid)
}

create table jokes {
    joke_uuid UUID, -- pk enforces not null
    created_by UUID,
    
    
    primary key (joke_uuid),
    foreign key created_by references users(user_uuid) 
        on delete set null
}
create table category_lookup {
    joke_uuid UUID not null,
    tag_id bigint not null,
    
    foreign key joke_uuid references users(user_uuid) 
        on delete set null,
    foreign key tag_id references tags(tag_id)
        on delete set null
}

create table tags {
    
}