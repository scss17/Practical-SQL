CREATE TABLE pls_fy2014_pupld14a (
    stabr varchar(2) NOT NULL,
    fscskey varchar(6) CONSTRAINT fscskey2014_key PRIMARY KEY,
    libid varchar(20) NOT NULL,
    libname varchar(100) NOT NULL,
    obereg varchar(2) NOT NULL,
    rstatus integer NOT NULL,
    statstru varchar(2) NOT NULL,
    statname varchar(2) NOT NULL,
    stataddr varchar(2) NOT NULL,
    longitud numeric(10,7) NOT NULL,
    latitude numeric(10,7) NOT NULL,
    fipsst varchar(2) NOT NULL,
    fipsco varchar(3) NOT NULL,
    address varchar(35) NOT NULL,
    city varchar(20) NOT NULL,
    zip varchar(5) NOT NULL,
    zip4 varchar(4) NOT NULL,
    cnty varchar(20) NOT NULL,
    phone varchar(10) NOT NULL,
    c_relatn varchar(2) NOT NULL,
    c_legbas varchar(2) NOT NULL,
    c_admin varchar(2) NOT NULL,
    geocode varchar(3) NOT NULL,
    lsabound varchar(1) NOT NULL,
    startdat varchar(10),
    enddate varchar(10),
    popu_lsa integer NOT NULL,
    centlib integer NOT NULL,
    branlib integer NOT NULL,
    bkmob integer NOT NULL,
    master numeric(8,2) NOT NULL,
    libraria numeric(8,2) NOT NULL,
    totstaff numeric(8,2) NOT NULL,
    locgvt integer NOT NULL,
    stgvt integer NOT NULL,
    fedgvt integer NOT NULL,
    totincm integer NOT NULL,
    salaries integer,
    benefit integer,
    staffexp integer,
    prmatexp integer NOT NULL,
    elmatexp integer NOT NULL,
    totexpco integer NOT NULL,
    totopexp integer NOT NULL,
    lcap_rev integer NOT NULL,
    scap_rev integer NOT NULL,
    fcap_rev integer NOT NULL,
    cap_rev integer NOT NULL,
    capital integer NOT NULL,
    bkvol integer NOT NULL,
    ebook integer NOT NULL,
    audio_ph integer NOT NULL,
    audio_dl float NOT NULL,
    video_ph integer NOT NULL,
    video_dl float NOT NULL,
    databases integer NOT NULL,
    subscrip integer NOT NULL,
    hrs_open integer NOT NULL,
    visits integer NOT NULL,
    referenc integer NOT NULL,
    regbor integer NOT NULL,
    totcir integer NOT NULL,
    kidcircl integer NOT NULL,
    elmatcir integer NOT NULL,
    loanto integer NOT NULL,
    loanfm integer NOT NULL,
    totpro integer NOT NULL,
    totatten integer NOT NULL,
    gpterms integer NOT NULL,
    pitusr integer NOT NULL,
    wifisess integer NOT NULL,
    yr_sub integer NOT NULL
);

CREATE INDEX libname2014_idx ON pls_fy2014_pupld14a (libname);
CREATE INDEX stabr2014_idx ON pls_fy2014_pupld14a (stabr);
CREATE INDEX city2014_idx ON pls_fy2014_pupld14a (city);
CREATE INDEX visits2014_idx ON pls_fy2014_pupld14a (visits);

COPY pls_fy2014_pupld14a
FROM 'C:\YourDirectory\pls_fy2014_pupld14a.csv'
WITH (FORMAT CSV, HEADER);

CREATE TABLE pls_fy2009_pupld09a (
    stabr varchar(2) NOT NULL,
    fscskey varchar(6) CONSTRAINT fscskey2009_key PRIMARY KEY,
    libid varchar(20) NOT NULL,
    libname varchar(100) NOT NULL,
    address varchar(35) NOT NULL,
    city varchar(20) NOT NULL,
    zip varchar(5) NOT NULL,
    zip4 varchar(4) NOT NULL,
    cnty varchar(20) NOT NULL,
    phone varchar(10) NOT NULL,
    c_relatn varchar(2) NOT NULL,
    c_legbas varchar(2) NOT NULL,
    c_admin varchar(2) NOT NULL,
    geocode varchar(3) NOT NULL,
    lsabound varchar(1) NOT NULL,
    startdat varchar(10),
    enddate varchar(10),
    popu_lsa integer NOT NULL,
    centlib integer NOT NULL,
    branlib integer NOT NULL,
    bkmob integer NOT NULL,
    master numeric(8,2) NOT NULL,
    libraria numeric(8,2) NOT NULL,
    totstaff numeric(8,2) NOT NULL,
    locgvt integer NOT NULL,
    stgvt integer NOT NULL,
    fedgvt integer NOT NULL,
    totincm integer NOT NULL,
    salaries integer,
    benefit integer,
    staffexp integer,
    prmatexp integer NOT NULL,
    elmatexp integer NOT NULL,
    totexpco integer NOT NULL,
    totopexp integer NOT NULL,
    lcap_rev integer NOT NULL,
    scap_rev integer NOT NULL,
    fcap_rev integer NOT NULL,
    cap_rev integer NOT NULL,
    capital integer NOT NULL,
    bkvol integer NOT NULL,
    ebook integer NOT NULL,
    audio integer NOT NULL,
    video integer NOT NULL,
    databases integer NOT NULL,
    subscrip integer NOT NULL,
    hrs_open integer NOT NULL,
    visits integer NOT NULL,
    referenc integer NOT NULL,
    regbor integer NOT NULL,
    totcir integer NOT NULL,
    kidcircl integer NOT NULL,
    loanto integer NOT NULL,
    loanfm integer NOT NULL,
    totpro integer NOT NULL,
    totatten integer NOT NULL,
    gpterms integer NOT NULL,
    pitusr integer NOT NULL,
    yr_sub integer NOT NULL,
    obereg varchar(2) NOT NULL,
    rstatus integer NOT NULL,
    statstru varchar(2) NOT NULL,
    statname varchar(2) NOT NULL,
    stataddr varchar(2) NOT NULL,
    longitud numeric(10,7) NOT NULL,
    latitude numeric(10,7) NOT NULL,
    fipsst varchar(2) NOT NULL,
    fipsco varchar(3) NOT NULL
);

CREATE INDEX libname2009_idx ON pls_fy2009_pupld09a (libname);
CREATE INDEX stabr2009_idx ON pls_fy2009_pupld09a (stabr);
CREATE INDEX city2009_idx ON pls_fy2009_pupld09a (city);
CREATE INDEX visits2009_idx ON pls_fy2009_pupld09a (visits);

COPY pls_fy2009_pupld09a
FROM 'C:\YourDirectory\pls_fy2009_pupld09a.csv'
WITH (FORMAT CSV, HEADER);

SELECT count(*) AS pls_2014
FROM pls_fy2014_pupld14a;

SELECT count(*) AS pls_2009
FROM pls_fy2009_pupld09a;

SELECT count(salaries)
FROM pls_fy2014_pupld14a;

-- THE FIRST QUERY RETURNS A ROW COUNT THAT MATCHES THE NUMBER OF ROWS IN THE TABLE THAT WE FOUND
SELECT count(libname)
FROM pls_fy2014_pupld14a;

-- WE EXPECT TO HAVE THE LIBRARY AGENCY NAME LISTED IN EVERY ROW. 
-- BUT THE SECOND QUERY RETURNS A SMALLER NUMBER
SELECT count(DISTINCT libname)
FROM pls_fy2014_pupld14a;

-- USES MAX() AND MIN() ON THE 2014 TABLE WITH THE VISITS COLUMN AS INPUT.
SELECT max(visits), min(visits)
FROM pls_fy2014_pupld14a;

SELECT city, stabr
FROM pls_fy2014_pupld14a
GROUP BY city, stabr
ORDER BY city, stabr;

-- WE CAN GET A COUNT OF AGENCIES BY STATE AND SORT THEM TO SEE WHICH 
-- STATES HAVE THE MOST
SELECT stabr, COUNT(*)
FROM pls_fy2014_pupld14a
GROUP BY stabr
ORDER BY COUNT(*) DESC;

SELECT sum(visits) AS visits_2014
FROM pls_fy2014_pupld14a
WHERE visits >= 0;

SELECT sum(visits) AS visits_2009
FROM pls_fy2009_pupld09a
WHERE visits >= 0;

-- AT THE TOP, WE USE THE SUM() AGGREGATE
-- FUNCTION TO TOTAL THE VISITS COLUMNS FROM THE 2014 AND 2009 TABLES.
SELECT sum(pls14.visits) AS visits_2014, 
       sum(pls09.visits) AS visits_2009

-- NOTE THAT WE USE A STANDARD JOIN, ALSO KNOWN AS AN INNER JOIN. THAT
-- MEANS THE QUERY RESULTS WILL ONLY INCLUDE ROWS WHERE THE PRIMARY KEY
-- VALUES OF BOTH TABLES (THE COLUMN FSCSKEY) MATCH.
FROM pls_fy2014_pupld14a AS pls14 INNER 
JOIN pls_fy2009_pupld09a AS pls09 ON pls14.fscskey = pls09.fscskey

-- USING THE WHERE CLAUSE, WE RETURN ROWS WHERE BOTH TABLES HAVE A
-- VALUE OF ZERO OR GREATER IN THE VISITS COLUMN.
WHERE pls14.visits >= 0 AND pls09.visits >= 0;

-- WE FOLLOW THE SELECT KEYWORD WITH THE STABR COLUMN FROM THE 2014
-- TABLE; THAT SAME COLUMN APPEARS IN THE GROUP BY CLAUSE. IT DOESN’T MATTER
-- WHICH TABLE’S stabr COLUMN WE USE BECAUSE WE’RE ONLY QUERYING AGENCIES
-- THAT APPEAR IN BOTH TABLES.
SELECT pls14.stabr,
       sum(pls14.visits) AS visits_2014,
       sum(pls09.visits) AS visits_2009,
       round( (CAST(sum(pls14.visits) AS decimal(10,1)) - sum(pls09.visits)) / sum(pls09.visits) * 100, 2 ) AS pct_change
FROM pls_fy2014_pupld14a AS pls14 
INNER JOIN pls_fy2009_pupld09a AS pls09 ON pls14.fscskey = pls09.fscskey
WHERE pls14.visits >= 0 AND pls09.visits >= 0
GROUP BY pls14.stabr
ORDER BY pct_change DESC;

-- WE’VE SET OUR QUERY RESULTS TO INCLUDE ONLY ROWS WITH A
-- SUM OF VISITS IN 2014 GREATER THAN 50 MILLION. THAT’S AN ARBITRARY VALUE I
-- CHOSE TO SHOW ONLY THE VERY LARGEST STATES. ADDING THE HAVING CLAUSE
-- REDUCES THE NUMBER OF ROWS IN THE OUTPUT TO JUST SIX.
SELECT pls14.stabr,
	   sum(pls14.visits) AS visits_2014,
       sum(pls09.visits) AS visits_2009,
       round( (CAST(sum(pls14.visits) AS decimal(10,1)) - sum(pls09.visits)) / sum(pls09.visits) * 100, 2 ) AS pct_change
FROM pls_fy2014_pupld14a AS pls14 

INNER JOIN pls_fy2009_pupld09a AS pls09 ON pls14.fscskey = pls09.fscskey
WHERE pls14.visits >= 0 AND pls09.visits >= 0
GROUP BY pls14.stabr
HAVING sum(pls14.visits) > 50000000
ORDER BY pct_change DESC;