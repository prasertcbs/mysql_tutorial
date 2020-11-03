-- สอน MySQL 8: การเปลี่ยนค่าสมาชิกใน JSON array
-- json_set(): insert or update
-- json_search(): search value
-- doc: https://dev.mysql.com/doc/refman/8.0/en/json.html
-- doc: https://dev.mysql.com/doc/refman/8.0/en/json-modification-functions.html
-- doc: https://dev.mysql.com/doc/refman/8.0/en/json-search-functions.html
-- YouTube: https://youtu.be/tkt3SKlyZwk
-- Author: Prasert Kanawattanachai
-- email: prasert.k@chula.ac.th

drop table if exists person;

CREATE TABLE person (
    id int,
    info json
);

INSERT INTO person VALUES (1, '{"age": 32, "gender": "M", "height": 1.78, "skills": {"computers": ["Word", "PowerPoint", "Excel"], "languages": [{"lang": "Korean", "level": 3}, {"lang": "Japanese", "level": 4}]}, "weight": 70, "address": {"city": "London", "postalCode": "630-0192", "streetAddress": "naist street"}, "hobbies": ["swimming", "running", "biking"], "lastName": "Bond", "firstName": "James", "phoneNumbers": [{"type": "work", "number": "07-007-8888"}, {"type": "home", "number": "0123-4567-8910"}]}');
INSERT INTO person VALUES (2, '{"age": 31, "gender": "F", "height": 1.6, "skills": {"computers": ["Photoshop", "Linux", "Excel", "PostgreSQL"], "languages": [{"lang": "English", "level": 3}, {"lang": "Chinese", "level": 4}, {"lang": "Korean", "level": 2}, {"lang": "French", "level": 1}]}, "weight": 48, "address": {"city": "New York", "postalCode": "630-0192", "streetAddress": "1st street"}, "hobbies": ["knitting", "reading", "swimming"], "lastName": "Foster", "firstName": "Jane", "phoneNumbers": [{"type": "mobile", "number": "089-123-4567"}, {"type": "home", "number": "02-567-3399"}, {"type": "work", "number": "02-432-4455"}]}');
INSERT INTO person VALUES (3, '{"age": 18, "gender": "M", "height": 1.65, "skills": {"computers": ["Python", "C"], "languages": [{"lang": "English", "level": 3}, {"lang": "Chinese", "level": 4}]}, "weight": 60, "address": {"city": "New York", "postalCode": "567-1122", "streetAddress": "5th Avenue"}, "hobbies": ["cooking", "swimming"], "lastName": "Parker", "firstName": "Peter", "phoneNumbers": [{"type": "mobile", "number": "055-111-5599"}, {"type": "home", "number": "02-111-2233"}]}');

select info, info->'$.hobbies' from person;

-- replace JSON array element by value

select info, 
    info->'$.hobbies',
    json_set(info->'$.hobbies', '$[0]', 'aaa') from person;

select info->'$.hobbies', 
    json_search(info->'$.hobbies', 'one', 'running'),
    json_unquote(json_search(info->'$.hobbies', 'one', 'running')),
    json_search(info->'$.hobbies', 'one', 'swimming')
    from person;

select info->'$.hobbies', 
    json_search(info->'$.hobbies', 'one', 'running'),
    json_unquote(json_search(info->'$.hobbies', 'one', 'running')),
    json_set(info->'$.hobbies', json_unquote(json_search(info->'$.hobbies', 'one', 'running')), 'jogging') 
from person;

select * from person;

-- add where clause
-- replace 'running' with 'jogging'
select info->'$.hobbies', 
    json_search(info->'$.hobbies', 'one', 'running'),
    json_unquote(json_search(info->'$.hobbies', 'one', 'running')),
    json_set(info->'$.hobbies', json_unquote(json_search(info->'$.hobbies', 'one', 'running')), 'jogging'),
    json_set(info, '$.hobbies', json_set(info->'$.hobbies', json_unquote(json_search(info->'$.hobbies', 'one', 'running')), 'jogging')) 
from person
where json_search(info->'$.hobbies', 'one', 'running') is not null;

select info->>'$.firstName', json_search(info->'$.hobbies', 'one', 'running') from person;

update person
    set info=json_set(info, '$.hobbies', json_set(info->'$.hobbies', json_unquote(json_search(info->'$.hobbies', 'one', 'running')), 'jogging')) 
where json_search(info->'$.hobbies', 'one', 'running') is not null;

select info->'$.hobbies' from person;
