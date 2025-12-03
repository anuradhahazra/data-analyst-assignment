/* 02_Hotel_Queries.sql
Solutions for Part A (Questions 1-5)
 */
/* 1) For every user in the system, get the user_id and last booked room_no
(latest booking_date per user)
 */
-- Using window function (works in MySQL 8+, PostgreSQL, SQL Server)
SELECT
    user_id,
    room_no,
    booking_date
FROM
    (
        SELECT
            b.user_id,
            b.room_no,
            b.booking_date,
            ROW_NUMBER() OVER (
                PARTITION BY
                    b.user_id
                ORDER BY
                    b.booking_date DESC
            ) AS rn
        FROM
            bookings b
    ) t
WHERE
    rn = 1;

/* Alternative portable approach using correlated subquery */
SELECT
    u.user_id,
    b.room_no
FROM
    users u
    LEFT JOIN bookings b ON u.user_id = b.user_id
WHERE
    b.booking_date = (
        SELECT
            MAX(b2.booking_date)
        FROM
            bookings b2
        WHERE
            b2.user_id = u.user_id
    );

/* 2) Get booking_id and total billing amount of every booking created in November, 2021
Assume "created in November" refers to bill_date in booking_commercials
 */
SELECT
    bc.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_amount
FROM
    booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
WHERE
    bc.bill_date >= '2021-11-01'
    AND bc.bill_date < '2021-12-01'
GROUP BY
    bc.booking_id;

/* 3) Get bill_id and bill amount of all the bills raised in October, 2021 having bill amount > 1000 */
SELECT
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM
    booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
WHERE
    bc.bill_date >= '2021-10-01'
    AND bc.bill_date < '2021-11-01'
GROUP BY
    bc.bill_id
HAVING
    SUM(bc.item_quantity * i.item_rate) > 1000;

/* 4) Determine the most ordered and least ordered item of each month of year 2021
(by total quantity per item per month)
 */
-- Aggregate quantities per item per month
WITH
    monthly_item_qty AS (
        SELECT
            DATE_FORMAT (bc.bill_date, '%Y-%m') AS year,
            bc.item_id,
            SUM(bc.item_quantity) AS total_qty
        FROM
            booking_commercials bc
        WHERE
            bc.bill_date >= '2021-01-01'
            AND bc.bill_date < '2022-01-01'
        GROUP BY
            DATE_FORMAT (bc.bill_date, '%Y-%m'),
            bc.item_id
    ),
    max_monthly AS (
        SELECT
            year,
            MAX(total_qty) AS max_qty
        FROM
            monthly_item_qty
        GROUP BY
            year
    ),
    min_monthly AS (
        SELECT
            year,
            MIN(total_qty) AS min_qty
        FROM
            monthly_item_qty
        GROUP BY
            year
    )
SELECT
    mi.year,
    i.item_name,
    mi.item_id,
    mi.total_qty,
    'most' AS rank_type
FROM
    monthly_item_qty mi
    JOIN items i ON mi.item_id = i.item_id
    JOIN max_monthly mx ON mi.year = mx.year
    AND mi.total_qty = mx.max_qty
UNION ALL
SELECT
    mi.year,
    i.item_name,
    mi.item_id,
    mi.total_qty,
    'least' AS rank_type
FROM
    monthly_item_qty mi
    JOIN items i ON mi.item_id = i.item_id
    JOIN min_monthly mn ON mi.year = mn.year
    AND mi.total_qty = mn.min_qty
ORDER BY
    year;

/* 5) Find the customers with the second highest bill value of each month of year 2021
(Assume bill value = sum of item_quantity * item_rate per bill_id)
 */
WITH
    bill_totals AS (
        SELECT
            bc.bill_id,
            b.user_id,
            DATE_FORMAT (bc.bill_date, '%Y-%m') AS year,
            SUM(bc.item_quantity * i.item_rate) AS bill_amount
        FROM
            booking_commercials bc
            JOIN items i ON bc.item_id = i.item_id
            JOIN bookings b ON bc.booking_id = b.booking_id
        WHERE
            bc.bill_date >= '2021-01-01'
            AND bc.bill_date < '2022-01-01'
        GROUP BY
            bc.bill_id,
            b.user_id,
            DATE_FORMAT (bc.bill_date, '%Y-%m')
    ),
    ranked AS (
        SELECT
            bt.*,
            DENSE_RANK() OVER (
                PARTITION BY
                    bt.year
                ORDER BY
                    bt.bill_amount DESC
            ) AS rnk
        FROM
            bill_totals bt
    )
SELECT
    r.year,
    r.bill_id,
    r.user_id,
    r.bill_amount
FROM
    ranked r
WHERE
    r.rnk = 2
ORDER BY
    r.year;