/*---------------------------------------------------------
A. Simple Views
---------------------------------------------------------*/
-- View: Active Customers
CREATE VIEW ActiveCustomers AS
SELECT CustomerID, CustomerName, Email, City
FROM Customers
WHERE Status = 'Active';

-- View: In-Stock Products
CREATE VIEW InStockProducts AS
SELECT ProductID, ProductName, Price, Quantity
FROM Products
WHERE Quantity > 0;

-- View: High Salary Employees
CREATE VIEW HighSalaryEmployees AS
SELECT EmployeeID, EmployeeName, Salary
FROM Employees
WHERE Salary > 50000;

/* ---------------------------------------------------------
B. Views Using Joins
---------------------------------------------------------*/
-- View: Customer Orders Summary
CREATE VIEW CustomerOrders AS
SELECT c.CustomerID,
       c.CustomerName,
       o.OrderID,
       o.OrderDate,
       o.TotalAmount
FROM Customers c
JOIN Orders o 



-- Basic cursor to fetch employee names one by one
DECLARE emp_cursor CURSOR FOR
SELECT FirstName FROM Employees;

OPEN emp_cursor;

DECLARE @EmpName VARCHAR(100);

FETCH NEXT FROM emp_cursor INTO @EmpName;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Employee: ' + @EmpName;

    FETCH NEXT FROM emp_cursor INTO @EmpName;
END;

CLOSE emp_cursor;
DEALLOCATE emp_cursor;


-- Cursor to calculate 10% bonus and display result
DECLARE bonus_cursor CURSOR FOR
SELECT EmployeeID, Salary FROM Employees;

DECLARE @EmpID INT;
DECLARE @Salary DECIMAL(10,2);
DECLARE @Bonus DECIMAL(10,2);

OPEN bonus_cursor;

FETCH NEXT FROM bonus_cursor INTO @EmpID, @Salary;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Bonus = @Salary * 0.10;
    PRINT 'EmployeeID: ' + CAST(@EmpID AS VARCHAR) + 
          ' | Bonus: ' + CAST(@Bonus AS VARCHAR);

    FETCH NEXT FROM bonus_cursor INTO @EmpID, @Salary;
END;

CLOSE bonus_cursor;
DEALLOCATE bonus_cursor;


-- Increase employee salary by 5% using cursor
DECLARE update_cursor CURSOR FOR
SELECT EmployeeID, Salary FROM Employees;

DECLARE @ID INT;
DECLARE @OldSalary DECIMAL(10,2);
DECLARE @NewSalary DECIMAL(10,2);

OPEN update_cursor;

FETCH NEXT FROM update_cursor INTO @ID, @OldSalary;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @NewSalary = @OldSalary * 1.05;

    UPDATE Employees
    SET Salary = @NewSalary
    WHERE EmployeeID = @ID;

    PRINT 'Updated Salary for EmployeeID ' + CAST(@ID AS VARCHAR);

    FETCH NEXT FROM update_cursor INTO @ID, @OldSalary;
END;

CLOSE update_cursor;
DEALLOCATE update_cursor;


-- Apply 15% bonus only to employees with salary < 30000
DECLARE cond_cursor CURSOR FOR
SELECT EmployeeID, Salary FROM Employees
WHERE Salary < 30000;

DECLARE @CID INT;
DECLARE @CSalary DECIMAL(10,2);
DECLARE @CBonus DECIMAL(10,2);

OPEN cond_cursor;

FETCH NEXT FROM cond_cursor INTO @CID, @CSalary;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @CBonus = @CSalary * 0.15;

    PRINT 'Employee ' + CAST(@CID AS VARCHAR) + 
          ' Eligible Bonus: ' + CAST(@CBonus AS VARCHAR);

    FETCH NEXT FROM cond_cursor INTO @CID, @CSalary;
END;

CLOSE cond_cursor;
DEALLOCATE cond_cursor;


-- Calculate total amount per order using cursor
DECLARE order_cursor CURSOR FOR
SELECT OrderID, TotalAmount FROM Orders;

DECLARE @OID INT;
DECLARE @OTotal DECIMAL(10,2);

OPEN order_cursor;

FETCH NEXT FROM order_cursor INTO @OID, @OTotal;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'OrderID ' + CAST(@OID AS VARCHAR) + 
          ' | Amount: ' + CAST(@OTotal AS VARCHAR);

    FETCH NEXT FROM order_cursor INTO @OID, @OTotal;
END;

CLOSE order_cursor;
DEALLOCATE order_cursor;


-- Cursor showing customer with each order they placed
DECLARE cust_order_cursor CURSOR FOR
SELECT c.CustomerName, o.OrderID, o.TotalAmount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;

DECLARE @CName VARCHAR(100);
DECLARE @OrderID INT;
DECLARE @Amount DECIMAL(10,2);

OPEN cust_order_cursor;

FETCH NEXT FROM cust_order_cursor INTO @CName, @OrderID, @Amount;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Customer: ' + @CName + 
          ' | OrderID: ' + CAST(@OrderID AS VARCHAR) +
          ' | Amount: ' + CAST(@Amount AS VARCHAR);

    FETCH NEXT FROM cust_order_cursor INTO @CName, @OrderID, @Amount;
END;

CLOSE cust_order_cursor;
DEALLOCATE cust_order_cursor;


-- Always close & deallocate the cursor
CLOSE emp_cursor;
DEALLOCATE emp_cursor;


-- Procedure to update salary based on department
CREATE PROCEDURE UpdateSalaryByDept(IN dept_id INT, IN increment DECIMAL(10,2))
BEGIN
  UPDATE Employees
  SET Salary = Salary + increment
  WHERE DepartmentID = dept_id;
END;


-- Rank employees by salary within each department
SELECT EmployeeName, DepartmentID, Salary,
       RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
FROM Employees;


-- Rank employees by salary within each department
SELECT EmployeeName, DepartmentID, Salary,
       RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
FROM Employees;


-- DCL: Grant privilege
GRANT SELECT, INSERT ON Employees TO user1;

-- TCL: Using transaction
START TRANSACTION;
UPDATE Accounts SET Balance = Balance - 500 WHERE AccountID = 1;
UPDATE Accounts SET Balance = Balance + 500 WHERE AccountID = 2;
COMMIT;


-- Trigger to auto-update audit table on insert
CREATE TRIGGER after_employee_insert
AFTER INSERT ON Employees
FOR EACH ROW
INSERT INTO EmployeeAudit (EmpID, Action, ActionTime)
VALUES (NEW.EmployeeID, 'INSERT', NOW());


