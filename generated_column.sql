-- generated columns

-- Ex 1. genrate/calculate/derive vat from price column
create table invoice (
    id int,
    price double,
    vat double as (price * 7 / 107)
);

insert into invoice (id,price) values (1, 107), (2, 200), (3, 500);
select * from invoice;

update invoice set price = 100 where id = 1;
select * from invoice;

-- Ex 2. generate bmi from weight and height
create table person (
    id int,
    weight double, -- kg
    height double, -- m
    bmi double as (weight / (height * height)) -- generated column
);

insert into person (id, weight, height) values
    (1, 45, 1.6),
    (2, 70, 1.7),
    (3, 70, 1.8);

select * from person;

-- Ex 3. generate income level from income
create table qnaire (
    id int,
    income double,
    level varchar(10) as (
        case
            when income > 70000 then 'high'
            when income > 40000 then 'med'
            else 'low'
        end
    )
);

insert into qnaire (id, income) values
    (1, 60000),
    (2, 200000),
    (3, 20000);

select * from qnaire;

insert into qnaire (id, income) values
    (4, 30000),
    (5, 50000),
    (6, 10000);

select * from qnaire;

select level, count(*) from qnaire group by level;