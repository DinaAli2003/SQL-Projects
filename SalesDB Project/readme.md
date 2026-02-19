# Sales_DB_SV E-commerce Database System

## 📋 Project Overview

The Sales_DB_SV project implements a complete e-commerce database solution with customer management, product catalog, order processing, and payment tracking. This production-ready system demonstrates advanced SQL features including views, window functions, and complex business logic implementation.

## 🎯 Project Objectives

- Design a scalable e-commerce database architecture
- Implement business rules through constraints
- Create reusable views for common queries
- Develop advanced analytics with window functions
- Track customer spending patterns and order history

## 🛠️ Technical Implementation

### Database Schema Design

**Core Business Entities:**

| Table | Purpose | Key Features |
|-------|---------|--------------|
| `Customers` | Customer master data | Email uniqueness, auto-generated IDs |
| `CustomerProfiles` | Extended customer information | 1:1 relationship with Customers |
| `Categories` | Product categorization | Unique category names |
| `Products` | Product master | Price validation, active status |
| `Orders` | Order header | Status workflow, date tracking |
| `OrderItems` | Line items | Historical pricing, quantity validation |
| `Payments` | Payment tracking | Method validation, amount checks |

### Key Features

#### Data Integrity Implementation

**Check Constraints:**
```sql
-- Status values limited to workflow states
CONSTRAINT CK_Orders_Status CHECK (Status IN ('NEW','PAID','CANCELLED'))

-- Positive quantity validation
CONSTRAINT CK_OrderItems_Quantity CHECK (Quantity > 0)

-- Non-negative pricing
CONSTRAINT CK_OrderItems_UnitPrice CHECK (UnitPrice >= 0)

-- Payment method validation
CONSTRAINT CK_Payments_Method CHECK (Method IN ('CARD','CASH','WALLET'))
```

**Referential Integrity:**
- Foreign keys with ON DELETE CASCADE for order management
- Unique constraints for 1:1 relationships
- Default values for audit fields

### Business Logic Implementation

#### 1. Order Management System
- Status-based order tracking
- Historical price capture at order time
- Payment validation and processing

#### 2. Customer Analytics View
```sql
CREATE OR ALTER VIEW dbo.vw_OrdersTotals AS
SELECT o.OrderID, o.CustomerID, o.Status, o.OrderDate,
       SUM(oi.Quantity * oi.UnitPrice) AS OrderTotal
FROM dbo.Orders o
JOIN dbo.OrderItems oi ON oi.OrderID = o.OrderID
GROUP BY o.OrderID, o.CustomerID, o.status, o.OrderDate;
```

#### 3. Advanced Analytics

**Customer Lifetime Value Calculation:**
```sql
WITH CustomerSpend AS (
    SELECT c.CustomerID, c.FullName,
           ISNULL(SUM(v.OrderTotal), 0) AS TotalSpend
    FROM dbo.Customers c
    LEFT JOIN dbo.vw_OrdersTotals v
        ON v.CustomerID = c.CustomerID AND v.Status = 'PAID'
    GROUP BY c.CustomerID, c.FullName
)
SELECT * FROM CustomerSpend ORDER BY TotalSpend DESC;
```

**Customer Segmentation:**
- Spending tiers using RANK() function
- High-value customer identification (>500 spend)
- Multi-order customer analysis

**Order Pattern Analysis:**
```sql
-- Compare each order to customer average
SELECT CustomerID, OrderID, OrderTotal,
       AVG(OrderTotal) OVER (PARTITION BY CustomerID) AS AvgOrderForCustomer,
       OrderTotal - AVG(OrderTotal) OVER (PARTITION BY CustomerID) AS DiffFromAvg
FROM OrderTotal
ORDER BY CustomerID, OrderID;
```

## 📊 Business Reports Generated

1. **Customer Lifetime Value** - Total spend per customer with ranking
2. **High-Value Customers** - Customers exceeding 500 spending threshold
3. **Order Frequency Analysis** - Customers with multiple orders
4. **Order Line Item Details** - With running order totals per order
5. **Customer Spending Tiers** - Rank-based segmentation for marketing
6. **Order Comparison Analysis** - Individual orders vs customer average

## 🔧 Technologies Used
- Advanced T-SQL programming
- Window functions (RANK, PARTITION BY, OVER clause)
- Common Table Expressions (CTEs) for complex queries
- Views for query abstraction and reusability
- Transaction management concepts
- Complex JOIN operations across multiple tables
- Data validation through constraints


---

## 🎓 Program Recognition

**All four projects were developed as part of the prestigious **Digilians Initiative**, a collaborative program between:**

- **Ministry of Communications and Information Technology (MCIT)** 
- **Egyptian Military Academy** 

*This initiative represents Egypt's commitment to developing world-class technical talent and fostering digital innovation across the nation.*
