CREATE DATABASE IF NOT EXISTS livestock_db;
USE livestock_db;

CREATE TABLE FARM (
    FarmID      INT AUTO_INCREMENT PRIMARY KEY,
    FarmName    VARCHAR(100) NOT NULL,
    Location    VARCHAR(150),
    Size        DECIMAL(10,2)   -- size in hectares
);

INSERT INTO FARM (FarmName, Location, Size) VALUES
('FUT Minna Teaching Farm', 'Gidan Kwano Campus, Minna', 12.5),
('Bosso Livestock Extension', 'Bosso Road, Minna', 8.0);

CREATE TABLE Housing (
    HousingID       INT AUTO_INCREMENT PRIMARY KEY,
    FarmID      INT NOT NULL,
    PenName     VARCHAR(50) NOT NULL,
    Capacity    INT,
    Type        VARCHAR(50),
    CONSTRAINT fk_pen_farm
        FOREIGN KEY (FarmID) REFERENCES FARM(FarmID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Housing (FarmID, PenName, Capacity, Type) VALUES
(1, 'Cattle Barn A', 20, 'Barn'),
(1, 'Goat Paddock 1', 15, 'Paddock'),
(1, 'Poultry House 1', 100, 'Coop'),
(2, 'Cattle Barn B', 25, 'Barn'),
(2, 'Sheep Paddock 1', 18, 'Paddock');

CREATE TABLE STAFF (
    StaffID     INT AUTO_INCREMENT PRIMARY KEY,
    FarmID      INT NOT NULL,
    Name        VARCHAR(100) NOT NULL,
    Role        VARCHAR(50),
    ContactInfo VARCHAR(100),
    CONSTRAINT fk_staff_farm
        FOREIGN KEY (FarmID) REFERENCES FARM(FarmID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO STAFF (FarmID, Name, Role, ContactInfo) VALUES
(1, 'Dr. Amina Bello', 'Veterinarian', 'amina.bello@futminna.edu.ng'),
(1, 'Chukwu Flora Chioma', 'Handler', '080100000001'),
(1, 'Kayode David Iyanu', 'Manager', '080100000002'),
(2, 'Dr. Ibrahim Suleiman', 'Veterinarian', 'ibrahim.suleiman@futminna.edu.ng'),
(2, 'Oyeleye Tolulope Oluwafemi', 'Handler', '080100000003');

CREATE TABLE ANIMAL (
    AnimalID    INT AUTO_INCREMENT PRIMARY KEY,
    HousingID       INT,
    TagNumber   VARCHAR(20) NOT NULL UNIQUE,
    Species     VARCHAR(50) NOT NULL,
    Breed       VARCHAR(50),
    DOB         DATE,
    Sex         ENUM('M','F'),
    Weight      DECIMAL(6,2),           -- kg
    Status      ENUM('Active','Sold','Deceased') NOT NULL DEFAULT 'Active',
    CONSTRAINT fk_animal_pen
        FOREIGN KEY (HousingID) REFERENCES Housing(HousingID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

INSERT INTO ANIMAL (HousingID, TagNumber, Species, Breed, DOB, Sex, Weight, Status) VALUES
(1, 'CTL-001', 'Cattle', 'White Fulani',   '2022-03-14', 'F', 320.50, 'Active'),
(1, 'CTL-002', 'Cattle', 'White Fulani',   '2021-11-02', 'M', 410.00, 'Active'),
(1, 'CTL-003', 'Cattle', 'Sokoto Gudali',  '2023-01-20', 'F', 280.75, 'Active'),
(2, 'GT-001',  'Goat',   'Red Sokoto',     '2023-06-10', 'F', 28.30,  'Active'),
(2, 'GT-002',  'Goat',   'Red Sokoto',     '2022-09-05', 'M', 35.10,  'Active'),
(2, 'GT-003',  'Goat',   'West African Dwarf', '2023-08-01', 'F', 22.00, 'Active'),
(3, 'PLT-001', 'Poultry','Broiler',        '2024-02-01', 'F', 2.10,   'Active'),
(3, 'PLT-002', 'Poultry','Broiler',        '2024-02-01', 'M', 2.35,   'Sold'),
(4, 'CTL-004', 'Cattle', 'Sokoto Gudali',  '2021-07-19', 'M', 450.20, 'Active'),
(4, 'CTL-005', 'Cattle', 'White Fulani',   '2022-12-11', 'F', 300.00, 'Deceased'),
(5, 'SHP-001', 'Sheep',  'Yankasa',        '2023-04-22', 'F', 40.50,  'Active'),
(5, 'SHP-002', 'Sheep',  'Balami',         '2022-10-30', 'M', 48.75,  'Active');

CREATE TABLE HEALTH_RECORD (
    RecordID    INT AUTO_INCREMENT PRIMARY KEY,
    AnimalID    INT NOT NULL,
    StaffID     INT,
    RecordDate  DATE NOT NULL,
    Type        VARCHAR(50),            -- vaccination / treatment / checkup
    Diagnosis   VARCHAR(150),
    Notes       TEXT,
    CONSTRAINT fk_health_animal
        FOREIGN KEY (AnimalID) REFERENCES ANIMAL(AnimalID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_health_staff
        FOREIGN KEY (StaffID) REFERENCES STAFF(StaffID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

INSERT INTO HEALTH_RECORD (AnimalID, StaffID, RecordDate, Type, Diagnosis, Notes) VALUES
(1, 1, '2026-01-10', 'Vaccination', 'FMD Vaccine', 'Routine biannual FMD vaccination'),
(2, 1, '2026-01-10', 'Vaccination', 'Anthrax Vaccine', 'Routine annual anthrax vaccination'),
(4, 1, '2026-02-15', 'Vaccination', 'PPR Vaccine', 'Routine PPR vaccination for small ruminants'),
(5, 1, '2026-03-01', 'Treatment', 'Foot Rot', 'Administered antibiotics, isolated for recovery'),
(7, 1, '2026-02-10', 'Vaccination', 'Newcastle Disease Vaccine', 'Routine poultry vaccination'),
(9, 4, '2026-01-20', 'Vaccination', 'CBPP Vaccine', 'Routine annual CBPP vaccination'),
(10,4, '2025-12-05', 'Treatment', 'Bloat', 'Animal did not respond to treatment, deceased 2025-12-08'),
(11,4, '2026-02-28', 'Vaccination', 'PPR Vaccine', 'Routine PPR vaccination; currently pregnant');

CREATE TABLE FEED_LOG (
    FeedLogID   INT AUTO_INCREMENT PRIMARY KEY,
    AnimalID    INT NOT NULL,
    FeedType    VARCHAR(50),
    Quantity    DECIMAL(6,2),           -- kg
    FeedDate    DATE NOT NULL,
    Cost        DECIMAL(8,2),
    CONSTRAINT fk_feed_animal
        FOREIGN KEY (AnimalID) REFERENCES ANIMAL(AnimalID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO FEED_LOG (AnimalID, FeedType, Quantity, FeedDate, Cost) VALUES
(1, 'Hay',        15.0, '2026-07-01', 4500.00),
(2, 'Hay',        18.0, '2026-07-01', 5400.00),
(4, 'Grain Mix',  3.0,  '2026-07-01', 1800.00),
(5, 'Grain Mix',  3.5,  '2026-07-01', 2100.00),
(7, 'Poultry Feed', 0.5, '2026-07-01', 600.00),
(9, 'Hay',        20.0, '2026-07-02', 6000.00),
(11,'Grass Silage', 5.0, '2026-07-02', 2500.00);

CREATE TABLE CUSTOMER (
    CustomerID  INT AUTO_INCREMENT PRIMARY KEY,
    Name        VARCHAR(100) NOT NULL,
    Phone       VARCHAR(20),
    Email       VARCHAR(100),
    Address     VARCHAR(150)
);

INSERT INTO CUSTOMER (Name, Phone, Email, Address) VALUES
('Musa Ibrahim', '080200000001', 'musa.ibrahim@example.com', 'Minna, Niger State'),
('Grace Okafor', '080200000002', 'grace.okafor@example.com', 'Bida, Niger State'),
('Suleiman Farms Ltd', '080200000003', 'contact@suleimanfarms.com', 'Kontagora, Niger State');

CREATE TABLE ANIMAL_TRANSACTION (
    TransactionID   INT AUTO_INCREMENT PRIMARY KEY,
    AnimalID        INT NOT NULL,
    `Type`          ENUM('Sale','Purchase') NOT NULL,
    TransactionDate DATE NOT NULL,
    Price           DECIMAL(10,2),
    CustomerID      INT NOT NULL,
    CONSTRAINT fk_transaction_animal
        FOREIGN KEY (AnimalID) REFERENCES ANIMAL(AnimalID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_transaction_customer
        FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO ANIMAL_TRANSACTION (AnimalID, CustomerID, `Type`, TransactionDate, Price) VALUES
(8, 1, 'Sale', '2026-05-15', 3500.00),        -- PLT-002 broiler (poultry, small-scale price)
(9, 3, 'Purchase', '2025-06-01', 650000.00),  -- CTL-004 Sokoto Gudali bull, 450kg, premium breed tier
(3, 2, 'Purchase', '2026-01-05', 320000.00),  -- CTL-003 Sokoto Gudali heifer, 280kg, medium-premium tier
(6, 1, 'Sale', '2026-06-01', 18000.00),       -- GT-003 West African Dwarf goat, southern market tier
(12,3, 'Purchase', '2025-09-10', 55000.00);   -- SHP-002 Balami ram, mid-range sheep tier

CREATE TABLE BREEDING_RECORD (
    BreedingID      INT AUTO_INCREMENT PRIMARY KEY,
    SireID          INT NOT NULL,
    DamID           INT NOT NULL,
    MatingDate      DATE,
    ExpectedDueDate DATE,
    OffspringID     INT,
    CONSTRAINT fk_breeding_sire
        FOREIGN KEY (SireID) REFERENCES ANIMAL(AnimalID)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_breeding_dam
        FOREIGN KEY (DamID) REFERENCES ANIMAL(AnimalID)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_breeding_offspring
        FOREIGN KEY (OffspringID) REFERENCES ANIMAL(AnimalID)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_sire_dam_different
        CHECK (SireID <> DamID)
);

INSERT INTO BREEDING_RECORD (SireID, DamID, MatingDate, ExpectedDueDate, OffspringID) VALUES
(2, 1, '2026-01-05', '2026-10-10', NULL),   -- Cattle: Sire CTL-002 x Dam CTL-001
(5, 4, '2026-02-01', '2026-07-05', NULL),   -- Goat:   Sire GT-002 x Dam GT-001
(12,11,'2025-11-20', '2026-04-19', NULL);   -- Sheep:  Sire SHP-002 x Dam SHP-001

