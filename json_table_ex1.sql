-- สอน MySQL 8: การแปลง JSON document ไปเก็บในตาราง
-- import JSON doc to table
-- doc: https://dev.mysql.com/doc/refman/8.0/en/json-table-functions.html
-- YouTube: 
-- Author: Prasert Kanawattanachai
-- email: prasert.k@chula.ac.th

-- # Ex 1
select * from
    json_table(
        '[
            {"firstName": "Peter", "lastName": "Parker", "age": 18}, 
            {"firstName": "Jane", "lastName": "Foster", "age": 30}
         ]',
        '$[*]' columns(v json path '$')) jt;

drop table if exists customer;
create table customer as
select * from
    json_table(
        '[
            {"firstName": "Peter", "lastName": "Parker", "age": 18}, 
            {"firstName": "Jane", "lastName": "Foster", "age": 30}
         ]',
        '$[*]' columns(
            fname varchar(50) path '$.firstName', 
            lname varchar(50) path '$.lastName',
            age int path '$.age')
    ) jt;

describe customer;
select * from customer;

drop table if exists employee;
create table employee as
select * from
    json_table(
        '
[
    {
        "firstName": "Peter", "lastName": "Parker",
        "age": 18,
        "skills": {
            "computers": ["Word", "Excel"],
            "languages": [{ "lang": "English", "level": 3 }, { "lang": "Japanese", "level": 1 }]
        }
    },
    {
        "firstName": "Jane", "lastName": "Foster",
        "age": 30,
        "skills": {
            "computers": ["Photoshop", "Illustrator"],
            "languages": [{ "lang": "English", "level": 5 }, { "lang": "Japanese", "level": 4 }, { "lang": "French", "level": 2 }]
        }
    }
]   
        ',
        '$[*]' columns
        (
            v json path '$', 
            fname varchar(50) path '$.firstName', 
            lname varchar(50) path '$.lastName',
            age int path '$.age',
            skills json path '$.skills',
            computers json path '$.skills.computers',
            languages json path '$.skills.languages'
        )
    ) jt;

describe employee;

select * from employee;