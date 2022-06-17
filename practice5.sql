-- PRIMARY KEYS, FOREIGN KEYS, CHECK, CHECK IN

-- 1. PRIMARY KEYS (must be unique and NOT NULL)
-- 1.1 Declare a single-column natural key as PRIMARY KEY
CREATE TABLE natural_key_example (
    license_id text CONSTRAINT license_key PRIMARY KEY,
    first_name text,
    last_name text
);

-- 1.2 Drop the table previosuly created
DROP TABLE natural_key_example;

-- 1.3 Recreate the last table but doing the primary key declaration in a new row
CREATE TABLE natural_key_example (
    license_id text,
    first_name text,
    last_name text,
    CONSTRAINT license_key PRIMARY KEY (license_id)
);

-- 1.4 Insert a row of information in the previously created table
INSERT INTO natural_key_example (license_id, first_name, last_name)
VALUES ('T229901', 'Gem', 'Godfrey');

_______________________________________________________________________________________________________________________________________________________________________

-- 2. PRIMARY KEY VIOLATION

-- 2.1.1 Repeated PRIMARY KEY
-- 2.1.2 Insert the exact same information that before
INSERT INTO natural_key_example (license_id, first_name, last_name)
VALUES ('T229901', 'Gem', 'Godfrey');

-- 2.2.1 Composed PRIMARY KEY as natural Key
CREATE TABLE natural_key_composite_example (
    student_id text,
    school_day date,
    present boolean,
    CONSTRAINT student_key PRIMARY KEY (student_id, school_day)
);

-- 2.3.1 Composed PRIMARY KEY violations
INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES(775, '2022-01-22', 'Y');

INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES(775, '2022-01-23', 'Y');

INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES(776, '2022-01-23', 'N');

-- 2.4 Create a new table using "bigint" datatype as the PRIMARY KEY
CREATE TABLE surrogate_key_example (
    order_number bigint GENERATED ALWAYS AS IDENTITY, -- "AS IDENTITY" cannot be modified
    product_name text,
    order_time timestamp with time zone,
    CONSTRAINT order_number_key PRIMARY KEY (order_number)
);

-- 2.5 Recreate the previous table using "bigserial" datatype so we can auto increment it
CREATE TABLE surrogate_key_example (
    order_number bigserial,
    product_name text,
    order_time timestamp with time zone,
    CONSTRAINT order_number_key PRIMARY KEY (order_number)
);

-- 2.6 Insert information into the table previously created
INSERT INTO surrogate_key_example (product_name, order_time)
VALUES ('Beachball Polish', '2020-03-15 09:21-07'),
       ('Wrinkle De-Atomizer', '2017-05-22 14:00-07'),
       ('Flux Capacitor', '1985-10-26 01:18:00-07');
	   
-- 2.7 Display all the data inside the table
Select * from surrogate_key_example

_______________________________________________________________________________________________________________________________________________________________________

-- 3. FOREIGN KEYS

-- 3.1 Create the first table with a primary key
CREATE TABLE licenses (
    license_id text,
    first_name text,
    last_name text,
    CONSTRAINT licenses_key PRIMARY KEY (license_id)
);

-- 3.2 Create the second table with a PRIMARY KEY and a reference to the PRIMARY KEY of the previous table (= create a FOREIGN KEY)
CREATE TABLE registrations (
    registration_id text,
    registration_date timestamp with time zone,
    license_id text REFERENCES licenses (license_id),
    CONSTRAINT registration_key PRIMARY KEY (registration_id, license_id)
);

-- 3.3 Insert data into the first table
INSERT INTO licenses (license_id, first_name, last_name)
VALUES ('T229901', 'Steve', 'Rothery');

-- 3.4 Insert data into the second table
INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES ('A203391', '2022-03-17', 'T229901');

-- 3.5 Insert data into the second table with a non existing license_id (it will fail)
INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES ('A75772', '2022-03-17', 'T000001');

_______________________________________________________________________________________________________________________________________________________________________

-- 4. CHECK / CHECK IN

-- 4.1 Create a table that validates the given data with CHECK function
CREATE TABLE check_constraint_example (
    user_id bigint GENERATED ALWAYS AS IDENTITY,
    user_role text,
    salary numeric(10,2),
    CONSTRAINT user_id_key PRIMARY KEY (user_id),
    CONSTRAINT check_role_in_list CHECK (user_role IN('Admin', 'Staff')),
    CONSTRAINT check_salary_not_below_zero CHECK (salary >= 0)
    
-- 4.2 Insert the "admin" role to the table (it will fail because the role "admin" doesn't exist)
INSERT INTO check_constraint_example (user_role)
VALUES ('admin');

-- 4.3 Insert value -10000 into the salary column (it will fail because the salary can't be a negative number)
INSERT INTO check_constraint_example (salary)
VALUES (-10000);

_______________________________________________________________________________________________________________________________________________________________________

-- 5. NOT NULL

-- 5.1 Create a table with NOT NULL attributes
CREATE TABLE not_null_example (
    student_id bigint GENERATED ALWAYS AS IDENTITY,
    first_name text NOT NULL,
    last_name text NOT NULL,
    CONSTRAINT student_id_key PRIMARY KEY (student_id)
);

-- 5.2 Insert information into the table (it will fail because last_name can't be NULL)
INSERT INTO not_null_example (first_name, last_name)
VALUES ('Sting', NULL);

-- 5.3 Drop PRIMARY KEY constraint
ALTER TABLE not_null_example DROP CONSTRAINT student_id_key;

-- 5.4 Add PRIMARY KEY constraint
ALTER TABLE not_null_example ADD CONSTRAINT student_id_key PRIMARY KEY (student_id);

-- 5.5 Drop NOT NULL constraint
ALTER TABLE not_null_example ALTER COLUMN last_name DROP NOT NULL;

-- 5.6 Add NOT NULL constraint
ALTER TABLE not_null_example ALTER COLUMN first_name SET NOT NULL;
