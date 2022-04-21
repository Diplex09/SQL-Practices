-- Import practice
-- General syntax

COPY table_name
FROM 'C:\DirectoryPath\file.csv'
WITH (FORMAT CSV, HEADER);

_______________________________________________________________________________________________________________________________________________________________________

-- 1. Importing data
-- 1.1 Create the us_counties table
CREATE TABLE us_counties_pop_est_2019 (
    state_fips text,                         -- State FIPS code
    county_fips text,                        -- County FIPS code
    region smallint,                         -- Region
    state_name text,                         -- State name	
    county_name text,                        -- County name
    area_land bigint,                        -- Area (Land) in square meters
    area_water bigint,                       -- Area (Water) in square meters
    internal_point_lat numeric(10,7),        -- Internal point (latitude)
    internal_point_lon numeric(10,7),        -- Internal point (longitude)
    pop_est_2018 integer,                    -- 2018-07-01 resident total population estimate
    pop_est_2019 integer,                    -- 2019-07-01 resident total population estimate
    births_2019 integer,                     -- Births from 2018-07-01 to 2019-06-30
    deaths_2019 integer,                     -- Deaths from 2018-07-01 to 2019-06-30
    international_migr_2019 integer,         -- Net international migration from 2018-07-01 to 2019-06-30
    domestic_migr_2019 integer,              -- Net domestic migration from 2018-07-01 to 2019-06-30
    residual_2019 integer,                   -- Residual for 2018-07-01 to 2019-06-30
    CONSTRAINT counties_2019_key PRIMARY KEY (state_fips, county_fips)	
);

-- 1.2 Make file available for pgadmin user
-- cp us_counties_pop_est_2019.csv  /tmp/ -> tmp is a folder available for all the users

-- 1.3 Copy from the folder we created
COPY us_counties_pop_est_2019
FROM '/tmp/us_counties_pop_est_2019.csv'
WITH (FORMAT CSV, HEADER);


-- 1.4 In this case, select everything, but...
-- It is possible to indicate the columns to import.
-- It is possible to import only some records using where.
-- It is possible to import to a temporary table and do an insert from there.
SELECT * FROM us_counties_pop_est_2019;

_______________________________________________________________________________________________________________________________________________________________________

-- 2. Exporting data
-- 2.1 Create the supervisor_salaries table
CREATE TABLE supervisor_salaries (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    town text,
    county text,
    supervisor text,
    start_date text,
    salary numeric(10,2),
    benefits numeric(10,2)
);

-- 2.2 Import data to supervisor_salaries by selecting which columns to import
COPY supervisor_salaries (town, supervisor, salary)
FROM '/tmp/supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER);

-- 2.3 Make a query
SELECT * FROM supervisor_salaries ORDER BY id LIMIT 2;

-- 2.4 Delete the data form table supervisor_salaries
DELETE FROM supervisor_salaries;

-- 2.5 Import data to supervisor_salaries WHERE town = 'New Brillig'
COPY supervisor_salaries (town, supervisor, salary)
FROM '/tmp/supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER)
WHERE town = 'New Brillig';

-- 2.6 Make a query
SELECT * FROM supervisor_salaries;

_______________________________________________________________________________________________________________________________________________________________________

-- 3. Create a temporary table

-- 3.1 Delete the data form table supervisor_salaries
DELETE FROM supervisor_salaries;

-- 3.2 Create the temporary table supervisor_salaries_temp
CREATE TEMPORARY TABLE supervisor_salaries_temp 
    (LIKE supervisor_salaries INCLUDING ALL);
	
-- 3.3 Import data to supervisor_salaries_temp
COPY supervisor_salaries_temp (town, supervisor, salary)
FROM '/tmp/supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER);

-- 3.4 Copy data form supervisor_salaries_temp to supervisor_salaries
INSERT INTO supervisor_salaries (town, county, supervisor, salary)
SELECT town, 'Mills', supervisor, salary
FROM supervisor_salaries_temp;

-- 3.5 Delete the temporary table supervisor_salaries_temp
DROP TABLE supervisor_salaries_temp;

-- 3.6 Make a query
SELECT * FROM supervisor_salaries ORDER BY id LIMIT 2;

_______________________________________________________________________________________________________________________________________________________________________

-- 4. Exporting the data form a table to a txt file

-- 4.1 Exporting a whole table using COPY
COPY us_counties_pop_est_2019
TO '/tmp/us_counties_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');

-- 4.2 Exporting selected columns from a table using COPY
COPY us_counties_pop_est_2019 
    (county_name, internal_point_lat, internal_point_lon)
TO '/tmp/us_counties_latlon_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');

-- 4.3 Exporting the query results with COPY
COPY (
    SELECT county_name, state_name
    FROM us_counties_pop_est_2019
    WHERE county_name ILIKE '%mill%'
     )
TO '/tmp/us_counties_mill_export.csv'
WITH (FORMAT CSV, HEADER);
