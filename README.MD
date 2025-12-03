# Data_Analyst_Assignment

This repository contains solutions for a data analyst assignment covering SQL, Spreadsheets, and Python.

## Structure

```
Data_Analyst_Assignment/
├── SQL/
│   ├── 01_Hotel_Schema_Setup.sql
│   ├── 02_Hotel_Queries.sql
│   ├── 03_Clinic_Schema_Setup.sql
│   └── 04_Clinic_Queries.sql
├── Spreadsheets/
│   └── Ticket_Analysis.xlsx
|   |___Ticket_Analysis - ticket.csv
|   |___Ticket_Analysis - feedbacks.csv
|   |___Ticket_Analysis - summary.csv
├── Python/
│   ├── 01_Time_Converter.py
│   └── 02_Remove_Duplicates.py
```

## How to run/use

### SQL
- The `.sql` files contain DDL and sample inserts. Load them into your DB (MySQL/Postgres) to create sample data.
- `02_Hotel_Queries.sql` and `04_Clinic_Queries.sql` contain solution queries. Some use functions (DATE_FORMAT, ROW_NUMBER, window functions) which may be DB-specific. Adjust DATE_TRUNC/DATE_FORMAT accordingly.

### Spreadsheet Proficiency - Ticket Analysis
- Open `Ticket_Analysis.xlsx` in Excel or Google Sheets.
- Populating 'ticket_created_at' in feedbacks:
    ```
     - Used XLOOKUP to fetch 'created_at' from 'ticket' sheet based on cms_id.
     - Formula: =XLOOKUP(E2, ticket!E:E, ticket!B:B, "")
  ```
  Convert the ticket created_at and closed_at strings to datetime using this formula
  ```
   Formula =DATE(MID(B2,7,4), MID(B2,4,2), LEFT(B2,2)) + TIMEVALUE(MID(B2,12,5))
  ```
- Outlet-wise counts:
  ```
    - Same Day: =SUMPRODUCT((ticket!D$2:D$100=A2)*(INT(ticket!B$2:B$100)=INT(ticket!C$2:C$100)))
    - Same Hour: =SUMPRODUCT((ticket!D$2:D$100=A2)*(TEXT(ticket!B$2:B$100,"yyyy-mm-dd hh")=TEXT(ticket!C$2:C$100,"yyyy-mm-dd hh")))
  ```
- Ticket analysis Excel file link: 
- [https://docs.google.com/spreadsheets/d/1erE-UJUf4OnQUKY-TwVBiKOAgZUnCcWO_s8s1Q8NpP4/edit?gid=0#gid=0]

### Python
- Run scripts with Python 3.8+:
  - `python3 01_Time_Converter.py`
  - `python3 02_Remove_Duplicates.py`

## Notes
- Date/time functions differ between MySQL/Postgres/SQLite. Adapt syntax when running in a specific RDBMS.
- Spreadsheet formulas are written for Excel but are compatible with Google Sheets in most cases.
