/* 01_Hotel_Schema_Setup.sql
Hotel management schema + sample inserts
 */
DROP TABLE IF EXISTS booking_commercials;

DROP TABLE IF EXISTS bookings;

DROP TABLE IF EXISTS items;

DROP TABLE IF EXISTS users;

CREATE TABLE
    users (
        user_id VARCHAR(50) PRIMARY KEY,
        name VARCHAR(150) NOT NULL,
        phone_number VARCHAR(20),
        mail_id VARCHAR(150),
        billing_address TEXT
    );

CREATE TABLE
    bookings (
        booking_id VARCHAR(50) PRIMARY KEY,
        booking_date DATETIME NOT NULL,
        room_no VARCHAR(50) NOT NULL,
        user_id VARCHAR(50) NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (user_id)
    );

CREATE TABLE
    items (
        item_id VARCHAR(50) PRIMARY KEY,
        item_name VARCHAR(200) NOT NULL,
        item_rate DECIMAL(10, 2) NOT NULL
    );

CREATE TABLE
    booking_commercials (
        id VARCHAR(100) PRIMARY KEY,
        booking_id VARCHAR(100) NOT NULL,
        bill_id VARCHAR(100) NOT NULL,
        bill_date DATETIME NOT NULL,
        item_id VARCHAR(100) NOT NULL,
        item_quantity DECIMAL(10, 2) NOT NULL
    );

/* Sample data - users */
INSERT INTO
    users (
        user_id,
        name,
        phone_number,
        mail_id,
        billing_address
    )
VALUES
    (
        '21wrcxuy-67erfn',
        'John Doe',
        '97XXXXXXXX',
        'john.doe@example.com',
        'XX, Street Y, ABC City'
    ),
    (
        'u-0002',
        'Alice Smith',
        '98XXXXXXXX',
        'alice.smith@example.com',
        '12, Road A, City B'
    ),
    (
        'u-0003',
        'Bob Lee',
        '99XXXXXXXX',
        'bob.lee@example.com',
        '45, Lane C, City D'
    ),
    (
        'u-0004',
        'Carol Chan',
        '96XXXXXXXX',
        'carol.chan@example.com',
        '78, Blvd E, City F'
    ),
    (
        'u-0005',
        'David Kumar',
        '95XXXXXXXX',
        'david.k@example.com',
        '101, Park Rd, City G'
    );

/* Sample data - bookings */
INSERT INTO
    bookings (booking_id, booking_date, room_no, user_id)
VALUES
    (
        'bk-09f3e-95hj',
        '2021-09-23 07:36:48',
        'rm-bhf9-aerjn',
        '21wrcxuy-67erfn'
    ),
    (
        'bk-nov-001',
        '2021-11-05 10:20:00',
        'rm-001',
        'u-0002'
    ),
    (
        'bk-nov-002',
        '2021-11-12 14:45:00',
        'rm-002',
        'u-0003'
    ),
    (
        'bk-oct-010',
        '2021-10-18 09:00:00',
        'rm-010',
        'u-0004'
    ),
    (
        'bk-nov-003',
        '2021-11-23 18:30:00',
        'rm-003',
        'u-0005'
    );

/* Sample data - items */
INSERT INTO
    items (item_id, item_name, item_rate)
VALUES
    ('itm-a9e8-q8fu', 'Tawa Paratha', 18.00),
    ('itm-a07vh-aer8', 'Mix Veg', 89.00),
    ('itm-w978-23u4', 'Tea', 12.50),
    ('itm-sand-001', 'Sandwich', 55.00),
    ('itm-juice-01', 'Orange Juice', 45.00);

/* Sample data - booking_commercials */
INSERT INTO
    booking_commercials (
        id,
        booking_id,
        bill_id,
        bill_date,
        item_id,
        item_quantity
    )
VALUES
    (
        'q34r-3q4o8-q34u',
        'bk-09f3e-95hj',
        'bl-0a87y-q340',
        '2021-09-23 12:03:22',
        'itm-a9e8-q8fu',
        3
    ),
    (
        'q3o4-ahf32-o2u4',
        'bk-09f3e-95hj',
        'bl-0a87y-q340',
        '2021-09-23 12:03:22',
        'itm-a07vh-aer8',
        1
    ),
    (
        '134lr-oyfo8-3qk4',
        'bk-09f3e-95hj',
        'bl-34qhd-r7h8',
        '2021-09-23 12:05:37',
        'itm-w978-23u4',
        0.5
    );