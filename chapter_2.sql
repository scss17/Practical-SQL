-- THIS IS THE MOST BASIC STATEMENT AND IT SELECTS ALL ROWS AND CLUMNS FROM TEACHERS TABLE
SELECT * FROM teachers;

-- WITH THIS SINTAX, THE QUERY WILL RETIEVE ALL ROWS FROM LAST NAME, FIRST NAME AND SALARY
SELECT last_name, first_name, salary 
FROM teachers; 

-- RETRIEVE UNIQUE SCHOOLS FROM TEACHERS TABLE
SELECT DISTINCT school FROM teachers;

-- RETRIEVE THE UNIQUE PAIR OF SCHOOL AND SALARY FROM TEACHERS TABLE
SELECT DISTINCT school, salary FROM teachers;

-- ORDER THE ROWS ACCORDING TO SALARY IN DESCENDING ORDER
SELECT first_name, last_name, salary
FROM teachers
ORDER BY salary DESC;

-- SORT THE QUERY BASED ON TWO CRITERIA 
SELECT last_name, school, hire_date
FROM teachers
ORDER BY school ASC, hire_date DESC; 

-- FILTER THE QUERY BY SCHOOL
SELECT last_name, school, hire_date
FROM teachers
WHERE school = 'Myers Middle School';

-- EXAMPLES WITH COMPARISON OPERATORS
-- FIRST, WE USE THE EQUALS OPERATOR TO FIND TEACHERS, HOSE FIRST NAME IS JANET
SELECT first_name, last_name, school
FROM teachers
WHERE first_name = 'Janet';

-- WE LIST ALL SCHOOL NAMES IN THE TABLE BUT EXCLUDE F.D. ROOSEVELT HS
SELECT school
FROM teachers
WHERE school != 'F.D. Roosevelt HS';

-- HERE WE USE THE LESS THAM OPERATOR TO LIST TEACHERS HIRED BEFORE JANUARY 1, 2000
SELECT first_name, last_name, hire_date
FROM teachers
WHERE hire_date < '2000-01-01';

-- WE FIND TEACHERS WHO EARN $43,500 OR MORE USING THE >= OPERATOR
SELECT first_name, last_name, salary
FROM teachers
WHERE salary >= 43500;

-- THE NEXT QUERY USES THE BETWEEN OPERATOR TO FIND TEACHERS WHO EARN BETWEEN $40,000 AND $65,000
SELECT first_name, last_name, school, salary
FROM teachers
WHERE salary BETWEEN 40000 AND 65000;

-- THE FIRST WHERE CLAUSE USES LIKE TO FIND NAMES THAT START WITH THE 
-- CHARACTERS sam, AND BECAUSE IT'S CASE SENSITIVE, IT WIILL RETURN ZERO RESULTS
SELECT first_name
FROM teachers
WHERE first_name LIKE 'sam%';

-- USING THE CASE-INSENSITIVE ILIKE, WILL RETURN SAMUEL AND SAMANTHA FROM
-- THE TABLE
SELECT first_name
FROM teachers
WHERE first_name ILIKE 'sam%';

-- THE FIRST QUERY USES AND IN THE WHERE CLAUSE TO FIND TEACHERS WHO WORK AT
-- THE MYERS MIDDLE SCHOOL AND HAVE A SALARY LESS THAN $40,000
SELECT * FROM teachers
WHERE school = 'Myers Middle School' AND 
      salary < 40000;

-- THE SECOND EXAMPLE USES OR TO SEARCH FOR ANY TEACHER WHOSE LAST NAME 
-- MATCHES Cole OR Bush
SELECT * FROM teachers
WHERE last_name = 'Cole' OR 
      last_name = 'Bush';

-- THE FINAL EXAMPLE LOOKS FOR TEACHERS AT ROSEVELT WHOSE SALARIES ARE EITHER 
-- LESS THAN $38,000 OR GREATER THAN $40,000
SELECT * FROM teachers
WHERE school = 'F.D. Roosevelt HS' AND 
      (salary < 38000 OR salary > 40000);

-- PUTTING IT ALL TOGETHER
SELECT first_name, last_name, school, hire_date, salary
FROM teachers
WHERE school LIKE '%Roos%'
ORDER BY hire_date DESC;

-- EXERCISES
-- QUESTION 1
-- The school district superintendent asks for a list of teachers in each school. 
-- Write a query that lists the schools in alphabetical order along with teachers ordered by last name A–Z.
SELECT school, last_name, first_name
FROM teachers
ORDER BY school ASC, last_name ASC;

-- QUESTION 2
-- Write a query that finds the one teacher whose first name starts with the letter S and who earns more than $40,000.
SELECT first_name, last_name, salary
FROM teachers
WHERE first_name LIKE 'S%' AND 
      salary > 40000;

-- QUESTION 3
-- Rank teachers hired since January 1, 2010, ordered by highest paid to lowest.
SELECT first_name, last_name, salary
FROM teachers
WHERE hire_date >= '2010-01-01'
ORDER BY salary DESC;