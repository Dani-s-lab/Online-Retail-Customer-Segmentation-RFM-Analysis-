-- 01 - DATA QUALITY CHECKS


-- 1) Table Creation
CREATE TABLE online_retail (
    invoice        TEXT,
    stock_code     TEXT,
    description    TEXT,
    quantity       INTEGER,
    invoice_date   TIMESTAMP,
    unit_price     NUMERIC(10,2),
    customer_id    TEXT,
    country        TEXT
);


-- 2) Row Count
SELECT COUNT(*) 
FROM online_retail;


-- 3) Null Values Check
SELECT 
    SUM(CASE WHEN invoice IS NULL THEN 1 END) AS invoice_null,
    SUM(CASE WHEN stock_code IS NULL THEN 1 END) AS stock_code_null,
    SUM(CASE WHEN description IS NULL THEN 1 END) AS description_null,
    SUM(CASE WHEN quantity IS NULL THEN 1 END) AS quantity_null,
    SUM(CASE WHEN invoice_date IS NULL THEN 1 END) AS invoice_date_null,
    SUM(CASE WHEN unit_price IS NULL THEN 1 END) AS unit_price_null,
    SUM(CASE WHEN customer_id IS NULL THEN 1 END) AS customer_id_null,
    SUM(CASE WHEN country IS NULL THEN 1 END) AS country_null
FROM online_retail;


-- 4) Negative Quantity (Returns)
SELECT COUNT(*)
FROM online_retail
WHERE quantity < 0;


-- 5) Zero or Negative Unit Price
SELECT *
FROM online_retail
WHERE unit_price <= 0;


-- 6) Negative Unit Price Count
SELECT COUNT(*)
FROM online_retail
WHERE unit_price < 0;


-- 7) Invalid Date Range
SELECT *
FROM online_retail
WHERE invoice_date < '2009-12-01'
   OR invoice_date >= '2011-12-10';