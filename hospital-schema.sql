-- hospital-schema.sql
--
-- Define hospital schema
--
-- Raka Primardika (hybrid)
-- Russel Tjahjadi (in-person)

DROP DATABASE IF EXISTS hospital;
CREATE DATABASE hospital;
USE hospital;

CREATE TABLE IF NOT EXISTS Patient(
	id INT,
    name TEXT,
    address TEXT,
    phone_num TEXT,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Physician(
	id INT,
    physician_name TEXT,
    cert_num TEXT, 
    address TEXT,
    field TEXT, 
    phone_num TEXT,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Nurse(
	id INT,
	name TEXT,
    cert_num TEXT,
    address TEXT,
    phone_num TEXT,
    PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS Medication(
	code INT,
    name TEXT,
    PRIMARY KEY(code)
);

CREATE TABLE IF NOT EXISTS Room(
	number INT,
    capacity INT,
    fee_nightly INT,
    PRIMARY KEY (number)
);

CREATE TABLE IF NOT EXISTS Instruction(
	code INT, 
    description TEXT, 
    fee INT,
    PRIMARY KEY(code)
);

CREATE TABLE IF NOT EXISTS Health_Record(
	id INT,
    pat_id INT,
    status TEXT,
    description TEXT,
    disease TEXT,
	health_record_date DATE,
	PRIMARY KEY(id),
    FOREIGN KEY (pat_id) REFERENCES Patient(id)
);


CREATE TABLE IF NOT EXISTS Monitors(
	phy_id INT, 
    pat_id INT, 
    duration_hr INT,
	PRIMARY KEY (phy_id, pat_id),
    FOREIGN KEY (phy_id) REFERENCES Physician(id),
    FOREIGN KEY (pat_id) REFERENCES Patient(id)
);

CREATE TABLE IF NOT EXISTS Hospitalised(
	pat_id INT, 
    room_num INT, 
    start_date DATE,
    end_date DATE,
	PRIMARY KEY (pat_id, room_num),
    FOREIGN KEY (pat_id) REFERENCES Patient(id),
    FOREIGN KEY (Room_num) REFERENCES Room(number)
);

CREATE TABLE IF NOT EXISTS Provide(
	nur_id INT,
    pat_id INT, 
    med_code INT, 
    dose TEXT,
	PRIMARY KEY (nur_id, pat_id, med_code),
    FOREIGN KEY (pat_id) REFERENCES Patient(id),
    FOREIGN KEY  (nur_id) REFERENCES Nurse(id),
    FOREIGN KEY (Med_code) REFERENCES Medication(code)
);

CREATE TABLE IF NOT EXISTS Invoice(
	id INT, 
    pat_id INT, 
    invoice_status TEXT,
    invoice_date DATE,
    PRIMARY KEY (id),
    FOREIGN KEY (pat_id) REFERENCES  Patient(id)
);

CREATE TABLE IF NOT EXISTS Doctor_order(
	id INT,
    pat_id INT,
    phy_id INT, 
    ins_code INT, 
    order_date DATE,
	PRIMARY KEY (id),
    FOREIGN KEY (pat_id) references Patient(id),
    FOREIGN KEY (phy_id) references Physician(id),
    FOREIGN KEY (ins_code) references Instruction(code)
);

CREATE TABLE IF NOT EXISTS Executes(
	ord_id INT,
    nur_id INT,
    executes_status TEXT,
    executes_date DATE,
    PRIMARY KEY(ord_id, nur_id),
    FOREIGN KEY (ord_id) references Doctor_order(id),
	FOREIGN KEY (nur_id) references Nurse(id)
);

CREATE TABLE IF NOT EXISTS Payable(
	id INT NOT NULL AUTO_INCREMENT,
    inv_id INT,
    amount INT,
    payable_type TEXT,
    payable_date DATE,
	PRIMARY KEY (id),
    FOREIGN KEY (inv_id) REFERENCES Invoice(id)
);

ALTER TABLE Payable AUTO_INCREMENT = 41000;