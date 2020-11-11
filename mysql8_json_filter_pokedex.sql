-- สอน MySQL 8: filter JSON data
-- pokedex table: https://github.com/prasertcbs/mysql_tutorial/blob/main/pokedex.sql
-- doc: https://dev.mysql.com/doc/refman/8.0/en/json-search-functions.html
-- YouTube: https://youtu.be/CxY6oxtXXkI
-- Author: Prasert Kanawattanachai
-- email: prasert.k@chula.ac.th

describe pokedex;

select * from pokedex limit 5;

select json_keys(info) from pokedex limit 1;

select info, 
    info->'$.base', 
    info->'$.name', 
    info->'$.type' 
    from pokedex limit 5;

select id, info, 
    info->'$.name.english' name_j,
    info->>'$.name.english' name,
    info->'$.base."Sp. Attack"',
    info->'$.type',
    info->>'$.type[0]'
    from pokedex limit 5;

-- filter json 
select id, info, info->>'$.name.english' name 
    from pokedex 
    where lower(info->>'$.name.english') = 'pikachu';

select id, info, info->>'$.name.english' name 
    from pokedex 
    where lower(info->>'$.name.english') like 'p%';

select id, info->'$.type', info->>'$.name.english' name 
    from pokedex 
    where info->>'$.type[0]'='Dragon';

select id, info, info->>'$.name.english', 
        info->'$.base.Attack', 
        json_type(info->'$.base.Attack') 
    from pokedex 
    where info->'$.base.Attack' > 150;

-- between
select id, info, info->>'$.name.english', 
        info->'$.base.Attack'
    from pokedex 
    where info->'$.base.Attack' between 150 and 200 and 
        info->>'$.type[0]'='Dragon';

-- member of (json array)
select id, info, info->>'$.name.english', info->'$.type' 
    from pokedex 
    where 'Poison' member of (info->'$.type') limit 5;

-- json_overlaps (or)
select id, info, info->>'$.name.english', info->'$.type' 
    from pokedex 
    where json_overlaps(info->'$.type', '"Poison"');

-- either Poison OR Grass type
select id, info, info->>'$.name.english', info->'$.type' 
    from pokedex 
    where json_overlaps(info->'$.type', '["Poison", "Grass"]');

-- json_contains (and)
-- Poison AND Bug type
select id, info, info->>'$.name.english', info->'$.type' 
    from pokedex 
    where json_contains(info, '["Poison", "Bug"]', '$.type');

select id, info, info->>'$.name.english', info->'$.type' 
    from pokedex 

select id, info, info->>'$.name.english', 
    info->'$.base.Attack' 
    from pokedex 
    where info->'$.base.Attack' > 150 and 
            json_overlaps(info->'$.type', '"Normal"');

-- aggregate
select info->>'$.type[0]', max(info->'$.base.Attack') max
    from pokedex
    group by info->>'$.type[0]'

-- best attack by type
select info->>'$.name.english' name, 
    info->>'$.type[0]' type1, info->'$.base.Attack' attack,
    rank() over (partition by info->>'$.type[0]' 
                 order by info->'$.base.Attack' desc) rank_no
    from pokedex;

-- Common Table Expression (CTE)
with t as (
select info->>'$.name.english' name, 
    info->>'$.type[0]' type1, info->'$.base.Attack' attack,
    rank() over (partition by info->>'$.type[0]' 
                 order by info->'$.base.Attack' desc) rank_no
    from pokedex
)
select * from t where rank_no=1 order by attack desc;
