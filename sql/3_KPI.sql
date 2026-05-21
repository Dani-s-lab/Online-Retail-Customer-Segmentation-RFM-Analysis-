-- 03 - KPI 


-- 1) Monthly Revenue
SELECT
    TO_CHAR(invoice_date, 'YYYY-MM') AS year_month,
    SUM(quantity * unit_price) AS monthly_revenue
FROM online_retail
WHERE
    (invoice_date >= '2010-12-01'
     AND invoice_date < '2011-12-10')
    AND (invoice IS NULL OR invoice NOT LIKE 'C%')
GROUP BY
    TO_CHAR(invoice_date, 'YYYY-MM')
ORDER BY
    year_month;

-- 2) Top Products Revenue
SELECT
    description,
    SUM(quantity * unit_price) AS total_revenue
FROM online_retail
WHERE quantity > 0
  AND unit_price > 0
  AND (invoice IS NULL OR invoice NOT LIKE 'C%')
GROUP BY description
ORDER BY total_revenue DESC
LIMIT 10;

-- 3) Country Revenue
SELECT
    country,
    SUM(quantity * unit_price) AS total_revenue
FROM online_retail
WHERE quantity > 0
  AND unit_price > 0
  AND (invoice IS NULL OR invoice NOT LIKE 'C%')
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 10;

-- 4) Top Customers Revenue
SELECT
    customer_id,
    SUM(quantity * unit_price) AS total_revenue
FROM online_retail
WHERE quantity > 0
  AND unit_price > 0
  AND customer_id IS NOT NULL
  AND (invoice IS NULL OR invoice NOT LIKE 'C%')
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;

-- 5) Monthly Orders
SELECT
    TO_CHAR(invoice_date, 'YYYY-MM') AS year_month,
    COUNT(DISTINCT invoice) AS total_orders
FROM online_retail
WHERE
    invoice_date >= '2010-12-01'
    AND invoice_date < '2011-12-10'
    AND (invoice IS NULL OR invoice NOT LIKE 'C%')
GROUP BY
    TO_CHAR(invoice_date, 'YYYY-MM')
ORDER BY
    year_month;


	


	

	

	