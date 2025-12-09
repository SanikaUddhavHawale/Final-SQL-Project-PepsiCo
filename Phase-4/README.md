SQL Features Implemented in the Project

This section documents the SQL concepts implemented from Views to Triggers, along with explanations and example queries used during the project.

Views

SQL Views are virtual tables created from SELECT queries. They help simplify complex logic, increase reusability, and provide controlled access to specific data.

Types of Views Used

Simple views with filters

Views created using JOINs

Aggregated views using GROUP BY

Example
-- View for active customers
CREATE VIEW ActiveCustomers AS
SELECT CustomerID, CustomerName
FROM Customers
WHERE Status = 'Active';

-- View with join & aggregation
CREATE VIEW DeptWiseSalary AS
SELECT DepartmentID, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentID;


Purpose:
These views support reporting, dashboard creation, reusable queries, and simplified business logic.

Cursors

Cursors allow row-by-row iteration through result sets when set-based operations are not sufficient.

Why Cursors Are Used

To process data sequentially

To apply operations on each row individually

Example
DECLARE emp_cursor CURSOR FOR
SELECT EmployeeName FROM Employees;

OPEN emp_cursor;
FETCH NEXT FROM emp_cursor;
CLOSE emp_cursor;
DEALLOCATE emp_cursor;


Purpose:
Useful for performing specialized validations, sequential logic, and complex transformations that require row-by-row operations.

Stored Procedures

Stored procedures encapsulate business logic inside the database. They support parameters and allow multiple operations in one execution.

Benefits

Reusable logic

Improved performance

Better security

Parameterized workflows

Example
CREATE PROCEDURE UpdateSalaryByDept(IN dept_id INT, IN increment DECIMAL(10,2))
BEGIN
  UPDATE Employees
  SET Salary = Salary + increment
  WHERE DepartmentID = dept_id;
END;


Purpose:
Used to update employee salary based on department-specific rules and business logic.

Window Functions

Window functions support advanced analytical operations without reducing result rows. They operate over partitions or windows of data.

Functions Used

ROW_NUMBER()

RANK(), DENSE_RANK()

NTILE()

LEAD(), LAG()

Example
SELECT EmployeeName, DepartmentID, Salary,
       RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
FROM Employees;


Purpose:
Helps in ranking, comparative analysis, trend detection, and performance evaluation.

DCL & TCL

These commands manage data access and control transactions to maintain consistency.

DCL (Data Control Language)

Controls user permissions.

GRANT SELECT, INSERT ON Employees TO user1;

TCL (Transaction Control Language)

Manages transactions to ensure accuracy and reliability.

START TRANSACTION;

UPDATE Accounts SET Balance = Balance - 500 WHERE AccountID = 1;
UPDATE Accounts SET Balance = Balance + 500 WHERE AccountID = 2;

COMMIT;


Purpose:
Used to maintain data integrity, secure access, and ensure safe execution of critical operations such as financial updates.

Triggers

Triggers are automatically executed when insert, update, or delete operations occur.

Types Implemented

BEFORE triggers

AFTER triggers

Example
CREATE TRIGGER after_employee_insert
AFTER INSERT ON Employees
FOR EACH ROW
INSERT INTO EmployeeAudit (EmpID, Action, ActionTime)
VALUES (NEW.EmployeeID, 'INSERT', NOW());


Purpose:
Used for auto-logging, auditing, validation, and maintaining data integrity across the system.
