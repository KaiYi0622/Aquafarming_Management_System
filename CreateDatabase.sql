CREATE USER hit PROFILE "DEFAULT" IDENTIFIED BY abcd
DEFAULT TABLESPACE "USERS" TEMPORARY TABLESPACE "TEMP";

GRANT CONNECT TO hit;
GRANT create session, create table, unlimited tablespace to hit;

CONNECT hit /abcd;

-- Create tablespaceDROP TABLE Pond CASCADE CONSTRAINT;
DROP TABLE Fish CASCADE CONSTRAINT;
DROP TABLE Employee CASCADE CONSTRAINT;
DROP TABLE Rearing_batch CASCADE CONSTRAINT;
DROP TABLE Fish_behavior CASCADE CONSTRAINT;
DROP TABLE Water_quality CASCADE CONSTRAINT;
DROP TABLE Water_cleaning CASCADE CONSTRAINT;
DROP TABLE Feed CASCADE CONSTRAINT;
DROP TABLE Feeding_Activity CASCADE CONSTRAINT;
DROP TABLE Medication CASCADE CONSTRAINT;
DROP TABLE Med_activity CASCADE CONSTRAINT;
DROP TABLE Equipment CASCADE CONSTRAINT;
DROP TABLE Equipment_list CASCADE CONSTRAINT;
DROP TABLE Vendor CASCADE CONSTRAINT;
DROP TABLE Purchase_record CASCADE CONSTRAINT;
DROP TABLE Customer CASCADE CONSTRAINT;
DROP TABLE Sales CASCADE CONSTRAINT;
DROP TABLE Sales_detail CASCADE CONSTRAINT;
DROP TABLE Associated_cost CASCADE CONSTRAINT;

CREATE TABLE Pond
(Pond_ID VARCHAR2(6),
Pond_locate NUMBER(4),
Pond_size NUMBER(4),
CONSTRAINT Pond_Pond_ID_pk PRIMARY KEY (Pond_ID));

CREATE TABLE Fish
(Species_ID VARCHAR2(6),
Species_name VARCHAR2(30),
Weight_ref NUMBER(6),
Age_ref NUMBER(4),
Temperature_ref NUMBER(2),
pH_ref NUMBER(2),
Oxygen_ref NUMBER(4,2),
Ammonia_ref NUMBER(2),
Nitrate_ref NUMBER(6,2),
Predator VARCHAR2(30),
Market_value NUMBER(6,2),
CONSTRAINT Fish_Species_ID_pk PRIMARY KEY (Species_ID));

CREATE TABLE Employee
(Emp_ID VARCHAR2(6),
Emp_name VARCHAR2(30),
Emp_contact NUMBER(11),
Position VARCHAR2(20),
Salary NUMBER(6,2),
CONSTRAINT Employee_Emp_ID_pk PRIMARY KEY (Emp_ID));

CREATE TABLE Rearing_batch
(Batch_ID VARCHAR2(6),
Pond_ID VARCHAR2(6),
Species_ID VARCHAR2(6),
Emp_ID VARCHAR2(6),
Start_date DATE,
End_date DATE,
Stocking_dencity NUMBER(4),
CONSTRAINT Rearing_batch_Batch_ID_pk PRIMARY KEY (Batch_ID),
CONSTRAINT Rearing_batch_Pond_ID_fk FOREIGN KEY (Pond_ID) REFERENCES Pond (Pond_ID),
CONSTRAINT Rearing_batch_Species_ID_fk FOREIGN KEY (Species_ID) REFERENCES Fish (Species_ID),
CONSTRAINT Rearing_batch_Emp_ID_fk FOREIGN KEY (Emp_ID) REFERENCES Employee (Emp_ID));

CREATE TABLE Fish_behavior
(Fb_date DATE,
Batch_ID VARCHAR2(6),
Fish_mortality NUMBER(4),
Fish_health VARCHAR2(10),
Avg_weight NUMBER(6),
CONSTRAINT Fish_behavior_pk PRIMARY KEY (Fb_date, Batch_ID),
CONSTRAINT Fish_behavior_Batch_ID_fk FOREIGN KEY (Batch_ID) REFERENCES Rearing_batch(Batch_ID));

CREATE TABLE Water_quality
(Wq_date DATE,
Batch_ID VARCHAR2(6),
Temperature NUMBER(2),
pH NUMBER(2),
Dissolve_oxygen NUMBER(4,2),
Ammonia_concentration NUMBER(2),
Nitrate_concentration NUMBER(6,2),
CONSTRAINT Water_quality_pk PRIMARY KEY (Wq_date, Batch_ID),
CONSTRAINT Water_quality_Batch_ID_fk FOREIGN KEY (Batch_ID) REFERENCES Rearing_batch(Batch_ID));

CREATE TABLE Water_cleaning
(Wc_ID VARCHAR2(6),
Batch_ID VARCHAR2(6),
Wc_date DATE,
Water_inlet NUMBER(4),
Water_outlet NUMBER(4),
CONSTRAINT Water_cleaning_Wc_ID_pk PRIMARY KEY (Wc_ID));

CREATE TABLE Feed
(Feed_ID VARCHAR2(6),
Feed_name VARCHAR2(30),
Kg_per_pack NUMBER(6),
CONSTRAINT Feed_Feed_ID_pk PRIMARY KEY (Feed_ID));

CREATE TABLE Feeding_activity
(Feeding_ID VARCHAR2(6),
Batch_ID VARCHAR2(6),
Feed_Id VARCHAR2(6),
Feeding_date DATE,
Feeding_time TIMESTAMP,
Feeding_unit NUMBER(6),
CONSTRAINT Fa_Feeding_ID_pk PRIMARY KEY (Feeding_ID),
CONSTRAINT Fa_Batch_ID_fk FOREIGN KEY (Batch_ID) REFERENCES Rearing_batch (Batch_ID),
CONSTRAINT Fa_Feed_ID_fk FOREIGN KEY (Feed_ID) REFERENCES Feed (Feed_ID));

CREATE TABLE Medication
(Med_ID VARCHAR2(6),
Med_name VARCHAR2(30),
Dose_per_unit NUMBER(6),
Use_conditions VARCHAR2(80),
CONSTRAINT Medication_Med_ID_pk PRIMARY KEY (Med_ID));

CREATE TABLE Med_activity
(Med_use_ID VARCHAR2(6),
Batch_ID VARCHAR2(6),
Med_ID	VARCHAR2(6),
Med_date DATE,
Med_time TIMESTAMP,
Med_unit NUMBER(6,2),
Prescription VARCHAR2(80),
CONSTRAINT Med_activity_Med_use_ID_pk PRIMARY KEY (Med_use_ID),
CONSTRAINT Med_activity_Batch_ID_ID_fk FOREIGN KEY (Batch_ID) REFERENCES Rearing_batch(Batch_ID),
CONSTRAINT Med_activity_Med_ID_fk FOREIGN KEY (Med_ID) REFERENCES Medication(Med_ID));

CREATE TABLE Equipment
(Equip_ID VARCHAR2(6),
Equip_name VARCHAR2(30),
Depreciation_rate NUMBER(6),
CONSTRAINT Equipment_Equip_ID_pk PRIMARY KEY (Equip_ID));

CREATE TABLE Equipment_list
(Equip_ID VARCHAR2(6),
Pond_ID VARCHAR2(6),
Attached_quantity NUMBER(6),
CONSTRAINT Equipment_list_pk PRIMARY KEY (Equip_ID, Pond_ID),
CONSTRAINT Equipment_list_Equip_ID_fk FOREIGN KEY (Equip_ID) REFERENCES Equipment (Equip_ID),
CONSTRAINT Equipment_list_Pond_ID_fk FOREIGN KEY (Pond_ID) REFERENCES Pond (Pond_ID));

CREATE TABLE Vendor
(Vendor_ID VARCHAR2(6),
Vendor_name VARCHAR2(30),
Vendor_contact NUMBER(11),
Payment_term VARCHAR2(30),
CONSTRAINT Vendor_Vendor_ID_pk PRIMARY KEY (Vendor_ID));

CREATE TABLE Purchase_record
(Purchase_ID VARCHAR2(6),
Vendor_ID VARCHAR2(6),
Batch_ID VARCHAR2(6),
Feed_ID VARCHAR2(6),
Med_ID VARCHAR2(6),
Equip_ID VARCHAR2(6),
Purchase_cost NUMBER(8),
Purchase_unit NUMBER(6),
Purchase_date DATE,
CONSTRAINT Pr_Purchase_ID_pk PRIMARY KEY (Purchase_ID),
CONSTRAINT Pr_Vendor_ID_fk FOREIGN KEY (Vendor_ID) REFERENCES Vendor (Vendor_ID),
CONSTRAINT Pr_Batch_ID_fk FOREIGN KEY (Batch_ID) REFERENCES Rearing_batch(Batch_ID),
CONSTRAINT Pr_Feed_ID_fk FOREIGN KEY (Feed_ID) REFERENCES Feed(Feed_ID),
CONSTRAINT Pr_Med_ID_fk FOREIGN KEY (Med_ID) REFERENCES Medication(Med_ID),
CONSTRAINT Pr_Equip_ID_fk FOREIGN KEY (Equip_ID) REFERENCES Equipment(Equip_ID));

CREATE TABLE Customer
(Cust_ID VARCHAR2(6),
Cust_name VARCHAR2(30),
Cust_contact NUMBER(11),
Hse_no VARCHAR2(10),
Street VARCHAR2(30),
City VARCHAR2(30),
Postcode NUMBER(5),
State VARCHAR2(30),
CONSTRAINT Customer_Cust_ID_pk PRIMARY KEY (Cust_ID));

CREATE TABLE Sales
(Sales_ID VARCHAR2(6),
Emp_ID VARCHAR2(6),
Cust_ID VARCHAR2(6),
Date_sold DATE,
CONSTRAINT Sales_Sales_ID_pk PRIMARY KEY (Sales_ID),
CONSTRAINT Sales_Emp_ID_fk FOREIGN KEY (Emp_ID) REFERENCES Employee (Emp_ID),
CONSTRAINT Sales_Cust_ID_fk FOREIGN KEY (Cust_ID) REFERENCES Customer (Cust_ID));

CREATE TABLE Sales_detail
(Sales_ID VARCHAR2(6),
Batch_ID VARCHAR2(6),
Weight_sold NUMBER(6,2),
CONSTRAINT Sales_detail_pk PRIMARY KEY (Sales_ID, Batch_ID),
CONSTRAINT Sales_detail_Sales_ID_fk FOREIGN KEY (Sales_ID) REFERENCES Sales (Sales_ID),
CONSTRAINT Sales_detail_Batch_ID_fk FOREIGN KEY (Batch_ID) REFERENCES Rearing_batch (Batch_ID));

CREATE TABLE Associated_cost
(Period DATE,
Emp_ID VARCHAR2(6),
Water_bill NUMBER(6),
Electricity_bill NUMBER(6),
CONSTRAINT Associated_cost_Period_pk PRIMARY KEY (Period),
CONSTRAINT Associated_cost_Emp_ID_fk FOREIGN KEY (Emp_ID) REFERENCES Employee (Emp_ID));

CREATE TABLE Customer
(Cust_ID VARCHAR2(6),
Cust_name VARCHAR2(30),
Cust_contact NUMBER(11),
Hse_no VARCHAR2(10),
Street VARCHAR2(30),
City VARCHAR2(30),
Postcode NUMBER(5),
State VARCHAR2(30),
CONSTRAINT Customer_Cust_ID_pk PRIMARY KEY (Cust_ID));

CREATE TABLE Sales
(Sales_ID VARCHAR2(6),
Emp_ID VARCHAR2(6),
Cust_ID VARCHAR2(6),
Date_sold DATE,
CONSTRAINT Sales_Sales_ID_pk PRIMARY KEY (Sales_ID),
CONSTRAINT Sales_Emp_ID_fk FOREIGN KEY (Emp_ID) REFERENCES Employee (Emp_ID),
CONSTRAINT Sales_Cust_ID_fk FOREIGN KEY (Cust_ID) REFERENCES Customer (Cust_ID));

CREATE TABLE Sales_detail
(Sales_ID VARCHAR2(6),
Batch_ID VARCHAR2(6),
Weight_sold NUMBER(6,2),
CONSTRAINT Sales_detail_pk PRIMARY KEY (Sales_ID, Batch_ID),
CONSTRAINT Sales_detail_Sales_ID_fk FOREIGN KEY (Sales_ID) REFERENCES Sales (Sales_ID),
CONSTRAINT Sales_detail_Batch_ID_fk FOREIGN KEY (Batch_ID) REFERENCES Rearing_batch (Batch_ID));

CREATE TABLE Associated_cost
(Period DATE,
Emp_ID VARCHAR2(6),
Water_bill NUMBER(6),
Electricity_bill NUMBER(6),
CONSTRAINT Associated_cost_Period_pk PRIMARY KEY (Period),
CONSTRAINT Associated_cost_Emp_ID_fk FOREIGN KEY (Emp_ID) REFERENCES Employee (Emp_ID));

INSERT INTO Pond
VALUES ('P001', 1, 20);

INSERT INTO Pond
VALUES ('P002', 2, 40);

INSERT INTO Pond
VALUES ('P003', 3, 35);

INSERT INTO Pond
VALUES ('P004', 4, 20);

INSERT INTO Pond
VALUES ('P005', 5, 10);

INSERT INTO Fish
VALUES ('SP001', 'Tilapia', 40, 3, 28, 5, 0.10, 8, 10, 'bird', 17.00);

INSERT INTO Fish
VALUES ('SP002', 'Salmon', 30, 3, 28, 5, 0.10, 8, 10, 'bird', 19.00);

INSERT INTO Fish
VALUES ('SP003', 'Catfish', 50, 3, 28, 5, 0.10, 8, 10, 'bird', 12.00);

INSERT INTO Fish
VALUES ('SP004', 'Trout', 39, 3, 28, 5, 0.10, 8, 10, 'bird', 14.00);

INSERT INTO Fish
VALUES ('SP005', 'Carp', 35, 3, 28, 5, 0.10, 8, 10, 'bird', 10.00);

INSERT INTO Employee
VALUES ('EY001', 'Adrian', '0124587234', 'Fish farmer', '2000.00');

INSERT INTO Employee
VALUES ('EY002', 'Sylvia', '0175586281', 'Marketing', '2500.00');

INSERT INTO Employee
VALUES ('EY003', 'Abu', '0165271942', 'Fish farmer', '2000.00');

INSERT INTO Rearing_batch
VALUES ('B001', 'P001', 'SP001', 'EY001',  TO_DATE ('01/08/2024', 'DD/MM/YYYY'), TO_DATE ('01/01/2024', 'DD/MM/YYYY'), 30);

INSERT INTO Rearing_batch
VALUES ('B002', 'P002', 'SP002', 'EY001', TO_DATE ('20/08/2024', 'DD/MM/YYYY'), TO_DATE ('30/01/2024', 'DD/MM/YYYY'), 50);

INSERT INTO Rearing_batch
VALUES ('B003', 'P003', 'SP003', 'EY003', TO_DATE ('05/09/2024', 'DD/MM/YYYY'), TO_DATE ('26/01/2024', 'DD/MM/YYYY'), 35);

INSERT INTO Rearing_batch
VALUES ('B004', 'P004', 'SP004', 'EY003', TO_DATE ('15/09/2024', 'DD/MM/YYYY'), TO_DATE ('05/02/2024', 'DD/MM/YYYY'), 18);

INSERT INTO Rearing_batch
VALUES ('B005', 'P004', 'SP001', 'EY003', TO_DATE ('15/09/2023', 'DD/MM/YYYY'), TO_DATE ('05/02/2024', 'DD/MM/YYYY'), 18);

INSERT INTO Fish_behavior
VALUES (TO_DATE('01/08/2023', 'DD/MM/YYYY'), 'B001', 0, 'Good', 10);

INSERT INTO Fish_behavior
VALUES (TO_DATE('07/08/2023', 'DD/MM/YYYY'), 'B001', 6, 'Unhealthy', 18);

INSERT INTO Fish_behavior
VALUES (TO_DATE('20/09/2023', 'DD/MM/YYYY'), 'B002', 15, 'Good', 20);

INSERT INTO Fish_behavior
VALUES (TO_DATE('15/12/2023', 'DD/MM/YYYY'), 'B003', 25, 'Good', 29);

INSERT INTO Fish_behavior
VALUES (TO_DATE('10/01/2023', 'DD/MM/YYYY'), 'B004', 18, 'Good', 42);

INSERT INTO Water_quality
VALUES (TO_DATE('01/08/2023', 'DD/MM/YYYY'), 'B001', 27, 5, 0.10, 8, 8);

INSERT INTO Water_quality
VALUES (TO_DATE('02/08/2023', 'DD/MM/YYYY'), 'B001', 32, 6, 0.04, 8, 8);

INSERT INTO Water_quality
VALUES (TO_DATE('03/08/2023', 'DD/MM/YYYY'), 'B001', 26, 5, 0.08, 8, 8);

INSERT INTO Water_quality
VALUES (TO_DATE('07/08/2023', 'DD/MM/YYYY'), 'B001', 26, 5, 0.05, 5, 8);

INSERT INTO Water_cleaning
VALUES ('WC001', 'B001', TO_DATE('07/08/2024', 'DD/MM/YYYY'), 5, 8);
 
INSERT INTO Water_cleaning
VALUES ('WC002', 'B001', TO_DATE('14/08/2024', 'DD/MM/YYYY'), 7, 10);

INSERT INTO Water_cleaning
VALUES ('WC003', 'B001', TO_DATE('21/08/2024', 'DD/MM/YYYY'), 6, 9); 

INSERT INTO Feed
VALUES ('F001', 'Skretting', 1);

INSERT INTO Feed
VALUES ('F002', 'Purina', 2);

INSERT INTO Feed
VALUES ('F003', 'Aller Aqua', 1);

INSERT INTO Feeding_Activity
VALUES ('FA001', 'B001', 'F001', TO_DATE('01/08/2024', 'DD/MM/YYYY'), TO_TIMESTAMP('2023-08-01 12:00:02', 'YYYY-MM-DD HH24:MI:SS'), 40);

INSERT INTO Feeding_Activity
VALUES ('FA008', 'B001', 'F001', TO_DATE('07/08/2024', 'DD/MM/YYYY'), TO_TIMESTAMP('2023-08-07 18:30:10', 'YYYY-MM-DD HH24:MI:SS'), 35);

INSERT INTO Feeding_Activity
VALUES ('FA015', 'B001', 'F001', TO_DATE('14/08/2024', 'DD/MM/YYYY'), TO_TIMESTAMP('2023-08-14 12:02:50', 'YYYY-MM-DD HH24:MI:SS'), 25);

INSERT INTO Feeding_Activity
VALUES ('FA045', 'B002', 'F003', TO_DATE('10/10/2024', 'DD/MM/YYYY'), TO_TIMESTAMP('2023-10-10 12:03:56', 'YYYY-MM-DD HH24:MI:SS'), 52);

INSERT INTO Feeding_Activity
VALUES ('FA096', 'B002', 'F003', TO_DATE('10/11/2024', 'DD/MM/YYYY'), TO_TIMESTAMP('2023-11-10 12:10:26', 'YYYY-MM-DD HH24:MI:SS'), 48);

INSERT INTO Medication
VALUES ('M001', 'Salt', 1, 'Improve water quality');

INSERT INTO Medication
VALUES ('M002', 'Antibacterial', 5, 'Control bacterial infections');

INSERT INTO Medication
VALUES ('M003', 'Hydrogen Peroxide', 1, 'Treat external perasites');

INSERT INTO Med_activity
VALUES ('MA_001', 'B001', 'M002', TO_DATE('02/08/2024', 'DD/MM/YYYY'), TO_TIMESTAMP('2023-08-02 15:20:42', 'YYYY-MM-DD HH24:MI:SS'), 0.50, 'The mortality is high');

INSERT INTO Med_activity
VALUES ('MA_002', 'B001', 'M001', TO_DATE('07/08/2024', 'DD/MM/YYYY'), TO_TIMESTAMP('2023-08-07 10:08:08', 'YYYY-MM-DD HH24:MI:SS'), 0.30, 'The water quality is below average');

INSERT INTO Med_activity
VALUES ('MA_015', 'B002', 'M003', TO_DATE('12/10/2024', 'DD/MM/YYYY'), TO_TIMESTAMP('2023-10-12 12:00:02', 'YYYY-MM-DD HH24:MI:SS'), 0.10, 'There is too much algae in the pond');

INSERT INTO Equipment
VALUES ('EM001', 'Pipe', 10);

INSERT INTO Equipment
VALUES ('EM002', 'Pumps and filter', 10);

INSERT INTO Equipment
VALUES ('EM003', 'Feeding Equipment', 10);

INSERT INTO Equipment
VALUES ('EM004', 'Netting and fencing', 10);

INSERT INTO Equipment
VALUES ('EM005', 'Pipe', 10);

INSERT INTO Equipment_list
VALUES ('EM001', 'P001', 8);

INSERT INTO Equipment_list
VALUES ('EM002', 'P001', 6);

INSERT INTO Equipment_list
VALUES ('EM003', 'P001', 2);

INSERT INTO Equipment_list
VALUES ('EM004', 'P001', 5);

INSERT INTO Equipment_list
VALUES ('EM001', 'P002', 8);

INSERT INTO Vendor
VALUES ('V001', 'Ali', '0102257963', 'Credit');

INSERT INTO Vendor
VALUES ('V002', 'Daniel', '0139856742', 'Credit');

INSERT INTO Vendor
VALUES ('V003', 'Faiz', '0162274695', 'Credit');

INSERT INTO Purchase_record
VALUES ('PR001', 'V001', 'B001', NULL, NULL, NULL, 250, 25, TO_DATE('30/05/2024', 'DD/MM/YYYY'));

INSERT INTO Purchase_record
VALUES ('PR002', 'V003', NULL, NULL, NULL, 'EM001', 300, 16, TO_DATE('25/07/2024', 'DD/MM/YYYY'));

INSERT INTO Purchase_record
VALUES ('PR003', 'V002', NULL, 'F001', NULL, NULL, 150, 40, TO_DATE('25/07/2024', 'DD/MM/YYYY'));

INSERT INTO Purchase_record
VALUES ('PR004', 'V001', NULL, NULL, 'M001', NULL, 200, 20, TO_DATE('25/07/2024', 'DD/MM/YYYY'));

INSERT INTO Purchase_record
VALUES ('PR008', 'V001', NULL, NULL, NULL, 'EM001', 200, 30, TO_DATE('15/08/2024', 'DD/MM/YYYY'));

INSERT INTO Customer
VALUES ('C001', 'Patrick', '0186421869', '16', 'Jalan Emperik', 'Cheras', '56000', 'Kuala Lumpur');

INSERT INTO Customer
VALUES ('C002', 'Christine', '0167549213', '20-1-2', 'Jalan Usaha', 'Kajang', '43200', 'Selangor');

INSERT INTO Customer
VALUES ('C003', 'Mandy', '0174512678', '20', 'Jalan Bintang', 'Puchong', '47100', 'Selangor');

INSERT INTO Sales
VALUES ('S001', 'EY002', 'C002', TO_DATE('12/11/2024', 'DD/MM/YYYY'));

INSERT INTO Sales
VALUES ('S008', 'EY002', 'C001', TO_DATE('12/12/2024', 'DD/MM/YYYY'));

INSERT INTO Sales
VALUES ('S012', 'EY002', 'C003', TO_DATE('01/01/2024', 'DD/MM/YYYY'));

INSERT INTO Sales
VALUES ('S055', 'EY002', 'C002', TO_DATE('01/02/2024', 'DD/MM/YYYY'));

INSERT INTO Sales_detail
VALUES ('S001', 'B001', 500.00);

INSERT INTO Sales_detail
VALUES ('S001', 'B002', 600.00);

INSERT INTO Sales_detail
VALUES ('S001', 'B003', 700.00);

INSERT INTO Sales_detail
VALUES ('S008', 'B001', 500.00);

INSERT INTO Sales_detail
VALUES ('S008', 'B002', 800.00);

INSERT INTO Sales_detail
VALUES ('S012', 'B003', 900.00);

INSERT INTO Sales_detail
VALUES ('S055', 'B005', 21.00);

INSERT INTO Associated_cost
VALUES (TO_DATE('30/09/2024', 'DD/MM/YYYY'), 'EY001', 200, 200);

INSERT INTO Associated_cost
VALUES (TO_DATE('31/10/2024', 'DD/MM/YYYY'), 'EY001', 100, 300);

INSERT INTO Associated_cost
VALUES (TO_DATE('30/11/2024', 'DD/MM/YYYY'), 'EY001', 300, 200);