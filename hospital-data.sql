-- hospital-data.sql
--
-- Inserting fabricated entries into the hospital schema
--
-- Raka Primardika (hybrid)
-- Russel Tjahjadi (in-person)
USE hospital;

INSERT INTO Patient(id, name, address, phone_num) VALUES
	(1001, "Denny Mulyanto", "Depok", "8129972455"),
    (1002, "Bagas Aditya", "Depok", "8127785677"),
    (1003, "Agus Wijaya", "Cibinong", "8121129908"),
    (1004, "Kevin Siregar", "Bekasi", "8134429091"),
    (1005, "Togar Harahap", "Jakarta Utara", "8161123422"),
    (1006, "Christian Chen", "Bintaro", NULL),
    (1007, "Joko Sulaiman", "Jakarta Barat", "8110990546"),
    (1008, "Anggara Parto", "Bintaro", NULL),
    (1009, "Dimas Pradana", "Jakarta Selatan", "8123553678");
    
INSERT INTO Physician(id, physician_name, cert_num, field, address, phone_num) VALUES
	(5001, "Angelica Kristianto", "MED-5001", "OBGYN", "Bogor", "8889432255"),
    (5002, "Muhammad Sharif", "MED-5002", "Surgery", "Jakarta Selatan", "8889715243"),
    (5003, "Komang Maulana", "MED-5003", "Radiology", "Jakarta Selatan", "8880040006"),
    (5004, "Zaid Zakaria", "MED-5004", "Medicine", "Jakarta Selatan", "8885776846"),
    (5005, "Ibrahim Kartono", "MED-5005", "Cardiology", "Jakarta Utara", "8881234567"),
    (5006, "Valentina Yahya", "MED-5006", "Neurology", "Jakarta Utara", "8887005534");
    
INSERT INTO Nurse(id, name, cert_num, address, phone_num) VALUES
	(7001, "Gerard Wilson", "MED-7001", "Depok", "8882008567"),
    (7002, "Adisti Zulkarnaen", "MED-7002", "Depok", NULL),
    (7003, "Valeria Chan", "MED-7003", "Bekasi", "8881244533"),
    (7004, "Lavi Prihandoko", "MED-7004", "Bekasi", "8886872133"),
    (7005, "Joan Alvarez", "MED-7005", "Tangerang Selatan", "8881200998"),
    (7006, "Hamzah Salahuddin", "MED-7006", "Depok", NULL);
    
INSERT INTO Medication(code, name) VALUES
	(35001, "Ibuprofen"),
    (35002, "Morphine"),
    (35003, "Adderall"),
    (35004, "Oxycontin"),
    (35005, "Ativan"),
    (35006, "Narcan"),
    (35007, "Benadryl"),
    (35008, "Meloxicam"),
    (35009, "Flagyl"),
    (35010, "Tylenol"),
    (35011, "Benzonatate"),
    (35012, "Wellbutrin"),
    (35013, "Lyrica"),
    (35014, "Lorazepam"),
    (35015, "Cipro"); -- Examples from https://www.webmd.com/drugs/2/index
    
INSERT INTO Room(number, capacity, fee_nightly) VALUES
	(101, 4, 50), -- First floor: Basic rooms
    (102, 4, 50),
    (103, 4, 50),
    (104, 4, 50),
    (201, 2, 175), -- Second floor: Longer-term residents
    (202, 2, 175),
    (203, 2, 175),
    (204, 2, 175),
    (311, 1, 550), -- Third floor: Exclusive rooms
    (312, 1, 550),
    (411, 1, 2300), -- Fourth floor: VIP rooms
    (412, 1, 2300);

INSERT INTO Instruction(code, description, fee) VALUES
	(92001, "Blood Test", 25),
    (92002, "Endoscopy", 300),
    (92003, "X-Ray Scan", 270),
    (92004, "CT Scan", 5000),
    (92005, "Biopsy", 1600),
    (92006, "Genetic Testing", 2300),
    (92007, "MRI Scan", 2500),
    (92008, "PET Scan", 1900); -- Examples from https://www.merckmanuals.com/home/resources/common-medical-tests/common-medical-tests
    
INSERT INTO Health_Record(id, pat_id, disease, health_record_date, description, status) VALUES
	(100101, 1001, "Diabetes II", "2019-07-05", "Initial diagnosis", "Ongoing Treatment"),
    (100102, 1001, "Partial Blindness", "2004-11-22", "Found buildup of cataracts", "Not Treated"),
    (100103, 1001, "ADHD", "2018-08-31", "Prescribed Adderall", "On Medications"),
    (100601, 1006, "Generalised Anxiety Disorder", "2020-04-01", "Referred to another hospital for CBT", "Not Treated"),
    (100201, 1002, "Lower Body Paralysis", "1998-06-09", "Regular Physical Therapy until 2005", "Cured");

INSERT INTO Monitors(phy_id, pat_id, duration_hr) VALUES
	(5001, 1003, 4),
    (5001, 1007, 8),
    (5003, 1004, 4),
    (5003, 1009, 2),
    (5003, 1001, 3),
    (5004, 1002, 5),
    (5005, 1009, 2),
    (5006, 1008, 7);

INSERT INTO Hospitalised(pat_id, room_num, start_date, end_date) VALUES
	(1009, 412, "2023-04-10", "2023-04-13"),
    (1007, 203, "2023-04-17", "2023-04-18"),
    (1003, 101, "2023-03-29", "2023-04-05"),
    (1006, 101, "2023-03-30", "2023-04-02"),
    (1005, 101, "2023-04-01", "2023-04-07"),
    (1004, 201, "2023-04-11", "2023-04-13"),
    (1003, 204, "2023-04-10", "2023-04-16"),
    (1001, 201, "2023-04-13", "2023-04-15");

INSERT INTO Provide(nur_id, pat_id, med_code, dose) VALUES
	(7002, 1001, 35003, "10 mg"),
    (7006, 1006, 35003, "55 mg"),
    (7006, 1005, 35002, "0.15 mg, 4hr"),
    (7003, 1004, 35002, "0.17 mg, 4hr"),
    (7001, 1008, 35014, "4.88 mg, 2 days");

INSERT INTO Doctor_order(id, phy_id, pat_id, ins_code, order_date) VALUES
	(26131, 5001, 1003, 92001, "2023-03-29"),
    (26341, 5003, 1004, 92001, "2023-04-11"),
    (26342, 5003, 1004, 92007, "2023-04-11"),
    (26681, 5006, 1008, 92001, "2023-04-14"),
    (26391, 5003, 1009, 92004, "2023-04-10");

INSERT INTO Executes(ord_id, nur_id, executes_status, executes_date) VALUES
	(26131, 7001, "Ongoing", "2023-03-29"),
    (26341, 7004, "Not Executed", "2023-04-11"),
    (26342, 7004, "Completed", "2023-04-11"),
    (26681, 7002, "Ongoing", "2023-04-14"),
    (26391, 7003, "Completed", "2023-04-10");

INSERT INTO Invoice(id, pat_id, invoice_status, invoice_date) VALUES
	(88011, 1001, "Paid", "2023-04-17"),
    (88021, 1002, "Not Paid", "2023-04-20"),
    (88031, 1003, "Paid", "2023-04-06"),
    (88032, 1003, "Not Paid", "2023-04-18"),
    (88041, 1004, "Paid", "2023-04-15"),
    (88051, 1005, "Not Paid", "2023-04-07"),
    (88061, 1006, "Not Paid", "2023-04-05"),
    (88071, 1007, "Paid", "2023-04-18"),
    (88081, 1008, "Paid", "2023-04-15"),
    (88091, 1009, "Not Paid", "2023-04-16");

INSERT INTO Payable(inv_id, payable_type, amount, payable_date) VALUES
	(88011, "Rooms Total", 350, "2023-04-15"),
    (88031, "Rooms Total", 350, "2023-04-05"),
    (88031, "Instructions Total", 25, "2023-03-29"),
    (88032, "Rooms Total", 1050, "2023-04-16"),
    (88041, "Rooms Total", 350, "2023-04-13"),
    (88041, "Instructions Total", 2525, "2023-04-11"),
    (88051, "Rooms Total", 300, "2023-04-07"),
    (88061, "Rooms Total", 150, "2023-04-02"),
    (88071, "Rooms Total", 175, "2023-04-18"),
    (88081, "Instructions Total", 25, "2023-04-14"),
    (88091, "Rooms Total", 6900, "2023-04-13"),
    (88091, "Instructions Total", 5000, "2023-04-10");

