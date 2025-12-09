------------------------------------------------------------
-- 1) OPERATORS QUERIES
------------------------------------------------------------

-- Q1: Calculate yearly salary of each employee (Arithmetic *)
SELECT 
    FirstName,
    LastName,
    Salary,
    Salary * 12 AS AnnualSalary
FROM Employees;

-- Q2: Add 10 loyalty points to all customers (+ operator)
SELECT 
    CustomerName,
    LoyaltyPoints,
    LoyaltyPoints + 10 AS UpdatedPoints
FROM Customers;


------------------------------------------------------------
-- Comparison Operators (=, >, <, !=)
------------------------------------------------------------

-- Q3: Employees earning more than 80,000
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary > 80000;

-- Q4: Products priced equal to 45
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice = 45;


------------------------------------------------------------
-- Logical Operators (AND, OR, NOT)
------------------------------------------------------------

-- Q5: Products priced above 30 AND stock more than 400
SELECT ProductName, UnitPrice, UnitsInStock
FROM Products
WHERE UnitPrice > 30 AND UnitsInStock > 400;

-- Q6: Employees from IT OR Finance departments
SELECT FirstName, LastName, DepartmentID
FROM Employees
WHERE DepartmentID = 7 OR DepartmentID = 10;


------------------------------------------------------------
-- Special Operators (IN, BETWEEN, LIKE, IS NULL)
------------------------------------------------------------

-- Q7: Locations in Mumbai, Pune, or Chennai (IN operator)
SELECT LocationName, City
FROM Locations
WHERE City IN ('Mumbai', 'Pune', 'Chennai');

-- Q8: Products priced between 20 and 40 (BETWEEN operator)
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 20 AND 40;

-- Q9: Employees whose email ends with '.co.in' (LIKE operator)
SELECT FirstName, Email
FROM Employees
WHERE Email LIKE '%.co.in';

-- Q10: Departments with no manager assigned (IS NULL)
SELECT DepartmentName, ManagerID
FROM Departments
WHERE ManagerID IS NULL;


------------------------------------------------------------
-- 2) CLAUSES
------------------------------------------------------------

-- Q11: Products expiring in the year 2025 (WHERE + YEAR)
SELECT ProductName, ExpiryDate
FROM Products
WHERE YEAR(ExpiryDate) = 2025;

-- Q12: Employees sorted by highest salary (ORDER BY DESC)
SELECT FirstName, LastName, Salary
FROM Employees
ORDER BY Salary DESC;

-- Q13: Count employees per department (GROUP BY)
SELECT DepartmentID, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentID;

-- Q14: Departments having more than 1 employee (GROUP BY + HAVING)
SELECT DepartmentID, COUNT(*) AS EmpCount
FROM Employees
GROUP BY DepartmentID
HAVING COUNT(*) > 1;

-- Q15: Top 5 most expensive products (LIMIT)
SELECT ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC
LIMIT 5;


------------------------------------------------------------
-- 3) ALIAS (Column Alias + Table Alias)
------------------------------------------------------------

-- Q16: Product price with GST added (Column Alias)
SELECT 
    ProductName,
    UnitPrice,
    UnitPrice * 1.18 AS PriceWithGST
FROM Products;

-- Q17: Join Employees + Departments using aliases (e & d)
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Q18: Customer alias example (c)
SELECT 
    c.CustomerName AS Name,
    c.LoyaltyPoints AS Points
FROM Customers c;


/* ============================================================
   1️⃣ CREATE TABLES WITH CASCADE RULES
   Demonstrating ON DELETE CASCADE and ON UPDATE CASCADE
   ============================================================ */

-- Parent Table: Departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

-- Child Table: Employees (depends on Departments)
-- Using ON DELETE CASCADE and ON UPDATE CASCADE
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10,2),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) 
        REFERENCES Departments(DepartmentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);



/* ============================================================
   2️⃣ INSERT SAMPLE DATA
   ============================================================ */

-- Insert departments
INSERT INTO Departments VALUES
(10, 'IT'),
(20, 'Finance'),
(30, 'HR');

-- Insert employees linked to departments
INSERT INTO Employees VALUES
(1, 'Rohan', 'Verma', 80000, 10),
(2, 'Neha', 'Patel', 90000, 10),
(3, 'Amit', 'Shah', 75000, 20),
(4, 'Priya', 'Iyer', 60000, 30);



/* ============================================================
   3️⃣ CASCADE DEMONSTRATION
   ============================================================ */

-- (A) ON DELETE CASCADE Example
-- Meaning: Deleting a department removes ALL its employees.

-- ❗ Example: Delete IT department → deletes employees with DeptID 10
DELETE FROM Departments
WHERE DepartmentID = 10;

-- After this:
-- Employees 1 & 2 (Rohan & Neha) are automatically DELETED.



-- (B) ON UPDATE CASCADE Example
-- Meaning: Updating a parent primary key updates child foreign keys automatically.

-- ❗ Example: Update DepartmentID = 20 → becomes 200
UPDATE Departments
SET DepartmentID = 200
WHERE DepartmentID = 20;

-- After this:
-- Employee 3 (Amit) now has DepartmentID = 200 updated automatically.


/* ============================================================
   4️⃣ NEAT & CLEAN DOCUMENTED QUERIES
   ============================================================ */

-- ----------------------------
-- DDL Example (ALTER TABLE)
-- ----------------------------
-- Add JoiningDate column to Employees table
ALTER TABLE Employees 
ADD COLUMN JoiningDate DATE;


-- ----------------------------
-- DML Example (UPDATE)
-- ----------------------------
-- Increase salary of Finance department employees by 10%
UPDATE Employees
SET Salary = Salary * 1.10
WHERE DepartmentID = 200;  -- Updated ID from cascade example


-- ----------------------------
-- DML Example (INSERT)
-- Insert new employee with new joining date
INSERT INTO Employees (EmployeeID, FirstName, LastName, Salary, DepartmentID, JoiningDate)
VALUES (5, 'Sneha', 'Kulkarni', 85000, 30, '2024-01-15');


-- ----------------------------
-- DML Example (DELETE)
-- Delete an employee
DELETE FROM Employees
WHERE EmployeeID = 4;



-- ----------------------------
-- DQL Example (SELECT)
-- Find top 5 highest paid employees
SELECT 
    FirstName AS EmployeeName, 
    Salary
FROM Employees
ORDER BY Salary DESC
LIMIT 5;


-- ----------------------------
-- DQL Example (JOIN)
-- Show employee names with their department names
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName
FROM Employees e
JOIN Departments d 
    ON e.DepartmentID = d.DepartmentID;


-- ----------------------------
-- DQL Example (Filtering with WHERE)
-- Show employees earning above 70,000
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary > 70000;


-- ----------------------------
-- GROUP BY Example
-- Count employees per department
SELECT 
    DepartmentID,
    COUNT(*) AS TotalEmployees
FROM Employees
GROUP BY DepartmentID;


-- ----------------------------
-- HAVING Example
-- Departments having more than 1 employee
SELECT 
    DepartmentID,
    COUNT(*) AS EmpCount
FROM Employees
GROUP BY DepartmentID
HAVING COUNT(*) > 1;
