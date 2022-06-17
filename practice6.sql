-- INDEXES

-- They are used to retrieve data from the database more quickly than otherwise.
-- They use data structures (trees, hashes) to optimize search.

-- 1. Create a table for importing data
CREATE TABLE new_york_addresses (
    longitude numeric(9,6),
    latitude numeric(9,6),
    street_number text,
    street text,
    unit text,
    postcode text,
    id integer CONSTRAINT new_york_key PRIMARY KEY
);

-- 2. Import information to the previous table
COPY new_york_addresses
FROM 'C:\YourDirectory\city_of_new_york.csv'
WITH (FORMAT CSV, HEADER);

-- 3. Benchmark queries for index performance
EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = 'BROADWAY';

EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = '52 STREET';

EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = 'ZWICKY AVENUE';

-- 4. Creating a B-tree index on the new_york_addresses table
CREATE INDEX street_idx ON new_york_addresses (street);
