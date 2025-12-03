/* 04_Clinic_Queries.sql
Solutions for Part B (Questions 1-5)
 */
/* 1) Find the revenue we got from each sales channel in a given year (e.g., 2021) */
SELECT
    sales_channel,
    SUM(amount) AS revenue
FROM
    clinic_sales
WHERE
    datetime >= '2021-01-01'
    AND datetime < '2022-01-01'
GROUP BY
    sales_channel
ORDER BY
    revenue DESC;

/* 2) Find top 10 the most valuable customers for a given year (by total spend) */
SELECT
    cs.uid,
    p.name,
    SUM(cs.amount) AS total_spend
FROM
    clinic_sales cs
    JOIN patients p ON cs.uid = p.uid
WHERE
    cs.datetime >= '2021-01-01'
    AND cs.datetime < '2022-01-01'
GROUP BY
    cs.uid,
    p.name
ORDER BY
    total_spend DESC
LIMIT
    10;

/* 3) Find month wise revenue, expense, profit , status (profitable / not-profitable) for a given year */
-- Approach: aggregate sales by month, aggregate expenses by month, then full outer join (use unions for MySQL)
-- Using common table expressions (works in MySQL 8+, Postgres)
WITH
    rev AS (
        SELECT
            DATE_FORMAT (datetime, '%Y-%m') AS month,
            SUM(amount) AS revenue
        FROM
            clinic_sales
        WHERE
            datetime >= '2021-01-01'
            AND datetime < '2022-01-01'
        GROUP BY
            DATE_FORMAT (datetime, '%Y-%m')
    ),
    exp AS (
        SELECT
            DATE_FORMAT (datetime, '%Y-%m') AS month,
            SUM(amount) AS expense
        FROM
            expenses
        WHERE
            datetime >= '2021-01-01'
            AND datetime < '2022-01-01'
        GROUP BY
            DATE_FORMAT (datetime, '%Y-%m')
    )
    -- FULL OUTER JOIN Simulation
SELECT
    r.month AS month,
    r.revenue,
    COALESCE(e.expense, 0) AS expense,
    r.revenue - COALESCE(e.expense, 0) AS profit,
    CASE
        WHEN r.revenue - COALESCE(e.expense, 0) > 0 THEN 'profitable'
        ELSE 'not-profitable'
    END AS status
FROM
    rev r
    LEFT JOIN exp e ON r.month = e.month
UNION
SELECT
    e.month AS month,
    COALESCE(r.revenue, 0) AS revenue,
    e.expense,
    COALESCE(r.revenue, 0) - e.expense AS profit,
    CASE
        WHEN COALESCE(r.revenue, 0) - e.expense > 0 THEN 'profitable'
        ELSE 'not-profitable'
    END AS status
FROM
    exp e
    LEFT JOIN rev r ON r.month = e.month
ORDER BY
    month;

/* Note: MySQL does not support FULL OUTER JOIN directly; simulate using UNION of left and right joins. */
/* 4) For each city find the most profitable clinic for a given month
- For a given month (e.g., '2021-09'), compute profit per clinic = revenue - expenses and pick max per city
 */
WITH
    clinic_rev AS (
        SELECT
            cid,
            SUM(amount) AS revenue
        FROM
            clinic_sales
        WHERE
            DATE_FORMAT (datetime, '%Y-%m') = '2021-09'
        GROUP BY
            cid
    ),
    clinic_exp AS (
        SELECT
            cid,
            SUM(amount) AS expense
        FROM
            expenses
        WHERE
            DATE_FORMAT (datetime, '%Y-%m') = '2021-09'
        GROUP BY
            cid
    ),
    clinic_profit AS (
        SELECT
            c.cid,
            c.clinic_name,
            c.city,
            COALESCE(cr.revenue, 0) AS revenue,
            COALESCE(ce.expense, 0) AS expense,
            COALESCE(cr.revenue, 0) - COALESCE(ce.expense, 0) AS profit
        FROM
            clinics c
            LEFT JOIN clinic_rev cr ON c.cid = cr.cid
            LEFT JOIN clinic_exp ce ON c.cid = ce.cid
    )
SELECT
    cp.city,
    cp.cid,
    cp.clinic_name,
    cp.profit
FROM
    (
        SELECT
            city,
            cid,
            clinic_name,
            profit,
            RANK() OVER (
                PARTITION BY
                    city
                ORDER BY
                    profit DESC
            ) AS rnk
        FROM
            clinic_profit
    ) cp
WHERE
    cp.rnk = 1
ORDER BY
    cp.city;

/* 5) For each state find the second least profitable clinic for a given month
- Compute profit per clinic for the month and then pick the second smallest (by profit) per state
 */
WITH
    clinic_profit AS (
        SELECT
            c.cid,
            c.clinic_name,
            c.state,
            COALESCE(
                (
                    SELECT
                        SUM(amount)
                    FROM
                        clinic_sales cs
                    WHERE
                        cs.cid = c.cid
                        AND DATE_FORMAT (cs.datetime, '%Y-%m') = '2021-09'
                ),
                0
            ) AS revenue,
            COALESCE(
                (
                    SELECT
                        SUM(amount)
                    FROM
                        expenses ex
                    WHERE
                        ex.cid = c.cid
                        AND DATE_FORMAT (ex.datetime, '%Y-%m') = '2021-09'
                ),
                0
            ) AS expense
        FROM
            clinics c
    ),
    profit_calc AS (
        SELECT
            cid,
            clinic_name,
            state,
            (revenue - expense) AS profit
        FROM
            clinic_profit
    )
SELECT
    state,
    cid,
    clinic_name,
    profit
FROM
    (
        SELECT
            p.*,
            ROW_NUMBER() OVER (
                PARTITION BY
                    state
                ORDER BY
                    profit ASC
            ) AS rn
        FROM
            profit_calc p
    ) t
WHERE
    rn = 2
ORDER BY
    state;