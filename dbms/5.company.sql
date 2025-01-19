
create database company_test;
use  company_test;

create table department (
    dno int primary key,
    dname varchar(20),
    mgrssn varchar(10),
    mgrstartdate date
);

create table employee (
    ssn varchar(10) primary key,
    name varchar(20),
    address varchar(20),
    sex char(1),
    salary int,
    superssn varchar(10),
    dno int,
    foreign key (dno) references department(dno) on delete cascade,
    foreign key (superssn) references employee(ssn) on delete cascade
);

desc department;

alter table department
add foreign key (mgrssn) references employee(ssn) on delete cascade;

create table dlocation (
    dno int,
    dloc varchar(20),
 foreign key (dno) references department(dno) on delete cascade
);

create table project (
    pno int primary key,
    pname varchar(20),
    plocation varchar(20),
    dno int,
    foreign key (dno) references department(dno) on delete cascade
);

create table works_on (
    ssn varchar(20),
    pno int,
    hours int,
    foreign key (ssn) references employee(ssn) on delete cascade,
    foreign key (pno) references project(pno) on delete cascade
);

drop table works_on;

insert into employee
    (ssn, name, address, sex, salary)
values
    ('a1', 'charles scott', 'beng', 'm', 500000),
    ('a2', 'michael scott', 'mys', 'm', 700000),
    ('a3', 'anhi', 'beng', 'm', 100000),
    ('a4', 'nayana', 'mang', 'f', 890000),
    ('a5', 'gayana', 'hubli', 'f', 788888);

select * from employee;

insert into department (dno, dname, mgrssn, mgrstartdate)
values
    (1, 'accounts', 'a1', '2023-01-01'),
    (2, 'testing', 'a2', '2023-01-01'),
    (3, 'f-engineer', 'a3', '2023-01-01'),
    (4, 'b-engineer', 'a4', '2023-01-01'),
    (5, 'db-admin', 'a5', '2023-01-01');

select * from department;

update employee
set superssn = null , dno ='5'
where ssn = 'a1';
update employee
set superssn = 'a1' , dno ='3'
where ssn = 'a2';
update employee
set superssn = 'a2' , dno ='5'
where ssn = 'a3';
update employee
set superssn = 'a1' , dno ='2'
where ssn = 'a4';
update employee
set superssn = 'a4' , dno ='1'
where ssn = 'a5';

insert into dlocation (dno, dloc)
values
    (1, 'beng'),
    (2,'mys'),
    (3, 'mys'),
    (4, 'hubli'),
    (5, 'beng');

select * from dlocation;

insert into project (pno, pname, plocation, dno)
values
    (101, 'iot', 'beng', 1),
    (102, 'sensors', 'mys', 2),
    (103, 'prog1', 'mys', 5),
    (104, 'prog2', 'beng', 5),
    (105, 'prog3', 'mys', 5);

insert into project (pno, pname, plocation, dno)
values (106, 'p6', 'mys', 3);

insert into works_on (ssn, pno, hours)
values
    ('a2', 106, 70),
    ('a2', 101, 30),
    ('a1', 103, 45);

insert into works_on (ssn, pno, hours)
values
    ('a3',101, 30),
    ('a4', 101, 30);

insert into works_on(ssn, pno, hours) values
    ('a5', 103, 30),
    ('a5', 104, 30),
    ('a5', 105, 30);

#1
select distinct p.pno
from project p,employee e, department d
where p.dno = d.dno and
      d.mgrssn = e.ssn and
      e.name like '%scott'
union
select distinct p.pno
from project p,employee e, works_on w
where w.pno = p.pno and
      w.ssn = e.ssn and
      e.name like '%scott';

#2
select e.name,e.ssn, 1.1*e.salary
from employee e, project p, works_on w
where p.pno = w.pno and
      e.ssn = w.ssn and
      p.pname = 'iot';

#3
select max(employee.salary),min(employee.salary),avg(employee.salary),sum(employee.salary)
from employee , department d
where employee.dno = d.dno and
      d.dname = 'accounts';

#4
select e.name, e.ssn
from employee e
where not exists(
    select pno
    from project
    where dno = '5' and pno not in (
        select pno
        from works_on
        where e.ssn = ssn
        )
);

#5
update employee
set salary = 1000000
where ssn = 'a3';

select d.dno, count(*) as count
from department d , employee e
where d.dno = e.dno
and e.salary > 600000
and d.dno in (
    select e1.dno
    from employee e1
    group by e1.dno
    having count(*)>1
    )
group by d.dno;
