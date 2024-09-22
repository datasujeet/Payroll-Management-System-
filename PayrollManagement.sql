
CREATE DATABASE PayrollManagement;

USE PayrollManagement;

'''
Key Components of a Payroll Management System
1.	Employee Information
2.	Salary Details
3.	Attendance Records
4.	Payroll Processing
5.	Tax and Deduction Management
6.	Payment Records
'''
-- Create the Tables

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DateOfBirth DATE,
    HireDate DATE,
    Department NVARCHAR(50),
    Position NVARCHAR(50),
    Email NVARCHAR(100),
    PhoneNumber NVARCHAR(20),
    Address NVARCHAR(255)
	);

--Salary Table

CREATE TABLE Salaries (
    SalaryID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    BasicSalary DECIMAL(18, 2) NOT NULL,
    Allowances DECIMAL(18, 2),
    Deductions DECIMAL(18, 2),
    EffectiveDate DATE NOT NULL
);

--Attendance Table

CREATE TABLE Attendance (
    AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    AttendanceDate DATE NOT NULL,
    Status NVARCHAR(10) NOT NULL -- Present, Absent, Leave, etc.
);

-- Payroll Table

CREATE TABLE Payroll (
    PayrollID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    PayDate DATE NOT NULL,
    GrossSalary DECIMAL(18, 2) NOT NULL,
    TaxAmount DECIMAL(18, 2),
    NetSalary DECIMAL(18, 2) NOT NULL,
    ProcessedBy NVARCHAR(50)
);

--Tax and Deduction Table

CREATE TABLE TaxDeductions (
    DeductionID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    DeductionType NVARCHAR(50), -- e.g., Income Tax, Health Insurance, etc.
    DeductionAmount DECIMAL(18, 2),
    DeductionDate DATE
);

--Payment Records Table

CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    PaymentDate DATE NOT NULL,
    PaymentMethod NVARCHAR(50), -- e.g., Bank Transfer, Cash, etc.
    AmountPaid DECIMAL(18, 2) NOT NULL,
    PayrollID INT FOREIGN KEY REFERENCES Payroll(PayrollID)
);

-- Inserting Sample Data

INSERT INTO Employees (FirstName, LastName, DateOfBirth, HireDate, Department, Position, Email, PhoneNumber, Address)
VALUES 
('John', 'Doe', '1985-05-20', '2010-01-15', 'HR', 'Manager', 'john.doe@example.com', '123-456-7890', '123 Main St');

INSERT INTO Salaries (EmployeeID, BasicSalary, Allowances, Deductions, EffectiveDate)
VALUES 
(1, 50000, 5000, 2000, '2024-01-01');

INSERT INTO Attendance (EmployeeID, AttendanceDate, Status)
VALUES 
(1, '2024-08-01', 'Present'),
(1, '2024-08-02', 'Present'),
(1, '2024-08-03', 'Absent');

INSERT INTO Payroll (EmployeeID, PayDate, GrossSalary, TaxAmount, NetSalary, ProcessedBy)
VALUES 
(1, '2024-08-31', 55000, 5000, 50000, 'Admin');

INSERT INTO TaxDeductions (EmployeeID, DeductionType, DeductionAmount, DeductionDate)
VALUES 
(1, 'Income Tax', 5000, '2024-08-31');

INSERT INTO Payments (EmployeeID, PaymentDate, PaymentMethod, AmountPaid, PayrollID)
VALUES 
(1, '2024-08-31', 'Bank Transfer', 50000, 1);

--Insert Multiple records
INSERT INTO Employees (FirstName, LastName, DateOfBirth, HireDate, Department, Position, Email, PhoneNumber, Address)
VALUES 
('Ankur', 'Patil', '1986-04-10', '2020-01-15', 'Recruiter', 'Executive', 'ankur.patil@egmail.com', '897-132-7890', '321 Left St'),
('Puskar', 'Joshi', '1985-02-10', '2023-01-15', 'Technical', 'Manager', 'puskar.joshi@yahoo.com', '978-543-1230', '875 Behind St'),
('Dileep', 'Sab', '1989-02-10', '2023-09-15', 'Account', 'Manager', 'dileep.Sab@hotmail.com', '873-925-4990', '753 Down St'),
('Kanis', 'Dashi', '1978-03-20', '2020-04-15', 'HR', 'Manager', 'puskar.joshi@yahoo.com', '123-456-7890', '982 Bank St');

--Insert Multiple Salaries records
INSERT INTO Salaries (EmployeeID, BasicSalary, Allowances, Deductions, EffectiveDate)
VALUES 
(2, 40000, 3000, 5000, '2023-01-01'),
(3, 50000, 6000, 7000, '2024-02-04'),
(4, 40000, 3000, 3000, '2024-04-06'),
(5, 30000, 2000, 4000, '2024-05-02');

INSERT INTO Attendance (EmployeeID, AttendanceDate, Status)
VALUES 
(2, '2024-07-01', 'Present'),
(1, '2024-02-01', 'Absent'),
(3, '2024-01-01', 'Absent');

INSERT INTO TaxDeductions (EmployeeID, DeductionType, DeductionAmount, DeductionDate)
VALUES 
(3, 'Other Tax', 100, '2024-08-31'),
(2, 'TDS Tax', 500, '2024-08-31'),
(4, 'Income Tax', 3000, '2024-08-31');

-- Querying Data
-- Retrieve an employee's payroll history:

SELECT 
    e.FirstName, e.LastName, p.PayDate, p.GrossSalary, p.TaxAmount, p.NetSalary
FROM 
    Employees e
JOIN 
    Payroll p ON e.EmployeeID = p.EmployeeID
WHERE 
    e.EmployeeID = 1;

--Extracting the domain name from email
SELECT*, SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS Domain_Name
FROM Employees;

--Identify the duplicate email id in a table
SELECT 
    Email,  -- Replace with the column(s) that define uniqueness
    COUNT(*) AS duplicate_count
FROM 
    Employees
GROUP BY 
    Email  -- Replace with the column(s) that define uniqueness
HAVING 
    COUNT(*) > 1;

--Find the employeeid getting salary more then average salary
--first method

SELECT *
FROM Salaries
WHERE BasicSalary > (SELECT AVG(BasicSalary) FROM Salaries);

--Second method
WITH SalaryCTE AS (
    SELECT *, AVG(BasicSalary) OVER() AS Average_Salary
    FROM Salaries
)
SELECT *
FROM SalaryCTE
WHERE BasicSalary > Average_Salary;

--Calculate Net Salary for All Employees:
SELECT e.FirstName, e.LastName, 
       (s.BasicSalary + s.Allowances - s.Deductions) AS NetSalary
FROM Employees e
JOIN Salaries s ON e.EmployeeID = s.EmployeeID;

--Calculate Monthly Payroll:
SELECT e.FirstName, e.LastName, 
       SUM(s.BasicSalary + s.Allowances - s.Deductions) AS TotalSalary
FROM Employees e
JOIN Salaries s ON e.EmployeeID = s.EmployeeID
GROUP BY e.FirstName, e.LastName;

--Retrieve Attendance Report for September 2023:
SELECT e.FirstName, e.LastName, a.AttendanceDate, a.Status
FROM Employees e
JOIN Attendance a ON e.EmployeeID = a.EmployeeID
WHERE a.AttendanceDate BETWEEN '2024-04-01' AND '2024-09-30';

select name from sys.tables;

--Monthly Tax and Deductions Summary:
SELECT e.FirstName, e.LastName, t.DeductionAmount, t.DeductionType
FROM Employees e
JOIN TaxDeductions t ON e.EmployeeID = t.EmployeeID
WHERE t.DeductionAmount > 100

--Top 3 Highest-Paid Employees:
SELECT TOP 3 e.FirstName, e.LastName, 
       (s.BasicSalary + s.Allowances - s.Deductions) AS NetSalary
FROM Employees e
JOIN Salaries s ON e.EmployeeID = s.EmployeeID
ORDER BY NetSalary DESC;

--Count of Employees in Each Department:
SELECT Department, COUNT(EmployeeID) AS TotalEmployees
FROM Employees
GROUP BY Department;

--Net Salary by Department:
SELECT e.Department, SUM(s.BasicSalary + s.Allowances - s.Deductions) AS TotalNetSalary
FROM Employees e
JOIN Salaries s ON e.EmployeeID = s.EmployeeID
GROUP BY e.Department;

--Employees with More than 1 Day of Absence:
SELECT e.FirstName, e.LastName, COUNT(a.Status) AS AbsentDays
FROM Employees e
JOIN Attendance a ON e.EmployeeID = a.EmployeeID
WHERE a.Status = 'Absent'
AND a.AttendanceDate BETWEEN '2023-09-01' AND '2024-09-30'
GROUP BY e.FirstName, e.LastName
HAVING COUNT(a.Status) > 1;


