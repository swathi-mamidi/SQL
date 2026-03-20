## SQL — Structured Query Language
---
### Table of Contents

1. [What is SQL?](#1-what-is-sql)
2. [SQL Categories (DDL, DML, DQL, DCL, TCL)](#2-sql-categories)
3. [Data Types](#3-data-types)
4. [DDL — Creating & Managing Structure](#4-ddl)
5. [DML — Inserting, Updating, Deleting](#5-dml)
6. [DQL — SELECT & Querying](#6-dql)
7. [Clauses — WHERE, ORDER BY, GROUP BY, HAVING](#7-clauses)
8. [JOINs](#8-joins)
9. [Subqueries & CTEs](#9-subqueries--ctes)
10. [Aggregate Functions](#10-aggregate-functions)
11. [Window Functions](#11-window-functions)
12. [Indexes](#12-indexes)
13. [Constraints](#13-constraints)
14. [Views](#14-views)
15. [Stored Procedures & Functions](#15-stored-procedures--functions)
16. [Triggers](#16-triggers)
17. [Transactions & ACID](#17-transactions--acid)
18. [Normalization](#18-normalization)
19. [Performance & Optimization](#19-performance--optimization)
20. [Interview Questions — Conceptual](#20-interview-questions--conceptual)
21. [Interview Questions — Query Writing](#21-interview-questions--query-writing)
22. [Real-World Scenario Questions](#22-real-world-scenario-questions)

---

### 1. What is SQL?

SQL (Structured Query Language) is the standard language for **relational database management systems (RDBMS)**. It lets you create, read, update, and delete data stored in tables.

**Popular RDBMS:** MySQL, PostgreSQL, SQL Server (T-SQL), Oracle, SQLite

---

### 2. SQL Categories

| Category | Full Form | Purpose | Commands |
|---|---|---|---|
| DDL | Data Definition Language | Structure of DB | `CREATE`, `ALTER`, `DROP`, `TRUNCATE`, `RENAME` |
| DML | Data Manipulation Language | Data inside tables | `INSERT`, `UPDATE`, `DELETE`, `MERGE` |
| DQL | Data Query Language | Retrieve data | `SELECT` |
| DCL | Data Control Language | Permissions | `GRANT`, `REVOKE` |
| TCL | Transaction Control Language | Manage transactions | `COMMIT`, `ROLLBACK`, `SAVEPOINT` |

---

### 3. Data Types

```sql
-- Numeric
INT, BIGINT, SMALLINT, TINYINT
DECIMAL(p, s), NUMERIC(p, s)    -- exact precision (use for money)
FLOAT, DOUBLE                    -- approximate

-- String
VARCHAR(n)   -- variable length, up to n chars
CHAR(n)      -- fixed length (padded with spaces)
TEXT         -- large text blocks

-- Date/Time
DATE         -- YYYY-MM-DD
TIME         -- HH:MM:SS
DATETIME     -- YYYY-MM-DD HH:MM:SS
TIMESTAMP    -- auto-updated (great for audit columns)

-- Other
BOOLEAN / BOOL
BLOB         -- binary large object
JSON         -- supported in MySQL 5.7+, PostgreSQL
```

---

### 4. DDL

```sql
-- Create a table
CREATE TABLE employees (
    emp_id     INT PRIMARY KEY AUTO_INCREMENT,
    name       VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary     DECIMAL(10, 2),
    hire_date  DATE,
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

-- Add a column
ALTER TABLE employees ADD COLUMN email VARCHAR(255);

-- Modify a column
ALTER TABLE employees MODIFY COLUMN salary DECIMAL(12, 2);

-- Rename a column (PostgreSQL / MySQL 8+)
ALTER TABLE employees RENAME COLUMN name TO full_name;

-- Drop a column
ALTER TABLE employees DROP COLUMN email;

-- Drop table
DROP TABLE employees;

-- Truncate (deletes all rows, resets auto-increment, no rollback in most DBs)
TRUNCATE TABLE employees;
```

---

### 5. DML

```sql
-- Insert single row
INSERT INTO employees (name, department, salary, hire_date)
VALUES ('Aarav Shah', 'Engineering', 85000.00, '2023-06-15');

-- Insert multiple rows
INSERT INTO employees (name, department, salary, hire_date) VALUES
('Priya Reddy', 'HR', 60000.00, '2022-01-10'),
('Ravi Kumar', 'Finance', 72000.00, '2021-09-01');

-- Update
UPDATE employees
SET salary = salary * 1.10
WHERE department = 'Engineering';

-- Delete specific rows
DELETE FROM employees WHERE emp_id = 5;

-- Upsert (INSERT or UPDATE if exists) — MySQL
INSERT INTO employees (emp_id, name, salary) VALUES (1, 'Aarav Shah', 90000)
ON DUPLICATE KEY UPDATE salary = VALUES(salary);

-- MERGE (SQL Server / Oracle)
MERGE INTO target_table AS t
USING source_table AS s ON t.id = s.id
WHEN MATCHED THEN UPDATE SET t.salary = s.salary
WHEN NOT MATCHED THEN INSERT (id, name) VALUES (s.id, s.name);
```

---

### 6. DQL

```sql
-- Basic SELECT
SELECT * FROM employees;
SELECT name, department, salary FROM employees;

-- Aliasing
SELECT name AS employee_name, salary * 12 AS annual_salary
FROM employees;

-- DISTINCT
SELECT DISTINCT department FROM employees;

-- LIMIT / OFFSET (pagination)
SELECT * FROM employees ORDER BY salary DESC LIMIT 10 OFFSET 20;

-- CASE expression
SELECT name,
    CASE
        WHEN salary >= 100000 THEN 'Senior'
        WHEN salary >= 60000  THEN 'Mid'
        ELSE 'Junior'
    END AS grade
FROM employees;
```

---

### 7. Clauses

```sql
-- WHERE (filter rows)
SELECT * FROM employees WHERE department = 'Engineering' AND salary > 70000;
SELECT * FROM employees WHERE department IN ('HR', 'Finance');
SELECT * FROM employees WHERE name LIKE 'A%';      -- starts with A
SELECT * FROM employees WHERE hire_date BETWEEN '2022-01-01' AND '2023-12-31';
SELECT * FROM employees WHERE manager_id IS NULL;   -- top-level managers

-- ORDER BY
SELECT * FROM employees ORDER BY salary DESC, name ASC;

-- GROUP BY
SELECT department, COUNT(*) AS total, AVG(salary) AS avg_salary
FROM employees
GROUP BY department;

-- HAVING (filter after aggregation — unlike WHERE which filters before)
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 70000;

-- Execution order (important for interviews!)
-- FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT
```

---

### 8. JOINs

```sql
-- Sample tables: employees(emp_id, name, dept_id), departments(dept_id, dept_name)

-- INNER JOIN — only matching rows from both tables
SELECT e.name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;

-- LEFT JOIN — all rows from left, matched rows from right (NULL if no match)
SELECT e.name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;

-- RIGHT JOIN — all rows from right, matched rows from left
SELECT e.name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

-- FULL OUTER JOIN — all rows from both tables
SELECT e.name, d.dept_name
FROM employees e
FULL OUTER JOIN departments d ON e.dept_id = d.dept_id;

-- CROSS JOIN — cartesian product (every combination)
SELECT e.name, d.dept_name FROM employees e CROSS JOIN departments d;

-- SELF JOIN — join a table to itself (e.g., find manager names)
SELECT e.name AS employee, m.name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;

-- Join on multiple conditions
SELECT * FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id AND oi.quantity > 1;
```

---

### 9. Subqueries & CTEs

```sql
-- Subquery in WHERE
SELECT name, salary FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Subquery in FROM (derived table)
SELECT dept_name, avg_sal
FROM (
    SELECT department AS dept_name, AVG(salary) AS avg_sal
    FROM employees
    GROUP BY department
) AS dept_stats
WHERE avg_sal > 70000;

-- Correlated subquery (references outer query — row by row)
SELECT name, salary FROM employees e
WHERE salary > (
    SELECT AVG(salary) FROM employees
    WHERE department = e.department   -- correlated
);

-- EXISTS / NOT EXISTS
SELECT name FROM employees e
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.manager_id = e.emp_id
);

-- CTE (Common Table Expression) — readable, reusable within a query
WITH high_earners AS (
    SELECT emp_id, name, salary, department
    FROM employees
    WHERE salary > 80000
),
dept_counts AS (
    SELECT department, COUNT(*) AS cnt FROM high_earners GROUP BY department
)
SELECT h.name, h.salary, d.cnt AS dept_high_earner_count
FROM high_earners h
JOIN dept_counts d ON h.department = d.department;

-- Recursive CTE — great for org charts / hierarchies
WITH RECURSIVE org_chart AS (
    -- Base case: top-level employees (no manager)
    SELECT emp_id, name, manager_id, 0 AS level
    FROM employees WHERE manager_id IS NULL

    UNION ALL

    -- Recursive case
    SELECT e.emp_id, e.name, e.manager_id, oc.level + 1
    FROM employees e
    JOIN org_chart oc ON e.manager_id = oc.emp_id
)
SELECT * FROM org_chart ORDER BY level;
```

---

### 10. Aggregate Functions

```sql
SELECT
    COUNT(*)                AS total_rows,
    COUNT(DISTINCT dept_id) AS unique_depts,
    SUM(salary)             AS total_payroll,
    AVG(salary)             AS average_salary,
    MIN(salary)             AS min_salary,
    MAX(salary)             AS max_salary,
    STDDEV(salary)          AS salary_stddev,
    GROUP_CONCAT(name ORDER BY name SEPARATOR ', ')  -- MySQL only
FROM employees;

-- NULL behaviour: COUNT(*) counts all rows; COUNT(col) skips NULLs
-- AVG, SUM, MIN, MAX all ignore NULLs
```

---

### 11. Window Functions

Window functions compute across a "window" of related rows **without collapsing them** (unlike GROUP BY).

```sql
-- Syntax: function() OVER (PARTITION BY ... ORDER BY ... ROWS/RANGE ...)

-- ROW_NUMBER — unique sequential rank
SELECT name, department, salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_num
FROM employees;

-- RANK vs DENSE_RANK
-- RANK:       1, 1, 3 (skips 2)
-- DENSE_RANK: 1, 1, 2 (no skip)
SELECT name, salary,
    RANK()       OVER (ORDER BY salary DESC) AS rnk,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rnk
FROM employees;

-- NTILE — split into N buckets
SELECT name, salary, NTILE(4) OVER (ORDER BY salary) AS quartile FROM employees;

-- LAG / LEAD — access previous/next row
SELECT name, salary,
    LAG(salary, 1)  OVER (PARTITION BY department ORDER BY hire_date) AS prev_salary,
    LEAD(salary, 1) OVER (PARTITION BY department ORDER BY hire_date) AS next_salary
FROM employees;

-- Running total
SELECT name, hire_date, salary,
    SUM(salary) OVER (PARTITION BY department ORDER BY hire_date
                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM employees;

-- FIRST_VALUE / LAST_VALUE
SELECT name, salary,
    FIRST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS highest_in_dept
FROM employees;
```

---

### 12. Indexes

```sql
-- Create index (speeds up reads on large tables)
CREATE INDEX idx_emp_dept ON employees(department);

-- Composite index (column order matters — put most selective first)
CREATE INDEX idx_dept_salary ON employees(department, salary);

-- Unique index
CREATE UNIQUE INDEX idx_unique_email ON employees(email);

-- Full-text index (MySQL)
CREATE FULLTEXT INDEX idx_ft_name ON employees(name);

-- Drop index
DROP INDEX idx_emp_dept ON employees;       -- MySQL
DROP INDEX idx_emp_dept;                    -- PostgreSQL (implicit table binding)

-- View indexes (MySQL)
SHOW INDEX FROM employees;

-- When indexes help:  WHERE, JOIN ON, ORDER BY, GROUP BY columns
-- When indexes hurt:  Heavy INSERT/UPDATE/DELETE workloads; tiny tables
-- Avoid:  Functions on indexed columns: WHERE YEAR(hire_date) = 2023  ← index not used
-- Better: WHERE hire_date BETWEEN '2023-01-01' AND '2023-12-31'
```

---

### 13. Constraints

```sql
CREATE TABLE orders (
    order_id   INT          PRIMARY KEY,          -- unique + not null
    user_id    INT          NOT NULL,
    amount     DECIMAL(10,2) CHECK (amount > 0),  -- value rule
    status     VARCHAR(20)  DEFAULT 'pending',    -- default value
    order_date DATE         DEFAULT CURRENT_DATE,
    UNIQUE (user_id, order_date),                 -- composite unique
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE                          -- delete orders if user deleted
        ON UPDATE CASCADE                          -- update FK if PK changes
);

-- ON DELETE options: CASCADE | SET NULL | SET DEFAULT | RESTRICT | NO ACTION
```

---

### 14. Views

```sql
-- Create a view (stored query, not stored data)
CREATE VIEW active_employees AS
SELECT emp_id, name, department, salary
FROM employees
WHERE status = 'active';

-- Query a view like a table
SELECT * FROM active_employees WHERE department = 'Engineering';

-- Update a view
CREATE OR REPLACE VIEW active_employees AS
SELECT emp_id, name, department FROM employees WHERE status = 'active';

-- Drop a view
DROP VIEW active_employees;

-- Materialized view (PostgreSQL — stores actual data, must be refreshed)
CREATE MATERIALIZED VIEW dept_summary AS
SELECT department, COUNT(*) AS cnt, AVG(salary) AS avg_sal
FROM employees GROUP BY department;

REFRESH MATERIALIZED VIEW dept_summary;
```

---

### 15. Stored Procedures & Functions

```sql
-- Stored Procedure (MySQL)
DELIMITER $$
CREATE PROCEDURE give_raise(IN dept VARCHAR(50), IN pct DECIMAL(5,2))
BEGIN
    UPDATE employees
    SET salary = salary * (1 + pct / 100)
    WHERE department = dept;
    SELECT ROW_COUNT() AS rows_updated;
END$$
DELIMITER ;

CALL give_raise('Engineering', 10.00);

-- Function (returns a value, usable in SELECT)
DELIMITER $$
CREATE FUNCTION annual_salary(monthly DECIMAL(10,2))
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    RETURN monthly * 12;
END$$
DELIMITER ;

SELECT name, annual_salary(salary) AS yearly FROM employees;
```

---

### 16. Triggers

```sql
-- Log salary changes automatically
CREATE TABLE salary_audit (
    audit_id   INT PRIMARY KEY AUTO_INCREMENT,
    emp_id     INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER trg_salary_change
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO salary_audit (emp_id, old_salary, new_salary)
        VALUES (OLD.emp_id, OLD.salary, NEW.salary);
    END IF;
END;

-- Trigger types: BEFORE / AFTER × INSERT / UPDATE / DELETE
```

---

### 17. Transactions & ACID

```sql
-- Transaction block
START TRANSACTION;

UPDATE accounts SET balance = balance - 5000 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 5000 WHERE account_id = 2;

-- If all good:
COMMIT;

-- If something went wrong:
ROLLBACK;

-- Savepoint (partial rollback)
START TRANSACTION;
INSERT INTO orders (user_id, amount) VALUES (1, 200);
SAVEPOINT sp1;
INSERT INTO orders (user_id, amount) VALUES (2, 300);
-- Undo only the second insert
ROLLBACK TO SAVEPOINT sp1;
COMMIT;
```

### ACID Properties

| Property | Meaning |
|---|---|
| **Atomicity** | All operations in a transaction succeed or all fail — no partial commits |
| **Consistency** | DB moves from one valid state to another; constraints always satisfied |
| **Isolation** | Concurrent transactions don't interfere; controlled by isolation levels |
| **Durability** | Once committed, data survives crashes (written to disk) |

### Isolation Levels (read problems they prevent)

| Level | Dirty Read | Non-Repeatable Read | Phantom Read |
|---|---|---|---|
| READ UNCOMMITTED | ✅ possible | ✅ possible | ✅ possible |
| READ COMMITTED | ❌ prevented | ✅ possible | ✅ possible |
| REPEATABLE READ | ❌ prevented | ❌ prevented | ✅ possible |
| SERIALIZABLE | ❌ prevented | ❌ prevented | ❌ prevented |

---

### 18. Normalization

Normalization removes redundancy and ensures data integrity.

| Normal Form | Rule |
|---|---|
| **1NF** | Each column has atomic values; no repeating groups |
| **2NF** | 1NF + no partial dependency (every non-key column depends on the whole PK) |
| **3NF** | 2NF + no transitive dependency (non-key column depends only on PK, not another non-key) |
| **BCNF** | Stricter 3NF — every determinant must be a candidate key |
| **4NF** | No multi-valued dependencies |

**Denormalization** = intentionally introducing redundancy for read performance (common in data warehouses, OLAP).

---

### 19. Performance & Optimization

```sql
-- EXPLAIN / EXPLAIN ANALYZE (see query execution plan)
EXPLAIN SELECT * FROM employees WHERE department = 'Engineering';
EXPLAIN ANALYZE SELECT ...;  -- PostgreSQL (also executes the query)

-- Tips:
-- 1. Use indexes on JOIN and WHERE columns
-- 2. Avoid SELECT * — fetch only needed columns
-- 3. Avoid functions on indexed columns in WHERE
-- 4. Use EXISTS instead of IN for large subqueries
-- 5. Use LIMIT to restrict result sets
-- 6. Use CTEs for readability (may not always be faster)
-- 7. Avoid N+1 queries — batch with JOINs
-- 8. Partition large tables (range/hash/list partitioning)

-- Slow query: scan-heavy
SELECT * FROM orders WHERE YEAR(order_date) = 2024;

-- Fast equivalent: index-friendly range
SELECT * FROM orders WHERE order_date >= '2024-01-01' AND order_date < '2025-01-01';
```

---

### 20. Interview Questions — Conceptual

### Fundamentals
1. What is the difference between `DELETE`, `TRUNCATE`, and `DROP`?
2. What is the difference between `WHERE` and `HAVING`?
3. What is the order of SQL clause execution?
4. What is a primary key vs. a foreign key?
5. What is a composite key?
6. What is the difference between `CHAR` and `VARCHAR`?
7. What is a NULL value? How does it behave in comparisons and aggregations?
8. What is the difference between `UNION` and `UNION ALL`?

### Joins
9. Explain the difference between `INNER JOIN` and `LEFT JOIN` with an example.
10. What is a CROSS JOIN and when would you use it?
11. What is a SELF JOIN? Give a real-world use case.
12. Can you join more than two tables? How?

### Indexes & Performance
13. What is an index? How does it improve performance?
14. What is a clustered vs. a non-clustered index?
15. When should you NOT use an index?
16. What is query execution plan? How do you read it?
17. What is the difference between OLTP and OLAP?

### Advanced
18. What are window functions? How are they different from GROUP BY?
19. What is the difference between `RANK()`, `DENSE_RANK()`, and `ROW_NUMBER()`?
20. What is a CTE? When would you prefer a CTE over a subquery?
21. What is a recursive CTE?
22. What is a materialized view vs. a regular view?
23. What are ACID properties? Explain each.
24. What are database isolation levels? What is a dirty read?
25. What is normalization? Explain 1NF, 2NF, 3NF with examples.
26. What is the difference between a stored procedure and a function?
27. What is a trigger? Give an example use case.
28. What is deadlock? How do you prevent it?
29. What is sharding? When would you use it?
30. Explain the difference between optimistic and pessimistic locking.

---

### 21. Interview Questions — Query Writing

> Use this schema for all problems:
> - `employees(emp_id, name, department, salary, hire_date, manager_id)`
> - `departments(dept_id, dept_name, location)`
> - `orders(order_id, user_id, product_id, amount, order_date, status)`
> - `products(product_id, name, price, category, stock)`

### Easy
1. Find all employees earning more than ₹80,000.
2. List all unique departments.
3. Count the number of employees in each department.
4. Find the top 5 highest-paid employees.
5. Find employees who were hired in the last 30 days.

### Medium
6. Find the second highest salary in the `employees` table.
7. Get the name of the department with the most employees.
8. List employees who earn more than their department's average salary.
9. Find all managers (employees who appear in the `manager_id` column).
10. Get products that have never been ordered.
11. Find the running total of salary by hire date per department.
12. For each department, show the highest-paid and lowest-paid employee in the same row.

### Hard
13. Find the Nth highest salary (make it generic — handle any N).
14. Find employees who joined the company in the same month and year as their manager.
15. For each order, show: order_id, user name, product name, amount, and rank of this order within the user's orders (most expensive = 1).
16. Write a query to detect duplicate rows in the `employees` table (same name + department).
17. Find all departments where no employee earns below ₹50,000.
18. Write a recursive query to output the full management hierarchy (emp → manager → manager's manager).

---

### 22. Real-World Scenario Questions

These test system thinking, not just syntax.

1. **E-commerce:** Write a query to find the top 3 best-selling products by total revenue in the last 90 days, along with the percentage of total revenue each represents.

2. **Banking:** A `transactions` table has `(txn_id, account_id, txn_type, amount, txn_date)`. Write a query to find all accounts that had a negative balance at any point in time (cumulative running total dips below 0).

3. **HR Analytics:** An `attendance` table has `(emp_id, date, status)` where status is 'present'/'absent'. Find employees who were absent for 3 or more consecutive days in any given month.

4. **Reporting:** A `sales` table has monthly revenue data. Write a query that shows month-over-month growth percentage.

5. **Data Quality:** You have a `customers` table with duplicate email addresses. Write a query to keep only the most recently created record for each email and delete the rest.

6. **Inventory:** Find products whose stock has fallen below their reorder level, and for each, show how many pending orders are currently waiting to be fulfilled.

7. **Session Analysis:** A `user_events` table stores `(user_id, event_type, event_time)`. Define a session as a sequence of events where no two consecutive events are more than 30 minutes apart. Write a query to assign a session_id to each event.

8. **Recommendation:** Write a query to find "customers who bought product A also frequently bought product B" — the basis of collaborative filtering.

---

### 📌 Quick Reference Cheat Sheet

```sql
-- Pattern matching
WHERE name LIKE 'A%'          -- starts with A
WHERE name LIKE '%kumar'      -- ends with kumar
WHERE name LIKE '%raj%'       -- contains raj
WHERE name REGEXP '^[A-Z]'    -- MySQL regex

-- NULL handling
IS NULL / IS NOT NULL
COALESCE(col, 'default')      -- returns first non-NULL value
NULLIF(a, b)                  -- returns NULL if a = b, else returns a
IFNULL(col, 0)                -- MySQL: replace NULL with 0

-- String functions
CONCAT(first_name, ' ', last_name)
UPPER(name), LOWER(name)
TRIM(name), LTRIM(), RTRIM()
LENGTH(name), CHAR_LENGTH(name)
SUBSTRING(name, 1, 3)
REPLACE(name, 'old', 'new')

-- Date functions
NOW(), CURDATE(), CURTIME()
DATE_ADD(hire_date, INTERVAL 1 YEAR)
DATEDIFF(NOW(), hire_date)
DATE_FORMAT(hire_date, '%Y-%m')
YEAR(hire_date), MONTH(hire_date), DAY(hire_date)

-- Conditional
CASE WHEN ... THEN ... ELSE ... END
IF(condition, true_val, false_val)   -- MySQL only
IIF(condition, true_val, false_val)  -- SQL Server only
```

---

