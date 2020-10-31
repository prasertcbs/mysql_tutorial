-- unnest JSON array
-- doc: https://dev.mysql.com/doc/refman/8.0/en/json-table-functions.html
-- YouTube: 
-- Author: Prasert Kanawattanachai
-- email: prasert.k@chula.ac.th

describe pokemon;

select * from pokemon limit 10;

select id, name->>'$.english', type, v 
    from pokemon, 
    json_table(type, 
        '$[*]' columns(v varchar(20) path '$')) jt;

with t as (
    select v 
    from pokemon, 
    json_table(type, 
        '$[*]' columns(v varchar(20) path '$')) jt
)
select * from t;

-- CTE
with t as (
    select v 
    from pokemon, 
    json_table(type, 
        '$[*]' columns(v varchar(20) path '$')) jt
)
select v, count(*) freq 
    from t 
    group by v 
    order by freq desc;
