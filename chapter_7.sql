-- CONSIDER THESE TWO HYPOTHETICAL CREATE TABLE
-- STATEMENTS FOR POSTGRESQL
CREATE TABLE customers (
customer_id SERIAL,
--snip--
);

-- BUT RATHER THAN CREATING A SECOND TABLE CALLED CUSTOMERS, 
-- THE SECOND STATEMENT WILL THROW AN ERROR:
-- RELATION "CUSTOMERS" ALREADY EXISTS.
CREATE TABLE Customers (
customer_id SERIAL,
--snip--
);

-- IF YOU WANT TO PRESERVE THE UPPERCASE LETTER AND CREATE A SEPARATE
-- TABLE NAMED CUSTOMERS, YOU MUST SURROUND THE IDENTIFIER WITH QUOTES
CREATE TABLE "Customers" (
customer_id SERIAL,
--snip--
);

-- LATER, TO QUERY CUSTOMERS RATHER THAN CUSTOMERS, YOU’LL HAVE TO
-- QUOTE ITS NAME IN THE SELECT STATEMENT
SELECT * FROM "Customers";

-- WE DECLARE A PRIMARY KEY USING THE COLUMN CONSTRAINT AND TABLE CONSTRAINT
-- METHODS ON A TABLE SIMILAR TO THE DRIVER’S LICENSE EXAMPLE MENTIONED 
-- EARLIER. BECAUSE WE EXPECT THE DRIVER’S LICENSE IDS TO ALWAYS BE 
-- UNIQUE, WE’LL USE THAT COLUMN AS A NATURAL KEY.
CREATE TABLE natural_key_example (
	license_id VARCHAR(10) CONSTRAINT license_key PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50)
);

DROP TABLE natural_key_example;

CREATE TABLE natural_key_example (
    license_id VARCHAR(10),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
CONSTRAINT license_key PRIMARY KEY (license_id)
);

-- CHECKING THE CONSTRAINT
INSERT INTO natural_key_example (license_id, first_name, last_name)
VALUES ('T229901', 'Lynn', 'Malero');

INSERT INTO natural_key_example (license_id, first_name, last_name)
VALUES ('T229901', 'Sam', 'Tracy');

/** ERROR: duplicate key value violates unique constraint "license_key"
DETAIL: Key (license_id)=(T229901) already exists. **/

CREATE TABLE natural_key_composite_example (
    student_id VARCHAR(10),
    school_day DATE,
    present BOOLEAN,
CONSTRAINT student_key PRIMARY KEY (student_id, school_day)
);

INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES
(775, '1/22/2017', 'Y');

INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES
(775, '1/23/2017', 'Y');


-- THE FIRST TWO INSERT STATEMENTS EXECUTE FINE BECAUSE THERE’S NO
-- DUPLICATION OF VALUES IN THE COMBINATION OF KEY COLUMNS. BUT THE THIRD
-- STATEMENT CAUSES AN ERROR BECAUSE THE STUDENT_ID AND SCHOOL_DAY VALUES IT
-- CONTAINS MATCH A COMBINATION THAT ALREADY EXISTS IN THE TABLE
INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES
(775, '1/23/2017', 'N');

/** ERROR: duplicate key value violates unique constraint "student_key"
DETAIL: Key (student_id, school_day)=(775, 2017-01-23) already exists. **/

-- IT SHOWS HOW TO DECLARE THE BIGSERIAL DATA TYPE FOR AN
-- ORDER_NUMBER COLUMN AND SET THE COLUMN AS THE PRIMARY KEY. WHEN YOU
-- INSERT DATA INTO THE TABLE, YOU CAN OMIT THE ORDER_NUMBER COLUMN.
CREATE TABLE surrogate_key_example (
    order_number BIGSERIAL,
    product_name VARCHAR(50),
    order_date DATE,
CONSTRAINT order_key PRIMARY KEY (order_number)
);

INSERT INTO surrogate_key_example (product_name, order_date)
VALUES 
('Beachball Polish', '2015-03-17'),
('Wrinkle De-Atomizer', '2017-05-22'),
('Flux Capacitor', '1985-10-26');

SELECT * FROM surrogate_key_example;

CREATE TABLE licenses (
    license_id VARCHAR(10),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
CONSTRAINT licenses_key PRIMARY KEY (license_id)
);

-- IN THE REGISTRATIONS TABLE, WE DESIGNATE THE COLUMN LICENSE_ID AS A 
-- FOREIGN KEY BY ADDING THE REFERENCES KEY
CREATE TABLE registrations (
    registration_id VARCHAR(10),
    registration_date DATE,
    license_id VARCHAR(10) REFERENCES licenses (license_id),
CONSTRAINT registration_key PRIMARY KEY (registration_id, license_id)
);

INSERT INTO licenses (license_id, first_name, last_name)
VALUES 
('T229901', 'Lynn', 'Malero');

INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES 
('A203391', '3/17/2017', 'T229901');

INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES 
('A75772', '3/17/2017', 'T000001');

CREATE TABLE check_constraint_example (
    user_id BIGSERIAL,
    user_role VARCHAR(50),
    salary INTEGER,
CONSTRAINT user_id_key PRIMARY KEY (user_id),
CONSTRAINT check_role_in_list CHECK (user_role IN('Admin', 'Staff')),
CONSTRAINT check_salary_not_zero CHECK (salary > 0)
);

-- IF WE USE THE TABLE CONSTRAINT SYNTAX, WE ALSO CAN COMBINE MORE THAN
-- ONE TEST IN A SINGLE CHECK STATEMENT.
CONSTRAINT grad_check CHECK (credits >= 120 AND tuition = 'Paid')

-- YOU CAN ALSO TEST VALUES ACROSS COLUMNS, AS IN THE FOLLOWING EXAMPLE 
-- WHERE WE WANT TO MAKE SURE AN ITEM’S SALE PRICE IS A DISCOUNT ON 
-- THE ORIGINAL, ASSUMING WE HAVE COLUMNS FOR BOTH VALUES
CONSTRAINT sale_check CHECK (sale_price < retail_price)

CREATE TABLE unique_constraint_example (
	contact_id BIGSERIAL CONSTRAINT contact_id_key PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(200),
CONSTRAINT email_unique UNIQUE (email)
);

INSERT INTO unique_constraint_example (first_name, last_name, email)
VALUES 
('Samantha', 'Lee', 'slee@example.org');

INSERT INTO unique_constraint_example (first_name, last_name, email)
VALUES 
('Betty', 'Diaz', 'bdiaz@example.org');

INSERT INTO unique_constraint_example (first_name, last_name, email)
VALUES 
('Sasha', 'Lee', 'slee@example.org');

/** ERROR: duplicate key value violates unique constraint "email_unique"
DETAIL: Key (email)=(slee@example.org) already exists. **/

CREATE TABLE not_null_example (
	student_id BIGSERIAL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
CONSTRAINT student_id_key PRIMARY KEY (student_id)
);

-- TO REMOVE A PRIMARY KEY, FOREIGN KEY, OR A UNIQUE CONSTRAINT, YOU
-- WOULD WRITE AN ALTER TABLE STATEMENT IN THIS FORMAT
ALTER TABLE table_name DROP CONSTRAINT constraint_name;

-- TO DROP A NOT NULL CONSTRAINT, THE STATEMENT OPERATES ON THE COLUMN, SO
-- YOU MUST USE THE ADDITIONAL ALTER COLUMN KEYWORDS
ALTER TABLE table_name ALTER COLUMN column_name DROP NOT NULL;

-- EXAMPLES
ALTER TABLE not_null_example DROP CONSTRAINT student_id_key;
ALTER TABLE not_null_example ADD CONSTRAINT student_id_key PRIMARY KEY (student_id);
ALTER TABLE not_null_example ALTER COLUMN first_name DROP NOT NULL;
ALTER TABLE not_null_example ALTER COLUMN first_name SET NOT NULL;