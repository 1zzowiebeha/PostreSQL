CREATE TABLE coach (
coach_id bigint generated always as identity,
name varchar not null,
primary key (coach_id)
  );

CREATE TABLE team (
team_id bigint generated always as identity,
name varchar not null,
coach_id bigint null,
primary key (team_id),
-- table constraint
  foreign key (coach_id) references coach(coach_id)
  );

CREATE TABLE player(
player_id bigint generated always as identity,
name varchar not null,
-- column constraint can't contain 'foreign key' keywords.
team_id bigint not null references team(team_id),
  primary key (player_id)
  );

-- COACH TABLE
INSERT INTO coach (name) VALUES ('Phil Jackson');
INSERT INTO coach (name) VALUES ('Gregg Popovich');
INSERT INTO coach (name) VALUES ('Steve Kerr');
INSERT INTO coach (name) VALUES ('Erik Spoelstra');
INSERT INTO coach (name) VALUES ('Doc Rivers');

-- TEAM TABLE
INSERT INTO team (name, coach_id) VALUES ('Los Angeles Lakers', 1);
INSERT INTO team (name, coach_id) VALUES ('San Antonio Spurs', 2);
INSERT INTO team (name, coach_id) VALUES ('Golden State Warriors', 3);
INSERT INTO team (name, coach_id) VALUES ('Miami Heat', 4);
INSERT INTO team (name, coach_id) VALUES ('Philadelphia 76ers', 5);
INSERT INTO team (name, coach_id) VALUES ('Big Frys', null);

-- PLAYER TABLE
INSERT INTO player (name, team_id) VALUES ('LeBron James', 1);
INSERT INTO player (name, team_id) VALUES ('Kawhi Leonard', 2);
INSERT INTO player (name, team_id) VALUES ('Steph Curry', 3);
INSERT INTO player (name, team_id) VALUES ('Jimmy Butler', 4);
INSERT INTO player (name, team_id) VALUES ('Joel Embiid', 5);
INSERT INTO player (name, team_id) VALUES ('Benjamin Butler', 6);
INSERT INTO player (name, team_id) VALUES ('James Mingolus', 6);

-- double quote for database identifiers
-- single quote for string literals
-- https://stackoverflow.com/questions/1992314/what-is-the-difference-between-single-and-double-quotes-in-sql
-- AS is required if the new column name matches any keyword at all, reserved or not. Recommended practice is to use AS or double-quote output column names, to prevent any possible conflict against future keyword additions.
select p.name as "Player", t.name as Team, c.name as "Coach"
from player as p
join team as t using (team_id) -- virtual table formed
left join coach as c using (coach_id);
