create database db_employee
CREATE TABLE
    tbl_Employee (
        employee_name VARCHAR(255) NOT NULL,
        street VARCHAR(255) NOT NULL,
        city VARCHAR(255) NOT NULL,
        PRIMARY KEY(employee_name)
    );
 
 
CREATE TABLE
    tbl_Works (
        employee_name VARCHAR(255) NOT NULL,
        FOREIGN KEY (employee_name) REFERENCES tbl_Employee(employee_name),
        company_name VARCHAR(255),
        salary DECIMAL(10, 2)
    );
 
CREATE TABLE
    tbl_Company (
        company_name VARCHAR(255) NOT NULL,
        city VARCHAR(255),
        PRIMARY KEY(company_name)
    );
 
CREATE TABLE
    tbl_Manages (
        employee_name VARCHAR(255) NOT NULL,
        FOREIGN KEY (employee_name) REFERENCES tbl_Employee(employee_name),
        manager_name VARCHAR(255)
    );
 
INSERT INTO
    tbl_Employee (employee_name, street, city)
VALUES (
        'Alice Williams',
        '321 Maple St',
        'Houston'
    ), (
        'Sara Davis',
        '159 Broadway',
        'New York'
    ), (
        'Mark Thompson',
        '235 Fifth Ave',
        'New York'
    ), (
        'Ashley Johnson',
        '876 Market St',
        'Chicago'
    ), (
        'Emily Williams',
        '741 First St',
        'Los Angeles'
    ), (
        'Michael Brown',
        '902 Main St',
        'Houston'
    ), (
        'Samantha Smith',
        '111 Second St',
        'Chicago'
    );
	 
INSERT INTO
    tbl_Employee (employee_name, street, city)
VALUES (
        'Patrick',
        '123 Main St',
        'New Mexico'
    );
 
INSERT INTO
    tbl_Works (
        employee_name,
        company_name,
        salary
    )
VALUES (
        'Patrick',
        'Pongyang Corporation',
        500000
	);
 
INSERT INTO
    tbl_Works (
        employee_name,
        company_name,
        salary
    )
VALUES (
        'Sara Davis',
        'First Bank Corporation',
        82500.00
    ), (
        'Mark Thompson',
        'Small Bank Corporation',
        78000.00
    ), (
        'Ashley Johnson',
        'Small Bank Corporation',
        92000.00
    ), (
        'Emily Williams',
        'Small Bank Corporation',
        86500.00
    ), (
        'Michael Brown',
        'Small Bank Corporation',
        81000.00
    ), (
        'Samantha Smith',
        'Small Bank Corporation',
        77000.00
    );
 
INSERT INTO
    tbl_Company (company_name, city)
VALUES (
        'Small Bank Corporation', 'Chicago'), 
        ('ABC Inc', 'Los Angeles'), 
        ('Def Co', 'Houston'), 
        ('First Bank Corporation','New York'), 
        ('456 Corp', 'Chicago'), 
        ('789 Inc', 'Los Angeles'), 
        ('321 Co', 'Houston'),
        ('Pongyang Corporation','Chicago'
    );
 
INSERT INTO
    tbl_Manages(employee_name, manager_name)
VALUES 
    ('Mark Thompson', 'Emily Williams'),
    ('Alice Williams', 'Emily Williams'),
    ('Samantha Smith', 'Sara Davis'),
    ('Patrick', 'Jane Doe');
 
SELECT * FROM tbl_Employee;
SELECT * FROM tbl_Works;
SELECT * FROM tbl_Manages; 
SELECT * FROM tbl_Company;

-- Update the value of salary to 1000 where employee name= John Smith and company_name = First Bank Corporation
UPDATE tbl_Works
SET salary = '1000'
WHERE
    employee_name = 'Sara Davis'
AND company_name = 'First Bank Corporation';


--count the number of employees under every manager
SELECT COUNT(employee_name) AS number_of_employee, manager_name FROM tbl_Manages
GROUP BY manager_name
HAVING COUNT(employee_name)>1

--A)Find the names of all employees who work for First Bank Corporation.
SELECT employee_name FROM tbl_Employee
WHERE employee_name IN 
(SELECT employee_name FROM tbl_Works WHERE company_name ='First Bank Corporation');

--OR
SELECT employee_name FROM tbl_Works
WHERE company_name ='First Bank Corporation';

--B)Find the names and cities of residence of all employees who work for First Bank Corporation
SELECT employee_name,city FROM tbl_Employee
WHERE employee_name IN 
(SELECT employee_name FROM tbl_Works 
WHERE company_name ='First Bank Corporation');


--or
SELECT * FROM tbl_Employee cross join tbl_Works;


--or
select * from tbl_Employee left join tbl_Works
on tbl_Employee.employee_name=tbl_Works.employee_name
AND company_name='First Bank Corporation';

--or
select * from tbl_Employee RIGHT join tbl_Works
on tbl_Employee.employee_name=tbl_Works.employee_name
AND company_name='First Bank Corporation';

--OR
--or
select * from tbl_Employee join tbl_Works
on tbl_Employee.employee_name=tbl_Works.employee_name
AND company_name='First Bank Corporation'
AND salary=1210;


--C) Find the names, street addresses, and cities of residence of all employees who work for First Bank Corporation and earn more than $10,000.
SELECT employee_name,street,city FROM tbl_Employee
WHERE employee_name IN 
(SELECT employee_name FROM tbl_Works
WHERE company_name ='First Bank Corporation' AND salary='10000');


--d)Find all employees in the database who live in the same cities as the companies for which they work
SELECT tbl_Employee.employee_name FROM tbl_Works,tbl_Employee,tbl_Company
WHERE tbl_Company.city=tbl_Employee.city
AND tbl_Works.company_name=tbl_Company.company_name
AND tbl_Employee.employee_name=tbl_Works.employee_name;

--e)
SELECT e.employee_name
FROM tbl_Employee AS e, tbl_Employee AS e1, tbl_Manages AS m
WHERE m.employee_name = e.employee_name 
AND m.manager_name = e1.employee_name 
AND e.city = e1.city 
AND e.street = e1.street ;

--or

SELECT tbl_Employee.employee_name
FROM tbl_Employee ,  tbl_Employee AS E1 , tbl_Manages
WHERE tbl_Manages.employee_name = tbl_Employee.employee_name 
AND tbl_Manages.manager_name = E1.employee_name 
AND tbl_Employee.city = E1.city 
AND tbl_Employee.street = E1.street ;


--f)

SELECT employee_name FROM tbl_Works
WHERE company_name<>'First Bank Corporation';

--g)
SELECT employee_name
FROM tbl_Works
WHERE salary > ALL
(SELECT salary
FROM tbl_Works
WHERE company_name = 'Small Bank Corporation') ;


--or
SELECT employee_name
FROM tbl_Works
WHERE salary >
(SELECT MAX(salary)
FROM tbl_Works
WHERE company_name = 'Small Bank Corporation') ;

--h)
SELECT c.company_name
FROM tbl_Company AS c
WHERE c.city = ALL
(SELECT c.city
FROM tbl_company AS c
WHERE c.company_name='Small Bank Corporation');


--i)
select employee_name
from tbl_Works t 
where salary >(select avg(salary) from tbl_Works  as s        
where t.company_name = s.company_name) ;

--j)
select company_name from tbl_Works
group by company_name
having count( distinct employee_name) >= all (select count(distinct employee_name) from tbl_Works
group by company_name);


--k)
select company_name
from tbl_Works
group by company_name 
having sum(salary) <= all (select sum(salary) from tbl_Works group by company_name)

--l)

select company_name
from tbl_Works
group by company_name
having avg (salary) > (select avg (salary)
from tbl_Works
where company_name ='First Bank Corporation');

--3(A)

update tbl_Employee
set city='Newtown'
where employee_name='Jones';

--B)

update tbl_Works
set salary = salary * 1.1
where company_name = 'First Bank Corporation';

--c)
update tbl_Works
set salary = salary * 1.1
where employee_name in (select manager_name from tbl_Manages)
AND company_name = 'First Bank Corporation';



