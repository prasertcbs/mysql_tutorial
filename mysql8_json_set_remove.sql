-- สอน MySQL 8: การเพิ่ม ลบและแก้ไขค่าใน JSON
-- json_set(): insert or update
-- json_remove(): remove key/value object
-- doc: https://dev.mysql.com/doc/refman/8.0/en/json.html
-- doc: https://dev.mysql.com/doc/refman/8.0/en/json-modification-functions.html
-- doc: https://dev.mysql.com/doc/refman/8.0/en/json-search-functions.html
-- YouTube: https://youtu.be/WmyXmtiNVHc
-- Author: Prasert Kanawattanachai
-- email: prasert.k@chula.ac.th

-- PART I
drop table if exists person;

CREATE TABLE person (
    id int,
    info json
);

INSERT INTO person VALUES (1, '{"age": 32, "gender": "M", "height": 1.78, "skills": {"computers": ["Word", "PowerPoint", "Excel"], "languages": [{"lang": "Korean", "level": 3}, {"lang": "Japanese", "level": 4}]}, "weight": 70, "address": {"city": "London", "postalCode": "630-0192", "streetAddress": "naist street"}, "hobbies": ["swimming", "running", "biking"], "lastName": "Bond", "firstName": "James", "phoneNumbers": [{"type": "work", "number": "07-007-8888"}, {"type": "home", "number": "0123-4567-8910"}]}');
INSERT INTO person VALUES (2, '{"age": 31, "gender": "F", "height": 1.6, "skills": {"computers": ["Photoshop", "Linux", "Excel", "PostgreSQL"], "languages": [{"lang": "English", "level": 3}, {"lang": "Chinese", "level": 4}, {"lang": "Korean", "level": 2}, {"lang": "French", "level": 1}]}, "weight": 48, "address": {"city": "New York", "postalCode": "630-0192", "streetAddress": "1st street"}, "hobbies": ["knitting", "reading", "swimming"], "lastName": "Foster", "firstName": "Jane", "phoneNumbers": [{"type": "mobile", "number": "089-123-4567"}, {"type": "home", "number": "02-567-3399"}, {"type": "work", "number": "02-432-4455"}]}');
INSERT INTO person VALUES (3, '{"age": 18, "gender": "M", "height": 1.65, "skills": {"computers": ["Python", "C"], "languages": [{"lang": "English", "level": 3}, {"lang": "Chinese", "level": 4}]}, "weight": 60, "address": {"city": "New York", "postalCode": "567-1122", "streetAddress": "5th Avenue"}, "hobbies": ["cooking", "swimming"], "lastName": "Parker", "firstName": "Peter", "phoneNumbers": [{"type": "mobile", "number": "055-111-5599"}, {"type": "home", "number": "02-111-2233"}]}');

select * from person;

select json_keys(info) from person;

-- update existing key/value
select info->>'$.firstName' from person;

select json_set(info, '$.firstName', 'Tony') from person
    where info->>'$.firstName'='Peter';

update person 
    set info=json_set(info, '$.firstName', 'Tony')
    where info->>'$.firstName'='Peter';

select info->>'$.firstName' from person;

-- insert new key/value
select json_set(info, '$.dob', '2002-03-14') from person
    where info->>'$.firstName'='Jane';

update person 
    set info=json_set(info, '$.dob', '2002-03-14')
    where info->>'$.firstName'='Jane';

select info->>'$.firstName', info->'$.dob' from person;

-- WRONG
select json_set(info, '$.socialmedia.twitter', 'tw_tiger') from person;

-- RIGHT
select json_object('twitter', 'tw_tiger');

select json_set(info, '$.socialmedia', json_object('twitter', 'tw_tiger')) 
    from person;

select json_set(info, '$.socialmedia', 
    json_object('twitter', 'tw_tiger', 'ig', 'ig_tiger')) 
    from person;

select concat('tw', '_', info->>'$.firstName') from person;

select json_set(info, '$.socialmedia', 
    json_object('twitter', concat('tw', '_', info->>'$.firstName'), 
                'ig', concat('ig', '_', info->>'$.firstName'))) 
    from person;

update person
    set info=json_set(info, '$.socialmedia', 
    json_object('twitter', concat('tw', '_', info->>'$.firstName'), 
                'ig', concat('ig', '_', info->>'$.firstName')));

select info->'$.socialmedia' from person;

-- json_remove()

select info, info->'$.gender' from person;

select json_remove(info, '$.gender') from person;

select json_remove(info, '$.phoneNumbers') from person;

select info, json_remove(info, '$.gender', '$.phoneNumbers', '$.skills.computers') from person;

update person
    set info=json_remove(info, '$.gender', '$.phoneNumbers', '$.skills.computers');

select * from person;
