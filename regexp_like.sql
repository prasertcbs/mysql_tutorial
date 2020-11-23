-- สอน MySQL 8: basic regular expression
-- doc: https://dev.mysql.com/doc/refman/8.0/en/regexp.html
-- sql script: 
-- YouTube: 
-- Author: Prasert Kanawattanachai
-- email: prasert.k@chula.ac.th

-- create 'movies' table script: https://github.com/prasertcbs/mysql_tutorial/blob/main/data/movies.sql
select title from movies limit 50; 

-- contains
-- rlike is case insensitive
select title from movies where title like '%iron%'; 

-- three different ways
select title from movies where title rlike 'iron';
select title from movies where title regexp('iron');
select title from movies where regexp_like(title, 'iron');

select * from movies where (director rlike 'jame') and (rating > 7);

-- not rlike
select title from movies where title not rlike 'iron';

-- contains
select title from movies where title rlike 'man';

-- or
select title from movies where title rlike 'iron|spider|bat';

select title from movies 
    where (title like '%iron%') or (title like '%spider%') or (title like '%bat%');

select title from movies 
    where (description rlike 'love') or (title rlike 'love');

-- starts with
select title from movies where title rlike '^man';

-- word boundary
select title from movies where title rlike '^\\bman\\b';

-- ends with
select title from movies where title rlike 'man$';
select title from movies where title rlike '\\d$';
select title from movies where title rlike '3$';
select title from movies where title rlike '\\b3\\b$';
select title from movies where title rlike '^t.*\\d$';

-- () -> group
select title from movies where title rlike '(spider|bat|iron)';
select title from movies where title rlike '^(spider|bat|iron)';

-- contains 'three' or ends with 3
select title from movies where title rlike 'three|3$';

-- ends with 'three' or 3
select title from movies where title rlike 'three$|3$|iii$';
select title from movies where title rlike '(three|3|iii)$';

select title from movies where title rlike '(three|\\b3\\b)$';

select title from movies where title rlike '^i.*(three|3|iii)$';
select title from movies where title rlike '^s.*(three|3|iii)$';

-- match one of a set of characters []
select title from movies where title rlike 'm[a|e]n';
select title from movies where title rlike '^\\bm[a|e]n\\b';

-- downey AND evans
select title, actors from movies where actors rlike 'downey.*evans';

select title, actors from movies where actors rlike 'downey.*evans|evans.*downey';

select title, actors from movies 
    where (actors rlike 'downey') and (actors rlike 'evans');

-- contains digit
select title from movies where title rlike '\\d';

-- contains non-digit
select title from movies where title not rlike '\\d';
select title from movies where title rlike '\\D';

-- {n}, {m,n}, {n,}
select title from movies where title rlike 'i{2}';
select title from movies where title rlike 'i{1,2}';
select title from movies where title rlike 'i{2,}';

-- title, ?, +
-- atitle -> a{0,}
-- a+ -> a{1,} (at least one)
-- a? -> a{0,1}

select title from movies where title rlike '0title';
select title from movies where title rlike '0+';
select title from movies where title rlike '0?';

select title from movies where title rlike '0{2}';

select title from movies where title rlike '0{1,2}';

select title from movies where title rlike 'spiderman';
select title from movies where title rlike 'spider-man';
select title from movies where title rlike 'spider-?man';
select title from movies where title rlike 'spider[-\\s]?man';
select title from movies where title rlike '(bat|super)titleman';
select title from movies where title rlike '(bat|super)?man';
select title from movies where title rlike '(bat|super)+man';

select title from movies where title rlike '(bat|spider|ant|iron)[\\-\\s]titleman';

-- create 'm' table
drop table if exists m;
create table m as select title from movies where title rlike 'm[a|e]n';

select title from m where title rlike 'spider';

update m 
    set title='The Amazing Spiderman 2' 
    where title='The Amazing Spider-Man 2';

select title from m where title rlike 'spider';
select title from m where title rlike 'spider-?man';

