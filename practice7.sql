-- CLEAN UP DATA

-- 1. Create a table for importing data
CREATE TABLE meat_poultry_egg_establishments (
    establishment_number text CONSTRAINT est_number_key PRIMARY KEY,
    company text,
    street text,
    city text,
    st text,
    zip text,
    phone text,
    grant_date date,
    activities text,
    dbas text
);

-- 2. Import information to the previous table
COPY meat_poultry_egg_establishments
FROM '/tmp/MPI_Directory_by_Establishment_Name.csv'
WITH (FORMAT CSV, HEADER);

-- 3. Create a B-tree index on the meat_poultry_egg_establishments table
CREATE INDEX company_idx ON meat_poultry_egg_establishments (company);

-- 4. List the number of rows in the table
Select count(*) from meat_poultry_egg_establishments;

-- 5. Group by to group data
SELECT company,
       street,
       city,
       st,
       count(*) AS address_count
FROM meat_poultry_egg_establishments
GROUP BY company, street, city, st
HAVING count(*) > 1
ORDER BY company, street, city, st;

-- 6. Group by and count to counting states
SELECT st, 
       count(*) AS st_count
FROM meat_poultry_egg_establishments
GROUP BY st
ORDER BY st;

-- 7. Find missing values
SELECT establishment_number,
       company,
       city,
       st,
       zip
FROM meat_poultry_egg_establishments
WHERE st IS NULL;

-- 8. Using length() and count() methods
SELECT length(zip),
       count(*) AS length_count
FROM meat_poultry_egg_establishments
GROUP BY length(zip)
ORDER BY length(zip) ASC;

-- 9. Filtering with length()
SELECT st,
       count(*) AS st_count
FROM meat_poultry_egg_establishments
WHERE length(zip) < 5
GROUP BY st
ORDER BY st ASC;

-- 10. Create a backup table.
CREATE TABLE meat_poultry_egg_establishments_backup AS
SELECT * FROM meat_poultry_egg_establishments;

-- 11. Create new column in order to experiment with the state column
ALTER TABLE meat_poultry_egg_establishments ADD COLUMN st_copy text;

UPDATE meat_poultry_egg_establishments
SET st_copy = st;

UPDATE meat_poultry_egg_establishments
SET st = 'MN'
WHERE establishment_number = 'V18677A';

UPDATE meat_poultry_egg_establishments
SET st = 'AL'
WHERE establishment_number = 'M45319+P45319';

UPDATE meat_poultry_egg_establishments
SET st = 'WI'
WHERE establishment_number = 'M263A+P263A+V263A'
RETURNING establishment_number, company, city, st, zip;

-- 12. Restore the st column from backup
UPDATE meat_poultry_egg_establishments
SET st = st_copy;

-- 13. Restore the st column from the table backup
UPDATE meat_poultry_egg_establishments original
SET st = backup.st
FROM meat_poultry_egg_establishments_backup backup
WHERE original.establishment_number = backup.establishment_number;

-- 14. Modify codes in the zip column
UPDATE meat_poultry_egg_establishments
SET zip = '00' || zip
WHERE st IN('PR','VI') AND length(zip) = 3;

-- 15. Modify codes in the zip column missing one leading zero
UPDATE meat_poultry_egg_establishments
SET zip = '0' || zip
WHERE st IN('CT','MA','ME','NH','NJ','RI','VT') AND length(zip) = 4;

-- 16. Add a new column that says whether a estabishment has activities related to meat processing
ALTER TABLE meat_poultry_egg_establishments ADD COLUMN meat_processing bool;

-- 17. Fill the new column with a condition
UPDATE meat_poultry_egg_establishments
SET meat_processing = true
WHERE activities LIKE '%Meat Processing%';

-- 18. Display the first 100 rows of the table to verify that the last query worked
SELECT * FROM meat_poultry_egg_establishments LIMIT(100);

-- 19. Start transaction.
-- Data consistency is really important among modern databases systems. This can be achieved using TRANSACTIONS.
-- If something fails inside a transaction, we can rollback. This will not save the changes.
-- To save them, call 'commit;'
-- Use transaction everytime you're updating your data.
start transaction 

update meat_poultry_egg_establishments
set company ='gdl'

select company, * from meat_poultry_egg_establishments;
rollback;
