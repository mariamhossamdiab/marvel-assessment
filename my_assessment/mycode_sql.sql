create database marvel;
use marvel;

CREATE TABLE u1sales_raw (
    client_id       NVARCHAR(200),
    client          NVARCHAR(200),
    center          NVARCHAR(200),
    sale_date       DATE,
    product_name    NVARCHAR(200),
    units           INT,
    price           DECIMAL(10,2),
    region_id       INT,
    region          NVARCHAR(200),
    product_id      NVARCHAR(50),
    product         NVARCHAR(200),
    line            NVARCHAR(200),
    line_id         NVARCHAR(50),
    value           DECIMAL(12,2),
    month_name      NVARCHAR(50),
	month_id        SMALLINT,
    day_number      SMALLINT
);
LOAD DATA INFILE 'E:/Users/ALNOUR-320/Downloads/task/cleaned_sales.csv'
INTO TABLE u1sales_raw
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(client_id, client, center, @sale_date, product_name, units, price, region_id, region, product_id, product, line, line_id, value, month_name, month_id, day_number)
SET sale_date = STR_TO_DATE(@sale_date, '%d/%m/%Y');

 select * from  u1sales_raw
 
ALTER TABLE u1sales_raw
ADD COLUMN unified_id INT,
ADD COLUMN rep_id INT;
####
#drop TABLE unified_present
 CREATE TABLE unified_present (
    unified_id INT NOT NULL,
    month_id INT NOT NULL,
    day_id INT NOT NULL,
    region_id INT NOT NULL,
    product_id NVARCHAR(50) NOT NULL,
    PRIMARY KEY (month_id, day_id, region_id, product_id)
);
INSERT INTO unified_present (unified_id, month_id, day_id, region_id, product_id)
VALUES
(1, 10, 25, 2, 'G10'),
(2, 1, 2, 2, 'G4'),
(3, 1, 3, 5, 'R1');
######
SET SQL_SAFE_UPDATES = 0;

UPDATE u1sales_raw AS s
JOIN unified_present AS u
  ON s.month_id = u.month_id
 AND s.day_number = u.day_id
 AND s.region_id = u.region_id
 AND s.product_id = u.product_id
SET s.unified_id = u.unified_id;
##

 CREATE TABLE rep_present (
    rep_id INT NOT NULL,
    month_id INT NOT NULL,
    day_id INT NOT NULL,
    region_id INT NOT NULL,
    product_id NVARCHAR(50) NOT NULL,
    PRIMARY KEY (month_id, day_id, region_id, product_id)
);
SET SQL_SAFE_UPDATES = 0;
UPDATE u1sales_raw AS s
JOIN rep_present AS u
  ON s.month_id = u.month_id
 AND s.day_number = u.day_id
 AND s.region_id = u.region_id
 AND s.product_id = u.product_id
SET s.rep_id = u.rep_id;
SET SQL_SAFE_UPDATES = 1;
###
CREATE TABLE u1sales_analysis AS
SELECT 
    region_id,
    region,
    product_id,
    product,
    line_id,
    line,
    month_id,
    
    -- Overall metrics
    SUM(value) AS total_sales,
    SUM(units) AS total_units,
    COUNT(*) AS transaction_count,
    AVG(price) AS avg_price,
    COUNT(DISTINCT client_id) AS unique_clients,
    
    -- Bonus transactions (units = 0)
    SUM(CASE WHEN units = 0 THEN 1 ELSE 0 END) AS bonus_count,
    
    -- Successful selling (units > 0)
    SUM(CASE WHEN units > 0 THEN value ELSE 0 END) AS successful_sales,
    SUM(CASE WHEN units > 0 THEN units ELSE 0 END) AS successful_units,
    SUM(CASE WHEN units > 0 THEN 1 ELSE 0 END) AS successful_count,
    
    -- Returns (units < 0)
    SUM(CASE WHEN units < 0 THEN value ELSE 0 END) AS return_sales,
    SUM(CASE WHEN units < 0 THEN units ELSE 0 END) AS return_units,
    SUM(CASE WHEN units < 0 THEN 1 ELSE 0 END) AS return_count
    
FROM u1sales_raw
GROUP BY 
    region_id,  
    product_id, 
    line_id, 
    month_id;
select * from u1sales_analysis; 
# Refresh the Materialized View
TRUNCATE TABLE u1sales_analysis;
INSERT INTO u1sales_analysis
SELECT region_id,
    region,
    product_id,
    product,
    line_id,
    line,
    month_id,
    
    -- Overall metrics
    SUM(value) AS total_sales,
    SUM(units) AS total_units,
    COUNT(*) AS transaction_count,
    AVG(price) AS avg_price,
    COUNT(DISTINCT client_id) AS unique_clients,
    
    -- Bonus transactions (units = 0)
    SUM(CASE WHEN units = 0 THEN 1 ELSE 0 END) AS bonus_count,
    
    -- Successful selling (units > 0)
    SUM(CASE WHEN units > 0 THEN value ELSE 0 END) AS successful_sales,
    SUM(CASE WHEN units > 0 THEN units ELSE 0 END) AS successful_units,
    SUM(CASE WHEN units > 0 THEN 1 ELSE 0 END) AS successful_count,
    
    -- Returns (units < 0)
    SUM(CASE WHEN units < 0 THEN value ELSE 0 END) AS return_sales,
    SUM(CASE WHEN units < 0 THEN units ELSE 0 END) AS return_units,
    SUM(CASE WHEN units < 0 THEN 1 ELSE 0 END) AS return_count
    
FROM u1sales_raw
GROUP BY 
    region_id,  
    product_id, 
    line_id, 
    month_id;   