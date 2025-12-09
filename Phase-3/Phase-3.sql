/* ============================================================
   1️⃣ INNER JOIN
   Meaning: Returns only matching rows from both tables
   ============================================================ */

-- 🔹 Customers with their orders
SELECT 
    c.CustomerName, 
    o.OrderDate, 
    o.TotalAmount
FROM Customers c
INNER JOIN Orders o 
    ON c.CustomerID = o.CustomerID;


-- 🔹 Orders with employee details
SELECT 
    o.OrderID,
    e.FirstName AS EmployeeName,
    o.OrderDate
FROM Orders o
INNER JOIN Employees e
    ON o.EmployeeID = e.EmployeeID;


-- 🔹 Products with Category info
SELECT 
    p.ProductName,
    c.CategoryName,
    p.UnitPrice
FROM Products p
INNER JOIN Categories c
    ON p.CategoryID = c.CategoryID;



/* ============================================================
   2️⃣ LEFT JOIN (LEFT OUTER JOIN)
   Meaning: Returns ALL rows from left table + matching from right.
            Non-matching = NULL.
   ============================================================ */

-- 🔹 Employees without a department
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName
FROM Employees e
LEFT JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentID IS NULL;


-- 🔹 Products that may not be supplied by any supplier
SELECT 
    p.ProductName,
    s.SupplierName
FROM Products p
LEFT JOIN Suppliers s
    ON p.SupplierID = s.SupplierID;


-- 🔹 Orders that may not have payments yet
SELECT 
    o.OrderID,
    o.TotalAmount,
    p.PaymentMode
FROM Orders o
LEFT JOIN Payments p
    ON o.OrderID = p.OrderID;



/* ============================================================
   3️⃣ RIGHT JOIN (RIGHT OUTER JOIN)
   Meaning: All records from right table + matching from left.
   ============================================================ */

-- 🔹 All departments including those with no employees
SELECT 
    d.DepartmentName,
    e.FirstName AS EmployeeName
FROM Employees e
RIGHT JOIN Departments d
    ON e.DepartmentID = d.DepartmentID;


-- 🔹 All suppliers including those with no products
SELECT 
    s.SupplierName,
    p.ProductName
FROM Products p
RIGHT JOIN Suppliers s
    ON p.SupplierID = s.SupplierID;



/* ============================================================
   4️⃣ FULL JOIN  (if supported, ex: PostgreSQL/SQL Server)
   Meaning: All rows from both sides (matches + non-matches)
   ============================================================ */

-- 🔹 All customers and all orders (matched or not)
-- (For MySQL use UNION of LEFT + RIGHT)
SELECT 
    c.CustomerName,
    o.OrderDate
FROM Customers c
LEFT JOIN Orders o 
    ON c.CustomerID = o.CustomerID

UNION

SELECT 
    c.CustomerName,
    o.OrderDate
FROM Customers c
RIGHT JOIN Orders o 
    ON c.CustomerID = o.CustomerID;



/* ============================================================
   5️⃣ SELF JOIN
   Meaning: Join table with itself (e.g., ParentCategory)
   ============================================================ */

-- 🔹 Categories with parent category name
SELECT 
    c.CategoryName AS ChildCategory,
    p.CategoryName AS ParentCategory
FROM Categories c
LEFT JOIN Categories p
    ON c.ParentCategoryID = p.CategoryID;



/* ============================================================
   6️⃣ CROSS JOIN
   Meaning: Returns cartesian product (A × B)
   ============================================================ */

-- 🔹 All employee × machine combinations
SELECT 
    e.FirstName AS Employee,
    m.MachineName
FROM Employees e
CROSS JOIN Machines m;


-- 🔹 All product × warehouse mapping (theoretical stock combinations)
SELECT 
    p.ProductName,
    w.WarehouseName
FROM Products p
CROSS JOIN Warehouses w;



/* ============================================================
   7️⃣ MULTI-TABLE JOINS
   ============================================================ */

-- 🔹 Order → Customer → Employee → Payment pipeline
SELECT 
    o.OrderID,
    c.CustomerName,
    e.FirstName AS ProcessedBy,
    p.PaymentMode,
    o.TotalAmount
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
LEFT JOIN Payments p ON o.OrderID = p.OrderID;


-- 🔹 Product inventory with warehouse and supplier info
SELECT 
    p.ProductName,
    w.WarehouseName,
    i.QuantityAvailable,
    s.SupplierName
FROM Inventory i
INNER JOIN Products p ON i.ProductID = p.ProductID
INNER JOIN Warehouses w ON i.WarehouseID = w.WarehouseID
LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID;



/* ============================================================
   8️⃣ ADVANCED JOINS WITH CONDITIONS
   ============================================================ */

-- 🔹 Employees with attendance status on a specific date
SELECT 
    e.FirstName,
    a.Status,
    a.CheckInTime,
    a.CheckOutTime
FROM Employees e
LEFT JOIN EmployeeAttendance a
    ON e.EmployeeID = a.EmployeeID
WHERE a.AttendanceDate = '2025-01-01';


-- 🔹 Orders with detailed line items (OrderDetails)
SELECT 
    o.OrderID,
    p.ProductName,
    od.Quantity,
    od.UnitPrice,
    od.Discount
FROM OrderDetails od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID;


/* ============================================================
   1️⃣ SCALAR SUBQUERY
   Meaning: Returns a single value (one row, one column)
   ============================================================ */

-- 🔹 Employees earning more than AVG salary
SELECT 
    FirstName, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);


-- 🔹 Products whose price is above the average unit price
SELECT 
    ProductName, UnitPrice
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products);


-- 🔹 Orders above overall average order amount
SELECT 
    OrderID, TotalAmount
FROM Orders
WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM Orders);



/* ============================================================
   2️⃣ SUBQUERY WITH IN
   ============================================================ */

-- 🔹 Customers who placed more than 5 orders
SELECT 
    CustomerID, CustomerName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    GROUP BY CustomerID
    HAVING COUNT(OrderID) > 5
);


-- 🔹 List of employees who handled any order
SELECT 
    EmployeeID, FirstName
FROM Employees
WHERE EmployeeID IN (
    SELECT DISTINCT EmployeeID FROM Orders
);


-- 🔹 Products that appear in at least one OrderDetails entry
SELECT 
    ProductID, ProductName
FROM Products
WHERE ProductID IN (
    SELECT DISTINCT ProductID FROM OrderDetails
);



/* ============================================================
   3️⃣ SUBQUERY WITH EXISTS (faster for large tables)
   ============================================================ */

-- 🔹 Customers who have at least one order
SELECT 
    CustomerID, CustomerName
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders o
    WHERE o.CustomerID = c.CustomerID
);


-- 🔹 Products that are currently in stock (Inventory)
SELECT 
    p.ProductName
FROM Products p
WHERE EXISTS (
    SELECT 1
    FROM Inventory i
    WHERE i.ProductID = p.ProductID
      AND i.QuantityAvailable > 0
);



/* ============================================================
   4️⃣ SUBQUERY WITH ANY / ALL
   ============================================================ */

-- 🔹 Products priced higher than ANY category average
SELECT 
    ProductName, UnitPrice
FROM Products
WHERE UnitPrice > ANY (
    SELECT AVG(UnitPrice)
    FROM Products
    GROUP BY CategoryID
);

-- 🔹 Employees with salary higher than ALL salaries in Department 2
SELECT 
    FirstName, Salary
FROM Employees
WHERE Salary > ALL (
    SELECT Salary FROM Employees WHERE DepartmentID = 2
);



/* ============================================================
   5️⃣ CORRELATED SUBQUERIES
   Meaning: Subquery depends on outer query row (executed for each row)
   ============================================================ */

-- 🔹 Employees whose salary is highest in their department
SELECT 
    e.FirstName, e.DepartmentID, e.Salary
FROM Employees e
WHERE Salary = (
    SELECT MAX(Salary)
    FROM Employees
    WHERE DepartmentID = e.DepartmentID
);


-- 🔹 Products whose price is higher than category average
SELECT 
    p.ProductName, p.UnitPrice
FROM Products p
WHERE UnitPrice > (
    SELECT AVG(UnitPrice)
    FROM Products
    WHERE CategoryID = p.CategoryID
);


-- 🔹 Customers who placed more orders than the average of ALL customers
SELECT
    c.CustomerName
FROM Customers c
WHERE (
    SELECT COUNT(*)
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
) > (
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(*) AS order_count
        FROM Orders
        GROUP BY CustomerID
    ) AS summary
);



/* ============================================================
   6️⃣ SUBQUERIES IN FROM (Inline Views / Derived Tables)
   ============================================================ */

-- 🔹 Top 3 highest selling products (based on total quantity)
SELECT 
    p.ProductName, summary.TotalSold
FROM (
    SELECT ProductID, SUM(Quantity) AS TotalSold
    FROM OrderDetails
    GROUP BY ProductID
) AS summary
INNER JOIN Products p ON summary.ProductID = p.ProductID
ORDER BY TotalSold DESC
LIMIT 3;


-- 🔹 Department-wise salary summary
SELECT 
    d.DepartmentName,
    x.TotalEmployees,
    x.AvgSalary
FROM (
    SELECT 
        DepartmentID,
        COUNT(*) AS TotalEmployees,
        AVG(Salary) AS AvgSalary
    FROM Employees
    GROUP BY DepartmentID
) AS x
INNER JOIN Departments d ON x.DepartmentID = d.DepartmentID;



/* ============================================================
   7️⃣ SUBQUERIES IN SELECT CLAUSE
   ============================================================ */

-- 🔹 Show each customer's total orders
SELECT 
    c.CustomerName,
    (SELECT COUNT(*) 
     FROM Orders o 
     WHERE o.CustomerID = c.CustomerID) AS TotalOrders
FROM Customers c;


-- 🔹 Show stock of each product from Inventory
SELECT 
    p.ProductName,
    (SELECT SUM(QuantityAvailable)
     FROM Inventory i
     WHERE i.ProductID = p.ProductID) AS TotalStock
FROM Products p;



/* ============================================================
   8️⃣ NESTED SUBQUERIES
   ============================================================ */

-- 🔹 Employees earning more than overall 2nd highest salary
SELECT 
    FirstName, Salary
FROM Employees
WHERE Salary > (
    SELECT MAX(Salary)
    FROM Employees
    WHERE Salary < (SELECT MAX(Salary) FROM Employees)
);


-- 🔹 Products whose price is above the avg of products above avg price
SELECT 
    ProductName, UnitPrice
FROM Products
WHERE UnitPrice > (
    SELECT AVG(UnitPrice)
    FROM Products
    WHERE UnitPrice > (
        SELECT AVG(UnitPrice) FROM Products
    )
);



/*---------------------------------------------------------
JOINS – Complete One-Shot Implementation
---------------------------------------------------------*/
-- Applied Multiple JOIN Types Across 25 Tables
-- INNER JOIN – Customers with their Orders
SELECT c.CustomerName, o.OrderDate
FROM Customers c
INNER JOIN Orders o 
      ON c.CustomerID = o.CustomerID;

-- LEFT JOIN – Employees without Projects
SELECT e.EmployeeName, p.ProjectName
FROM Employees e
LEFT JOIN Projects p 
       ON e.ProjectID = p.ProjectID
WHERE p.ProjectID IS NULL;

-- RIGHT JOIN – Suppliers with Products
SELECT s.SupplierName, p.ProductName
FROM Suppliers s
RIGHT JOIN Products p 
        ON s.SupplierID = p.SupplierID;


-- SELF JOIN – Employees & Their Managers
SELECT e.EmployeeName AS Employee,
       m.EmployeeName AS Manager
FROM Employees e
LEFT JOIN Employees m
       ON e.ManagerID = m.EmployeeID;

-- CROSS JOIN – Generate Combinations
SELECT EmployeeName, ShiftName
FROM Employees
CROSS JOIN Shifts;

/*---------------------------------------------------------
SUBQUERIES – Complete One-Shot Implementation
---------------------------------------------------------*/
Scalar Subquery – Salary > Average Salary
SELECT EmployeeName, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

-- IN Subquery – Customers With >5 Orders
SELECT CustomerID, CustomerName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    GROUP BY CustomerID
    HAVING COUNT(OrderID) > 5
);

-- EXISTS Subquery – Customers With Orders
SELECT c.CustomerID, c.CustomerName
FROM Customers c
WHERE EXISTS (
    SELECT 1 
    FROM Orders o 
    WHERE o.CustomerID = c.CustomerID
);

-- Correlated Subquery – Employees With Above-Dept Avg Salary
SELECT e.EmployeeName, e.Department, e.Salary
FROM Employees e
WHERE e.Salary > (
    SELECT AVG(e2.Salary)
    FROM Employees e2
    WHERE e2.Department = e.Department
);

-- Subquery in FROM Clause
SELECT Department, AVG(Salary) AS AvgDeptSalary
FROM (
    SELECT Department, Salary
    FROM Employees
) AS temp
GROUP BY Department;

/*---------------------------------------------------------
 FUNCTIONS + UDFs – Complete One-Shot Implementation
---------------------------------------------------------*/
-- A. Built-In Functions
-- String Functions
SELECT UPPER(EmployeeName) FROM Employees;
SELECT SUBSTRING(ProductName, 1, 5) FROM Products;
SELECT CONCAT(CustomerName, ' - ', City) FROM Customers;

-- Numeric Functions
SELECT ROUND(Salary) FROM Employees;
SELECT FLOOR(Price) FROM Products;

-- Date Functions
SELECT EmployeeName, JoiningDate
FROM Employees
WHERE YEAR(JoiningDate) = YEAR(CURDATE());

SELECT OrderID, DATEDIFF(CURDATE(), OrderDate)
FROM Orders;

-- Aggregate Functions
SELECT SUM(TotalAmount) AS TotalRevenue FROM Orders;
SELECT MIN(Price), MAX(Price) FROM Products;

-- B. User-Defined Functions (UDFs)
// UDF: Yearly Salary
CREATE FUNCTION GetAnnualSalary(monthly_salary DECIMAL(10,2))
RETURNS DECIMAL(12,2)
DETERMINISTIC
RETURN monthly_salary * 12;


-- UDF: Final Price After Discount
CREATE FUNCTION ApplyDiscount(price DECIMAL(10,2), discount DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
RETURN price - (price * discount / 100);

-- UDF: Student Grade Classification
CREATE FUNCTION GetGrade(score INT)
RETURNS VARCHAR(5)
DETERMINISTIC
RETURN (
    CASE
        WHEN score >= 90 THEN 'A+'
        WHEN score >= 75 THEN 'A'
        WHEN score >= 60 THEN 'B'
        WHEN score >= 45 THEN 'C'
        ELSE 'F'
    END
);

-- UDF: Total Stock Value
CREATE FUNCTION StockValue(qty INT, price DECIMAL(10,2))
RETURNS DECIMAL(12,2)
DETERMINISTIC
RETURN qty * price;

-- UDF: Age Calculation
CREATE FUNCTION GetAge(dob DATE)
RETURNS INT
DETERMINISTIC
RETURN TIMESTAMPDIFF(YEAR, dob, CURDATE());

-- UDF: Total Loan Calculation
CREATE FUNCTION TotalLoan(emi DECIMAL(10,2), months INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
RETURN emi * months;

/*---------------------------------------------------------
CASCADE RULES – ON DELETE / UPDATE CASCADE
---------------------------------------------------------*/
// Example Foreign Key With Cascades
ALTER TABLE Orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (CustomerID)
REFERENCES Customers(CustomerID)
ON DELETE CASCADE
ON UPDATE CASCADE;


/*---------------------------------------------------------
CLEAN DDL / DML / DQL QUERIES WITH COMMENTS
---------------------------------------------------------*/
DDL – Add Column
-- Add JoiningDate column
ALTER TABLE Employees 
ADD COLUMN JoiningDate DATE;

-- DML – Increase Salary
-- Increase salary of IT Department by 10%
UPDATE Employees
SET Salary = Salary * 1.10
WHERE Department = 'IT';

-- DQL – Top 5 Highest Paid Employees
/* Retrieve Top 5 Highest Salaries */
SELECT EmployeeName, Salary
FROM Employees
ORDER BY Salary DESC
LIMIT 5;