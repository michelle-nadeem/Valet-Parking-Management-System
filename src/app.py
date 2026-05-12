from flask import Flask, jsonify, request, send_from_directory
from flask_cors import CORS
import pyodbc
import os
from datetime import datetime

app = Flask(__name__, static_folder='.')
CORS(app)

# ─── DB CONFIG ──────────────────────────────────────────────────────────────
# Update these values to match your SQL Server setup
DB_CONFIG = {
    'server':   'localhost',          # e.g. 'DESKTOP-XXXX\\SQLEXPRESS'
    'database': 'DBMS Lab FP',
    'driver':   'ODBC Driver 17 for SQL Server',
    # For Windows Authentication (most common for local SQL Server):
    'trusted_connection': 'yes',
    # For SQL Server Authentication, comment out trusted_connection and use:
    # 'uid': 'sa',
    # 'pwd': 'your_password',
}

def get_connection():
    conn_str = (
        f"DRIVER={{{DB_CONFIG['driver']}}};"
        f"SERVER={DB_CONFIG['server']};"
        f"DATABASE={DB_CONFIG['database']};"
    )
    if DB_CONFIG.get('trusted_connection') == 'yes':
        conn_str += "Trusted_Connection=yes;"
    else:
        conn_str += f"UID={DB_CONFIG['uid']};PWD={DB_CONFIG['pwd']};"
    return pyodbc.connect(conn_str)

def rows_to_dict(cursor):
    cols = [col[0] for col in cursor.description]
    return [dict(zip(cols, row)) for row in cursor.fetchall()]

# ─── SERVE FRONTEND ─────────────────────────────────────────────────────────
@app.route('/')
def index():
    return send_from_directory('.', 'index.html')

# ─── DASHBOARD STATS ────────────────────────────────────────────────────────
@app.route('/api/stats')
def stats():
    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute("SELECT COUNT(*) FROM Customers")
        total_customers = cur.fetchone()[0]

        cur.execute("SELECT COUNT(*) FROM Vehicles")
        total_vehicles = cur.fetchone()[0]

        cur.execute("SELECT COUNT(*) FROM Parking_Slots WHERE is_occupied = 1")
        occupied_slots = cur.fetchone()[0]

        cur.execute("SELECT COUNT(*) FROM Parking_Slots")
        total_slots = cur.fetchone()[0]

        cur.execute("SELECT COUNT(*) FROM Valet_Staff WHERE availability_status = 'Available'")
        available_staff = cur.fetchone()[0]

        cur.execute("SELECT ISNULL(SUM(total_fee),0) FROM Parking_Transactions WHERE payment_status = 'Paid'")
        total_revenue = float(cur.fetchone()[0])

        cur.execute("SELECT COUNT(*) FROM Parking_Transactions WHERE exit_time IS NULL")
        active_parkings = cur.fetchone()[0]

        conn.close()
        return jsonify({
            'total_customers': total_customers,
            'total_vehicles': total_vehicles,
            'occupied_slots': occupied_slots,
            'total_slots': total_slots,
            'available_staff': available_staff,
            'total_revenue': total_revenue,
            'active_parkings': active_parkings
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ─── CUSTOMERS ──────────────────────────────────────────────────────────────
@app.route('/api/customers')
def get_customers():
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("SELECT * FROM Customers ORDER BY customer_id")
        data = rows_to_dict(cur)
        conn.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/customers', methods=['POST'])
def add_customer():
    try:
        body = request.json
        conn = get_connection()
        cur = conn.cursor()
        cur.execute(
            "INSERT INTO Customers (first_name, last_name, phone_number, email) VALUES (?,?,?,?)",
            body['first_name'], body['last_name'], body['phone_number'], body['email']
        )
        conn.commit()
        conn.close()
        return jsonify({'message': 'Customer added successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ─── VEHICLES ───────────────────────────────────────────────────────────────
@app.route('/api/vehicles')
def get_vehicles():
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT v.*, c.first_name + ' ' + c.last_name AS customer_name
            FROM Vehicles v
            JOIN Customers c ON v.customer_id = c.customer_id
            ORDER BY v.vehicle_id
        """)
        data = rows_to_dict(cur)
        conn.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/vehicles', methods=['POST'])
def add_vehicle():
    try:
        body = request.json
        conn = get_connection()
        cur = conn.cursor()
        cur.execute(
            "INSERT INTO Vehicles (license_plate, vehicle_type, customer_id) VALUES (?,?,?)",
            body['license_plate'], body['vehicle_type'], body['customer_id']
        )
        conn.commit()
        conn.close()
        return jsonify({'message': 'Vehicle registered successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ─── PARKING SLOTS ──────────────────────────────────────────────────────────
@app.route('/api/slots')
def get_slots():
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("SELECT * FROM Parking_Slots ORDER BY slot_id")
        data = rows_to_dict(cur)
        conn.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ─── VALET STAFF ────────────────────────────────────────────────────────────
@app.route('/api/staff')
def get_staff():
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("SELECT * FROM Valet_Staff ORDER BY staff_id")
        data = rows_to_dict(cur)
        conn.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ─── TRANSACTIONS ───────────────────────────────────────────────────────────
@app.route('/api/transactions')
def get_transactions():
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT t.transaction_id, v.license_plate, p.slot_number,
                   s.name AS staff_name,
                   CONVERT(VARCHAR, t.entry_time, 120) AS entry_time,
                   CONVERT(VARCHAR, t.exit_time, 120) AS exit_time,
                   t.total_fee, t.payment_status
            FROM Parking_Transactions t
            JOIN Vehicles v ON t.vehicle_id = v.vehicle_id
            JOIN Parking_Slots p ON t.slot_id = p.slot_id
            JOIN Valet_Staff s ON t.staff_id = s.staff_id
            ORDER BY t.transaction_id DESC
        """)
        data = rows_to_dict(cur)
        conn.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ─── PARK VEHICLE (Stored Procedure) ────────────────────────────────────────
@app.route('/api/park', methods=['POST'])
def park_vehicle():
    try:
        body = request.json
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("EXEC ParkVehicle @vehicle_id=?, @slot_id=?",
                    body['vehicle_id'], body['slot_id'])
        conn.commit()
        conn.close()
        return jsonify({'message': 'Vehicle parked successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ─── EXIT VEHICLE (Stored Procedure) ────────────────────────────────────────
@app.route('/api/exit', methods=['POST'])
def exit_vehicle():
    try:
        body = request.json
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("EXEC ExitVehicle @transaction_id=?", body['transaction_id'])
        conn.commit()
        conn.close()
        return jsonify({'message': 'Vehicle exited successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ─── MAKE PAYMENT (Stored Procedure) ────────────────────────────────────────
@app.route('/api/pay', methods=['POST'])
def make_payment():
    try:
        body = request.json
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("EXEC MakePayment @transaction_id=?", body['transaction_id'])
        conn.commit()
        conn.close()
        return jsonify({'message': 'Payment completed'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ─── ZONE OCCUPANCY VIEW ─────────────────────────────────────────────────────
@app.route('/api/zones')
def get_zones():
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("SELECT * FROM View_ZoneOccupancy")
        data = rows_to_dict(cur)
        conn.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    print("🚗 Valet Parking Management System")
    print("   Backend running at http://localhost:5000")
    print("   Open http://localhost:5000 in your browser")
    app.run(debug=True, port=5000)
