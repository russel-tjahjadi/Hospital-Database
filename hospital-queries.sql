-- hospital-queries.sql
--
-- Sample queries on the Hospital Database
--
-- Raka Primardika (hybrid)
-- Russel Tjahjadi (in-person)

-- ##############################################################################
-- Views

-- 1. Unpaid invoices
CREATE VIEW Unpaid_invoices AS
SELECT I.id, name, phone_num, address, SUM(amount) AS total_amount 
FROM Invoice I
	JOIN Payable P ON I.id = P.inv_id
    JOIN Patient T ON I.pat_id = T.id
WHERE invoice_status <> "Paid"
GROUP BY I.id;

-- 2. Available rooms
CREATE VIEW Available_rooms AS
SELECT number, capacity - COALESCE(num_occupants, 0) AS cur_capacity
-- Ref: https://www.w3schools.com/sql/func_sqlserver_coalesce.asp
FROM Room R LEFT JOIN
	(SELECT room_num, COUNT(pat_id) AS num_occupants
	FROM Hospitalised
	WHERE NOW() >= start_date AND NOW() <= end_date
	GROUP BY room_num) AS CR ON R.number = CR.room_num
WHERE capacity - COALESCE(num_occupants, 0) > 0;

-- 3. Pending orders
CREATE VIEW Pending_orders AS
SELECT  N.id AS nid, N.name AS nname,
		P.id AS pid, P.name AS pname,
        I.description AS instruction,
        executes_status AS status
FROM Doctor_order O
	JOIN Executes E ON O.id = E.ord_id
    JOIN Instruction I ON O.ins_code = I.code
    JOIN Nurse N ON N.id = E.nur_id
    JOIN Patient P ON P.id = O.pat_id
WHERE executes_status <> "Completed";


-- ##############################################################################
-- Triggers

-- 1. Create payable for each room booking
CREATE TRIGGER create_room_payable
AFTER INSERT ON Hospitalised
FOR EACH ROW
INSERT INTO Payable(inv_id, payable_type, amount, payable_date) VALUES (
	NULL,
    "Rooms Total",
    (DATEDIFF(NEW.end_date, NEW.start_date)) * (SELECT fee_nightly FROM Room WHERE number = NEW.room_num),
    CAST(NOW() AS DATE)
);

-- 2. Monitor expensive procedures
DELIMITER |
-- Ref: https://stackoverflow.com/questions/39307880/
--      mysql-trigger-syntax-missing-semicolon
CREATE TRIGGER monitor_expensive_procedures
AFTER INSERT ON Doctor_order
FOR EACH ROW
BEGIN
	IF (SELECT fee FROM Instruction WHERE code = NEW.ins_code) > 1000 THEN
	-- Ref: https://dev.mysql.com/doc/refman/8.0/en/insert-on-duplicate.html
		INSERT INTO Monitors(phy_id, pat_id, duration_hr)
		VALUES (
			NEW.phy_id, NEW.pat_id, 2
		) ON DUPLICATE KEY UPDATE
        duration_hr = duration_hr + 2;
	END IF;
END |
DELIMITER ;

-- 3. TODO

-- ##############################################################################
-- Queries

-- 1. People covered by insurance
SELECT name, total
FROM Patient T, (SELECT pat_id, SUM(amount) AS total
		FROM Invoice I
			JOIN Payable P ON I.id = P.inv_id
		WHERE pat_id NOT IN (SELECT pat_id
							FROM Hospitalised
							WHERE room_num > 400)
		GROUP BY pat_id
		HAVING total >= 300) AS S
WHERE pat_id = T.id;

-- 2. Most common administered medicine
SELECT code, name, COUNT(dose) AS total_provisions
FROM Provide P
	RIGHT JOIN Medication M ON P.med_code = M.code
GROUP BY code
ORDER BY total_provisions DESC;

-- 3. Unused rooms in April 2023
SELECT number
FROM Room
WHERE number NOT IN (
		SELECT room_num
		FROM Hospitalised
		WHERE (start_date >= "2023-04-01" AND start_date <= "2023-04-30")
			OR (end_date >= "2023-04-01" AND end_date <= "2023-04-30")
);

-- 4. Proper instruction orders?
SELECT physician_name, field, description
FROM Doctor_order O
	JOIN Physician D ON D.id = O.phy_id
    JOIN Instruction I ON I.code = O.ins_code;
    
-- 5. Instruction with the most expense
SELECT description, SUM(fee) AS total_cost
FROM Doctor_Order O
	JOIN Instruction I ON I.code = O.ins_code
GROUP BY code
ORDER BY total_cost DESC
LIMIT 1;

-- 6. Names of Patients who have not paid their invoices
SELECT Patient.name 
FROM Patient
	JOIN Invoice on Invoice.pat_id = Patient.id
WHERE Invoice.invoice_status = "Not Paid";

-- 7. Find out which physician is in charge of a certain instruction, the cost of that instruction (which is more than $300) and its description
SELECT Physician.physician_name, Instruction.fee as instruction_fee, Instruction.description
FROM Instruction
LEFT JOIN Doctor_order on Doctor_order.ins_code = Instruction.code 
LEFT JOIN Physician on Physician.id = Doctor_order.phy_id
WHERE Instruction.fee > 300;

-- 8. Insurance company doesn't want to pay for instructions under 100 dollars. List out all invoices along with their total price, but exclude instruction costs under 100 dollars.
SELECT Payable.id as payable_id
FROM Payable
JOIN Invoice on Invoice.id = Payable.inv_id
JOIN Doctor_order on Doctor_order.pat_id = Invoice.pat_id
JOIN Instruction on Instruction.code = Doctor_order.ins_code
WHERE Instruction.fee > 100;

-- 9. TODO

-- 10. TODO

-- 11. Patients with health records monitored?
SELECT T.name AS pat_name, D.id, D.physician_name
FROM Patient T
	LEFT JOIN Monitors M ON T.id = M.pat_id
	LEFT JOIN Physician D ON M.phy_id = D.id
WHERE T.id IN (
	SELECT pat_id FROM Health_record
);

-- 12. Total revenue from rooms
SELECT SUm(amount) AS revenue
FROM Payable
WHERE payable_type = "Rooms Total"
	AND payabla_date = "2023-01-01"
    AND payabla_date = "2023-12-31";

-- 13. Contact missing nurses
SELECT name, phone_num
FROM Pending_orders PO
	JOIN Nurse N ON PO.nid = N.id;

-- 14. Detecting favouritism of nurses
SELECT D.id AS pid, D.physician_name,
	N.id AS nid, N.name AS nurse_name,
    COUNT(ord_id) AS occasions
FROM Executes E
	JOIN Doctor_order O ON E.ord_id = O.id
    JOIN Nurse N ON E.nur_id = N.id
    JOIN Physician D ON O.phy_id = D.id
GROUP BY D.id, N.id
ORDER BY occasions DESC;

-- 15. Total revenue already paid
SELECT SUM(amount) AS revenue
FROM Invoice I
	JOIN Payable P ON I.id = P.inv_id
WHERE invoice_status = "Paid";

-- ##############################################################################
-- Transactions

-- 1. 
SET TRANSACTION READ WRITE;
-- a. Doctor makes a new order
INSERT INTO Doctor_order
(id, phy_id, pat_id, ins_code, order_date)
VALUES
(26331, 5003, 1003,
(SELECT code FROM Instruction
WHERE description = "Adderall"),
CAST(NOW() AS DATE));
-- b. Assign a nurse to handle it
INSERT INTO Executes
(ord_id, nur_id, executes_status, executes_date)
VALUES
(26331, 7005, "Not Executed",
CAST(NOW() AS DATE));
-- c. Verify changes
SELECT *
FROM Executes;
-- Finish
COMMIT;

-- 2. Booking a new room while checking for empty ones
SET TRANSACTION READ WRITE;
-- a. Check for empty rooms
SELECT * FROM Available_rooms;
-- b. Book a new room for a patient
INSERT INTO Hospitalised
(pat_id, room_num, start_date, end_date)
VALUES
(1005, 203, CAST(NOW() AS DATE), "2023-05-10");
-- c. Verify booking exists
SELECT * FROM Hospitalised;
-- d. Verify payable exists
SELECT * FROM Payable;
-- Finish
COMMIT;

-- ##############################################################################