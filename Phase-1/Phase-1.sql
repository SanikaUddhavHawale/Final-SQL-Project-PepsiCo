-- ==============================================================
-- Project: PepsiCo Pvt. Ltd. Database Management System
-- Author: [Your Name]
-- Phase-1: Database Design, Table Creation, Constraints
-- ==============================================================

CREATE DATABASE PepsiCoDB;
USE PepsiCoDB;

-- ==============================================================
-- 1. Locations
-- ==============================================================
CREATE TABLE Locations (
    LocationID INT PRIMARY KEY AUTO_INCREMENT,
    LocationName VARCHAR(100) NOT NULL,
    Address VARCHAR(200),
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    PostalCode VARCHAR(10),
    Region VARCHAR(50),
    ContactNo VARCHAR(15),
    Email VARCHAR(100)
);

-- ==============================================================
-- 2. Departments
-- ==============================================================
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100) UNIQUE NOT NULL,
    LocationID INT,
    ManagerID INT,
    Budget DECIMAL(12,2),
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);

-- ==============================================================
-- 3. Employees
-- ==============================================================
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50),
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
    DOB DATE,
    HireDate DATE NOT NULL,
    DepartmentID INT,
    Designation VARCHAR(100),
    Salary DECIMAL(10,2) CHECK (Salary > 0),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15) UNIQUE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- ==============================================================
-- 4. Categories
-- ==============================================================
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) UNIQUE,
    Description TEXT,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    ActiveStatus BOOLEAN DEFAULT TRUE,
    TaxRate DECIMAL(5,2),
    HSNCode VARCHAR(20),
    GSTApplicable BOOLEAN DEFAULT TRUE,
    ParentCategoryID INT,
    FOREIGN KEY (ParentCategoryID) REFERENCES Categories(CategoryID)
);


-- ==============================================================
-- 5. Suppliers
-- ==============================================================
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierName VARCHAR(100),
    ContactPerson VARCHAR(100),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Address VARCHAR(200),
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    GSTNumber VARCHAR(20) UNIQUE
);

-- ==============================================================
-- 6. Products
-- ==============================================================
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT,
    UnitPrice DECIMAL(8,2) CHECK (UnitPrice > 0),
    UnitsInStock INT DEFAULT 0,
    ReorderLevel INT DEFAULT 10,
    SupplierID INT,
    ExpiryDate DATE,
    ManufacturedDate DATE,
    Description TEXT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- ==============================================================
-- 7. Customers
-- ==============================================================
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    Address VARCHAR(200),
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    RegistrationDate DATE,
    LoyaltyPoints INT DEFAULT 0
);


-- ==============================================================
-- 8. Orders
-- ==============================================================
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    EmployeeID INT,
    OrderDate DATE,
    ShipDate DATE,
    ShippingMethod VARCHAR(50),
    TotalAmount DECIMAL(10,2),
    PaymentStatus VARCHAR(20) CHECK (PaymentStatus IN ('Pending','Paid','Cancelled')),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- ==============================================================
-- 9. OrderDetails
-- ==============================================================
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT CHECK (Quantity > 0),
    UnitPrice DECIMAL(8,2),
    Discount DECIMAL(5,2) DEFAULT 0,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- ==============================================================
-- 10. Payments
-- ==============================================================
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    PaymentDate DATE,
    PaymentMode VARCHAR(50),
    Amount DECIMAL(10,2),
    TransactionID VARCHAR(50) UNIQUE,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- ==============================================================
-- 11. Inventory
-- ==============================================================
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT,
    WarehouseID INT,
    QuantityAvailable INT DEFAULT 0,
    LastUpdated DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- ==============================================================
-- 12. Warehouses
-- ==============================================================
CREATE TABLE Warehouses (
    WarehouseID INT PRIMARY KEY AUTO_INCREMENT,
    WarehouseName VARCHAR(100),
    LocationID INT,
    Capacity INT,
    ManagerID INT,
    ContactNo VARCHAR(15),
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);

-- ==============================================================
-- 13. RawMaterials
-- ==============================================================
CREATE TABLE RawMaterials (
    MaterialID INT PRIMARY KEY AUTO_INCREMENT,
    MaterialName VARCHAR(100),
    SupplierID INT,
    UnitPrice DECIMAL(8,2),
    QuantityInStock INT,
    ReorderLevel INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- ==============================================================
-- 14. ProductionBatch
-- ==============================================================
CREATE TABLE ProductionBatch (
    BatchID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT,
    MaterialID INT,
    BatchDate DATE,
    QuantityProduced INT,
    ProducedBy INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (MaterialID) REFERENCES RawMaterials(MaterialID),
    FOREIGN KEY (ProducedBy) REFERENCES Employees(EmployeeID)
);

-- ==============================================================
-- 15. QualityCheck
-- ==============================================================
CREATE TABLE QualityCheck (
    QCID INT PRIMARY KEY AUTO_INCREMENT,
    BatchID INT,
    QCDate DATE,
    CheckedBy INT,
    Status VARCHAR(20) CHECK (Status IN ('Passed','Failed','Pending')),
    Remarks TEXT,
    FOREIGN KEY (BatchID) REFERENCES ProductionBatch(BatchID),
    FOREIGN KEY (CheckedBy) REFERENCES Employees(EmployeeID)
);

-- ==============================================================
-- 16. Distributors
-- ==============================================================
CREATE TABLE Distributors (
    DistributorID INT PRIMARY KEY AUTO_INCREMENT,
    DistributorName VARCHAR(100),
    ContactPerson VARCHAR(100),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    CreditLimit DECIMAL(10,2)
);

-- ==============================================================
-- 17. Retailers
-- ==============================================================
CREATE TABLE Retailers (
    RetailerID INT PRIMARY KEY AUTO_INCREMENT,
    RetailerName VARCHAR(100),
    DistributorID INT,
    City VARCHAR(100),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    FOREIGN KEY (DistributorID) REFERENCES Distributors(DistributorID)
);

-- ==============================================================
-- 18. Shipments
-- ==============================================================
CREATE TABLE Shipments (
    ShipmentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    WarehouseID INT,
    ShipmentDate DATE,
    DeliveryDate DATE,
    TransportID INT,
    Status VARCHAR(20) CHECK (Status IN ('In Transit','Delivered','Cancelled')),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID)
);

-- ==============================================================
-- 19. Transport
-- ==============================================================
CREATE TABLE Transport (
    TransportID INT PRIMARY KEY AUTO_INCREMENT,
    TransportCompany VARCHAR(100),
    DriverName VARCHAR(100),
    VehicleNo VARCHAR(20),
    ContactNo VARCHAR(15),
    Route VARCHAR(100),
    CostPerKM DECIMAL(8,2)
);

-- ==============================================================
-- 20. Machines
-- ==============================================================
CREATE TABLE Machines (
    MachineID INT PRIMARY KEY AUTO_INCREMENT,
    MachineName VARCHAR(100),
    PurchaseDate DATE,
    MaintenanceCycle INT,
    Status VARCHAR(20) CHECK (Status IN ('Active','Inactive','Under Maintenance')),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- ==============================================================
-- 21. Maintenance
-- ==============================================================
CREATE TABLE Maintenance (
    MaintenanceID INT PRIMARY KEY AUTO_INCREMENT,
    MachineID INT,
    TechnicianID INT,
    MaintenanceDate DATE,
    Cost DECIMAL(10,2),
    Remarks TEXT,
    FOREIGN KEY (MachineID) REFERENCES Machines(MachineID),
    FOREIGN KEY (TechnicianID) REFERENCES Employees(EmployeeID)
);

-- ==============================================================
-- 22. MarketingCampaigns
-- ==============================================================
CREATE TABLE MarketingCampaigns (
    CampaignID INT PRIMARY KEY AUTO_INCREMENT,
    CampaignName VARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    Budget DECIMAL(12,2),
    TargetRegion VARCHAR(100),
    ManagerID INT,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

-- ==============================================================
-- 23. SalesTargets
-- ==============================================================
CREATE TABLE SalesTargets (
    TargetID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    TargetMonth VARCHAR(20),
    TargetAmount DECIMAL(10,2),
    AchievedAmount DECIMAL(10,2),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- ==============================================================
-- 24. EmployeeAttendance
-- ==============================================================
CREATE TABLE EmployeeAttendance (
    AttendanceID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    AttendanceDate DATE,
    Status VARCHAR(10) CHECK (Status IN ('Present','Absent','Leave')),
    CheckInTime TIME,
    CheckOutTime TIME,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- ==============================================================
-- 25. Feedback
-- ==============================================================
CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    ProductID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comments TEXT,
    FeedbackDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- ==============================================================
-- SAMPLE BASIC QUERIES (for screenshots/documentation)
-- ==============================================================

-- SELECT Queries
SELECT * FROM Employees;
SELECT * FROM Products;
SELECT * FROM Orders WHERE PaymentStatus = 'Pending';

-- TRUNCATE and DROP (for demonstration)
-- TRUNCATE TABLE Feedback;
-- DROP TABLE Feedback;



/* ---------------------------
   1) Locations (20 rows)
   --------------------------- */
INSERT INTO Locations (LocationName, Address, City, State, Country, PostalCode, Region, ContactNo, Email) VALUES
('Mumbai HQ','12 Corporate Ave, Bandra East','Mumbai','Maharashtra','India','400051','West','+91-22-40001001','mumbai.hq@pepsico.co.in'),
('Pune Plant','45 Industrial Park, Pimpri','Pune','Maharashtra','India','411018','West','+91-20-40001002','pune.plant@pepsico.co.in'),
('Bengaluru Office','88 Tech Park Road','Bengaluru','Karnataka','India','560068','South','+91-80-40001003','bengaluru.office@pepsico.co.in'),
('Delhi Office','101 Business Center, Nehru Place','New Delhi','Delhi','India','110019','North','+91-11-40001004','delhi.office@pepsico.co.in'),
('Kolkata Depot','7 Riverside Road','Kolkata','West Bengal','India','700091','East','+91-33-40001005','kolkata.depot@pepsico.co.in'),
('Chennai Plant','22 Manufacturing Lane','Chennai','Tamil Nadu','India','600032','South','+91-44-40001006','chennai.plant@pepsico.co.in'),
('Ahmedabad Office','9 Central Plaza','Ahmedabad','Gujarat','India','380009','West','+91-79-40001007','ahmedabad.office@pepsico.co.in'),
('Hyderabad Warehouse','30 Logistics Park','Hyderabad','Telangana','India','500081','South','+91-40-40001008','hyderabad.wh@pepsico.co.in'),
('Noida Sales','5 Sector Road','Noida','Uttar Pradesh','India','201301','North','+91-120-40001009','noida.sales@pepsico.co.in'),
('Surat Depot','14 Trade Street','Surat','Gujarat','India','395004','West','+91-261-40001010','surat.depot@pepsico.co.in'),
('Lucknow Office','2 Corporate Tower','Lucknow','Uttar Pradesh','India','226001','North','+91-522-40001011','lucknow.office@pepsico.co.in'),
('Nagpur Distribution','18 Central Logistics','Nagpur','Maharashtra','India','440001','Central','+91-712-40001012','nagpur.dist@pepsico.co.in'),
('Coimbatore Plant','66 Textile Road','Coimbatore','Tamil Nadu','India','641018','South','+91-422-40001013','coimbatore.plant@pepsico.co.in'),
('Vishakhapatnam Depot','11 Harbor Road','Visakhapatnam','Andhra Pradesh','India','530017','South','+91-891-40001014','vizag.depot@pepsico.co.in'),
('Indore Office','27 Industrial Estate','Indore','Madhya Pradesh','India','452010','Central','+91-731-40001015','indore.office@pepsico.co.in'),
('Bhopal Warehouse','3 Logistic Ring','Bhopal','Madhya Pradesh','India','462001','Central','+91-755-40001016','bhopal.wh@pepsico.co.in'),
('Jaipur Depot','50 Pink City Road','Jaipur','Rajasthan','India','302001','North','+91-141-40001017','jaipur.depot@pepsico.co.in'),
('Bhubaneswar Office','8 Odisha Plaza','Bhubaneswar','Odisha','India','751001','East','+91-674-40001018','bhubaneswar.office@pepsico.co.in'),
('Ernakulam Plant','40 Backwater Ave','Kochi','Kerala','India','682016','South','+91-484-40001019','kochi.plant@pepsico.co.in'),
('Goa Distribution','12 Seaside Road','Panaji','Goa','India','403001','West','+91-832-40001020','goa.dist@pepsico.co.in');

-- ---------------------------
-- 2) Departments (20 rows)
-- Note: LocationID values reference the 20 rows above (1..20)
-- --------------------------- 
INSERT INTO Departments (DepartmentName, LocationID, ManagerID, Budget) VALUES
('Manufacturing',1,NULL,20000000.00),
('Quality Assurance',2,NULL,5000000.00),
('Sales - North',3,NULL,8000000.00),
('Sales - South',4,NULL,8000000.00),
('Logistics',5,NULL,10000000.00),
('Human Resources',6,NULL,3000000.00),
('Finance',7,NULL,12000000.00),
('R&D',8,NULL,15000000.00),
('Procurement',9,NULL,7000000.00),
('IT',10,NULL,9000000.00),
('Marketing',11,NULL,11000000.00),
('Customer Service',12,NULL,2500000.00),
('Legal',13,NULL,2000000.00),
('Supply Chain',14,NULL,13000000.00),
('Export',15,NULL,6000000.00),
('Warehouse Ops',16,NULL,4000000.00),
('Product Development',17,NULL,14000000.00),
('Business Analytics',18,NULL,3500000.00),
('Health & Safety',19,NULL,1800000.00),
('Corporate Affairs',20,NULL,16000000.00);

-- ---------------------------
-- 3) Employees (20 rows)
-- Note: DepartmentID references Departments (1..20). Emails & Phones unique.
-- ---------------------------
INSERT INTO Employees (FirstName, LastName, Gender, DOB, HireDate, DepartmentID, Designation, Salary, Email, Phone) VALUES
('Amit','Sharma','M','1985-06-12','2015-03-01',1,'Plant Manager',95000.00,'amit.sharma@pepsico.co.in','+91-9000100101'),
('Priya','Verma','F','1990-11-23','2018-07-15',2,'QA Lead',65000.00,'priya.verma@pepsico.co.in','+91-9000100102'),
('Rakesh','Patel','M','1988-02-10','2016-01-05',3,'Regional Sales Manager',72000.00,'rakesh.patel@pepsico.co.in','+91-9000100103'),
('Sneha','Iyer','F','1992-09-30','2019-04-20',4,'Sales Executive',42000.00,'sneha.iyer@pepsico.co.in','+91-9000100104'),
('Vikram','Singh','M','1983-12-05','2012-10-01',5,'Logistics Head',88000.00,'vikram.singh@pepsico.co.in','+91-9000100105'),
('Neha','Kumar','F','1994-05-18','2020-02-10',6,'HR Manager',62000.00,'neha.kumar@pepsico.co.in','+91-9000100106'),
('Rahul','Mehta','M','1986-08-22','2014-06-18',7,'Finance Controller',99000.00,'rahul.mehta@pepsico.co.in','+91-9000100107'),
('Anita','Rao','F','1989-03-14','2017-09-12',8,'R&D Scientist',78000.00,'anita.rao@pepsico.co.in','+91-9000100108'),
('Sanjay','Desai','M','1991-01-02','2019-11-01',9,'Procurement Specialist',54000.00,'sanjay.desai@pepsico.co.in','+91-9000100109'),
('Kavita','Joshi','F','1987-07-07','2013-05-22',10,'IT Manager',85000.00,'kavita.joshi@pepsico.co.in','+91-9000100110'),
('Manish','Gupta','M','1993-04-20','2021-08-12',11,'Marketing Lead',60000.00,'manish.gupta@pepsico.co.in','+91-9000100111'),
('Swati','Nair','F','1995-10-28','2022-01-09',12,'Customer Care Exec',33000.00,'swati.nair@pepsico.co.in','+91-9000100112'),
('Arvind','Kulkarni','M','1982-11-11','2010-07-01',13,'Legal Counsel',105000.00,'arvind.kulkarni@pepsico.co.in','+91-9000100113'),
('Meera','Paul','F','1990-02-26','2016-05-03',14,'Supply Chain Analyst',56000.00,'meera.paul@pepsico.co.in','+91-9000100114'),
('Dev','Bhandari','M','1984-03-30','2011-12-19',15,'Export Manager',75000.00,'dev.bhandari@pepsico.co.in','+91-9000100115'),
('Ritu','Chopra','F','1996-06-16','2021-04-27',16,'Warehouse Supervisor',38000.00,'ritu.chopra@pepsico.co.in','+91-9000100116'),
('Karan','Malhotra','M','1987-09-09','2014-09-05',17,'Product Developer',70000.00,'karan.malhotra@pepsico.co.in','+91-9000100117'),
('Lina','Bose','F','1991-12-19','2018-02-14',18,'Data Analyst',54000.00,'lina.bose@pepsico.co.in','+91-9000100118'),
('Arjun','Reddy','M','1992-04-01','2019-06-20',19,'H&S Officer',47000.00,'arjun.reddy@pepsico.co.in','+91-9000100119'),
('Pooja','Shah','F','1988-08-08','2015-10-11',20,'Corporate Affairs Manager',82000.00,'pooja.shah@pepsico.co.in','+91-9000100120');

-- ---------------------------
-- 4) Categories (20 rows)
-- ---------------------------
INSERT INTO Categories (CategoryName, Description, CreatedDate, ActiveStatus, TaxRate, HSNCode, GSTApplicable, ParentCategoryID) VALUES
('Carbonated Drinks','Carbonated soft drinks - cola and flavored','2023-01-10 09:00:00',TRUE,18.00,'2202','TRUE',NULL),
('Juices & Nectars','Fruit juices and nectar beverages','2023-01-12 09:00:00',TRUE,12.00,'2009','TRUE',NULL),
('Bottled Water','Packaged drinking water','2023-01-15 09:00:00',TRUE,18.00,'2201','TRUE',NULL),
('Ready-to-Drink Tea/Coffee','RTD tea and coffee beverages','2023-01-20 09:00:00',TRUE,18.00,'2101','TRUE',NULL),
('Chips & Crisps','Potato chips and extruded snacks','2023-02-01 09:00:00',TRUE,18.00,'2106','TRUE',NULL),
('Nuts & Snacks','Roasted nuts and healthy snacks','2023-02-05 09:00:00',TRUE,18.00,'2008','TRUE',NULL),
('Dips & Sauces','Condiments, sauces and dips','2023-02-10 09:00:00',TRUE,18.00,'2103','TRUE',NULL),
('Breakfast Cereals','Cereal and grain-based breakfast products','2023-02-12 09:00:00',TRUE,18.00,'1904','TRUE',NULL),
('Confectionery','Candies, chocolates and gums','2023-02-14 09:00:00',TRUE,18.00,'1704','TRUE',NULL),
('Health Drinks','Nutritious powdered drinks and supplements','2023-02-16 09:00:00',TRUE,12.00,'2102','TRUE',NULL),
('Ready Meals','Packaged ready-to-eat meals','2023-03-01 09:00:00',TRUE,18.00,'1602','TRUE',NULL),
('Sauces & Dressings','Salad dressings and cooking sauces','2023-03-05 09:00:00',TRUE,18.00,'2103','TRUE',NULL),
('Pet Beverages','Non-alcoholic specialty beverages','2023-03-10 09:00:00',TRUE,18.00,'2202','TRUE',NULL),
('Ketchup','Tomato ketchup and related products','2023-03-15 09:00:00',TRUE,18.00,'2103','TRUE',NULL),
('Snack Bars','Energy and protein bars','2023-03-20 09:00:00',TRUE,18.00,'1904','TRUE',NULL),
('Ice Cream & Frozen Desserts','Frozen desserts and ice creams','2023-03-22 09:00:00',TRUE,18.00,'2105','TRUE',NULL),
('Baking Mixes','Baking ingredients and mixes','2023-03-25 09:00:00',TRUE,18.00,'1904','TRUE',NULL),
('Syrups & Concentrates','Beverage syrups and concentrates','2023-03-28 09:00:00',TRUE,18.00,'2104','TRUE',NULL),
('Seasonings','Spices and flavor seasonings','2023-04-01 09:00:00',TRUE,18.00,'0901','TRUE',NULL),
('Promotional Items','Branded promotional goods','2023-04-05 09:00:00',TRUE,0.00,'9999','FALSE',NULL);

-- ---------------------------
-- 5) Suppliers (20 rows)
-- ---------------------------
INSERT INTO Suppliers (SupplierName, ContactPerson, Phone, Email, Address, City, State, Country, GSTNumber) VALUES
('Global Ingredients Ltd','Mr. S. Rao','+91-9876500001','rao@globalingredients.com','12 Spice Lane','Mumbai','Maharashtra','India','27GIL000001X1Z5'),
('Fresh Farms Pvt Ltd','Ms. K. Singh','+91-9876500002','ksingh@freshfarms.in','88 Agro Park','Pune','Maharashtra','India','27FFP000002X1Z5'),
('Beverage Supplies Co','Mr. J. Fernandes','+91-9876500003','jfernandes@bevsupplies.com','5 Harbor St','Goa','Goa','India','30BSC000003X1Z5'),
('Packaging World','Ms. L. Das','+91-9876500004','ldas@packworld.in','20 Pack St','Surat','Gujarat','India','24PW000004X1Z5'),
('ColdChain Logistics','Mr. R. Iyer','+91-9876500005','riyer@coldchain.com','9 Storage Rd','Hyderabad','Telangana','India','36CCL000005X1Z5'),
('Sweeteners Inc','Mr. A. Gupta','+91-9876500006','agupta@sweetenersinc.com','33 Sugar Ave','Delhi','Delhi','India','07SI000006X1Z5'),
('FlavourTech Labs','Ms. S. Menon','+91-9876500007','smenon@flavourtech.com','44 Lab Street','Kochi','Kerala','India','32FTL000007X1Z5'),
('AquaPure Ltd','Mr. D. Nair','+91-9876500008','dnair@aquapure.com','66 Waterway','Bengaluru','Karnataka','India','29APL000008X1Z5'),
('Snack Ingredients Co','Ms. M. Rao','+91-9876500009','mrao@snackingredients.com','77 Crunch Rd','Indore','Madhya Pradesh','India','23SIC000009X1Z5'),
('Equipment Solutions','Mr. P. Kumar','+91-9876500010','pkumar@equipsol.com','101 Machine Park','Ahmedabad','Gujarat','India','24ES000010X1Z5'),
('Dairy Partners','Mr. V. Patel','+91-9876500011','vpatel@dairypartners.in','12 Milk Lane','Coimbatore','Tamil Nadu','India','33DP000011X1Z5'),
('Fiber Foods','Ms. R. Nair','+91-9876500012','rnair@fiberfoods.com','55 Grain Blvd','Bhopal','Madhya Pradesh','India','23FF000012X1Z5'),
('Transport Services','Mr. S. Verma','+91-9876500013','sverma@transportservices.in','14 Fleet Road','Nagpur','Maharashtra','India','27TS000013X1Z5'),
('Cool Packaging','Ms. T. Abraham','+91-9876500014','tabraham@coolpack.com','9 Chill Ave','Chennai','Tamil Nadu','India','33CP000014X1Z5'),
('GlassWorks Ltd','Mr. O. Khan','+91-9876500015','okhan@glassworks.com','3 Glass Road','Jaipur','Rajasthan','India','08GW000015X1Z5'),
('Herbal Extracts','Ms. N. Bose','+91-9876500016','nbose@herbalext.com','22 Herb Lane','Bhubaneswar','Odisha','India','21HE000016X1Z5'),
('Spice Mills','Mr. L. Iqbal','+91-9876500017','liqbal@spicemills.in','77 Mill Road','Lucknow','Uttar Pradesh','India','09SM000017X1Z5'),
('Energy Additives','Mr. G. Das','+91-9876500018','gdas@energyadd.com','45 Power Park','Visakhapatnam','Andhra Pradesh','India','37EA000018X1Z5'),
('LabelPrint Co','Ms. H. Paul','+91-9876500019','hpaul@labelprint.co','18 Print Street','Surat','Gujarat','India','24LP000019X1Z5'),
('Sugar Mills','Mr. R. Bhattacharya','+91-9876500020','rbb@sugarmills.in','200 Cane Rd','Kolkata','West Bengal','India','19SM000020X1Z5');




/* ---------------------------
   6) Products (20 rows)
   --------------------------- */
INSERT INTO Products (ProductName, CategoryID, UnitPrice, UnitsInStock, ReorderLevel, SupplierID, ExpiryDate, ManufacturedDate, Description) VALUES
('Pepsi 500ml',1,35.00,500,100,3,'2025-12-31','2025-01-01','Carbonated cola drink'),
('Pepsi 1L',1,60.00,400,100,3,'2025-12-31','2025-01-01','Carbonated cola drink'),
('Mirinda Orange 500ml',1,30.00,350,100,3,'2025-12-31','2025-02-01','Orange-flavored carbonated drink'),
('7UP 500ml',1,32.00,300,80,3,'2025-12-31','2025-03-01','Lemon-lime carbonated drink'),
('Tropicana Orange Juice 1L',2,110.00,250,50,2,'2025-10-31','2025-04-01','100% orange juice'),
('Tropicana Apple Juice 1L',2,115.00,260,50,2,'2025-10-31','2025-04-01','100% apple juice'),
('Aquafina 1L',3,25.00,1000,150,8,'2026-01-31','2025-05-01','Packaged drinking water'),
('Aquafina 500ml',3,15.00,800,150,8,'2026-01-31','2025-05-01','Packaged drinking water'),
('Lipton Iced Tea 500ml',4,40.00,450,100,7,'2025-12-31','2025-03-10','Ready-to-drink lemon iced tea'),
('Lay’s Classic Salted 52g',5,20.00,700,200,9,'2025-06-30','2025-01-15','Potato chips salted flavor'),
('Lay’s Magic Masala 52g',5,20.00,720,200,9,'2025-06-30','2025-01-15','Spicy potato chips'),
('Kurkure Masala Munch 90g',5,25.00,600,150,9,'2025-07-31','2025-02-10','Crunchy spicy snack'),
('Quaker Oats 1kg',8,180.00,200,40,12,'2026-01-31','2025-03-05','Rolled oats for breakfast'),
('Gatorade Lemon 500ml',10,45.00,500,100,18,'2025-12-31','2025-03-01','Electrolyte sports drink'),
('Slice Mango Drink 500ml',2,35.00,400,100,2,'2025-09-30','2025-04-10','Mango-flavored drink'),
('Pepsi Black 500ml',1,38.00,450,100,3,'2025-12-31','2025-05-01','No sugar cola drink'),
('Lay’s Cream & Onion 52g',5,20.00,700,200,9,'2025-06-30','2025-03-05','Cream and onion chips'),
('Tropicana Mixed Fruit 1L',2,120.00,240,50,2,'2025-10-31','2025-04-05','Mixed fruit juice'),
('Quaker Muesli 700g',8,210.00,150,30,12,'2026-01-31','2025-03-10','Healthy breakfast muesli'),
('Gatorade Orange 500ml',10,45.00,450,100,18,'2025-12-31','2025-03-01','Electrolyte orange drink');

/* ---------------------------
   7) Customers (20 rows)
   --------------------------- */
INSERT INTO Customers (CustomerName, Email, Phone, Address, City, State, Country, RegistrationDate, LoyaltyPoints) VALUES
('Rahul Kapoor','rahul.kapoor@example.com','+91-9998000001','23 Green St','Mumbai','Maharashtra','India','2022-01-15',120),
('Sneha Joshi','sneha.joshi@example.com','+91-9998000002','14 Rose Lane','Pune','Maharashtra','India','2022-03-20',95),
('Vikram Nair','vikram.nair@example.com','+91-9998000003','5 Palm Road','Bengaluru','Karnataka','India','2021-12-10',180),
('Anita Dutta','anita.dutta@example.com','+91-9998000004','10 MG Road','Delhi','Delhi','India','2023-02-05',60),
('Amit Patel','amit.patel@example.com','+91-9998000005','88 Silver Tower','Ahmedabad','Gujarat','India','2022-06-01',150),
('Priya Mehta','priya.mehta@example.com','+91-9998000006','9 Garden View','Chennai','Tamil Nadu','India','2021-10-10',75),
('Suresh Rao','suresh.rao@example.com','+91-9998000007','33 Horizon Blvd','Hyderabad','Telangana','India','2022-09-15',130),
('Rina Paul','rina.paul@example.com','+91-9998000008','18 Sea View','Kolkata','West Bengal','India','2023-01-22',50),
('Harish Malhotra','harish.malhotra@example.com','+91-9998000009','101 Corporate Park','Noida','Uttar Pradesh','India','2021-09-25',200),
('Pooja Iyer','pooja.iyer@example.com','+91-9998000010','45 Sunshine Ave','Bengaluru','Karnataka','India','2023-03-15',40),
('Nitin Bansal','nitin.bansal@example.com','+91-9998000011','78 Lotus Road','Delhi','Delhi','India','2022-07-09',90),
('Kavya Shah','kavya.shah@example.com','+91-9998000012','25 Blue Street','Pune','Maharashtra','India','2023-02-12',55),
('Arun Krishnan','arun.krishnan@example.com','+91-9998000013','7 Beach View','Chennai','Tamil Nadu','India','2022-08-05',110),
('Simran Kaur','simran.kaur@example.com','+91-9998000014','3 Pearl Rd','Amritsar','Punjab','India','2021-06-20',160),
('Ravi Sinha','ravi.sinha@example.com','+91-9998000015','27 Riverside','Lucknow','Uttar Pradesh','India','2022-11-17',85),
('Neelam Das','neelam.das@example.com','+91-9998000016','60 Garden St','Guwahati','Assam','India','2023-04-01',35),
('Karan Thakur','karan.thakur@example.com','+91-9998000017','22 King Road','Jaipur','Rajasthan','India','2022-10-02',100),
('Lata Bose','lata.bose@example.com','+91-9998000018','89 Central Ave','Kolkata','West Bengal','India','2023-03-12',45),
('Vishal Desai','vishal.desai@example.com','+91-9998000019','5 Lake View','Surat','Gujarat','India','2021-11-22',175),
('Rohit Shetty','rohit.shetty@example.com','+91-9998000020','14 Park Road','Mumbai','Maharashtra','India','2022-02-11',190);

/* ---------------------------
   8) Orders (20 rows)
   --------------------------- */
INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, ShipDate, ShippingMethod, TotalAmount, PaymentStatus) VALUES
(1,3,'2024-11-01','2024-11-03','Road',520.00,'Paid'),
(2,4,'2024-11-02','2024-11-04','Road',110.00,'Pending'),
(3,5,'2024-11-03','2024-11-05','Air',250.00,'Paid'),
(4,6,'2024-11-04','2024-11-06','Road',180.00,'Cancelled'),
(5,7,'2024-11-05','2024-11-07','Rail',90.00,'Paid'),
(6,8,'2024-11-06','2024-11-08','Road',360.00,'Paid'),
(7,9,'2024-11-07','2024-11-09','Road',450.00,'Pending'),
(8,10,'2024-11-08','2024-11-10','Air',310.00,'Paid'),
(9,11,'2024-11-09','2024-11-11','Road',260.00,'Paid'),
(10,12,'2024-11-10','2024-11-12','Road',175.00,'Pending'),
(11,13,'2024-11-11','2024-11-13','Rail',320.00,'Paid'),
(12,14,'2024-11-12','2024-11-14','Air',410.00,'Paid'),
(13,15,'2024-11-13','2024-11-15','Road',95.00,'Pending'),
(14,16,'2024-11-14','2024-11-16','Road',270.00,'Paid'),
(15,17,'2024-11-15','2024-11-17','Rail',460.00,'Pending'),
(16,18,'2024-11-16','2024-11-18','Air',120.00,'Paid'),
(17,19,'2024-11-17','2024-11-19','Road',560.00,'Paid'),
(18,20,'2024-11-18','2024-11-20','Road',140.00,'Pending'),
(19,1,'2024-11-19','2024-11-21','Rail',290.00,'Paid'),
(20,2,'2024-11-20','2024-11-22','Air',380.00,'Paid');

/* ---------------------------
   9) OrderDetails (20 rows)
   --------------------------- */
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Discount) VALUES
(1,1,10,35.00,0),
(2,5,2,110.00,0),
(3,7,5,25.00,0),
(4,11,6,20.00,0),
(5,13,1,180.00,0),
(6,10,12,20.00,5.00),
(7,8,10,15.00,0),
(8,9,8,40.00,2.00),
(9,14,6,45.00,0),
(10,16,5,38.00,0),
(11,2,4,60.00,0),
(12,3,7,30.00,0),
(13,17,6,20.00,0),
(14,15,3,35.00,0),
(15,18,2,120.00,0),
(16,4,10,32.00,0),
(17,19,3,210.00,10.00),
(18,6,2,115.00,0),
(19,12,8,25.00,0),
(20,20,5,45.00,0);

/* ---------------------------
   10) Payments (20 rows)
   --------------------------- */
INSERT INTO Payments (OrderID, PaymentDate, PaymentMode, Amount, TransactionID) VALUES
(1,'2024-11-02','Credit Card',520.00,'TXN10001'),
(2,'2024-11-03','UPI',110.00,'TXN10002'),
(3,'2024-11-04','NetBanking',250.00,'TXN10003'),
(4,'2024-11-05','Credit Card',180.00,'TXN10004'),
(5,'2024-11-06','UPI',90.00,'TXN10005'),
(6,'2024-11-07','UPI',360.00,'TXN10006'),
(7,'2024-11-08','Credit Card',450.00,'TXN10007'),
(8,'2024-11-09','NetBanking',310.00,'TXN10008'),
(9,'2024-11-10','UPI',260.00,'TXN10009'),
(10,'2024-11-11','Credit Card',175.00,'TXN10010'),
(11,'2024-11-12','Credit Card',320.00,'TXN10011'),
(12,'2024-11-13','UPI',410.00,'TXN10012'),
(13,'2024-11-14','NetBanking',95.00,'TXN10013'),
(14,'2024-11-15','UPI',270.00,'TXN10014'),
(15,'2024-11-16','Credit Card',460.00,'TXN10015'),
(16,'2024-11-17','Credit Card',120.00,'TXN10016'),
(17,'2024-11-18','UPI',560.00,'TXN10017'),
(18,'2024-11-19','NetBanking',140.00,'TXN10018'),
(19,'2024-11-20','Credit Card',290.00,'TXN10019'),
(20,'2024-11-21','UPI',380.00,'TXN10020');




/* ---------------------------
   11) Inventory (20 rows)
   --------------------------- */
INSERT INTO Inventory (ProductID, WarehouseID, QuantityOnHand, ReorderLevel, LastUpdated) VALUES
(1,1,300,100,'2024-10-25'),
(2,1,280,100,'2024-10-25'),
(3,2,250,80,'2024-10-25'),
(4,2,270,80,'2024-10-25'),
(5,3,180,50,'2024-10-25'),
(6,3,190,50,'2024-10-25'),
(7,4,600,150,'2024-10-25'),
(8,4,580,150,'2024-10-25'),
(9,5,220,100,'2024-10-25'),
(10,5,330,200,'2024-10-25'),
(11,6,350,200,'2024-10-25'),
(12,6,400,150,'2024-10-25'),
(13,7,150,40,'2024-10-25'),
(14,8,350,100,'2024-10-25'),
(15,9,250,100,'2024-10-25'),
(16,9,260,100,'2024-10-25'),
(17,10,340,200,'2024-10-25'),
(18,10,300,50,'2024-10-25'),
(19,11,120,30,'2024-10-25'),
(20,11,200,100,'2024-10-25');

/* ---------------------------
   12) Warehouses (20 rows)
   --------------------------- */
INSERT INTO Warehouses (WarehouseName, Location, Capacity, ManagerName, ContactNumber) VALUES
('Mumbai Central Warehouse','Mumbai',50000,'Ramesh Naik','+91-9801000001'),
('Pune Beverage Storage','Pune',40000,'Neha Joshi','+91-9801000002'),
('Bengaluru Snack Depot','Bengaluru',45000,'Praveen Kumar','+91-9801000003'),
('Chennai Distribution Hub','Chennai',55000,'Vikas Rao','+91-9801000004'),
('Delhi Packaging Unit','Delhi',60000,'Ritu Sharma','+91-9801000005'),
('Kolkata Storage Facility','Kolkata',42000,'Soumitra Ghosh','+91-9801000006'),
('Hyderabad Beverage Plant','Hyderabad',48000,'Anita Iyer','+91-9801000007'),
('Ahmedabad Snack Depot','Ahmedabad',40000,'Rajesh Patel','+91-9801000008'),
('Lucknow Cold Storage','Lucknow',35000,'Pankaj Singh','+91-9801000009'),
('Jaipur Packaging Hub','Jaipur',30000,'Manish Thakur','+91-9801000010'),
('Surat Beverage Center','Surat',28000,'Sonal Desai','+91-9801000011'),
('Indore Distribution Point','Indore',32000,'Deepak Mehta','+91-9801000012'),
('Nagpur Stockhouse','Nagpur',37000,'Ravi Deshmukh','+91-9801000013'),
('Bhopal Regional Hub','Bhopal',39000,'Kavita Pandey','+91-9801000014'),
('Guwahati Depot','Guwahati',25000,'Anand Das','+91-9801000015'),
('Patna Warehouse','Patna',30000,'Rohit Sinha','+91-9801000016'),
('Cochin Beverage Storage','Cochin',27000,'Suresh Menon','+91-9801000017'),
('Chandigarh Depot','Chandigarh',28000,'Simran Kaur','+91-9801000018'),
('Nashik Stock Center','Nashik',26000,'Vikram Joshi','+91-9801000019'),
('Varanasi Regional Store','Varanasi',25000,'Amit Mishra','+91-9801000020');

/* ---------------------------
   13) RawMaterials (20 rows)
   --------------------------- */
INSERT INTO RawMaterials (MaterialName, SupplierID, UnitCost, QuantityAvailable, LastRestockedDate) VALUES
('Sugar',3,45.00,5000,'2024-10-10'),
('Carbonated Water',8,15.00,8000,'2024-10-15'),
('Citric Acid',3,60.00,3000,'2024-10-12'),
('Flavoring Agent',7,75.00,2500,'2024-10-18'),
('Mango Pulp',2,95.00,1500,'2024-10-16'),
('Orange Pulp',2,90.00,1600,'2024-10-17'),
('Lemon Extract',7,85.00,1400,'2024-10-18'),
('Packaging Bottle 500ml',9,12.00,7000,'2024-10-09'),
('Packaging Bottle 1L',9,15.00,6500,'2024-10-09'),
('Plastic Caps',9,5.00,9000,'2024-10-08'),
('Labels',9,3.00,10000,'2024-10-08'),
('Salt',12,20.00,2000,'2024-10-10'),
('Potato Flakes',9,55.00,2500,'2024-10-11'),
('Corn Flour',9,50.00,2600,'2024-10-11'),
('Oats',12,80.00,1800,'2024-10-13'),
('Milk Powder',12,110.00,1500,'2024-10-14'),
('Food Color',3,65.00,1400,'2024-10-12'),
('Preservative E211',7,70.00,1200,'2024-10-19'),
('Water Bottles Cap Seal',8,6.00,8500,'2024-10-09'),
('PET Preform',9,9.00,9200,'2024-10-08');

/* ---------------------------
   14) ProductionBatch (20 rows)
   --------------------------- */
INSERT INTO ProductionBatch (BatchCode, ProductID, ProductionDate, QuantityProduced, WarehouseID, SupervisorName) VALUES
('PB20241001',1,'2024-10-01',2000,1,'Amit Yadav'),
('PB20241002',2,'2024-10-02',1800,1,'Ravi Kumar'),
('PB20241003',3,'2024-10-03',1600,2,'Neha Joshi'),
('PB20241004',4,'2024-10-04',1500,2,'Manoj Nair'),
('PB20241005',5,'2024-10-05',1400,3,'Ritika Dey'),
('PB20241006',6,'2024-10-06',1300,3,'Sanjay Rao'),
('PB20241007',7,'2024-10-07',2500,4,'Pooja Iyer'),
('PB20241008',8,'2024-10-08',2300,4,'Rohit Singh'),
('PB20241009',9,'2024-10-09',1700,5,'Kiran Sharma'),
('PB20241010',10,'2024-10-10',2600,5,'Mehul Patel'),
('PB20241011',11,'2024-10-11',2700,6,'Shweta Gupta'),
('PB20241012',12,'2024-10-12',2200,6,'Rahul Joshi'),
('PB20241013',13,'2024-10-13',900,7,'Ajay Deshmukh'),
('PB20241014',14,'2024-10-14',2100,8,'Ramesh Sinha'),
('PB20241015',15,'2024-10-15',2000,9,'Kavita Shah'),
('PB20241016',16,'2024-10-16',1900,9,'Nilesh Iyer'),
('PB20241017',17,'2024-10-17',2500,10,'Sneha Kulkarni'),
('PB20241018',18,'2024-10-18',1600,10,'Suresh Rao'),
('PB20241019',19,'2024-10-19',800,11,'Priya Mehta'),
('PB20241020',20,'2024-10-20',1200,11,'Vikas Patel');

/* ---------------------------
   15) QualityCheck (20 rows)
   --------------------------- */
INSERT INTO QualityCheck (BatchID, InspectionDate, InspectorName, Status, Remarks) VALUES
(1,'2024-10-02','Anil Verma','Passed','Meets all quality standards'),
(2,'2024-10-03','Sneha Shah','Passed','Clean batch, no issues'),
(3,'2024-10-04','Pooja Reddy','Passed','Slight delay in cooling'),
(4,'2024-10-05','Rahul Singh','Failed','Improper carbonation'),
(5,'2024-10-06','Amit Das','Passed','Meets packaging norms'),
(6,'2024-10-07','Deepa Iyer','Passed','Perfect sealing'),
(7,'2024-10-08','Karan Patel','Passed','Water quality excellent'),
(8,'2024-10-09','Sonal Jain','Passed','Label alignment perfect'),
(9,'2024-10-10','Ravi Kumar','Failed','Low syrup consistency'),
(10,'2024-10-11','Neha Rao','Passed','All standards maintained'),
(11,'2024-10-12','Priya Dey','Passed','No contamination found'),
(12,'2024-10-13','Arjun Mehta','Passed','Great quality'),
(13,'2024-10-14','Rina Sharma','Passed','Oats texture good'),
(14,'2024-10-15','Pankaj Sinha','Passed','Clear liquid consistency'),
(15,'2024-10-16','Meera Patel','Failed','Incorrect labeling'),
(16,'2024-10-17','Suresh Das','Passed','No microbial issue'),
(17,'2024-10-18','Kavita Naik','Passed','Satisfactory sample'),
(18,'2024-10-19','Lalit Thakur','Passed','Minor moisture variation'),
(19,'2024-10-20','Nidhi Ghosh','Passed','Color stable'),
(20,'2024-10-21','Rohit Kumar','Passed','All chemical parameters OK');





/* ---------------------------
   16) Distributors (20 rows)
   --------------------------- */
INSERT INTO Distributors (DistributorName, ContactPerson, Phone, Email, City, State, Country, CreditLimit) VALUES
('Star Distributors','Rajesh Patel','+91-9810010001','rajesh@star.com','Mumbai','Maharashtra','India',500000),
('Elite Beverages','Rohit Sharma','+91-9810010002','rohit@elite.com','Pune','Maharashtra','India',400000),
('SouthIndia Foods','Vikas Rao','+91-9810010003','vikas@sifoods.com','Chennai','Tamil Nadu','India',450000),
('FreshFlow Traders','Anita Iyer','+91-9810010004','anita@freshflow.com','Bengaluru','Karnataka','India',300000),
('Royal Supply Co','Pankaj Singh','+91-9810010005','pankaj@royalsupply.com','Delhi','Delhi','India',600000),
('Oceanic Traders','Ritu Sharma','+91-9810010006','ritu@oceanic.com','Kolkata','West Bengal','India',350000),
('Urban Distribution','Neha Joshi','+91-9810010007','neha@urban.com','Hyderabad','Telangana','India',420000),
('SpeedServe Ltd','Karan Mehta','+91-9810010008','karan@speedserve.com','Ahmedabad','Gujarat','India',370000),
('MegaMart Supply','Sonal Jain','+91-9810010009','sonal@megamart.com','Jaipur','Rajasthan','India',390000),
('Premium Dealers','Ravi Nair','+91-9810010010','ravi@premium.com','Lucknow','Uttar Pradesh','India',360000),
('Western Link','Priya Dey','+91-9810010011','priya@westernlink.com','Surat','Gujarat','India',410000),
('Express Supplies','Arjun Verma','+91-9810010012','arjun@express.com','Nagpur','Maharashtra','India',380000),
('EastPoint Distribution','Suresh Das','+91-9810010013','suresh@eastpoint.com','Patna','Bihar','India',340000),
('Northline Trade Co','Deepa Thakur','+91-9810010014','deepa@northline.com','Bhopal','Madhya Pradesh','India',400000),
('Sunrise Logistics','Anil Sharma','+91-9810010015','anil@sunrise.com','Indore','Madhya Pradesh','India',370000),
('BlueSky Suppliers','Meera Patel','+91-9810010016','meera@bluesky.com','Varanasi','Uttar Pradesh','India',390000),
('Golden Way Traders','Lalit Ghosh','+91-9810010017','lalit@goldenway.com','Chandigarh','Punjab','India',420000),
('Global Distribution','Sneha Shah','+91-9810010018','sneha@global.com','Cochin','Kerala','India',350000),
('QuickServe Pvt Ltd','Ravi Kumar','+91-9810010019','ravi@quickserve.com','Nashik','Maharashtra','India',380000),
('Sunline Agency','Amit Yadav','+91-9810010020','amit@sunline.com','Guwahati','Assam','India',360000);

/* ---------------------------
   17) Retailers (20 rows)
   --------------------------- */
INSERT INTO Retailers (RetailerName, DistributorID, City, Phone, Email) VALUES
('CoolDrinks Mart',1,'Mumbai','+91-9820010001','info@cooldrinks.com'),
('Daily Delights',1,'Thane','+91-9820010002','daily@delights.com'),
('SmartGrocer',2,'Pune','+91-9820010003','contact@smartgrocer.com'),
('SnackWorld',2,'Pimpri','+91-9820010004','hello@snackworld.com'),
('FreshChoice',3,'Chennai','+91-9820010005','fresh@choice.com'),
('UrbanCart',3,'Madurai','+91-9820010006','support@urbancart.com'),
('DrinkStop',4,'Bengaluru','+91-9820010007','sales@drinkstop.com'),
('TastyBites',4,'Mysuru','+91-9820010008','tasty@bites.com'),
('GroceryPlus',5,'Delhi','+91-9820010009','hello@groceryplus.com'),
('MegaStore',5,'Noida','+91-9820010010','contact@megastore.com'),
('EastFresh',6,'Kolkata','+91-9820010011','info@eastfresh.com'),
('QuickPick',7,'Hyderabad','+91-9820010012','quick@pick.com'),
('PrimeMart',8,'Ahmedabad','+91-9820010013','prime@mart.com'),
('BestBuy Grocers',9,'Jaipur','+91-9820010014','buy@best.com'),
('SnackCorner',10,'Lucknow','+91-9820010015','snack@corner.com'),
('FoodHub',11,'Surat','+91-9820010016','food@hub.com'),
('HappyMart',12,'Nagpur','+91-9820010017','happy@mart.com'),
('LocalChoice',13,'Patna','+91-9820010018','local@choice.com'),
('TopPick Stores',14,'Bhopal','+91-9820010019','top@pick.com'),
('Everyday Needs',15,'Indore','+91-9820010020','every@needs.com');

/* ---------------------------
   18) Shipments (20 rows)
   --------------------------- */
INSERT INTO Shipments (OrderID, WarehouseID, ShipmentDate, DeliveryDate, TransportID, Status) VALUES
(1,1,'2024-10-03','2024-10-05',1,'Delivered'),
(2,2,'2024-10-04','2024-10-06',2,'Delivered'),
(3,3,'2024-10-05','2024-10-07',3,'Delivered'),
(4,4,'2024-10-06','2024-10-08',4,'In Transit'),
(5,5,'2024-10-07','2024-10-09',5,'Delivered'),
(6,6,'2024-10-08','2024-10-10',6,'Delivered'),
(7,7,'2024-10-09','2024-10-11',7,'Delivered'),
(8,8,'2024-10-10','2024-10-12',8,'Cancelled'),
(9,9,'2024-10-11','2024-10-13',9,'Delivered'),
(10,10,'2024-10-12','2024-10-14',10,'Delivered'),
(11,1,'2024-10-13','2024-10-15',11,'Delivered'),
(12,2,'2024-10-14','2024-10-16',12,'Delivered'),
(13,3,'2024-10-15','2024-10-17',13,'Delivered'),
(14,4,'2024-10-16','2024-10-18',14,'In Transit'),
(15,5,'2024-10-17','2024-10-19',15,'Delivered'),
(16,6,'2024-10-18','2024-10-20',16,'Delivered'),
(17,7,'2024-10-19','2024-10-21',17,'Delivered'),
(18,8,'2024-10-20','2024-10-22',18,'Cancelled'),
(19,9,'2024-10-21','2024-10-23',19,'Delivered'),
(20,10,'2024-10-22','2024-10-24',20,'Delivered');

/* ---------------------------
   19) Transport (20 rows)
   --------------------------- */
INSERT INTO Transport (TransportCompany, DriverName, VehicleNo, ContactNo, Route, CostPerKM) VALUES
('BlueLine Logistics','Ramesh Chauhan','MH12AB1234','+91-9876543001','Mumbai–Pune',12.50),
('FastTrack Movers','Amit Sharma','DL01CD4321','+91-9876543002','Delhi–Noida',10.20),
('SwiftHaul Pvt Ltd','Neeraj Singh','KA05EF5678','+91-9876543003','Bengaluru–Chennai',11.30),
('TransLink Logistics','Rohit Rao','TN09GH6789','+91-9876543004','Chennai–Madurai',9.80),
('RoadRunners','Kunal Patel','GJ18IJ3456','+91-9876543005','Ahmedabad–Surat',10.50),
('MoveOn Express','Vivek Mehta','MH31KL4567','+91-9876543006','Nagpur–Pune',12.00),
('UrbanTrans','Deepa Joshi','UP16MN6789','+91-9876543007','Lucknow–Varanasi',11.00),
('QuickCarry','Ravi Kumar','WB20OP9876','+91-9876543008','Kolkata–Patna',9.50),
('CityLine Carriers','Ajay Sinha','MP04QR1234','+91-9876543009','Indore–Bhopal',10.75),
('StarHaul Logistics','Sonal Naik','RJ27ST4321','+91-9876543010','Jaipur–Delhi',10.90),
('MetroMove','Pooja Iyer','AP09UV5678','+91-9876543011','Hyderabad–Vijayawada',11.40),
('SpeedTrans','Kiran Das','TN08WX6789','+91-9876543012','Chennai–Coimbatore',9.90),
('FastFlow Transport','Nikhil Ghosh','MH14YZ3456','+91-9876543013','Mumbai–Nashik',12.80),
('RoadKing Carriers','Anita Desai','GJ11AB2345','+91-9876543014','Ahmedabad–Vadodara',10.60),
('GoTrans Express','Priya Thakur','UP18CD7890','+91-9876543015','Agra–Lucknow',11.10),
('MovePlus Logistics','Lalit Rao','MP19EF8901','+91-9876543016','Bhopal–Indore',9.70),
('TransIndia Movers','Neha Jain','MH22GH6789','+91-9876543017','Mumbai–Goa',13.20),
('SafeTrack Cargo','Suresh Mehta','KA03JK3456','+91-9876543018','Bengaluru–Hubli',11.50),
('RapidRoad Carriers','Kavita Shah','WB02LM5678','+91-9876543019','Kolkata–Guwahati',12.10),
('OnWay Logistics','Arjun Dey','DL09NP9876','+91-9876543020','Delhi–Chandigarh',10.40);

/* ---------------------------
   20) Machines (20 rows)
   --------------------------- */
INSERT INTO Machines (MachineName, PurchaseDate, MaintenanceCycle, Status, DepartmentID) VALUES
('Filling Machine A','2022-03-15',180,'Active',1),
('Labeling Machine B','2022-05-20',200,'Active',1),
('Packaging Unit 1','2021-12-10',150,'Under Maintenance',2),
('Cooling Unit C','2023-01-12',120,'Active',2),
('Mixing Machine D','2022-06-01',180,'Active',3),
('Carbonation Tank E','2022-07-11',210,'Inactive',3),
('Bottling Line F','2021-11-30',200,'Active',4),
('Sealing Unit G','2023-02-18',180,'Active',4),
('Conveyor Belt H','2021-08-25',150,'Under Maintenance',5),
('Printing Machine I','2023-04-10',160,'Active',5),
('Pasteurizer J','2022-09-14',180,'Active',6),
('Washer K','2023-06-22',200,'Active',6),
('Capping Machine L','2021-07-13',180,'Inactive',7),
('Mixer M','2023-01-30',180,'Active',7),
('Sterilizer N','2022-10-19',160,'Active',8),
('Label Printer O','2022-11-15',200,'Under Maintenance',8),
('Cooler P','2023-03-05',180,'Active',9),
('Air Compressor Q','2021-09-20',220,'Inactive',9),
('Shrink Wrapper R','2022-08-08',150,'Active',10),
('Bottle Inspector S','2023-02-25',180,'Active',10);



/* ---------------------------
   21) Maintenance (20 rows)
   --------------------------- */
INSERT INTO Maintenance (MachineID, MaintenanceDate, TechnicianName, Cost, Remarks) VALUES
(1,'2024-02-10','Amit Verma',2500,'Oil change and calibration'),
(2,'2024-03-05','Ravi Singh',1800,'Label sensor alignment'),
(3,'2024-04-02','Pooja Iyer',3200,'Packaging belt replacement'),
(4,'2024-05-08','Suresh Kumar',2100,'Cooling fan replaced'),
(5,'2024-05-20','Karan Patel',2700,'Mixer blade sharpening'),
(6,'2024-06-01','Ritu Sharma',3500,'Pressure valve check'),
(7,'2024-06-15','Anil Joshi',2600,'Bottle line inspection'),
(8,'2024-06-25','Sneha Rao',2400,'Sealing temperature adjustment'),
(9,'2024-07-05','Rakesh Das',2800,'Belt motor serviced'),
(10,'2024-07-15','Priya Mehta',2300,'Ink cartridge replaced'),
(11,'2024-07-28','Vikram Singh',2900,'Temperature calibration'),
(12,'2024-08-10','Nisha Iyer',2600,'Water flow valve fixed'),
(13,'2024-08-20','Manish Gupta',3100,'Capping head adjusted'),
(14,'2024-08-30','Poonam Shah',2700,'Motor vibration fixed'),
(15,'2024-09-10','Ravi Nair',3000,'Steam regulator maintenance'),
(16,'2024-09-20','Neha Sharma',2500,'Print head cleaned'),
(17,'2024-09-25','Aakash Patel',2700,'Cooling coil replaced'),
(18,'2024-10-01','Divya Rao',3400,'Air pressure sensor changed'),
(19,'2024-10-05','Ramesh Sinha',2200,'Shrink tunnel check'),
(20,'2024-10-10','Anita Mehra',2900,'Lens alignment maintenance');

/* ---------------------------
   22) MarketingCampaigns (20 rows)
   --------------------------- */
INSERT INTO MarketingCampaigns (CampaignName, StartDate, EndDate, Budget, Objective) VALUES
('Pepsi Summer Blast','2024-03-01','2024-05-31',500000,'Boost summer sales'),
('New Year Rush','2024-12-20','2025-01-15',350000,'Promote holiday packs'),
('Cricket Fever','2024-04-10','2024-05-10',450000,'Engage fans during IPL'),
('College Connect','2024-08-01','2024-09-30',300000,'Attract young audience'),
('Festive Offer','2024-10-01','2024-11-15',400000,'Increase Diwali sales'),
('Mega Mall Promo','2024-06-01','2024-07-15',200000,'In-store promotion'),
('Online Buzz','2024-07-20','2024-08-15',250000,'Digital brand engagement'),
('Eco Campaign','2024-04-01','2024-06-30',220000,'Highlight sustainability'),
('Cold Rush','2024-05-15','2024-06-15',270000,'Push cold drink sales'),
('Street Fest','2024-11-01','2024-12-10',300000,'Local market exposure'),
('Party Pack','2025-01-01','2025-02-28',320000,'Launch party-size bottles'),
('Refresh & Win','2024-09-01','2024-10-15',250000,'Contest-based promotion'),
('Cool College Challenge','2024-02-01','2024-03-15',180000,'Campus competitions'),
('Game Night Boost','2024-04-15','2024-05-30',270000,'Evening snack pairing'),
('Beat the Heat','2024-03-20','2024-05-05',300000,'Summer awareness drive'),
('Weekend Chill','2024-06-15','2024-07-20',240000,'Promote leisure consumption'),
('Bottle Recycle Drive','2024-07-10','2024-08-30',210000,'CSR environment campaign'),
('Midnight Refresh','2024-08-05','2024-09-10',200000,'Nightlife marketing'),
('SportsZone','2024-10-20','2024-12-20',380000,'Tie-up with sports bars'),
('Cool Cashbacks','2024-11-25','2025-01-05',260000,'Retail cashback scheme');

/* ---------------------------
   23) SalesTargets (20 rows)
   --------------------------- */
INSERT INTO SalesTargets (EmployeeID, Month, Year, TargetAmount, AchievedAmount) VALUES
(1,'January',2024,50000,52000),
(2,'February',2024,48000,47000),
(3,'March',2024,60000,61000),
(4,'April',2024,55000,56000),
(5,'May',2024,53000,50000),
(6,'June',2024,49000,51000),
(7,'July',2024,62000,63000),
(8,'August',2024,58000,57000),
(9,'September',2024,60000,62000),
(10,'October',2024,64000,65000),
(11,'November',2024,55000,54000),
(12,'December',2024,67000,68000),
(13,'January',2024,52000,50000),
(14,'February',2024,54000,55000),
(15,'March',2024,58000,57000),
(16,'April',2024,60000,59000),
(17,'May',2024,62000,63000),
(18,'June',2024,58000,57000),
(19,'July',2024,64000,65000),
(20,'August',2024,66000,68000);

/* ---------------------------
   24) EmployeeAttendance (20 rows)
   --------------------------- */
INSERT INTO EmployeeAttendance (EmployeeID, Date, Status) VALUES
(1,'2024-10-01','Present'),
(2,'2024-10-01','Present'),
(3,'2024-10-01','Absent'),
(4,'2024-10-01','Present'),
(5,'2024-10-01','Present'),
(6,'2024-10-01','Present'),
(7,'2024-10-01','Present'),
(8,'2024-10-01','Present'),
(9,'2024-10-01','Present'),
(10,'2024-10-01','Present'),
(11,'2024-10-01','Absent'),
(12,'2024-10-01','Present'),
(13,'2024-10-01','Present'),
(14,'2024-10-01','Present'),
(15,'2024-10-01','Present'),
(16,'2024-10-01','Present'),
(17,'2024-10-01','Present'),
(18,'2024-10-01','Present'),
(19,'2024-10-01','Present'),
(20,'2024-10-01','Present');

/* ---------------------------
   25) Feedback (20 rows)
   --------------------------- */
INSERT INTO Feedback (RetailerID, FeedbackDate, Rating, Comments) VALUES
(1,'2024-08-05',5,'Excellent product quality and fast delivery.'),
(2,'2024-08-07',4,'Good taste, need better packaging.'),
(3,'2024-08-10',5,'Loved the summer offers!'),
(4,'2024-08-12',3,'Delivery delay by two days.'),
(5,'2024-08-15',4,'Sales rep was very supportive.'),
(6,'2024-08-17',5,'Pepsi demand increasing locally.'),
(7,'2024-08-19',4,'Slight delay in shipment but fine.'),
(8,'2024-08-22',5,'Best quality among competitors.'),
(9,'2024-08-24',5,'Excellent bulk discount offers.'),
(10,'2024-08-25',4,'Stock availability could improve.'),
(11,'2024-08-27',5,'Great brand visibility this season.'),
(12,'2024-08-29',4,'Quick response from support.'),
(13,'2024-09-01',5,'Always on-time delivery!'),
(14,'2024-09-03',3,'Received some damaged bottles.'),
(15,'2024-09-05',4,'Delivery tracking is very helpful.'),
(16,'2024-09-08',5,'Sales have increased with campaigns.'),
(17,'2024-09-10',4,'Better promo material needed.'),
(18,'2024-09-12',5,'Excellent customer service.'),
(19,'2024-09-14',4,'Delivery trucks need more punctuality.'),
(20,'2024-09-16',5,'Overall very satisfied retailer.');



-- ===============================
-- SELECT Queries (View Data)
-- ===============================
SELECT * FROM Locations;
SELECT * FROM Departments;
SELECT * FROM Employees;
SELECT * FROM Categories;
SELECT * FROM Suppliers;
SELECT * FROM Products;
SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;
SELECT * FROM Payments;
SELECT * FROM Inventory;
SELECT * FROM Warehouses;
SELECT * FROM RawMaterials;
SELECT * FROM ProductionBatch;
SELECT * FROM QualityCheck;
SELECT * FROM Distributors;
SELECT * FROM Retailers;
SELECT * FROM Shipments;
SELECT * FROM Transport;
SELECT * FROM Machines;
SELECT * FROM Maintenance;
SELECT * FROM MarketingCampaigns;
SELECT * FROM SalesTargets;
SELECT * FROM EmployeeAttendance;
SELECT * FROM Feedback;


-- ===============================
-- TRUNCATE Queries (Empty Tables)
-- ===============================
TRUNCATE TABLE Locations;
TRUNCATE TABLE Departments;
TRUNCATE TABLE Employees;
TRUNCATE TABLE Categories;
TRUNCATE TABLE Suppliers;
TRUNCATE TABLE Products;
TRUNCATE TABLE Customers;
TRUNCATE TABLE Orders;
TRUNCATE TABLE OrderDetails;
TRUNCATE TABLE Payments;
TRUNCATE TABLE Inventory;
TRUNCATE TABLE Warehouses;
TRUNCATE TABLE RawMaterials;
TRUNCATE TABLE ProductionBatch;
TRUNCATE TABLE QualityCheck;
TRUNCATE TABLE Distributors;
TRUNCATE TABLE Retailers;
TRUNCATE TABLE Shipments;
TRUNCATE TABLE Transport;
TRUNCATE TABLE Machines;
TRUNCATE TABLE Maintenance;
TRUNCATE TABLE MarketingCampaigns;
TRUNCATE TABLE SalesTargets;
TRUNCATE TABLE EmployeeAttendance;
TRUNCATE TABLE Feedback;



-- ===============================
-- DROP Queries (Delete Tables)
-- ===============================
DROP TABLE IF EXISTS Feedback;
DROP TABLE IF EXISTS EmployeeAttendance;
DROP TABLE IF EXISTS SalesTargets;
DROP TABLE IF EXISTS MarketingCampaigns;
DROP TABLE IF EXISTS Maintenance;
DROP TABLE IF EXISTS Machines;
DROP TABLE IF EXISTS Transport;
DROP TABLE IF EXISTS Shipments;
DROP TABLE IF EXISTS Retailers;
DROP TABLE IF EXISTS Distributors;
DROP TABLE IF EXISTS QualityCheck;
DROP TABLE IF EXISTS ProductionBatch;
DROP TABLE IF EXISTS RawMaterials;
DROP TABLE IF EXISTS Warehouses;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Locations;
