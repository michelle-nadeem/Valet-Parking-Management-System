                                                                      
                                                                         -- VALET PARKING MANAGEMENT SYSTEM --


---- 1. DATABASE AND TABLE CREATION (DDL)
CREATE DATABASE [DBMS Lab FP];
USE [DBMS Lab FP];

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number INT
);


CREATE TABLE Vehicles (
    vehicle_id INT PRIMARY KEY IDENTITY(1,1),
    license_plate VARCHAR(20) UNIQUE NOT NULL,
    vehicle_type VARCHAR(20),
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


CREATE TABLE Valet_Staff (
    staff_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15),
    availability_status VARCHAR(20) DEFAULT 'Available' 
);


CREATE TABLE Parking_Slots (
    slot_id INT PRIMARY KEY IDENTITY(1,1),
    slot_number VARCHAR(10) UNIQUE NOT NULL,
    zone_area VARCHAR(50),
    is_occupied BIT DEFAULT 0 
);


CREATE TABLE Parking_Transactions ( 
    transaction_id INT PRIMARY KEY IDENTITY(1,1),
    vehicle_id INT,
    slot_id INT,
    staff_id INT,
    entry_time DATETIME DEFAULT GETDATE(),
    exit_time DATETIME,
    total_fee DECIMAL(10, 2),
    payment_status VARCHAR(20) DEFAULT 'Pending', 
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    FOREIGN KEY (slot_id) REFERENCES Parking_Slots(slot_id),
    FOREIGN KEY (staff_id) REFERENCES Valet_Staff(staff_id)
); 


-- adding email column to customers
ALTER TABLE Customers
ADD email VARCHAR(40) UNIQUE;


-- adding CHECK consraint on availability_status (Avaliable/Busy)
ALTER TABLE Valet_Staff
ADD CONSTRAINT staff_status CHECK (availability_status IN ('Available' , 'Busy'))


-- adding CHECK constraint on payment_status (paid/pending)
ALTER TABLE Parking_Transactions
ADD CONSTRAINT fee_status CHECK (payment_status IN ('Paid' , 'Pending'))


-- changing the size of vehicle_type column
ALTER TABLE Vehicles
ALTER COLUMN vehicle_type VARCHAR(30)




---- 2. DATA MANIPULATION (DML)
INSERT INTO Customers (first_name, last_name, phone_number, email)
VALUES
('Ali','Khan','03001111111','ali1@gmail.com'),
('Ahmed','Raza','03002222222','ahmed1@gmail.com'),
('Usman','Iqbal','03003333333','usman1@gmail.com'),
('Hassan','Ali','03004444444','hassan1@gmail.com'),
('Bilal','Shah','03005555555','bilal1@gmail.com'),
('Omar','Farooq','03006666666','omar1@gmail.com'),
('Saad','Nawaz','03007777777','saad1@gmail.com'),
('Zain','Malik','03008888888','zain1@gmail.com'),
('Hamza','Javed','03009999999','hamza1@gmail.com'),
('Ahsan','Qureshi','03101111111','ahsan1@gmail.com'),
('Fahad','Sheikh','03102222222','fahad1@gmail.com'),
('Daniyal','Ahmed','03103333333','daniyal1@gmail.com'),
('Talha','Rashid','03104444444','talha1@gmail.com'),
('Ibrahim','Hassan','03105555555','ibrahim1@gmail.com'),
('Abdullah','Khan','03106666666','abdullah1@gmail.com'),
('Mubeen','Aslam','03107777777','mubeen@gmail.com'),
('Sufyan','Akram','03108888888','sufyan@gmail.com'),
('Rehan','Butt','03109999999','rehan@gmail.com'),
('Yasir','Mehmood','03201111111','yasir@gmail.com'),
('Noman','Chaudhry','03202222222','noman@gmail.com');


INSERT INTO Vehicles (license_plate, vehicle_type, customer_id)
VALUES
('LEA-101','Car',1),
('LHR-202','Bike',2),
('ISB-303','Car',3),
('KHI-404','Car',4),
('FSD-505','Bike',5),
('GUJ-606','Car',6),
('MUX-707','Car',7),
('SWL-808','Bike',8),
('RYK-909','Car',9),
('BWP-111','Car',10),
('SKP-222','Bike',11),
('JLM-333','Car',12),
('HFD-444','Car',13),
('MNS-555','Bike',14),
('DBG-666','Car',15),
('ABC-777','Car',16),
('XYZ-888','Bike',17),
('DEF-999','Car',18),
('GHI-111','Car',19),
('JKL-222','Bike',20);


INSERT INTO Valet_Staff (name, phone_number, availability_status)
VALUES
('Ali Raza','03010000001','Available'),
('Ahmed Khan','03010000002','Available'),
('Usman Ali','03010000003','Available'),
('Hassan Shah','03010000004','Available'),
('Bilal Ahmed','03010000005','Available'),
('Omar Farooq','03010000006','Available'),
('Saad Malik','03010000007','Available'),
('Zain Javed','03010000008','Available'),
('Hamza Iqbal','03010000009','Available'),
('Ahsan Qureshi','03010000010','Available'),
('Fahad Sheikh','03010000011','Available'),
('Daniyal Khan','03010000012','Available'),
('Talha Rashid','03010000013','Available'),
('Ibrahim Hassan','03010000014','Available'),
('Abdullah Nawaz','03010000015','Available'),
('Night Staff 1','03019999111','Available'),
('Night Staff 2','03019999222','Available'),
('Evening Staff 1','03019999333','Available'),
('Morning Staff 1','03019999444','Available'),
('Supervisor','03019999555','Available');


INSERT INTO Parking_Slots (slot_number, zone_area)
VALUES
('A1','Zone A'), ('A2','Zone A'), ('A3','Zone A'), ('A4','Zone A'), ('A5','Zone A'),
('B1','Zone B'), ('B2','Zone B'), ('B3','Zone B'), ('B4','Zone B'), ('B5','Zone B'),
('C1','Zone C'), ('C2','Zone C'), ('C3','Zone C'), ('C4','Zone C'), ('C5','Zone C'),
('D1','Zone D'), ('D2','Zone D'), ('D3','Zone D'), ('D4','Zone D'), ('D5','Zone D');


INSERT INTO Parking_Transactions (vehicle_id, slot_id, staff_id)
VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10),
(11, 11, 11),
(12, 12, 12),
(13, 13, 13),
(14, 14, 14),
(15, 15, 15),
(16, 16, 16),
(17, 17, 17),
(18, 18, 18),
(19, 19, 19),
(20, 20, 20);


-- show total number of vehicles per customer
SELECT customer_id, COUNT(vehicle_id) AS Total_Vehicles
FROM Vehicles
GROUP BY customer_id;


-- show most used parking slot
SELECT TOP 1 slot_id, COUNT(*) AS Usage_Count
FROM Parking_Transactions
GROUP BY slot_id
ORDER BY COUNT(*) DESC;


-- show vehicles that never exited yet
SELECT *
FROM Parking_Transactions
WHERE exit_time IS NULL;


-- show customers who have more than 1 vehicle
SELECT customer_id, COUNT(vehicle_id) AS Vehicle_Count
FROM Vehicles
GROUP BY customer_id
HAVING COUNT(vehicle_id) > 1;




---- 3. STORED PROCEDURES
-- 1) Park vehicle:
CREATE PROCEDURE ParkVehicle
@vehicle_id INT, 
@slot_id INT
AS
BEGIN
DECLARE @staff_id INT;

IF EXISTS (SELECT * FROM Parking_Transactions 
WHERE vehicle_id = @vehicle_id AND exit_time IS NULL)
BEGIN
PRINT 'Vehicle already parked';
RETURN;
END

IF EXISTS (SELECT * FROM Parking_Slots 
WHERE slot_id = @slot_id AND is_occupied = 1)
BEGIN
PRINT 'Slot not available';
RETURN;
END

SELECT TOP 1 @staff_id = staff_id
FROM Valet_Staff
WHERE availability_status = 'Available';

IF @staff_id IS NULL
BEGIN
PRINT 'No staff available';
RETURN;
END

INSERT INTO Parking_Transactions(vehicle_id, slot_id, staff_id)
VALUES (@vehicle_id, @slot_id, @staff_id);

UPDATE Valet_Staff
SET availability_status = 'Busy'
WHERE staff_id = @staff_id;
    PRINT 'Vehicle Parked Successfully';
END;


-- 2) Exit vehicle:
CREATE PROCEDURE ExitVehicle
@transaction_id INT
AS
BEGIN
DECLARE @entry DATETIME;
DECLARE @exit DATETIME = GETDATE();
DECLARE @hours INT;
DECLARE @fee INT;
DECLARE @staff_id INT;
DECLARE @slot_id INT;

SELECT @entry = entry_time, @staff_id = staff_id, @slot_id = slot_id
FROM Parking_Transactions
WHERE transaction_id = @transaction_id;

IF @entry IS NULL
BEGIN
PRINT 'Invalid Transaction';
RETURN;
END

SET @hours = DATEDIFF(HOUR, @entry, @exit);
IF @hours = 0
SET @hours = 1;
SET @fee = @hours * 50;

UPDATE Parking_Transactions
SET exit_time = @exit,
total_fee = @fee,
payment_status = 'pending'
WHERE transaction_id = @transaction_id;

UPDATE Valet_Staff
SET availability_status = 'Available'
WHERE staff_id = @staff_id;

PRINT 'Vehicle Exited Successfully';
END;


--3) payment:
CREATE PROCEDURE MakePayment
@transaction_id INT
AS
BEGIN
UPDATE Parking_Transactions
SET payment_status = 'Paid'
WHERE transaction_id = @transaction_id;
PRINT 'Payment Done';
END;


-- 4) customer history:
CREATE PROCEDURE GetCustomerHistory
@customer_id INT
AS
BEGIN
SELECT *
FROM Parking_Transactions as t, Vehicles as v
WHERE t.vehicle_id = v.vehicle_id
AND v.customer_id = @customer_id;
END;


-- 5) available slots:
CREATE PROCEDURE GetAvailableSlots
@zone VARCHAR(50)
AS
BEGIN
SELECT *
FROM Parking_Slots
WHERE zone_area = @zone
AND is_occupied = 0;
END;


-- 6) total revenue:
CREATE PROCEDURE GetTotalRevenue
AS
BEGIN
SELECT SUM(total_fee) AS Total_Revenue
FROM Parking_Transactions
WHERE payment_status = 'Paid';
END;


-- 7) total number of occupied slots:
CREATE PROCEDURE GetOccupiedSlotsCount
AS
BEGIN
SELECT COUNT(*) AS OccupiedSlots
FROM Parking_Slots
WHERE is_occupied = 1;
END;


-- 8) Get highest parking fee:
CREATE PROCEDURE GetMaxFee
AS
BEGIN
SELECT MAX(total_fee) AS HighestFee
FROM Parking_Transactions;
END;


-- 9) Show all currently parked vehicles:
CREATE PROCEDURE ShowActiveVehicles
AS
BEGIN
SELECT *
FROM Parking_Transactions
WHERE exit_time IS NULL;
END;


-- 10) Show all completed (exited) vehicles:
CREATE PROCEDURE ShowCompletedVehicles
AS
BEGIN
SELECT *
FROM Parking_Transactions
WHERE exit_time IS NOT NULL;
END;




---- 4. VIEWS
-- 1) Active Parking (currently parked vehicles)
CREATE VIEW View_ActiveParking AS
SELECT *
FROM Parking_Transactions
WHERE exit_time IS NULL;


-- 2) Completed Transactions (vehicles that have exited)
CREATE VIEW View_CompletedTransactions AS
SELECT *
FROM Parking_Transactions
WHERE exit_time IS NOT NULL;


-- 3) Available Parking Slots
CREATE VIEW View_AvailableSlots AS
SELECT *
FROM Parking_Slots
WHERE is_occupied = 0;


-- 4) Busy Staff List
CREATE VIEW View_BusyStaff AS
SELECT *
FROM Valet_Staff
WHERE availability_status = 'Busy';


-- 5) Customer with Vehicles Details
CREATE VIEW View_CustomerVehicles AS
SELECT c.customer_id, c.first_name, c.last_name, v.vehicle_id, v.license_plate, v.vehicle_type
FROM Customers c
JOIN Vehicles v
ON c.customer_id = v.customer_id;


-- 6) Daily Revenue Report
CREATE VIEW View_DailyRevenue AS
SELECT CAST(entry_time AS DATE) AS EntryDate, SUM(total_fee) AS TotalRevenue
FROM Parking_Transactions 
WHERE payment_status = 'Paid'
GROUP BY CAST(entry_time AS DATE);


-- 7) Most frequently parked vehicles
CREATE VIEW View_VehicleFrequency
AS
SELECT v.vehicle_id, v.license_plate, COUNT(t.transaction_id) AS Total_Parkings
FROM Vehicles v
LEFT JOIN Parking_Transactions t
ON v.vehicle_id = t.vehicle_id
GROUP BY v.vehicle_id, v.license_plate;


-- 8) Staff workload (how many vehicles handled)
CREATE VIEW View_StaffWorkload
AS
SELECT s.staff_id, s.name, COUNT(t.transaction_id) AS Total_Assigned
FROM Valet_Staff s
LEFT JOIN Parking_Transactions t
ON s.staff_id = t.staff_id
GROUP BY s.staff_id, s.name;


-- 9) Zone-wise occupancy report
CREATE VIEW View_ZoneOccupancy
AS
SELECT zone_area, COUNT(slot_id) AS Total_Slots, SUM(CAST(is_occupied AS INT)) AS Occupied_Slots, (COUNT(slot_id) - SUM(CAST(is_occupied AS INT))) AS Available_Slots
FROM Parking_Slots
GROUP BY zone_area;


-- 10) Average parking duration per vehicle
CREATE VIEW View_AvgParkingDuration
AS
SELECT vehicle_id, AVG(DATEDIFF(HOUR, entry_time, exit_time)) AS Avg_Hours
FROM Parking_Transactions
WHERE exit_time IS NOT NULL
GROUP BY vehicle_id;




---- 5. JOINS
-- 1) INNER JOIN: Customer with Vehicle details
SELECT c.first_name, c.phone_number, v.vehicle_type, v.license_plate
FROM Customers c
INNER JOIN Vehicles v
ON c.customer_id = v.customer_id;


-- 2)  LEFT JOIN: All parking slots with transactions (if any)
SELECT p.slot_id, p.slot_number, p.is_occupied, t.transaction_id
FROM Parking_Slots p
LEFT JOIN Parking_Transactions t
ON p.slot_id = t.slot_id;


-- 3) RIGHT JOIN: All staff with assigned transactions (if any)
SELECT s.staff_id, s.name, t.transaction_id
FROM Parking_Transactions t
RIGHT JOIN Valet_Staff s
ON t.staff_id = s.staff_id;


-- 4) FULL JOIN: All slots and transactions combined
SELECT p.slot_number, t.transaction_id, t.vehicle_id
FROM Parking_Slots p
FULL JOIN Parking_Transactions t
ON p.slot_id = t.slot_id;


-- 5) SELF JOIN: Staff with same availability status
SELECT s1.name AS Staff1, s2.name AS Staff2, s1.availability_status
FROM Valet_Staff s1
JOIN Valet_Staff s2
ON s1.availability_status = s2.availability_status
AND s1.staff_id <> s2.staff_id;


-- 6) INNER JOIN: Customer, Vehicle and Transaction details
SELECT c.first_name, v.license_plate, t.transaction_id, t.entry_time
FROM Customers c
INNER JOIN Vehicles v ON c.customer_id = v.customer_id
INNER JOIN Parking_Transactions t ON v.vehicle_id = t.vehicle_id;


-- 7) LEFT JOIN: Vehicles even if never parked
SELECT v.vehicle_id, v.license_plate, t.transaction_id, t.entry_time
FROM Vehicles v
LEFT JOIN Parking_Transactions t
ON v.vehicle_id = t.vehicle_id;


-- 8) INNER JOIN: Transactions with slot details
SELECT t.transaction_id, p.slot_number, t.entry_time, t.exit_time
FROM Parking_Transactions t
INNER JOIN Parking_Slots p
ON t.slot_id = p.slot_id;


-- 9) INNER JOIN: Transactions with staff details
SELECT t.transaction_id, s.name, s.phone_number
FROM Parking_Transactions t
INNER JOIN Valet_Staff s
ON t.staff_id = s.staff_id;


-- 10) SELF JOIN: Compare staff working on same shift status
SELECT s1.name AS Staff_A, s2.name AS Staff_B, s1.availability_status
FROM Valet_Staff s1
JOIN Valet_Staff s2
ON s1.availability_status = s2.availability_status
AND s1.staff_id < s2.staff_id;




---- 6. SUBQUERIES
-- 1) Customer who paid highest fee
SELECT *
FROM Customers
WHERE customer_id =
(SELECT TOP 1 v.customer_id
FROM Parking_Transactions t
JOIN Vehicles v
ON t.vehicle_id = v.vehicle_id
ORDER BY t.total_fee DESC);


-- 2) Vehicles with more than 1 transaction
SELECT vehicle_id
FROM Parking_Transactions
GROUP BY vehicle_id
HAVING COUNT(*) > 1;


-- 3) Staff who handled maximum transactions
SELECT TOP 1 staff_id
FROM Parking_Transactions
GROUP BY staff_id
ORDER BY COUNT(*) DESC;


-- 4) Customers who never used valet service
SELECT *
FROM Customers
WHERE customer_id NOT IN
(SELECT v.customer_id
FROM Vehicles v
JOIN Parking_Transactions t
ON v.vehicle_id = t.vehicle_id);


-- 5) Transactions where fee is greater than average fee
SELECT *
FROM Parking_Transactions
WHERE total_fee >
(SELECT AVG(total_fee)
FROM Parking_Transactions);


-- 6) Transactions above their own vehicle average
SELECT *
FROM Parking_Transactions t1
WHERE total_fee >
(SELECT AVG(t2.total_fee)
FROM Parking_Transactions t2
WHERE t1.vehicle_id = t2.vehicle_id);


-- 7) Customers who have at least one transaction
SELECT *
FROM Customers
WHERE customer_id IN
(SELECT DISTINCT v.customer_id
FROM Vehicles v
JOIN Parking_Transactions t
ON v.vehicle_id = t.vehicle_id);


-- 8) Vehicles that are currently parked
SELECT *
FROM Vehicles
WHERE vehicle_id IN
(SELECT vehicle_id
FROM Parking_Transactions
WHERE exit_time IS NULL);


-- 9) Staff who are currently busy
SELECT *
FROM Valet_Staff
WHERE staff_id IN
(SELECT staff_id
FROM Parking_Transactions
WHERE exit_time IS NULL);


-- 10) Customers who have more than 2 vehicles
SELECT customer_id
FROM Vehicles
GROUP BY customer_id
HAVING COUNT(vehicle_id) > 2;




---- 7. TRIGGERS
-- 1) OCCUPY SLOT AFTER INSERT
CREATE TRIGGER trg_OccupySlot
ON Parking_Transactions
AFTER INSERT
AS
BEGIN
UPDATE Parking_Slots
SET is_occupied = 1
WHERE slot_id IN (SELECT slot_id FROM inserted);
END;


-- 2) FREE SLOT AFTER EXIT
CREATE TRIGGER trg_FreeSlot
ON Parking_Transactions
AFTER UPDATE
AS
BEGIN
UPDATE Parking_Slots
SET is_occupied = 0
WHERE slot_id IN (
SELECT slot_id
FROM inserted
WHERE exit_time IS NOT NULL);
END;


-- 3) Prevent deleting active parking transactions
CREATE TRIGGER trg_PreventDeleteActive
ON Parking_Transactions
INSTEAD OF DELETE
AS
BEGIN
IF EXISTS (SELECT 1 FROM deleted
WHERE exit_time IS NULL)
BEGIN
PRINT 'Cannot delete active parked vehicle';
RETURN;
END

DELETE FROM Parking_Transactions
WHERE transaction_id IN (SELECT transaction_id FROM deleted);
END;


-- 4) Auto set payment status to Pending on insert
CREATE TRIGGER trg_DefaultPaymentStatus
ON Parking_Transactions
AFTER INSERT
AS
BEGIN
UPDATE Parking_Transactions
SET payment_status = 'Pending'
WHERE transaction_id IN (SELECT transaction_id FROM inserted);
END;




---- 8. FUNCTIONS
-- 1) CALCULATE FEE:
CREATE FUNCTION CalculateFee(@hours INT)
RETURNS INT
AS
BEGIN
RETURN @hours * 50;
END;


-- 2) TOTAL REVENUE:
CREATE FUNCTION TotalRevenue()
RETURNS DECIMAL(10,2)
AS
BEGIN
DECLARE @total DECIMAL(10,2);
SELECT @total = SUM(total_fee)
FROM Parking_Transactions
WHERE payment_status = 'Paid';
RETURN ISNULL(@total, 0);
END;


-- 3) Parking duration in minutes:
CREATE FUNCTION GetParkingMinutes(@entry DATETIME, @exit DATETIME)
RETURNS INT
AS
BEGIN
RETURN DATEDIFF(MINUTE, @entry, @exit);
END;



-- testing
SELECT * FROM Customers;
SELECT * FROM Vehicles;
SELECT * FROM Valet_Staff;
SELECT * FROM Parking_Slots;
SELECT * FROM Parking_Transactions;


