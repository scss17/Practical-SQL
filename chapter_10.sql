-- CREATE A TABLE
CREATE TABLE acs_2011_2015_stats(
	geoid VARCHAR(14),
	county VARCHAR(50) NOT NULL,
	st VARCHAR(20) NOT NULL,
	pct_travel_60_min NUMERIC(5, 3) NOT NULL,
	pct_bachelors_higher NUMERIC(5, 3) NOT NULL,
	pct_masters_higher NUMERIC(5,3) NOT NULL,
	median_hh_income INTEGER,
	CHECK (pct_masters_higher <= pct_bachelors_higher),

CONSTRAINT pk_geoid PRIMARY KEY (geoid)
);

-- COPY DATA FROM CSV FILE
COPY acs_2011_2015_stats
FROM 'C:\Users\pscam\Desktop\acs_2011_2015_stats.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

SELECT corr(median_hh_income, pct_bachelors_higher)
FROM acs_2011_2015_stats

SELECT 
	ROUND(CORR(median_hh_income, pct_bachelors_higher)::NUMERIC, 2
		 ) AS bachelor_income_r,
	ROUND(CORR(pct_travel_60_min, median_hh_income)::NUMERIC, 2
		 ) AS income_travel_r,
	ROUND(CORR(pct_travel_60_min, pct_bachelors_higher)::NUMERIC, 2
		 ) AS bachelors_travel
FROM acs_2011_2015_stats

SELECT 
	ROUND(REGR_R2(median_hh_income, pct_bachelors_higher)::NUMERIC, 3
		 ) AS r_squared
FROM acs_2011_2015_stats;

--CREATE TABLE
CREATE TABLE store_sales (
	store VARCHAR(30),
	category VARCHAR(30) NOT NULL,
	unit_sales BIGINT NOT NULL,

CONSTRAINT store_category_key PRIMARY KEY (store, category)
);

-- INSERTVALUES
INSERT INTO store_sales (store, category, unit_sales)
VALUES
('Broders', 'Cereal', 1104),
('Wallace', 'Ice Cream', 1863),
('Broders', 'Ice Cream', 2517),
('Cramers', 'Ice Cream', 2112),
('Broders', 'Beer', 641),
('Cramers', 'Cereal', 1003),
('Cramers', 'Beer', 640),
('Wallace', 'Cereal', 980);

SELECT category,
       store, 
	     unit_sales,
	     rank() OVER (PARTITION BY category ORDER BY unit_sales DESC)
FROM store_sales;

-- CREATE TABLE
CREATE TABLE fbi_crime_data_2015 (
	st varchar(20),
	city varchar(50),
	population integer,
	violent_crime integer,
	property_crime integer,
	burglary integer,
	larceny_theft integer,
	motor_vehicle_theft integer,
CONSTRAINT st_city_key PRIMARY KEY (st, city)
);

-- INSERT VALUES FROM CSV FILE
COPY fbi_crime_data_2015
FROM 'C:\Users\pscam\Desktop\fbi_crime_data_2015.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

SELECT *
FROM fbi_crime_data_2015
ORDER BY population DESC;

SELECT city,
       population,
       property_crime,
       ROUND((property_crime::NUMERIC / population) * 1000, 1) AS pc_per1000
FROM fbi_crime_data_2015
WHERE population >= 500000
ORDER BY (property_crime::NUMERIC / population) DESC;