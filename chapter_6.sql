-- THE DEPT_ID COLUMN UNIQUELY IDENTIFIES THE DEPARTMENT, AND ALTHOUGH 
-- THIS EXAMPLE CONTAINS ONLY A DEPARTMENT NAME AND CITY,
CREATE TABLE departments (
	dept_id BIGSERIAL,
	dept VARCHAR(100),
	city VARCHAR(100),
CONSTRAINT dept_key PRIMARY KEY (dept_id),
CONSTRAINT dept_city_unique UNIQUE (dept, city)
);

-- THE EMP_ID COLUMN UNIQUELY IDENTIFIES EACH ROW IN THE EMPLOYEES TABLE.
-- THE VALUES IN THIS COLUMN REFER TO VALUES IN THE DEPARTMENTS TABLE’S PRIMARY KEY.
CREATE TABLE employees (
	emp_id BIGSERIAL,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	salary INTEGER,
	dept_id INTEGER REFERENCES departments (dept_id),
CONSTRAINT emp_key PRIMARY KEY (emp_id),
CONSTRAINT emp_dept_unique UNIQUE (emp_id, dept_id)
);

INSERT INTO departments (dept, city)
VALUES
('Tax', 'Atlanta'),
('IT', 'Boston');

INSERT INTO employees (first_name, last_name, salary, dept_id)
VALUES
('Nancy', 'Jones', 62500, 1),
('Lee', 'Smith', 59300, 1),
('Soo', 'Nguyen', 83000, 2),
('Janet', 'King', 95000, 2);

-- THE JOIN KEYWORD GOES BETWEEN THE TWO TABLES YOU WANT DATA FROM. 
-- FINALLY, YOU SPECIFY THE COLUMNS TO JOIN THE TABLES USING THE ON KEYWORD.
SELECT *
FROM employees JOIN departments 
ON employees.dept_id = departments.dept_id;

-- THE JOIN KEYWORD GOES BETWEEN THE TWO TABLES YOU WANT DATA FROM. 
-- FINALLY, YOU SPECIFY THE COLUMNS TO JOIN THE TABLES USING THE ON KEYWORD.
SELECT *
FROM employees JOIN departments 
ON employees.dept_id = departments.dept_id;

-- WE CREATE AND FILL TWO TABLES: WE ADD A PRIMARY KEY TO EACH TABLE.
CREATE TABLE schools_left (
	id integer CONSTRAINT left_id_key PRIMARY KEY,
	left_school varchar(30)
);

-- THE KEYWORDS CONSTRAINT KEY_NAME PRIMARY KEY INDICATE THAT 
-- THOSE COLUMNS WILL SERVE AS THE PRIMARY KEY FOR THEIR TABLE.
CREATE TABLE schools_right (
	id integer CONSTRAINT right_id_key PRIMARY KEY,
	right_school varchar(30)
);

INSERT INTO schools_left (id, left_school) VALUES
	(1, 'Oak Street School'),
	(2, 'Roosevelt High School'),
	(5, 'Washington Middle School'),
	(6, 'Jefferson High School');

INSERT INTO schools_right (id, right_school) VALUES
	(1, 'Oak Street School'),
	(2, 'Roosevelt High School'),
	(3, 'Morrison Elementary'),
	(4, 'Chase Magnet Academy'),
	(6, 'Jefferson High School');

-- SCHOOLS THAT EXIST ONLY IN ONE OF THE TWO TABLES DON’T APPEAR IN THE RESULT.
SELECT *
FROM schools_left AS sl 
INNER JOIN schools_right AS sr ON sl.id = sr.id

-- THE RESULT OF THE QUERY SHOWS ALL FOUR ROWS FROM SCHOOLS_LEFT AS WELL AS
-- THE THREE ROWS IN SCHOOLS_RIGHT WHERE THE ID FIELDS MATCHED.
SELECT *
FROM schools_left 
LEFT JOIN schools_right ON schools_left.id = schools_right.id;

-- WE SEE SIMILAR BUT OPPOSITE BEHAVIOR BY RUNNING RIGHT JOIN
SELECT *
FROM schools_left RIGHT JOIN schools_right
ON schools_left.id = schools_right.id;

SELECT *
FROM schools_left FULL OUTER JOIN schools_right
ON schools_left.id = schools_right.id;

-- THE RESULT HAS 20 ROWS—THE PRODUCT OF FOUR ROWS IN THE LEFT TABLE
-- TIMES FIVE ROWS IN THE RIGHT
SELECT *
FROM schools_left CROSS JOIN schools_right;

SELECT *
FROM schools_left 
LEFT JOIN schools_right ON schools_left.id = schools_right.id
WHERE schools_right.id IS NULL;

SELECT *
FROM schools_left 
FULL OUTER JOIN schools_right ON schools_left.id = schools_right.id
WHERE schools_right.id IS NULL OR 
      schools_left.id IS NULL;

-- CONSIDER THE FOLLOWING QUERY, WHICH TRIES TO FETCH AN ID COLUMN
-- WITHOUT NAMING THE TABLE
SELECT id
FROM schools_left 
LEFT JOIN schools_right ON schools_left.id = schools_right.id;

-- TO FIX THE ERROR, WE NEED TO ADD THE TABLE NAME IN FRONT OF EACH
-- COLUMN WE’RE QUERYING, AS WE DO IN THE ON CLAUSE
SELECT schools_left.id,
			 schools_left.left_school,
			 schools_right.right_school
FROM schools_left 
LEFT JOIN schools_right ON schools_left.id = schools_right.id;

-- WE CAN ALSO ADD THE AS KEYWORD WE USED PREVIOUSLY WITH CENSUS DATA TO
-- MAKE IT CLEAR IN THE RESULTS THAT THE ID COLUMN IS FROM SCHOOLS_LEFT.
SELECT schools_left.id AS left_id
FROM schools_left 
LEFT JOIN schools_right ON schools_left.id = schools_right.id;

-- HERE ARE THE TABLES: SCHOOLS_ENROLLMENT HAS THE NUMBER OF STUDENTS PER SCHOOL:
CREATE TABLE schools_enrollment (
	id integer,
	enrollment integer
);

-- THE SCHOOLS_GRADES TABLE CONTAINS THE GRADE LEVELS HOUSED IN EACH BUILDING:
CREATE TABLE schools_grades (
	id integer,
	grades varchar(10)
);

INSERT INTO schools_enrollment (id, enrollment)
VALUES
(1, 360),
(2, 1001),
(5, 450),
(6, 927);

INSERT INTO schools_grades (id, grades)
VALUES
(1, 'K-3'),
(2, '9-12'),
(5, '6-8'),
(6, '9-12');

-- IN THE SELECT QUERY, WE JOIN SCHOOLS_LEFT TO SCHOOLS_ENROLLMENT USING THE
-- TABLES’ ID FIELDS. WE ALSO DECLARE TABLE ALIASES TO KEEP THE CODE COMPACT.
-- NEXT, THE QUERY JOINS SCHOOLS_LEFT TO SCHOOL_GRADES AGAIN ON THE ID FIELDS.
SELECT lt.id, lt.left_school, en.enrollment, gr.grades
FROM schools_left AS lt 
LEFT JOIN schools_enrollment AS en ON lt.id = en.id
LEFT JOIN schools_grades AS gr ON lt.id = gr.id;

-- IN THIS CODE, WE’RE BUILDING ON EARLIER FOUNDATIONS. WE HAVE THE
-- FAMILIAR CREATE TABLE STATEMENT, WHICH FOR THIS EXERCISE INCLUDES STATE AND
-- COUNTY CODES, A GEO_NAME COLUMN WITH THE FULL NAME OF THE STATE AND
-- COUNTY, AND NINE COLUMNS WITH POPULATION COUNTS INCLUDING TOTAL
-- POPULATION AND COUNTS BY RACE.
CREATE TABLE us_counties_2000 (
		geo_name varchar(90),
		state_us_abbreviation varchar(2),
		state_fips varchar(2),
		county_fips varchar(3),
		p0010001 integer,
		p0010002 integer,
		p0010003 integer,
		p0010004 integer,
		p0010005 integer,
		p0010006 integer,
		p0010007 integer,
		p0010008 integer,
		p0010009 integer,
		p0010010 integer,
		p0020002 integer,
		p0020003 integer
);

-- THE COPY STATEMENT IMPORTS A CSV FILE WITH THE CENSUS DATA
COPY us_counties_2000
FROM 'C:\YourDirectory\us_counties_2000.csv'
WITH (FORMAT CSV, HEADER);

-- THE SELECT STATEMENT INCLUDES THE COUNTY’S NAME AND STATE
-- ABBREVIATION FROM THE 2010 TABLE, WHICH IS ALIASED WITH C2010.
SELECT c2010.geo_name,
		   c2010.state_us_abbreviation AS state,
		   c2010.p0010001 AS pop_2010,
		   c2000.p0010001 AS pop_2000,
		   c2010.p0010001 - c2000.p0010001 AS raw_change,
		   round( (CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001) / c2000.p0010001 * 100, 1 ) AS pct_change

-- WE JOIN BY MATCHING VALUES IN TWO COLUMNS IN BOTH TABLES: STATE_FIPS
-- AND COUNTY_FIPS. THE REASON TO JOIN ON TWO COLUMNS INSTEAD OF ONE IS
-- THAT IN BOTH TABLES, WE NEED THE COMBINATION OF A STATE CODE AND A COUNTY
-- CODE TO FIND A UNIQUE COUNTY.
FROM us_counties_2010 AS c2010 
INNER JOIN us_counties_2000 AS c2000
ON c2010.state_fips = c2000.state_fips AND 
   c2010.county_fips = c2000.county_fips AND 

-- I’VE ADDED A THIRD CONDITION TO ILLUSTRATE USING AN INEQUALITY. 
-- THIS LIMITS THE JOIN TO COUNTIES WHERE THE p0010001
-- POPULATION COLUMN HAS A DIFFERENT VALUE.
   c2010.p0010001 <> c2000.p0010001
ORDER BY pct_change DESC;