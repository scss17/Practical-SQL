-- THE MEAT_POULTRY_EGG_INSPECT TABLE HAS 10 COLUMNS. WE ADD A NATURAL
-- PRIMARY KEY CONSTRAINT TO THE EST_NUMBER COLUMN, WHICH CONTAINS A
-- UNIQUE VALUE FOR EACH ROW THAT IDENTIFIES THE ESTABLISHMENT.
CREATE TABLE meat_poultry_egg_inspect(
	est_number VARCHAR(50) CONSTRAINT est_number_key PRIMARY KEY,
	company VARCHAR(100),
	street VARCHAR(100),
	city VARCHAR(50),
	st VARCHAR(2),
	zip VARCHAR(5),
	phone VARCHAR(14),
	grant_date DATE,
	activities TEXT,
	dbas TEXT
);

COPY meat_poultry_egg_inspect
FROM 'C:\Users\pscam\Desktop\MPI_Directory_by_Establishment_Name.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

CREATE INDEX company_idx ON meat_poultry_egg_inspect (company);

-- FOR PRACTICE, LET’S USE THE COUNT() AGGREGATE FUNCTION 
-- TO CHECK HOW MANY ROWS ARE IN THE MEAT_POULTRY_EGG_INSPECT TABLE:
SELECT COUNT(*) FROM meat_poultry_egg_inspect;

SELECT company,
       street,
       city,
       st,
       COUNT(*) AS address_count
FROM meat_poultry_egg_inspect
GROUP BY company, street, city, st
HAVING count(*) > 1
ORDER BY company, street, city, st;

-- WHEN YOU RUN THE QUERY, IT TALLIES THE NUMBER OF TIMES EACH STATE POSTAL
-- CODE (ST) APPEARS IN THE TABLE.
SELECT st, 
       COUNT(*) AS st_count
FROM meat_poultry_egg_inspect
GROUP BY 1
ORDER BY 1;

-- THIS QUERY RETURNS THREE ROWS THAT DON’T HAVE A VALUE IN THE ST COLUMN
SELECT est_number,
       company,
	     city, 
	     st,
	     zip
FROM meat_poultry_egg_inspect
WHERE ST IS NULL;

SELECT company, 
       COUNT(*) AS company_count
FROM meat_poultry_egg_inspect
GROUP BY company
ORDER BY company ASC;

-- THE RESULTS CONFIRM THE FORMATTING ERROR. AS YOU CAN SEE, 496 OF THE
-- ZIP CODES ARE FOUR CHARACTERS LONG, AND 86 ARE THREE CHARACTERS LONG,
-- WHICH MEANS THESE NUMBERS ORIGINALLY HAD TWO LEADING ZEROS THAT MY
-- CONVERSION ERRONEOUSLY ELIMINATED:
SELECT LENGTH(zip),
       COUNT(*) AS length_count
FROM meat_poultry_egg_inspect
GROUP BY LENGTH(zip)
ORDER BY LENGTH(zip) ASC;

-- USING THE WHERE CLAUSE, WE CAN CHECK THE DETAILS OF THE RESULTS TO SEE
-- WHICH STATES THESE SHORTENED ZIP CODES CORRESPOND TO:
SELECT st,
       COUNT(*) AS st_count
FROM meat_poultry_egg_inspect
WHERE LENGTH(zip) < 5
GROUP BY st
ORDER BY st ASC;

-- THE CODE FOR ADDING A COLUMN
ALTER TABLE table_name ADD COLUMN column_name data_type;

-- WE CAN REMOVE A COLUMN WITH THE FOLLOWING SYNTAX
ALTER TABLE table_name DROP COLUMN column_name;

-- TO CHANGE THE DATA TYPE OF A COLUMN, WE WOULD USE THIS CODE
ALTER TABLE table_name ALTER COLUMN column_name SET DATA TYPE data_type;

-- ADDING A NOT NULL CONSTRAINT TO A COLUMN WILL LOOK LIKE THE FOLLOWING
ALTER TABLE table_name ALTER COLUMN column_name SET NOT NULL;

-- REMOVING THE NOT NULL CONSTRAINT LOOKS LIKE THIS
ALTER TABLE table_name ALTER COLUMN column_name DROP NOT NULL;

UPDATE table_name
SET column_name = value;

UPDATE table
SET column_a = value,
    column_b = value;

UPDATE table
SET column_name = value
WHERE criteria;

-- SIMILARLY, THE WHERE EXISTS CLAUSE USES A SELECT STATEMENT TO GENERATE VALUES
-- THAT SERVE AS THE FILTER FOR THE UPDATE.
UPDATE table
SET column_name = (SELECT column_name
                   FROM table_b
                   WHERE table_column = table_b.column)

WHERE EXISTS (SELECT column_name
              FROM table_b
              WHERE table_column = table_b.column);

-- SOME DATABASE MANAGERS OFFER ADDITIONAL SYNTAX FOR UPDATING ACROSS
-- TABLES. POSTGRESQL SUPPORTS THE ANSI STANDARD BUT ALSO A SIMPLER SYNTAX
-- USING A FROM CLAUSE FOR UPDATING VALUES ACROSS TABLES:
UPDATE table
SET column_name = table_b.column
FROM table_b
WHERE table.column = table_b.column;

CREATE TABLE meat_poultry_egg_inspect_backup AS
SELECT * FROM meat_poultry_egg_inspect;

-- AFTER RUNNING THE CREATE TABLE STATEMENT, THE RESULT SHOULD BE A PRISTINE
-- COPY OF YOUR TABLE WITH THE NEW SPECIFIED NAME. YOU CAN CONFIRM THIS BY
-- COUNTING THE NUMBER OF RECORDS IN BOTH TABLES WITH ONE QUERY
SELECT
(SELECT count(*) FROM meat_poultry_egg_inspect) AS original,
(SELECT count(*) FROM meat_poultry_egg_inspect_backup) AS backup;

-- LET’S CREATE THE COPY AND FILL IT
-- WITH THE EXISTING ST COLUMN VALUES USING THE SQL STATEMENTS
ALTER TABLE meat_poultry_egg_inspect ADD COLUMN st_copy VARCHAR(2);

UPDATE meat_poultry_egg_inspect 
SET st_copy = st;

-- WE CAN CONFIRM THE VALUES WERE COPIED PROPERLY WITH A SIMPLE SELECT
-- QUERY ON BOTH COLUMNS
SELECT st,
       st_copy
FROM meat_poultry_egg_inspect
ORDER BY st;

-- LET’S CREATE THE COPY AND FILL IT
-- WITH THE EXISTING ST COLUMN VALUES USING THE SQL STATEMENTS
ALTER TABLE meat_poultry_egg_inspect ADD COLUMN st_copy VARCHAR(2);

UPDATE meat_poultry_egg_inspect 
SET st_copy = st;

-- WE CAN CONFIRM THE VALUES WERE COPIED PROPERLY WITH A SIMPLE SELECT
-- QUERY ON BOTH COLUMNS
SELECT st,
       st_copy
FROM meat_poultry_egg_inspect
ORDER BY st;

UPDATE meat_poultry_egg_inspect
SET st = st_copy;

UPDATE meat_poultry_egg_inspect AS original
SET st = backup.st
FROM meat_poultry_egg_inspect_backup AS backup
WHERE original.est_number = backup.est_number;

ALTER TABLE meat_poultry_egg_inspect 
ADD COLUMN company_standard VARCHAR(100);

UPDATE meat_poultry_egg_inspect
SET company_standard = company;

UPDATE meat_poultry_egg_inspect
SET company_standard = 'Armour-Eckrich Meats'
WHERE company LIKE 'Armour%';

SELECT company, company_standard
FROM meat_poultry_egg_inspect
WHERE company LIKE 'Armour%';

ALTER TABLE meat_poultry_egg_inspect ADD COLUMN zip_copy VARCHAR(5);

UPDATE meat_poultry_egg_inspect
SET zip_copy = zip;

-- WE USE THE CODE IN TO PERFORM THE FIRST UPDATE
UPDATE meat_poultry_egg_inspect
SET zip = '00' || zip
WHERE st IN('PR','VI') AND length(zip) = 3;

-- LET’S REPAIR THE REMAINING ZIP CODES USING A SIMILAR QUERY IN LISTING
UPDATE meat_poultry_egg_inspect
SET zip = '0' || zip
WHERE st IN('CT','MA','ME','NH','NJ','RI','VT') AND length(zip) = 4;

-- WE’LL CREATE TWO COLUMNS IN A STATE_REGIONS TABLE: ONE CONTAINING THE
-- TWO-CHARACTER STATE CODE ST AND THE OTHER CONTAINING THE REGION NAME.
CREATE TABLE state_regions (
	st VARCHAR(2) CONSTRAINT st_key PRIMARY KEY,
	region VARCHAR(20) NOT NULL
);

COPY state_regions
FROM 'C:\Users\pscam\Desktop\state_regions.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

-- THE ALTER TABLE STATEMENT CREATES THE INSPECTION_DATE COLUMN IN THE
-- MEAT_POULTRY_EGG_INSPECT TABLE. IN EFFECT, THE QUERY IS TELLING THE 
-- DATABASE TO FIND ALL THE ST CODES THAT CORRESPOND TO THE NEW ENGLAND 
-- REGION AND USE THOSE CODES TO FILTER THE UPDATE.
UPDATE meat_poultry_egg_inspect AS inspect
SET inspection_date = '2019-12-01'
WHERE EXISTS (SELECT state_regions.region
              FROM state_regions
              WHERE inspect.st = state_regions.st AND 
                    state_regions.region = 'New England');

SELECT st, inspection_date
FROM meat_poultry_egg_inspect
GROUP BY st, inspection_date
ORDER BY st;

-- GENERAL SYNTAX
ALTER TABLE table_name DROP COLUMN column_name;

-- EXAMPLE
ALTER TABLE meat_poultry_egg_inspect DROP COLUMN zip_copy;

-- GENERAL SYNTAX
DROP TABLE table_name;

-- EXAMPLE
DROP TABLE meat_poultry_egg_inspect_backup;

START TRANSACTION;

UPDATE meat_poultry_egg_inspect
SET company = 'AGRO Merchantss Oakland LLC'
WHERE company = 'AGRO Merchants Oakland, LLC';

SELECT company
FROM meat_poultry_egg_inspect
WHERE company LIKE 'AGRO%'
ORDER BY company;

ROLLBACK;

CREATE TABLE meat_poultry_egg_inspect_backup AS

SELECT *,
       '2018-02-07'::date AS reviewed_date
FROM meat_poultry_egg_inspect;

ALTER TABLE meat_poultry_egg_inspect RENAME TO meat_poultry_egg_inspect_temp;
ALTER TABLE meat_poultry_egg_inspect_backup RENAME TO meat_poultry_egg_inspect;
ALTER TABLE meat_poultry_egg_inspect_temp RENAME TO meat_poultry_egg_inspect_backup;