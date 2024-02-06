--------------
-- one to one
-- user_settings : user
--------------
create table user_account (
   user_id bigint generated always as identity,
   name text not null,

   primary key(user_id)
);

create table user_settings (
    user_settings_id bigint generated always as identity,
    online boolean not null default (true),

    user_id bigint unique not null references user_account(user_id),
  
    primary key(user_settings_id)
);

insert into user_account
values (default, 'john');

insert into user_settings
values (default, default, 1);

insert into user_account
values (default, 'jamal');

insert into user_settings
values (default, false, 2);

select account.user_id,
       account.name,
       CASE
           WHEN settings.online = true THEN
               'Online'
           ELSE
               'Offline'
       END
from user_account as account
inner join user_settings as settings
on account.user_id = settings.user_id;

-- ====================================

--------------
-- zero or one to one
-- one to zero or one
--------------

-- one

-- one or zero
create table user_settings2 (
    user_settings_id bigint generated always as identity,
    online boolean not null default (true),

    user_id bigint unique not null references user_account(user_id),
  
    primary key(user_settings_id)
);

-- ====================================

--------------
-- zero or one to zero or one
--------------

-- one or zero


-- one or zero
create table user_settings (
    user_settings_id bigint generated always as identity,
    online boolean not null default (true),

    user_id bigint unique null references user_account(user_id),
  
    primary key(user_settings_id)
);

-- ====================================

-- zero or one to many
create table blog_post (
    blog_post_id BIGINT generated always as identity,
    title text not null,
    body text not null,

    primary key (post_id)
);

create table blog_post_tag (
    blog_post_tag_id bigint generated always as identity,
    blog_post_id bigint references null blog_post(blog_post_id),
    tag_id bigint references null tag(tag_id),

    primary key (blog_post_tag_id)
);

create table tag (
    tag_id bigint generated always as identity,
    tag_text text not null,

    primary key (tag_id)
);


-- one to many or zero
create table blog_post (
    blog_post_id BIGINT generated always as identity,
    title text not null,
    body text not null,

    primary key (post_id)
);

create table blog_post_tag (
    blog_post_tag_id bigint generated always as identity,
    blog_post_id bigint references not null blog_post(blog_post_id),
    tag_id bigint references not null tag(tag_id),

    primary key (blog_post_tag_id)
);

create table tag (
    tag_id bigint generated always as identity,
    tag_text text not null,

    primary key (tag_id)
);


-- zero or one to many or zero
create table blog_post (
    blog_post_id BIGINT generated always as identity,
    title text not null,
    body text not null,

    primary key (post_id)
);

create table blog_post_tag (
    blog_post_tag_id bigint generated always as identity,
    blog_post_id bigint references not null blog_post(blog_post_id),
    tag_id bigint references not null tag(tag_id),

    primary key (blog_post_tag_id)
);

create table tag (
    tag_id bigint generated always as identity,
    tag_text text not null,

    primary key (tag_id)
);

