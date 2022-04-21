-- JOIN, UNION, INTERSECT, EXCEPT

-- 1. Create and fill tables

-- 1.1 Create distric tables
CREATE TABLE district_2020 (
    id integer CONSTRAINT id_key_2020 PRIMARY KEY,
    school_2020 text
);

CREATE TABLE district_2035 (
    id integer CONSTRAINT id_key_2035 PRIMARY KEY,
    school_2035 text
);

-- 1.2 Insert values to distric tables
INSERT INTO district_2020 VALUES
    (1, 'Oak Street School'),
    (2, 'Roosevelt High School'),
    (5, 'Dover Middle School'),
    (6, 'Webutuck High School');

INSERT INTO district_2035 VALUES
    (1, 'Oak Street School'),
    (2, 'Roosevelt High School'),
    (3, 'Morrison Elementary'),
    (4, 'Chase Magnet Academy'),
    (6, 'Webutuck High School');
    
-- 1.3 Create departments and employees table
CREATE TABLE departments (
    dept_id integer,
    dept text,
    city text,
    CONSTRAINT dept_key PRIMARY KEY (dept_id),
    CONSTRAINT dept_city_unique UNIQUE (dept, city)
);

CREATE TABLE employees (
    emp_id integer,
    first_name text,
    last_name text,
    salary numeric(10,2),
    dept_id integer REFERENCES departments (dept_id),
    CONSTRAINT emp_key PRIMARY KEY (emp_id)
);

-- 1.4 Insert values to departments and employees table
INSERT INTO departments
VALUES
    (1, 'Tax', 'Atlanta'),
    (2, 'IT', 'Boston');

INSERT INTO departments
VALUES
	(3, 'Dev', 'Guadalajara'),
	
INSERT INTO employees
VALUES
    (1, 'Julia', 'Reyes', 115300, 1),
    (2, 'Janet', 'King', 98000, 1),
    (3, 'Arthur', 'Pappas', 72700, 2),
    (4, 'Michael', 'Taylor', 89500, 2);
	
INSERT INTO employees
VALUES
    (5, 'Miguel', 'Palomenra', 89500, null);
    
_______________________________________________________________________________________________________________________________________________________________________

-- 2. JOIN

-- 2.1 SELECT JOIN: Joining columns of two tables
SELECT *
FROM employees JOIN departments
ON employees.dept_id = departments.dept_id
ORDER BY employees.dept_id;

-- 2.2 INNER JOIN: Elements matching the conditional
SELECT *
FROM district_2020 INNER JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- 2.3 LEFT JOIN: Elements matching the conditional and left conditional
SELECT *
FROM district_2020 LEFT JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- 2.4 RIGHT JOIN: Elements matching the conditional and right conditional
SELECT *
FROM district_2020 RIGHT JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2035.id;

-- 2.5 FULL OUTER JOIN: Showing elements that do not meet the condition
SELECT *
FROM district_2020 FULL OUTER JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- 2.6 CROSS JOIN: Joining rows with every element from the other table
SELECT *
FROM district_2020 CROSS JOIN district_2035
ORDER BY district_2020.id, district_2035.id;
-- Note: CROSS JOIN can be simplified as a SELECT from two (or more) tables

-- 2.7 JOIN with USING (the result query won't show the ids)
SELECT *
FROM district_2020 JOIN district_2035
USING (id)
ORDER BY district_2020.id;

_______________________________________________________________________________________________________________________________________________________________________

-- 3. UNION

-- 3.1 Combining query results with UNION
SELECT * FROM district_2020
UNION
SELECT * FROM district_2035
ORDER BY id;

-- 3.2 Combining query results with UNION ALL
SELECT * FROM district_2020
UNION ALL
SELECT * FROM district_2035
ORDER BY id;

-- 3.3 Customizing UNION
SELECT '2020' AS year,
       school_2020 AS school
FROM district_2020

UNION ALL

SELECT '2035' AS year,
       school_2035
FROM district_2035
ORDER BY school, year;

_______________________________________________________________________________________________________________________________________________________________________

-- 4. INTERSECT (all that are in A and B)
SELECT * FROM district_2020
INTERSECT
SELECT * FROM district_2035
ORDER BY id;

_______________________________________________________________________________________________________________________________________________________________________

-- 5. EXCEPT (all from A that are not in B)
SELECT * FROM district_2020
EXCEPT
SELECT * FROM district_2035
ORDER BY id;
