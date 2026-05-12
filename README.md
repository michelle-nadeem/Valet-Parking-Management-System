# 🚗 Valet Parking Management System

## Setup & Run Guide

### Step 1 — Install Python dependencies
```
pip install -r requirements.txt
```

### Step 2 — Configure your SQL Server connection
Open `app.py` and update the `DB_CONFIG` block at the top:

```python
DB_CONFIG = {
    'server':   'localhost',          # or 'DESKTOP-XXXX\\SQLEXPRESS'
    'database': 'DBMS Lab FP',
    'driver':   'ODBC Driver 17 for SQL Server',
    'trusted_connection': 'yes',      # Windows Auth (most common)
    # For SQL login, comment above and use:
    # 'uid': 'sa',
    # 'pwd': 'your_password',
}
```

> Make sure SQL Server is running and you've already executed Lab_Queries.sql to create the database and tables.

### Step 3 — Run the backend
```
python app.py
```

### Step 4 — Open the app
Visit: http://localhost:5000

---

## Features
- 📊 Dashboard with live stats and zone occupancy
- 👤 Customer management (view + add)
- 🚙 Vehicle registry with owner details
- 🅿️ Visual parking slot map (green = free, red = occupied)
- 👷 Staff roster with availability status
- 🔄 Full transaction history
- ⚙️ Operations: Park Vehicle, Exit Vehicle, Make Payment (calls stored procedures)
