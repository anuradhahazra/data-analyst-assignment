/* 03_Clinic_Schema_Setup.sql
   Clinic management schema + sample inserts
*/

DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS clinic_sales;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS specializations;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS clinics;

CREATE TABLE clinics (
    cid VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(200) NOT NULL,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE specializations (
    spec_id VARCHAR(50) PRIMARY KEY,
    spec_name VARCHAR(150) NOT NULL
);

CREATE TABLE doctors (
    did VARCHAR(50) PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    cid VARCHAR(50) NOT NULL,
    spec_id VARCHAR(50),
    FOREIGN KEY (cid) REFERENCES clinics(cid),
    FOREIGN KEY (spec_id) REFERENCES specializations(spec_id)
);

CREATE TABLE patients (
    uid VARCHAR(50) PRIMARY KEY,
    name VARCHAR(150),
    mobile VARCHAR(20)
);

CREATE TABLE clinic_sales (
    oid VARCHAR(50) PRIMARY KEY,
    uid VARCHAR(50) NOT NULL,
    cid VARCHAR(50) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    datetime DATETIME NOT NULL,
    sales_channel VARCHAR(100),
    FOREIGN KEY (uid) REFERENCES patients(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

CREATE TABLE expenses (
    eid VARCHAR(50) PRIMARY KEY,
    cid VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    amount DECIMAL(12,2) NOT NULL,
    datetime DATETIME NOT NULL,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

/* Sample data - clinics */
INSERT INTO clinics (cid, clinic_name, city, state, country) VALUES
('cnc-0100001','XYZ clinic','lorem','ipsum','dolor'),
('cnc-0100002','Alpha Clinic','Springfield','StateA','CountryX'),
('cnc-0100003','Beta Medical','Shelbyville','StateA','CountryX'),
('cnc-0100004','Gamma Health','Rivertown','StateB','CountryX'),
('cnc-0100005','Delta Care','Lakeside','StateB','CountryX');

/* Sample data - specializations */
INSERT INTO specializations (spec_id, spec_name) VALUES
('spec-001','General Physician'),
('spec-002','Dentistry'),
('spec-003','Pediatrics');

/* Sample data - doctors */
INSERT INTO doctors (did, name, cid, spec_id) VALUES
('doc-001','Dr. A','cnc-0100001','spec-001'),
('doc-002','Dr. B','cnc-0100002','spec-002'),
('doc-003','Dr. C','cnc-0100003','spec-001'),
('doc-004','Dr. D','cnc-0100004','spec-003'),
('doc-005','Dr. E','cnc-0100005','spec-001');

/* Sample data - patients */
INSERT INTO patients (uid, name, mobile) VALUES
('bk-09f3e-95hj','Jon Doe','97XXXXXXXX'),
('pat-002','Sara K','98XXXXXXXX'),
('pat-003','Tom H','99XXXXXXXX'),
('pat-004','Rita P','96XXXXXXXX'),
('pat-005','Samuel L','95XXXXXXXX');

/* Sample data - clinic_sales */
INSERT INTO clinic_sales (oid, uid, cid, amount, datetime, sales_channel) VALUES
('ord-00100-00100','bk-09f3e-95hj','cnc-0100001',24999,'2021-09-23 12:03:22','online'),
('ord-00100-00101','pat-002','cnc-0100002',5000,'2021-09-10 09:00:00','walk-in'),
('ord-00100-00102','pat-003','cnc-0100002',7500,'2021-09-15 11:15:00','online'),
('ord-00100-00103','pat-004','cnc-0100003',12000,'2021-09-20 14:30:00','referral'),
('ord-00100-00104','pat-005','cnc-0100004',3000,'2021-10-05 10:00:00','walk-in'),
('ord-00100-00105','bk-09f3e-95hj','cnc-0100001',15000,'2021-11-12 16:00:00','online'),
('ord-00100-00106','pat-002','cnc-0100005',2000,'2021-11-20 09:15:00','walk-in');

/* Sample data - expenses */
INSERT INTO expenses (eid, cid, description, amount, datetime) VALUES
('exp-0100-00100','cnc-0100001','first-aid supplies',557,'2021-09-23 07:36:48'),
('exp-0100-00101','cnc-0100002','equipment maintenance',1200,'2021-09-12 10:00:00'),
('exp-0100-00102','cnc-0100003','rent',5000,'2021-09-01 00:00:00'),
('exp-0100-00103','cnc-0100004','utilities',700,'2021-10-01 00:00:00'),
('exp-0100-00104','cnc-0100001','consumables',300,'2021-11-10 12:00:00');
