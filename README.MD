# Data_Analyst_Assignment

This repository contains solutions for a data analyst assignment covering SQL, Spreadsheets, and Python.

## Structure
Data_Analyst_Assignment/
├── SQL/
│   ├── 01_Hotel_Schema_Setup.sql
│   ├── 02_Hotel_Queries.sql
│   ├── 03_Clinic_Schema_Setup.sql
│   └── 04_Clinic_Queries.sql
├── Spreadsheets/
│   └── Ticket_Analysis.xlsx
├── Python/
│   ├── 01_Time_Converter.py
│   └── 02_Remove_Duplicates.py

## How to run / use

### SQL
- The `.sql` files contain DDL and sample inserts. Load them into your DB (MySQL/Postgres) to create sample data.
- `02_Hotel_Queries.sql` and `04_Clinic_Queries.sql` contain solution queries. Some use functions (DATE_FORMAT, ROW_NUMBER, window functions) which may be DB-specific. Adjust DATE_TRUNC/DATE_FORMAT accordingly.

### Spreadsheets
- Open `Ticket_Analysis.xlsx` in Excel or Google Sheets.
- `Feedbacks!D` contains an INDEX/MATCH formula to populate `ticket_created_at` from `Tickets`.
- `Tickets` sheet includes helper columns and formulas for same-day and same-hour calculations.
- `Summary` sheet aggregates outlet-wise counts using SUMIFS.
- Ticket analysis excel file link: 
- [https://docs.google.com/spreadsheets/d/1erE-UJUf4OnQUKY-TwVBiKOAgZUnCcWO_s8s1Q8NpP4/edit?gid=0#gid=0]

### Python
- Run scripts with Python 3.8+:
  - `python3 01_Time_Converter.py`
  - `python3 02_Remove_Duplicates.py`

## Notes
- Date/time functions differ between MySQL/Postgres/SQLite. Adapt syntax when running in a specific RDBMS.
- Spreadsheet formulas are written for Excel but compatible with Google Sheets in most cases.
