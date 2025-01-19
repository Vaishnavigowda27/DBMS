create database test_movie;
use test_movie;

create table actor (
  act_id int not null primary key,
  act_name varchar(20) ,
  act_gender char(1)
);

create table director (
  dir_id int not null primary key,
  dir_name varchar(20),
  dir_phone varchar(20)
);

create table movies(
  mov_id int not null primary key,
  mov_title varchar(20),
  mov_year year,
  mov_lang varchar(20),
  dir_id int references director(dir_id) on delete cascade
);


create table movie_cast (
  act_id int ,
  mov_id int,
  role varchar(20),
  foreign key (act_id) references actor(act_id) on delete cascade,
   foreign key (mov_id) references movies(mov_id) on delete cascade
);

create table rating(
  mov_id int,
  rev_stars varchar(25),
  foreign key (mov_id) references  movies(mov_id) on delete cascade
);

insert into actor (act_id, act_name, act_gender)
values
    (1, 'a','m'),
    (2, 'b', 'm'),
    (3, 'c', 'f'),
    (4, 'd', 'f'),
    (5, 'e', 'm');

select * from actor;

insert into director (dir_id, dir_name, dir_phone)
values
    (11, 'ab', '123'),
    (12, 'bc', '123'),
    (13, 'hitch', '123'),
    (14, 'steven', '123'),
    (15, 'cd', '123');

select * from director;

insert into movies (mov_id, mov_title, mov_year, mov_lang, dir_id)
values
    (101, 'qwqw', 1997, 'kan', 13),
    (102, 'wewe', 2021, 'kan', 14),
    (103, 'erer', 2015, 'eng', 11);

insert into movie_cast (act_id, mov_id, role)
values
    (1, 101, 'hero'),
    (2, 101, 'hero'),
    (3, 103, 'heroine');

insert into movie_cast (act_id, mov_id, role)
values
    (1, 102, 'hero');

insert into movie_cast (act_id, mov_id, role)
values
    (3, 101, 'hero');
insert into movie_cast (act_id, mov_id, role)
values
    (4, 103, 'hero');

insert into rating (mov_id, rev_stars)
values
    (102, 2),
    (101, 3),
    (103, 5);

insert into rating (mov_id, rev_stars)
values
    (102, 3),
    (101, 4),
    (103, 6);

select * from rating;

#1
select m.mov_title
from movies m natural join director
where dir_name = 'hitch';

#2
select m.mov_title
from movies m
natural join movie_cast mc
 where act_id in (select act_id
                  from movie_cast
                  group by act_id
                  having count(act_id)>1)
group by m.mov_title
having count(*)>1;

#3
select distinct mc.act_id
from movies m
join movie_cast mc on mc.mov_id = m.mov_id
where m.mov_year not between 2000 and 2020;

#4
select m.mov_title, max(rev_stars)
from rating natural join movies m
group by mov_title
order by mov_title;

#5
select * from rating;
update rating
set rev_stars = 5
where mov_id in (select mov_id
                 from movies natural join director
                 where dir_name = 'steven');
