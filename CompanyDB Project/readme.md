# CompanyDB Employee Management System

## 📋 Project Overview

The CompanyDB project implements a complete relational database management system for employee tracking, department management, project assignments, and dependent information. This comprehensive solution demonstrates full database lifecycle management from schema design to complex query execution.

## 🎯 Project Objectives

- Design and implement a normalized relational database schema
- Establish referential integrity through foreign key constraints
- Implement data validation with CHECK constraints
- Develop complex JOIN operations for cross-table analysis
- Calculate employee compensation and performance metrics

## 🛠️ Technical Implementation

### Database Schema Design

**Core Tables:**
| Table Name | Description | Key Constraints |
|------------|-------------|-----------------|
| `DEPARTMENT` | Department information and manager assignments | Primary key on DNUMBER |
| `EMPLOYEE` | Employee personal and employment details | Primary key on SSN, CHECK on SEX and SALARY |
| `DEPT_LOCATIONS` | Multi-location department tracking | Composite primary key |
| `PROJECT` | Project management and departmental assignments | Primary key on PNUMBER |
| `WORKS_ON` | Employee time allocation to projects | Composite primary key, CHECK on HOURS |
| `DEPENDENT` | Employee dependent information | Composite primary key, CHECK on SEX |

### Key Features

#### Data Integrity Implementation
- Primary key constraints on all tables
- Foreign key relationships with cascading updates
- CHECK constraints for data validation (SEX, SALARY, HOURS)
- UNIQUE constraints on department names

#### Sample Data Population
```sql
-- Department data
INSERT INTO DEPARTMENT VALUES
(1, 'IT', NULL, NULL),
(2, 'HR', NULL, NULL);

-- Employee data with manager relationships
INSERT INTO EMPLOYEE VALUES
('123456789', 'Omar', 'A', 'Ahmed', '1985-01-09', 'Cairo', 'M', 5000, NULL, 1),
('987654321', 'Sara', 'B', 'Ali', '1990-05-12', 'Alexandria', 'F', 6000, '123456789', 2);
```

#### Business Logic Queries

1. **Employee Compensation Analysis**
   - Annual salary calculations
   - Commission computations (10% of annual salary)
   - Salary threshold filtering

2. **Department and Project Management**
   - Department location tracking
   - Project assignment by department
   - Manager assignment and history

3. **Advanced Reporting**
   - Employee full name concatenation
   - Gender-based filtering
   - Department-specific project listings

## 📊 Sample Data Insights

The database includes sample data demonstrating:
- Multi-department structure (IT, HR)
- Employee-manager hierarchies
- Project assignments across departments
- Dependent relationships

## 🔧 Technologies Used
- T-SQL DDL and DML operations
- Referential integrity constraints
- Complex JOIN operations
- Date functions and calculations

## 📁 File Structure
```
📦 CompanyDB Project
 ┗ 📜 CompanyDB Assignment.sql    # Complete database implementation
```

## 🚀 How to Execute
1. Execute the script in SQL Server Management Studio
2. The script automatically creates the database and all tables
3. Sample data is inserted automatically
4. Test queries are provided at the end for validation

---

## 🎓 Program Recognition

**All four projects were developed as part of the prestigious **Digilians Initiative**, a collaborative program between:**

- **Ministry of Communications and Information Technology (MCIT)** 
- **Egyptian Military Academy** 

*This initiative represents Egypt's commitment to developing world-class technical talent and fostering digital innovation across the nation.*
