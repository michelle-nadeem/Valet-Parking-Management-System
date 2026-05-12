# 🚗 Valet Parking Management System

A full-stack web-based valet parking management system built with Python 
and MS SQL Server, designed to automate vehicle check-ins, slot tracking, 
staff management, and transaction reporting.

## 🛠️ Tech Stack
- Backend: Python, Flask, pyodbc
- Frontend: HTML, CSS, JavaScript
- Database: Microsoft SQL Server
- Architecture: RESTful API

## ✨ Features
- Dashboard with live statistics and zone occupancy
- Customer management (view and add)
- Vehicle registry with owner details
- Visual parking slot map (available and occupied)
- Staff roster with availability status
- Full transaction history
- Operations: Park Vehicle, Exit Vehicle, Make Payment

## ⚙️ Setup & Run Guide

### Step 1 - Install dependencies
pip install -r requirements.txt

### Step 2 - Configure SQL Server
Open app.py and update the DB_CONFIG block:
- server: your SQL Server name
- database: your database name
- Use Windows Authentication or SQL login credentials

### Step 3 - Run the application
python app.py

### Step 4 - Open in browser
Visit: http://localhost:5000
