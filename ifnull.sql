-- จัดการกับคอลัมน์ตัวเลขที่มีค่า null
-- Server: MySQL 8
-- Author: Prasert Kanawattanachai
-- YouTube: https://youtu.be/WX8y2ShVu-w

drop table if exists theater;

create table theater (
	year int,
	movie int,
	popcorn int,
	drink int
);

insert into theater (year, movie, popcorn, drink) values 
    (2011, 26, 18, null),
    (2012, 26, 13, 18),
    (2013, 16, 12, null),
    (2014, 30, null, 11),
    (2015, 25, 13, null),
    (2016, 23, 9, 23),
    (2017, 20, 9, 20),
    (2018, 11, 15, 11),
    (2019, 30, 15, null),
    (2020, 20, null, 24);

select * from theater;

select year, movie, popcorn, drink, movie+popcorn+drink from theater;

select ifnull(null, 0);

select year, movie, popcorn, drink, ifnull(movie,0)+ifnull(popcorn,0)+ifnull(drink,0) from theater;

select sum(movie), sum(popcorn), sum(drink), sum(movie+popcorn+drink) from theater;

select sum(movie), sum(popcorn), sum(drink), 
    sum(ifnull(movie,0)+ifnull(popcorn,0)+ifnull(drink,0)) total
    from theater;

select year, movie, popcorn, drink, ifnull(movie,0)+ifnull(popcorn,0)+ifnull(drink,0) total from theater
union
select null, sum(movie), sum(popcorn), sum(drink), sum(ifnull(movie,0)+ifnull(popcorn,0)+ifnull(drink,0)) total from theater;


