-- 04 - RFM Analysis


-- 1) Filter Transactions
WITH base_rfm AS (
    SELECT
        customer_id,
        invoice,
        invoice_date,
        quantity,
        unit_price
    FROM online_retail
    WHERE
        customer_id IS NOT NULL
        AND (invoice IS NULL OR invoice NOT LIKE 'C%')
        AND invoice_date >= DATE '2010-12-01'
        AND invoice_date <  DATE '2011-12-10'
)

-- 2) Compute RFM Metrics
, customer_rfm AS (
    SELECT
        customer_id,
        DATE '2011-12-10' - MAX(invoice_date) AS recency_days,
        COUNT(DISTINCT invoice) AS frequency_orders,
        SUM(quantity * unit_price) AS monetary_value
    FROM base_rfm
    GROUP BY customer_id
)

-- 3) Assign RFM Scores
, rfm_scores AS (
    SELECT
        customer_id,
        recency_days,
        frequency_orders,
        monetary_value,
        NTILE(5) OVER (ORDER BY recency_days ASC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency_orders DESC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary_value DESC) AS m_score
    FROM customer_rfm
)

-- 4) Build Final RFM Table
, rfm_final AS (
    SELECT
        customer_id,
        recency_days,
        frequency_orders,
        monetary_value,
        r_score,
        f_score,
        m_score,
        (r_score::text || f_score::text || m_score::text) AS rfm_score
    FROM rfm_scores
)

-- 5) Assign Segment
, rfm_with_segment AS (
    SELECT
        *,
        CASE
            WHEN r_score = 5 AND f_score = 5 AND m_score = 5 THEN 'Champions'
            WHEN r_score >= 4 AND f_score >= 4 THEN 'Loyal'
            WHEN r_score >= 4 AND f_score <= 2 THEN 'Potential Loyalists'
            WHEN r_score = 3 AND f_score >= 3 THEN 'Active'
            WHEN r_score = 2 AND f_score >= 3 THEN 'At Risk'
            WHEN r_score = 1 AND f_score >= 2 THEN 'Hibernating'
            ELSE 'Lost'
        END AS segment
    FROM rfm_final
)

-- 6) Segment Distribution
SELECT
    segment,
    COUNT(*) AS customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM rfm_with_segment
GROUP BY segment
ORDER BY CASE segment
    WHEN 'Champions' THEN 1
    WHEN 'Loyal' THEN 2
    WHEN 'Potential Loyalists' THEN 3
    WHEN 'Active' THEN 4
    WHEN 'At Risk' THEN 5
    WHEN 'Hibernating' THEN 6
    WHEN 'Lost' THEN 7
END;