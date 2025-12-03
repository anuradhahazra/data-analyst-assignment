/* 02_Hotel_Queries.sql
   Solutions for Part A (Questions 1-5)
*/

/* 1) For every user in the system, get the user_id and last booked room_no
   (latest booking_date per user)
*/
-- Using window function (works in MySQL 8+, PostgreSQL, SQL Server)
SELECT user_id, room_no, booking_date
FROM (
    SELECT b.user_id, b.room_no, b.booking_date,
           ROW_NUMBER() OVER (PARTITION BY b.user_id ORDER BY b.booking_date DESC) AS rn
    FROM bookings b
) t
WHERE rn = 1;

/* Alternative portable approach using correlated subquery */
SELECT u.user_id, b.room_no
FROM users u
LEFT JOIN bookings b ON u.user_id = b.user_id
WHERE b.booking_date = (
    SELECT MAX(b2.booking_date) FROM bookings b2 WHERE b2.user_id = u.user_id
);

/* 2) Get booking_id and total billing amount of every booking created in November, 2021
   Assume "created in November" refers to bill_date in booking_commercials
*/
SELECT bc.booking_id,
       SUM(bc.item_quantity * i.item_rate) AS total_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-11-01' AND bc.bill_date < '2021-12-01'
GROUP BY bc.booking_id;

/* 3) Get bill_id and bill amount of all the bills raised in October, 2021 having bill amount > 1000 */
SELECT bc.bill_id,
       SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-10-01' AND bc.bill_date < '2021-11-01'
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;

/* 4) Determine the most ordered and least ordered item of each month of year 2021
   (by total quantity per item per month)
*/
-- Aggregate quantities per item per month
WITH monthly_item_qty AS (
    SELECT
        DATE_FORMAT(bc.bill_date, '%Y-%m') AS year_month,  -- MySQL style; replace with TO_CHAR in PG
        bc.item_id,
        SUM(bc.item_quantity) AS total_qty
    FROM booking_commercials bc
    WHERE bc.bill_date >= '2021-01-01' AND bc.bill_date < '2022-01-01'
    GROUP BY DATE_FORMAT(bc.bill_date, '%Y-%m'), bc.item_id
)
SELECT mi.year_month, i.item_name, mi.item_id, mi.total_qty, 'most' AS rank_type
FROM monthly_item_qty mi
JOIN items i ON mi.item_id = i.item_id
WHERE (mi.year_month, mi.total_qty) IN (
    SELECT year_month, MAX(total_qty) FROM monthly_item_qty GROUP BY year_month
)
UNION ALL
SELECT mi2.year_month, i2.item_name, mi2.item_id, mi2.total_qty, 'least' AS rank_type
FROM monthly_item_qty mi2
JOIN items i2 ON mi2.item_id = i2.item_id
WHERE (mi2.year_month, mi2.total_qty) IN (
    SELECT year_month, MIN(total_qty) FROM monthly_item_qty GROUP BY year_month
)
ORDER BY year_month;

/* Note: For databases that don't support tuple IN, use window functions for max/min: */
-- Using window functions (Postgres / MySQL8+)
WITH monthly_item_qty AS (
    SELECT
        DATE_TRUNC('month', bc.bill_date) AS month_start,
        bc.item_id,
        SUM(bc.item_quantity) AS total_qty
    FROM booking_commercials bc
    WHERE bc.bill_date >= '2021-01-01' AND bc.bill_date < '2022-01-01'
    GROUP BY DATE_TRUNC('month', bc.bill_date), bc.item_id
),
ranked AS (
    SELECT mi.*,
           RANK() OVER (PARTITION BY month_start ORDER BY total_qty DESC) AS rank_desc,
           RANK() OVER (PARTITION BY month_start ORDER BY total_qty ASC) AS rank_asc
    FROM monthly_item_qty mi
)
SELECT month_start, item_id, total_qty,
       CASE WHEN rank_desc = 1 THEN 'most' WHEN rank_asc = 1 THEN 'least' END AS which
FROM ranked
WHERE rank_desc = 1 OR rank_asc = 1
ORDER BY month_start;

/* 5) Find the customers with the second highest bill value of each month of year 2021
   (Assume bill value = sum of item_quantity * item_rate per bill_id)
*/
WITH bill_totals AS (
    SELECT
        bc.bill_id,
        b.user_id,
        DATE_FORMAT(bc.bill_date, '%Y-%m') AS year_month,
        SUM(bc.item_quantity * i.item_rate) AS bill_amount
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    JOIN bookings b ON bc.booking_id = b.booking_id
    WHERE bc.bill_date >= '2021-01-01' AND bc.bill_date < '2022-01-01'
    GROUP BY bc.bill_id, b.user_id, DATE_FORMAT(bc.bill_date, '%Y-%m')
),
ranked AS (
    SELECT bt.*,
           DENSE_RANK() OVER (PARTITION BY bt.year_month ORDER BY bt.bill_amount DESC) AS rnk
    FROM bill_totals bt
)
SELECT r.year_month, r.bill_id, r.user_id, r.bill_amount
FROM ranked r
WHERE r.rnk = 2
ORDER BY r.year_month;
