-- CREATE A TABLE CALLED TEACHERS
CREATE TABLE teachers (
    id SERIAL, 
    first_name VARCHAR(25),
    last_name VARCHAR(50),
    school VARCHAR(50),
    hire_date DATE,
    salary NUMERIC
);

-- INSERT VALUES INTO TEACHERS TABLE
INSERT INTO teachers(first_name, last_name, school, hire_date, salary)
VALUES
('Janet', 'Smith', 'F.D. Roosevelt HS', '2011-10-30', 36200),
('Lee', 'Reynolds', 'F.D. Roosevelt HS', '1993-05-22', 65000),
('Samuel', 'Cole', 'Myers Middle School', '2005-08-01', 43500),
('Samantha', 'Bush', 'Myers Middle School', '2011-10-30', 36200),
('Betty', 'Diaz', 'Myers Middle School', '2005-08-30', 43500),
('Kathleen', 'Roush', 'F.D. Roosevelt HS', '2010-10-22', 38500);

-- SELECT ALL THE ROWS AND COLUMNS FROM THE TEACHERS TABLE
SELECT *
FROM teachers;

-- EXERCISES
-- QUESTION 1
-- Imagine you’re building a database to catalog all the animals at your local zoo. 
-- You want one table to track the kinds of animals in the collection and another table to track the specifics on each animal.
-- Write CREATE TABLE statements for each table that include some of the columns you need. Why did you include the columns you chose?

--THE FIRST TABLE WILL HOLD THE ANIMAL TYPES AND THEIR CONSERVATION STATUS
CREATE TABLE animal_types (
    animal_type_id SERIAL CONSTRAINT animal_types_key PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    conservation_status VARCHAR(50) NOT NULL
);

-- THE SECOND TABLE WILL HOLD DATA ON INDIVIDUAL ANIMALS
CREATE TABLE menagerie (
    menagerie_id SERIAL CONSTRAINT menagerie_key PRIMARY KEY,
    animal_type_id BIGINT REFERENCES animal_types (animal_type_id),
    date_acquired DATE NOT NULL,
    gender VARCHAR(1),
    acquired_from VARCHAR(100),
    name VARCHAR(100),
    notes TEXT
);

-- QUESTION 2
-- Now create INSERT statements to load sample data into the tables. How can you view the data via the pgAdmin tool? 
-- Create an additional INSERT statement for one of your tables. Purposely omit one of the required commas separating 
-- the entries in the VALUES clause of the query. What is the error message? Would it help you find the error in the code?

-- INSERT TWO VALUES INTO THE ANIMAL_TYPES TABLE
INSERT INTO animal_types (common_name, scientific_name, conservation_status)
VALUES
('Bengal Tiger', 'Panthera tigris tigris', 'Endangered'),
('Arctic Wolf', 'Canis lupus arctos', 'Least Concern');

-- INSERT TWO VALUES INTO MENAGERIE TABLE
INSERT INTO menagerie (animal_type_id, date_acquired, gender, acquired_from, name, notes)
VALUES
(1, '1996-03-12', 'F', 'Dhaka Zoo', 'Ariel', 'Healthy coat at last exam.'),
(2, '2000-09-30', 'F', 'National Zoo', 'Freddy', 'Strong appetite.');