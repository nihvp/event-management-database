-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema EventManagement
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema EventManagement
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `EventManagement` DEFAULT CHARACTER SET utf8 ;
USE `EventManagement` ;

-- -----------------------------------------------------
-- Table `EventManagement`.`CLIENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EventManagement`.`CLIENT` (
  `ClientID` INT NOT NULL,
  `Cnumber` VARCHAR(45) NOT NULL,
  `Fname` VARCHAR(45) NOT NULL,
  `Lname` VARCHAR(45) NOT NULL,
  `Minit` CHAR(1) NULL,
  `Organization` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ClientID`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `EventManagement`.`VENUE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EventManagement`.`VENUE` (
  `VenueID` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Capacity` INT NOT NULL,
  `Rental_Cost` DECIMAL(8,2) NOT NULL,
  `Emirate` VARCHAR(45) NOT NULL,
  `Street` VARCHAR(45) NOT NULL,
  `Building` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`VenueID`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `EventManagement`.`EVENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EventManagement`.`EVENT` (
  `EventID` INT NOT NULL,
  `Date` DATE NOT NULL,
  `Type` VARCHAR(45) NOT NULL,
  `Budget` DECIMAL(12,2) NOT NULL,
  `Expected_Attendees` INT NULL,
  `CLIENT_ClientID` INT NOT NULL,
  `VENUE_VenueID` INT NOT NULL,
  PRIMARY KEY (`EventID`),
  INDEX `fk_EVENT_CLIENT1_idx` (`CLIENT_ClientID` ASC) VISIBLE,
  INDEX `fk_EVENT_VENUE1_idx` (`VENUE_VenueID` ASC) VISIBLE,
  CONSTRAINT `fk_EVENT_CLIENT1`
    FOREIGN KEY (`CLIENT_ClientID`)
    REFERENCES `EventManagement`.`CLIENT` (`ClientID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_EVENT_VENUE1`
    FOREIGN KEY (`VENUE_VenueID`)
    REFERENCES `EventManagement`.`VENUE` (`VenueID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `EventManagement`.`SUPPLIER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EventManagement`.`SUPPLIER` (
  `SupplierID` INT NOT NULL,
  `Cemail` VARCHAR(45) NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Service_Type` VARCHAR(45) NOT NULL,
  `Rating` INT NULL,
  PRIMARY KEY (`SupplierID`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `EventManagement`.`TASK`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EventManagement`.`TASK` (
  `TaskID` INT NOT NULL,
  `Description` VARCHAR(255) NOT NULL,
  `Deadline` DATETIME NOT NULL,
  `EVENT_EventID` INT NOT NULL,
  PRIMARY KEY (`TaskID`),
  INDEX `fk_TASK_EVENT1_idx` (`EVENT_EventID` ASC) VISIBLE,
  CONSTRAINT `fk_TASK_EVENT1`
    FOREIGN KEY (`EVENT_EventID`)
    REFERENCES `EventManagement`.`EVENT` (`EventID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `EventManagement`.`STAFF_MEMBER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EventManagement`.`STAFF_MEMBER` (
  `StaffID` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Cphone` VARCHAR(45) NOT NULL,
  `Salary` DECIMAL(8,2) NULL,
  PRIMARY KEY (`StaffID`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `EventManagement`.`SUPPLIES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EventManagement`.`SUPPLIES` (
  `EVENT_EventID` INT NOT NULL,
  `SUPPLIER_SupplierID` INT NOT NULL,
  `Cost` DECIMAL(10,2) NULL,
  PRIMARY KEY (`EVENT_EventID`, `SUPPLIER_SupplierID`),
  INDEX `fk_EVENT_has_SUPPLIER_SUPPLIER1_idx` (`SUPPLIER_SupplierID` ASC) VISIBLE,
  INDEX `fk_EVENT_has_SUPPLIER_EVENT_idx` (`EVENT_EventID` ASC) VISIBLE,
  CONSTRAINT `fk_EVENT_has_SUPPLIER_EVENT`
    FOREIGN KEY (`EVENT_EventID`)
    REFERENCES `EventManagement`.`EVENT` (`EventID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_EVENT_has_SUPPLIER_SUPPLIER1`
    FOREIGN KEY (`SUPPLIER_SupplierID`)
    REFERENCES `EventManagement`.`SUPPLIER` (`SupplierID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `EventManagement`.`ASSIGNED`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EventManagement`.`ASSIGNED` (
  `STAFF_MEMBER_StaffID` INT NOT NULL,
  `TASK_TaskID` INT NOT NULL,
  PRIMARY KEY (`STAFF_MEMBER_StaffID`, `TASK_TaskID`),
  INDEX `fk_STAFF_MEMBER_has_TASK_TASK1_idx` (`TASK_TaskID` ASC) VISIBLE,
  CONSTRAINT `fk_STAFF_MEMBER_has_TASK_STAFF_MEMBER1`
    FOREIGN KEY (`STAFF_MEMBER_StaffID`)
    REFERENCES `EventManagement`.`STAFF_MEMBER` (`StaffID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_STAFF_MEMBER_has_TASK_TASK1`
    FOREIGN KEY (`TASK_TaskID`)
    REFERENCES `EventManagement`.`TASK` (`TaskID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `EventManagement`.`INVOICE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EventManagement`.`INVOICE` (
  `InvoiceID` INT NOT NULL,
  `Issue_Date` DATE NOT NULL,
  `Total_Amount` DECIMAL(10,2) NOT NULL,
  `Invoice_Type` VARCHAR(45) NOT NULL,
  `Payment_Status` VARCHAR(45) NULL,
  `EVENT_EventID` INT NOT NULL,
  PRIMARY KEY (`InvoiceID`),
  INDEX `fk_INVOICE_EVENT1_idx` (`EVENT_EventID` ASC) VISIBLE,
  CONSTRAINT `fk_INVOICE_EVENT1`
    FOREIGN KEY (`EVENT_EventID`)
    REFERENCES `EventManagement`.`EVENT` (`EventID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `EventManagement`.`SERVICE_PACKAGE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EventManagement`.`SERVICE_PACKAGE` (
  `PackageID` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Package_Description` VARCHAR(255) NULL,
  `Base_Cost` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`PackageID`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `EventManagement`.`SUBSCRIBES_TO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EventManagement`.`SUBSCRIBES_TO` (
  `EVENT_EventID` INT NOT NULL,
  `SERVICE_PACKAGE_PackageID` INT NOT NULL,
  PRIMARY KEY (`EVENT_EventID`, `SERVICE_PACKAGE_PackageID`),
  INDEX `fk_EVENT_has_SERVICE_PACKAGE_SERVICE_PACKAGE1_idx` (`SERVICE_PACKAGE_PackageID` ASC) VISIBLE,
  CONSTRAINT `fk_EVENT_has_SERVICE_PACKAGE_EVENT1`
    FOREIGN KEY (`EVENT_EventID`)
    REFERENCES `EventManagement`.`EVENT` (`EventID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_EVENT_has_SERVICE_PACKAGE_SERVICE_PACKAGE1`
    FOREIGN KEY (`SERVICE_PACKAGE_PackageID`)
    REFERENCES `EventManagement`.`SERVICE_PACKAGE` (`PackageID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `EventManagement`;

DELIMITER $$
USE `EventManagement`$$
CREATE DEFINER = CURRENT_USER TRIGGER `EventManagement`.`EVENT_BEFORE_INSERT` BEFORE INSERT ON `EVENT` FOR EACH ROW
BEGIN
DECLARE venue_capacity INT;
  
  SELECT Capacity INTO venue_capacity FROM VENUE WHERE VenueID = NEW.VENUE_VenueID;
  
  IF NEW.Expected_Attendees IS NOT NULL AND NEW.Expected_Attendees > venue_capacity THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Expected attendees cannot exceed venue capacity';
  END IF;
END$$

USE `EventManagement`$$
CREATE DEFINER = CURRENT_USER TRIGGER `EventManagement`.`EVENT_BEFORE_UPDATE` BEFORE UPDATE ON `EVENT` FOR EACH ROW
BEGIN
DECLARE venue_capacity INT;
  
  SELECT Capacity INTO venue_capacity FROM VENUE WHERE VenueID = NEW.VENUE_VenueID;
  
  IF NEW.Expected_Attendees IS NOT NULL AND NEW.Expected_Attendees > venue_capacity THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Expected attendees cannot exceed venue capacity';
  END IF;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

USE `EventManagement` ;

START TRANSACTION;

-- DML Inserts
INSERT INTO CLIENT (ClientID, Cnumber, Fname, Lname, Minit, Organization) VALUES
(1, '0501111111', 'Ali', 'Hassan', 'A', 'Alpha Corp'),
(2, '0502222222', 'Sara', 'Khan', 'M', 'EventX'),
(3, '0503333333', 'Rami', 'Nader', 'S', 'Tech360'),
(4, '0504444444', 'Lina', 'Qadri', 'A', 'Future Vision'),
(5, '0505555555', 'Omar', 'Fahad', 'H', 'Skyline LLC'),
(6, '0506666666', 'Nora', 'Yousef', 'M', 'Digital House'),
(7, '0507777777', 'Hadi', 'Zain', 'K', 'CreativeHub'),
(8, '0508888888', 'Reem', 'Salim', 'L', 'SmartWorks'),
(9, '0509999999', 'Maya', 'Sami', 'J', 'Prime Media'),
(10,'0580000000','Yousef','Adnan','F','Bright Events');

INSERT INTO VENUE (VenueID, Name, Capacity, Rental_Cost, Emirate, Street, Building) VALUES
(1, 'Grand Hall', 500, 15000.00, 'Dubai', 'Sheikh Zayed Rd', 'Building 1'),
(2, 'Sky Ballroom', 300, 12000.00, 'Sharjah', 'Al Wahda St', 'Tower A'),
(3, 'Outdoor Arena', 1000, 25000.00, 'Dubai', 'Marina Walk', 'Zone 3'),
(4, 'Event Plaza', 200, 7000.00, 'Ajman', 'University St', 'Block D'),
(5, 'Royal Venue', 800, 18000.00, 'Abu Dhabi', 'Corniche Rd', 'Tower 9'),
(6, 'Expo Center', 1200, 30000.00, 'Sharjah', 'Expo Rd', 'Gate 2'),
(7, 'Community Hall', 150, 5000.00, 'Dubai', 'Al Barsha', 'Center 4'),
(8, 'Heritage Hall', 250, 9000.00, 'Ajman', 'Al Nuaimiya', 'Hall 2'),
(9, 'Innovation Hub', 400, 14000.00, 'Dubai', 'Internet City', 'Block B'),
(10,'Unity Center', 600, 20000.00, 'Abu Dhabi', 'Airport Rd', 'Unit 5');

INSERT INTO EVENT (EventID, Date, Type, Budget, Expected_Attendees, CLIENT_ClientID, VENUE_VenueID) VALUES
(1, '2025-01-10', 'Conference', 50000.00, 400, 1, 1),
(2, '2025-02-15', 'Wedding', 80000.00, 250, 2, 2),
(3, '2025-03-01', 'Expo', 120000.00, 900, 3, 3),
(4, '2025-03-20', 'Seminar', 20000.00, 150, 4, 4),
(5, '2025-04-01', 'Corporate Event', 60000.00, 700, 5, 5),
(6, '2025-04-10', 'Tech Summit', 90000.00, 1100, 6, 6),
(7, '2025-05-05', 'Meetup', 12000.00, 120, 7, 7),
(8, '2025-05-12', 'Charity Gala', 75000.00, 200, 8, 8),
(9, '2025-06-01', 'Product Launch', 45000.00, 350, 9, 9),
(10,'2025-06-15', 'Networking Event', 30000.00, 500, 10, 10);

INSERT INTO SUPPLIER (SupplierID, Cemail, Name, Service_Type, Rating) VALUES
(1, 's1@mail.com', 'Ace Catering', 'Catering', 5),
(2, 's2@mail.com', 'Pro Lights', 'Lighting', 4),
(3, 's3@mail.com', 'Flora Deco', 'Decoration', 5),
(4, 's4@mail.com', 'SoundMax', 'Audio', 3),
(5, 's5@mail.com', 'Elite Security', 'Security', 4),
(6, 's6@mail.com', 'Fresh Flowers', 'Decoration', 5),
(7, 's7@mail.com', 'Ultra Screens', 'AV Screens', 4),
(8, 's8@mail.com', 'Chef Master', 'Catering', 5),
(9, 's9@mail.com', 'Event Rentals', 'Equipment', 4),
(10,'s10@mail.com','TechVision', 'Technical', 5);

INSERT INTO TASK (TaskID, Description, Deadline, EVENT_EventID) VALUES
(1, 'Set up stage', '2025-01-09 10:00:00', 1),
(2, 'Arrange catering', '2025-02-14 11:00:00', 2),
(3, 'Prepare booths', '2025-02-28 12:00:00', 3),
(4, 'Arrange seating', '2025-03-19 10:00:00', 4),
(5, 'Install lighting', '2025-03-30 09:00:00', 5),
(6, 'Sound check', '2025-04-08 13:00:00', 6),
(7, 'Prepare badges', '2025-05-03 09:30:00', 7),
(8, 'Decoration setup', '2025-05-11 15:00:00', 8),
(9, 'Stage build', '2025-05-30 08:00:00', 9),
(10,'Registration desk', '2025-06-14 10:00:00', 10);

INSERT INTO STAFF_MEMBER (StaffID, Name, Cphone, Salary) VALUES
(1, 'Ahmed Saleh', '0521111111', 5000.00),
(2, 'Farah Ali', '0522222222', 4800.00),
(3, 'Ziad Karim', '0523333333', 5100.00),
(4, 'Hana Yusuf', '0524444444', 4700.00),
(5, 'Majed Omar', '0525555555', 5200.00),
(6, 'Sara Ahmed', '0526666666', 4900.00),
(7, 'Fadi Nabil', '0527777777', 5300.00),
(8, 'Laila Noor', '0528888888', 4600.00),
(9, 'Jad Sami', '0529999999', 5000.00),
(10,'Ruba Hassan','0581234567', 4800.00);

INSERT INTO SUPPLIES (EVENT_EventID, SUPPLIER_SupplierID, Cost) VALUES
(1, 1, 10000.00),
(1, 2, 7000.00),
(2, 1, 12000.00),
(2, 3, 9000.00),
(3, 4, 15000.00),
(3, 5, 8000.00),
(4, 6, 4000.00),
(5, 1, 11000.00),
(5, 7, 9000.00),
(6, 8, 15000.00),
(6, 9, 12000.00),
(7, 10, 5000.00),
(8, 3, 8000.00),
(9, 2, 6000.00),
(10,4, 7500.00);

INSERT INTO ASSIGNED (STAFF_MEMBER_StaffID, TASK_TaskID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8);

INSERT INTO INVOICE (InvoiceID, Issue_Date, Total_Amount, Invoice_Type, Payment_Status, EVENT_EventID) VALUES
(1, '2025-01-11', 25000.00, 'Advance', 'Paid', 1),
(2, '2025-02-16', 40000.00, 'Final', 'Pending', 2),
(3, '2025-03-02', 60000.00, 'Advance', 'Paid', 3),
(4, '2025-03-22', 15000.00, 'Final', 'Paid', 4),
(5, '2025-04-02', 30000.00, 'Advance', 'Pending', 5),
(6, '2025-04-11', 45000.00, 'Final', 'Paid', 6),
(7, '2025-05-06', 7000.00, 'Advance', 'Pending', 7),
(8, '2025-05-13', 35000.00, 'Final', 'Paid', 8),
(9, '2025-06-02', 22000.00, 'Advance', 'Paid', 9),
(10,'2025-06-16', 15000.00, 'Final', 'Pending', 10);

INSERT INTO SERVICE_PACKAGE (PackageID, Name, Package_Description, Base_Cost) VALUES
(1, 'Gold Package', 'All inclusive event services', 30000.00),
(2, 'Silver Package', 'Standard event services', 20000.00),
(3, 'Bronze Package', 'Basic services', 15000.00),
(4, 'Catering Premium', 'High-end catering service', 12000.00),
(5, 'Lighting Pro', 'Professional lighting setup', 8000.00),
(6, 'Sound Basic', 'Standard audio system', 6000.00),
(7, 'Decor Deluxe', 'Premium decoration service', 10000.00),
(8, 'Security Full', 'Full event security', 9000.00),
(9, 'AV Screens', 'LED screen setup', 11000.00),
(10,'Technical Support', 'Tech support package', 7000.00);

INSERT INTO SUBSCRIBES_TO (EVENT_EventID, SERVICE_PACKAGE_PackageID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 1),
(6, 5),
(7, 6),
(8, 7),
(9, 8),
(10,9);

COMMIT;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- MySQL Workbench Generated SQL File

-- Query a: List the name of the events that have the greatest number of assigned vendors
SELECT E.EventID, E.Type, COUNT(S.SUPPLIER_SupplierID) as No_of_Vendors
FROM EVENT AS E, SUPPLIES AS S
WHERE E.EventID = S.EVENT_EventID
GROUP BY E.EventID, E.Type
HAVING COUNT(S.SUPPLIER_SupplierID) = (
        SELECT MAX(No_Of_Vendors)
        FROM (
                SELECT COUNT(SUPPLIER_SupplierID) AS No_Of_Vendors
                FROM SUPPLIES
                GROUP BY EVENT_EventID
        ) as COUNTS
);

/* Output:
+---------+-----------------+---------------+
| EventID | Type            | No_of_Vendors |
+---------+-----------------+---------------+
|       1 | Conference      |             2 |
|       2 | Wedding         |             2 |
|       3 | Expo            |             2 |
|       5 | Corporate Event |             2 |
|       6 | Tech Summit     |             2 |
+---------+-----------------+---------------+
5 rows in set (0.00 sec)
*/

-- Query b: List the name of the venues that are used for some events
SELECT DISTINCT V.VenueID, V.Name
FROM VENUE AS V, EVENT AS E
WHERE V.VenueID = E.VENUE_VenueID;

/* Output:
+---------+----------------+
| VenueID | Name           |
+---------+----------------+
|       1 | Grand Hall     |
|       2 | Sky Ballroom   |
|       3 | Outdoor Arena  |
|       4 | Event Plaza    |
|       5 | Royal Venue    |
|       6 | Expo Center    |
|       7 | Community Hall |
|       8 | Heritage Hall  |
|       9 | Innovation Hub |
|      10 | Unity Center   |
+---------+----------------+
10 rows in set (0.00 sec)
*/

-- Query c: List the names of suppliers which have provided services for at least two different events
SELECT S.SupplierID, S.Name, COUNT(DISTINCT SP.EVENT_EventID) as No_of_Events
FROM SUPPLIER AS S, SUPPLIES AS SP
WHERE S.SupplierID = SP.SUPPLIER_SupplierID
GROUP BY S.SupplierID, S.Name
HAVING COUNT(DISTINCT SP.EVENT_EventID) >= 2;

/* Output:
+------------+--------------+--------------+
| SupplierID | Name         | No_of_Events |
+------------+--------------+--------------+
|          1 | Ace Catering |            3 |
|          2 | Pro Lights   |            2 |
|          3 | Flora Deco   |            2 |
|          4 | SoundMax     |            2 |
+------------+--------------+--------------+
4 rows in set (0.00 sec)
*/

-- Query d: Report the total budget for events, grouped by host clients
SELECT C.ClientID, C.Fname, C.Lname, C.Organization, SUM(E.Budget) as Total_Budget
FROM CLIENT AS C, EVENT AS E
WHERE E.CLIENT_ClientID = C.ClientID
GROUP BY C.ClientID, C.Fname, C.Lname, C.Organization;

/* Output:
+----------+--------+--------+---------------+--------------+
| ClientID | Fname  | Lname  | Organization  | Total_Budget |
+----------+--------+--------+---------------+--------------+
|        1 | Ali    | Hassan | Alpha Corp    |     50000.00 |
|        2 | Sara   | Khan   | EventX        |     80000.00 |
|        3 | Rami   | Nader  | Tech360       |    120000.00 |
|        4 | Lina   | Qadri  | Future Vision |     20000.00 |
|        5 | Omar   | Fahad  | Skyline LLC   |     60000.00 |
|        6 | Nora   | Yousef | Digital House |     90000.00 |
|        7 | Hadi   | Zain   | CreativeHub   |     12000.00 |
|        8 | Reem   | Salim  | SmartWorks    |     75000.00 |
|        9 | Maya   | Sami   | Prime Media   |     45000.00 |
|       10 | Yousef | Adnan  | Bright Events |     30000.00 |
+----------+--------+--------+---------------+--------------+
10 rows in set (0.00 sec)
*/

-- Query e: List the names of staff members who are not assigned to any task in any event
SELECT ST.StaffID, ST.Name
FROM STAFF_MEMBER AS ST
WHERE StaffID NOT IN (
        SELECT DISTINCT STAFF_MEMBER_StaffID
        FROM ASSIGNED
);

/* Output:
+---------+-------------+
| StaffID | Name        |
+---------+-------------+
|       9 | Jad Sami    |
|      10 | Ruba Hassan |
+---------+-------------+
2 rows in set (0.00 sec)
*/