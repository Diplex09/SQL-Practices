SELECT *
FROM teachers
ORDER BY school ASC, last_name ASC;

SELECT *
FROM teachers
WHERE first_name LIKE 'S%'
AND salary > 40000;

SELECT *
FROM teachers
WHERE hire_date >= to_date('01-Jan-2010','DD-MON-YYYY')
ORDER BY salary DESC;
