SELECT geo_name,
       state_us_abbreviation,
	     p0010001
FROM us_counties_2010
WHERE p0010001 >= (SELECT PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY p0010001)
		     FROM us_counties_2010)
ORDER BY p0010001;

-- IT MAKES A COPY OF THE CENSUS TABLE AND THEN DELETS EVERYTHING
-- FROM THAT BACKUP EXCEPT THE 315 COUNTIES IN THE TOP 10 PERCENT 
-- OF POPULATION
CREATE TABLE us_countries_2010_top10 AS
SELECT * FROM us_countries_2010;

DELETE FROM us_countries_2010_top10
WHERE p0010001 < (SELECT PERCENTILE_CONT(0.9)
                         WITHIN GROUP (ORDER BY p0010001)
                  FROM us_countries_2010_top10);

-- QUERY FOR CALCULATING THE AVERAGE AND MEDIAN POPULATION OF US COUNTRIES 
SELECT AVG(p0010001) AS average,
	PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY p0010001)::NUMERIC(10,1) AS median
FROM us_counties_2010;

-- CALCULATING THE DIFFERENCE BETWEEN THE AVERAGE AND MEDIAN POPULATION OF US CONTTRIES
SELECT ROUND(calculus.average, 0) AS average_population,
       ROUND(calculus.median, 0) AS median_population,
	ROUND(calculus.average - calculus.median, 0) AS average_median_difference 
FROM (SELECT AVG(p0010001) AS average,
	      PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY p0010001)::NUMERIC(10,1) AS median
      FROM us_counties_2010) AS calculus;

WITH plants AS(
	SELECT st, COUNT(*) AS plant_count
	FROM meat_poultry_egg_inspect
	GROUP BY st),
	
census AS(
	SELECT state_us_abbreviation,
		   SUM(p0010001) AS st_population
	FROM us_counties_2010
	GROUP BY state_us_abbreviation
	ORDER BY 1
)

SELECT ce.state_us_abbreviation,
       ce.st_population,
	   pl.plant_count,
	   ROUND((pl.plant_count / ce.st_population::NUMERIC(10,1))*1000000, 1) AS plants_per_million
FROM plants pl
INNER JOIN census ce ON pl.st = ce.state_us_abbreviation
ORDER BY 1

-- ADD A COLUMN WITH THE US MEDIAN POPULATION
SELECT geo_name,
       state_us_abbreviation AS st,
	   p0010001 AS total_pop,
	   (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY p0010001)
	    FROM us_counties_2010) AS us_median
FROM us_counties_2010;

SELECT geo_name,
       state_us_abbreviation AS st,
	   p0010001 AS total_pop,
	   (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY p0010001)
	    FROM us_counties_2010) AS us_median,
		p0010001 - (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY p0010001)
	                FROM us_counties_2010) AS difference_from_median
FROM us_counties_2010
WHERE (p0010001 - (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY p0010001)
	                FROM us_counties_2010)) BETWEEN -1000 AND 1000
ORDER BY st;

WITH large_countries (geo_name, st, population) 
AS (
	SELECT geo_name, state_us_abbreviation, p0010001
	FROM us_counties_2010)

SELECT st, COUNT(*)
FROM large_countries
GROUP BY st
ORDER BY COUNT(*) DESC;

-- YOU COULD FIND THE SAME RESULTS USING A SELECT QUERY INSTEAD OF A CTE,
-- AS SHOWN HERE
SELECT state_us_abbreviation, COUNT(*)
FROM us_counties_2010
WHERE p0010001 >= 100000
GROUP BY state_us_abbreviation
ORDER BY COUNT(*) DESC;

WITH large_countries (geo_name, st, population) 
AS (
	SELECT geo_name, state_us_abbreviation, p0010001
	FROM us_counties_2010)

SELECT st, COUNT(*)
FROM large_countries
GROUP BY st
ORDER BY COUNT(*) DESC;

-- YOU COULD FIND THE SAME RESULTS USING A SELECT QUERY INSTEAD OF A CTE,
-- AS SHOWN HERE
SELECT state_us_abbreviation, COUNT(*)
FROM us_counties_2010
WHERE p0010001 >= 100000
GROUP BY state_us_abbreviation
ORDER BY COUNT(*) DESC;

-- FINDING THE STATES THAT HAVE THE MOST MEAT, EGG, AND POULTRY
-- PROCESSING PLANTS PER MILLION POPULATION) INTO A MORE READABLE FORMAT
WITH counties (st, population) 
AS (
SELECT state_us_abbreviation, SUM(population_count_100_percent)
FROM us_counties_2010
GROUP BY state_us_abbreviation),

plants (st, plants) AS
(SELECT st, COUNT(*) AS plants
FROM meat_poultry_egg_inspect
GROUP BY st)

SELECT counties.st, population, plants,
       ROUND((plants / population::NUMERIC(10,1)) * 1000000, 1) AS per_million
FROM counties 
INNER JOIN plants ON counties.st = plants.st
ORDER BY per_million DESC;

-- AS ANOTHER EXAMPLE, YOU CAN USE A CTE TO SIMPLIFY QUERIES WITH
-- REDUNDANT CODE. FOR EXAMPLE, HERE WE USED A SUBQUERY WITH
-- THE PERCENTILE_CONT() FUNCTION IN THREE DIFFERENT LOCATIONS TO FIND MEDIAN
-- COUNTY POPULATION.
WITH us_median AS (
SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY p0010001) AS us_median_pop
FROM us_counties_2010)

SELECT geo_name, 
       state_us_abbreviation AS st,
       p0010001 AS total_pop,
       us_median_pop,
       p0010001 - us_median_pop AS diff_from_median
FROM us_counties_2010 CROSS JOIN us_median
WHERE (p0010001 - us_median_pop) BETWEEN -1000 AND 1000;

CREATE EXTENSION tablefunc;

CREATE TABLE ice_cream_survey (
             response_id INTEGER PRIMARY KEY,
             office VARCHAR(20),
             flavor VARCHAR(20)
);

COPY ice_cream_survey
FROM 'C:\Users\pscam\OneDrive\Documents\GitHub\Practical-SQL\data\ice_cream_survey.csv'
WITH (FORMAT CSV, HEADER);

SELECT *
FROM crosstab('SELECT station_name,
			 date_part(''month'', observation_date),
			 percentile_cont(0.5) WITHIN GROUP (ORDER BY max_temp)
		 FROM temperature_readings
		 GROUP BY station_name, date_part(''month'', observation_date)
		 ORDER BY station_name',
				
		'SELECT month
		 FROM generate_series(1,12) month')

AS (station varchar(50),
jan numeric(3,0),
feb numeric(3,0),
mar numeric(3,0),
apr numeric(3,0),
may numeric(3,0),
jun numeric(3,0),
jul numeric(3,0),
aug numeric(3,0),
sep numeric(3,0),
oct numeric(3,0),
nov numeric(3,0),
dec numeric(3,0)
);

SELECT max_temp,
CASE WHEN max_temp >= 90 THEN 'Hot'
     WHEN max_temp BETWEEN 70 AND 89 THEN 'Warm'
     WHEN max_temp BETWEEN 50 AND 69 THEN 'Pleasant'
     WHEN max_temp BETWEEN 33 AND 49 THEN 'Cold'
     WHEN max_temp BETWEEN 20 AND 32 THEN 'Freezing'
     ELSE 'Inhumane' END AS temperature_group
FROM temperature_readings;

WITH temps_collapsed (station_name, max_temperature_group) AS (
	SELECT station_name, 
		   CASE WHEN max_temp >= 90 THEN 'Hot'
	               WHEN max_temp BETWEEN 70 AND 89 THEN 'Warm'
	               WHEN max_temp BETWEEN 50 AND 69 THEN 'Pleasant'
	               WHEN max_temp BETWEEN 33 AND 49 THEN 'Cold'
	               WHEN max_temp BETWEEN 20 AND 32 THEN 'Freezing'
	       ELSE 'Inhumane' END 
	FROM temperature_readings
)

SELECT station_name, max_temperature_group, COUNT(*)
FROM temps_collapsed
GROUP BY station_name, max_temperature_group
ORDER BY station_name, COUNT(*) DESC;