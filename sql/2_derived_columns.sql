-- 02 - DERIVED COLUMNS


-- 1) Total Price
SELECT 
    *,
    quantity * unit_price AS total_price
FROM online_retail
LIMIT 20;


-- 2) Year-Month
SELECT
    invoice_date,
    TO_CHAR(invoice_date, 'YYYY-MM') AS year_month
FROM online_retail
LIMIT 20;


-- 3) Is Return
SELECT
    quantity,
    CASE 
        WHEN quantity < 0 THEN TRUE
        ELSE FALSE
    END AS is_return
FROM online_retail
LIMIT 20;


-- 4) Is Bad Debt
SELECT
    invoice,
    CASE
        WHEN invoice LIKE 'C%' THEN TRUE
        ELSE FALSE
    END AS is_bad_debt
FROM online_retail
LIMIT 20;