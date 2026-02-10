
-- 1) Create Database

CREATE DATABASE IF NOT EXISTS CompanyDB;

USE CompanyDB;


 --  2) Create Tables
  

-- DEPARTMENT
CREATE TABLE DEPARTMENT (
    DNUMBER INT PRIMARY KEY,
    DNAME VARCHAR(30) UNIQUE NOT NULL,
    MGRSSN CHAR(9),
    MGRSTARTDATE DATE
);

-- EMPLOYEE
CREATE TABLE EMPLOYEE (
    SSN CHAR(9) PRIMARY KEY,
    FNAME VARCHAR(20) NOT NULL,
    MINIT CHAR(1),
    LNAME VARCHAR(20) NOT NULL,
    BDATE DATE,
    ADDRESS VARCHAR(100),
    SEX CHAR(1) CHECK (SEX IN ('M','F')),
    SALARY DECIMAL(10,2) CHECK (SALARY > 0),
    SUPERSSN CHAR(9),
    DNO INT
);

-- DEPT_LOCATIONS
CREATE TABLE DEPT_LOCATIONS (
    DNUMBER INT,
    DLOCATION VARCHAR(30),
    PRIMARY KEY (DNUMBER, DLOCATION)
);

-- PROJECT
CREATE TABLE PROJECT (
    PNUMBER INT PRIMARY KEY,
    PNAME VARCHAR(30) NOT NULL,
    PLOCATION VARCHAR(30),
    DNUM INT
);

-- WORKS_ON
CREATE TABLE WORKS_ON (
    ESSN CHAR(9),
    PNO INT,
    HOURS DECIMAL(4,1) CHECK (HOURS >= 0),
    PRIMARY KEY (ESSN, PNO)
);

-- DEPENDENT
CREATE TABLE DEPENDENT (
    ESSN CHAR(9),
    DEPENDENT_NAME VARCHAR(30),
    SEX CHAR(1) CHECK (SEX IN ('M','F')),
    BDATE DATE,
    RELATIONSHIP VARCHAR(20),
    PRIMARY KEY (ESSN, DEPENDENT_NAME)
);


  -- 3) Add Foreign Keys


-- EMPLOYEE → DEPARTMENT
ALTER TABLE EMPLOYEE
ADD CONSTRAINT FK_EMP_DEPT
FOREIGN KEY (DNO) REFERENCES DEPARTMENT(DNUMBER);

-- EMPLOYEE supervises EMPLOYEE
ALTER TABLE EMPLOYEE
ADD CONSTRAINT FK_EMP_SUPERVISOR
FOREIGN KEY (SUPERSSN) REFERENCES EMPLOYEE(SSN);

-- DEPARTMENT manager
ALTER TABLE DEPARTMENT
ADD CONSTRAINT FK_DEPT_MGR
FOREIGN KEY (MGRSSN) REFERENCES EMPLOYEE(SSN);

-- DEPT_LOCATIONS → DEPARTMENT
ALTER TABLE DEPT_LOCATIONS
ADD CONSTRAINT FK_DEPT_LOC
FOREIGN KEY (DNUMBER) REFERENCES DEPARTMENT(DNUMBER);

-- PROJECT → DEPARTMENT
ALTER TABLE PROJECT
ADD CONSTRAINT FK_PROJECT_DEPT
FOREIGN KEY (DNUM) REFERENCES DEPARTMENT(DNUMBER);

-- WORKS_ON → EMPLOYEE & PROJECT
ALTER TABLE WORKS_ON
ADD CONSTRAINT FK_WORKS_EMP
FOREIGN KEY (ESSN) REFERENCES EMPLOYEE(SSN);

ALTER TABLE WORKS_ON
ADD CONSTRAINT FK_WORKS_PROJ
FOREIGN KEY (PNO) REFERENCES PROJECT(PNUMBER);

-- DEPENDENT → EMPLOYEE
ALTER TABLE DEPENDENT
ADD CONSTRAINT FK_DEP_EMP
FOREIGN KEY (ESSN) REFERENCES EMPLOYEE(SSN);

/* =========================================
   4) Insert Data
   ========================================= */

-- DEPARTMENT
INSERT INTO DEPARTMENT VALUES
(1, 'IT', NULL, NULL),
(2, 'HR', NULL, NULL);

-- EMPLOYEE
INSERT INTO EMPLOYEE VALUES
('123456789', 'Omar', 'A', 'Ahmed', '1985-01-09', 'Cairo', 'M', 5000, NULL, 1),
('987654321', 'Sara', 'B', 'Ali', '1990-05-12', 'Alexandria', 'F', 6000, '123456789', 2);

-- Update Managers
UPDATE DEPARTMENT SET MGRSSN='123456789', MGRSTARTDATE='2020-01-01' WHERE DNUMBER=1;
UPDATE DEPARTMENT SET MGRSSN='987654321', MGRSTARTDATE='2021-03-15' WHERE DNUMBER=2;

-- DEPT_LOCATIONS
INSERT INTO DEPT_LOCATIONS VALUES
(1, 'Cairo'),
(2, 'Alexandria');

-- PROJECT
INSERT INTO PROJECT VALUES
(10, 'Website Development', 'Cairo', 1),
(20, 'HR System', 'Alexandria', 2);

-- WORKS_ON
INSERT INTO WORKS_ON VALUES
('123456789', 10, 20),
('987654321', 20, 15);

-- DEPENDENT
INSERT INTO DEPENDENT VALUES
('123456789', 'Ahmed', 'M', '2010-02-10', 'Son'),
('987654321', 'Mona', 'F', '2012-07-20', 'Daughter');



-- =============================================
-- 4. Queries
-- =============================================

-- 1) Display all the employees data
SELECT * FROM Employee;

-- 2) Display employee First name, Last name, Salary, and Department number
SELECT FirstName, LastName, Salary, DepartmentID FROM Employee;

-- 3) Display all project names, locations, and responsible department
SELECT P.ProjName, P.Location AS ProjectLocation, D.DeptName AS DepartmentName
FROM Project P
JOIN Department D ON P.DeptID = D.DeptID;

-- 4) Display each employee full name and annual commission (10% of annual salary)
SELECT CONCAT(FirstName, ' ', LastName) AS FullName,
       (Salary * 12 * 0.10) AS AnnualComm
FROM Employee;

-- 5) Display employees Id and name who earn more than 1000 LE monthly
SELECT EmpID, CONCAT(FirstName, ' ', LastName) AS FullName
FROM Employee
WHERE Salary > 1000;

-- 6) Display employees Id and name who earn more than 10000 LE annually
SELECT EmpID, CONCAT(FirstName, ' ', LastName) AS FullName
FROM Employee
WHERE (Salary * 12) > 10000;

-- 7) Display names and salaries of female employees
SELECT CONCAT(FirstName, ' ', LastName) AS FullName, Salary
FROM Employee
WHERE Gender = 'F';

-- 8) Display each department id and name managed by manager with ID 968574
SELECT DeptID, DeptName
FROM Department
WHERE ManagerID = 968574;

-- 9) Display IDs, names, and locations of projects controlled by department 10
SELECT ProjID, ProjName, Location
FROM Project
WHERE DeptID = 10;
