# SQL — Complete Study Notes

> **Structured Query Language** — A complete reference from basics to advanced concepts, including tricky scenarios and interview questions.

---

## Table of Contents

1. [What is SQL?](#1-what-is-sql)
2. [SQL Case Sensitivity & Collation](#2-sql-case-sensitivity--collation)
3. [Data Types](#3-data-types)
4. [SQL Commands](#4-sql-commands)
5. [Constraints](#5-constraints)
6. [Clauses](#6-clauses)
7. [Operators](#7-operators)
8. [Functions](#8-functions)
9. [Order of Execution](#9-order-of-execution)
10. [Joins](#10-joins)
11. [Set Operations](#11-set-operations)
12. [Views & Stored Procedures](#12-views--stored-procedures)
13. [Subqueries, Derived Tables, CTEs & CASE](#13-subqueries-derived-tables-ctes--case-statement)
14. [ACID Properties & Triggers](#14-acid-properties--triggers)
15. [SQL Normalization](#15-sql-normalization)

---

## 1. What is SQL?

**SQL (Structured Query Language)** helps perform **CRUD Operations** on databases.

| Term | Definition |
|------|-----------|
| **DB (Database)** | The actual collection of organized data |
| **DBMS** | Software that interacts with the user, applications, and the database to capture and analyze data via CRUD operations |
| **RDBMS** | Data stored in rows and columns; SQL is used to retrieve and manipulate it |

### Why SQL?
- **Traditional Database** → Data stored in folder format → difficult to retrieve/modify
- **RDBMS** → Data in rows & columns → SQL makes CRUD operations easy

### Why MySQL?
- Easy to understand
- Free and open source

---

> **Interview Question**
>
> **The "Why":** Why would a company choose a Relational Database (RDBMS) over a simple NoSQL or File-based system for financial transactions?

---

## 2. SQL Case Sensitivity & Collation

SQL **keywords** are case-insensitive (`SELECT` = `select` = `Select`).
However, **data inside cells** may or may not be case-sensitive depending on **collation**.

### What is Collation?
> A set of rules that defines how characters are **compared and sorted** in a database column.

### Examples

```sql
-- Case-insensitive search (default behavior)
SELECT product_id
FROM product
WHERE product_name = 'LaPTOP';

-- Case-sensitive search using BINARY
SELECT product_id
FROM product
WHERE BINARY product_name = 'LaPTOP';
```

---

> 💡 **Tricky Scenarios**
>
> **A. Default Collation & Keywords**
> Since SQL is case-insensitive for keywords, does that mean data inside cells (like `'Apple'` vs `'apple'`) is also always treated as the same during a `WHERE` clause filter?
>
> **Answer:** No. It depends on the column's **collation**. Use `BINARY` or a `_bin` collation to enforce case-sensitive data comparison.

> **B. Password Security**
> If passwords are stored in a `VARCHAR` column with `utf8mb4_0900_ai_ci` collation, can a user log in with `"p@ssword123"` when their password is `"P@ssword123"`?
>
> **Answer:** Yes — `_ci` (Case Insensitive) treats them as the same. For passwords, always use `BINARY` or `_bin` collation so `"A"` ≠ `"a"`.

> **C. UNIQUE Constraint & Collation**
> A table has a `UNIQUE` constraint on `username`. `"Admin"` exists. Can `"admin"` be inserted?
>
> **Answer:**
> - `_ci` collation →  Throws **Duplicate Entry** error
> - `_cs` or `_bin` collation → Both are allowed

> **D. GROUP BY with Mixed Case**
> Cities list: `['London', 'london', 'LONDON', 'Paris']`
> ```sql
> SELECT city, COUNT(*) FROM travel GROUP BY city;
> ```
> **Answer:** Returns **2 rows** — `London (3)` and `Paris (1)`. All London variants are treated as identical under `_ci` collation.

---

## 3. Data Types

### Numeric Data Types

| Category | Types |
|----------|-------|
| **Fixed Integer** | `TINYINT`, `SMALLINT`, `MEDIUMINT`, `INT`, `BIGINT` |
| **Fixed Decimal** | `DECIMAL(m, d)` |
| **Approximate** | `FLOAT` (4 bytes), `REAL`, `DOUBLE` (8 bytes), `PRECISION` |

### String Data Types

| Category | Types |
|----------|-------|
| **Character String** | `CHAR`, `VARCHAR`, `TEXT`, `ENUM`, `SET` |
| **Binary String** | `BINARY`, `VARBINARY`, `BLOB` |

### Date & Time Data Types

| Type | Description |
|------|-------------|
| `DATE` | Date only |
| `TIME` | Time only |
| `DATETIME` | Date + Time (not timezone-aware) |
| `TIMESTAMP` | Date + Time (timezone-aware, uses server timezone) |
| `YEAR` | Year only |

---

> **Interview Questions**
>
> **Q1.** What data type would you use to store distance rounded to the nearest mile?
>
> **Answer:** `INTEGER` (or `INT`) for whole numbers. Use `DECIMAL` if precision is needed.

> **The "Why": VARCHAR vs TEXT**
>
> Why use `VARCHAR(255)` instead of `TEXT` for every string column?
>
> | | VARCHAR | TEXT |
> |--|---------|------|
> | **Storage** | Stored **inline** in the table row | Stored **off-row** with a pointer |
> | **Performance** | Faster — data found directly | Slower — requires an extra disk read |
>
> Use `VARCHAR` for small-to-medium strings for better performance.

> **Tricky Scenario: DATETIME vs TIMESTAMP**
>
> What is the functional difference when a user moves from New York to London?
>
> - `TIMESTAMP` → Adjusts to the **server's timezone**
> - `DATETIME` → Stores as-is, **not timezone-dependent**

> **The "Decimal" Logic: Money Storage**
>
> Why is `DECIMAL` preferred over `FLOAT` or `DOUBLE` for money?
>
> - `FLOAT`/`DOUBLE` → **Approximate** → `0.1 + 0.2 = 0.30000000000000004` ❌
> - `DECIMAL` → **Fixed-Point** → Each digit preserved exactly ✅
>
> In banking, floating-point errors accumulate into massive discrepancies.

---

## 4. SQL Commands

| Category | Commands |
|----------|----------|
| **DDL** (Data Definition Language) | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` |
| **DML** (Data Manipulation Language) | `INSERT`, `UPDATE`, `DELETE` |
| **DQL** (Data Query Language) | `SELECT` |
| **DCL** (Data Control Language) | `GRANT`, `REVOKE` |
| **TCL** (Transaction Control Language) | `SAVEPOINT`, `ROLLBACK`, `COMMIT` |

---

> **Interview Questions**
>
> **The "Why": TRUNCATE (DDL) vs DELETE (DML)**
>
> Both remove data — so why are they classified differently?
>
> | | DELETE | TRUNCATE |
> |--|--------|----------|
> | **Acts on** | The **data** inside the table | The **table structure** itself |
> | **Type** | DML | DDL |
> | **Rollback** | Can be rolled back | Cannot be rolled back (in most DBs) |
> | **WHERE clause** | Supported | Not supported |

> **Tricky Scenario:**
>
> If you run a `DELETE` without a `COMMIT` in a transaction, can another user see the changes? What about a `DROP` command?
>
> - `DELETE` without `COMMIT` → Changes are **not visible** to others (transaction is pending)
> - `DROP` → Is **auto-committed** (DDL commands implicitly commit)

---

## 5. Constraints

| Constraint | Description |
|------------|-------------|
| `NOT NULL` | Column must have a value |
| `UNIQUE KEY` | All values in column must be unique |
| `PRIMARY KEY` | Uniquely identifies each row; NOT NULL + UNIQUE |
| `FOREIGN KEY` | Links to PRIMARY KEY of another table |
| `COMPOSITE KEY` | A key made of two or more columns |
| `DEFAULT` | Assigns a default value if none provided |
| `CHECK` | Validates data against a condition |

---

> **Interview Questions**
>
> **The "Why": Multiple UNIQUE Keys vs PRIMARY KEY**
>
> Can a table have multiple `UNIQUE` keys? If so, why do we still need a `PRIMARY KEY`?
>
> **Answer:** Yes, a table can have multiple `UNIQUE` keys. But `PRIMARY KEY` is still needed for:
> - Structural identity of each row
> - Establishing relationships with other tables via `FOREIGN KEY`
> - A `PRIMARY KEY` cannot be `NULL`; a `UNIQUE` key can

> **FOREIGN KEY & Deletion Behavior**
>
> Can you delete a parent row while a child row still references it?
>
> **Answer:** By default → Throws an error.
>
> | Option | Behavior |
> |--------|----------|
> | `ON DELETE CASCADE` | Deletes all child rows automatically |
> | `ON DELETE SET NULL` | Sets child's FK column to `NULL` |

> **Can referential integrity be enforced without using `FOREIGN KEY` keyword?**
>
> **Answer:** Yes — through application-level checks or triggers, though it's less reliable than DB-level constraints.

---

## 6. Clauses

| Clause | Purpose |
|--------|---------|
| `WHERE` | Filters rows **before** grouping |
| `GROUP BY` | Groups rows sharing a value |
| `HAVING` | Filters groups **after** `GROUP BY` |
| `ORDER BY` | Sorts the result set |
| `LIMIT` | Restricts number of rows returned |
| `TOP` | Returns top N rows (SQL Server) |
| `FROM` | Specifies source table |
| `AND` / `OR` | Logical row filtering |

### LIKE Pattern Matching

| Pattern | Meaning |
|---------|---------|
| `%` | Zero, one, or multiple characters |
| `_` | Exactly one character |

```sql
-- Starts with 'a'
SELECT * FROM products WHERE name LIKE 'a%';

-- 'a' is in the second position
SELECT * FROM products WHERE name LIKE '_a%';
```

---

> **Interview Questions**
>
> **The "Why": WHERE vs HAVING**
>
> | | WHERE | HAVING |
> |--|-------|--------|
> | **Filters** | Individual rows | Grouped data |
> | **Timing** | Before `GROUP BY` | After `GROUP BY` |
> | **Aggregate functions** | Cannot use | Can use |
> | **Used with** | Any query | Typically with `GROUP BY` |

> **Tricky Scenario: HAVING without GROUP BY**
>
> ```sql
> SELECT SUM(salary) FROM Employees HAVING SUM(salary) > 1000000;
> ```
> **Answer:** Yes — it treats the **entire table as one group**. Returns the sum only if total payroll exceeds 1,000,000.

---

## 7. Operators

| Category | Operators |
|----------|-----------|
| **Arithmetic** | `+`, `-`, `*`, `/`, `%` |
| **Assignment** | `+=`, `-=`, `*=`, `/=`, `%=` |
| **Comparison** | `<`, `>`, `<=`, `>=`, `=`, `!=` / `<>` |
| **Logical** | `AND` (`&&`), `OR` (`\|\|`), `NOT` |
| **Bitwise** | `&`, `^` (XOR), `\|`, `~` (inversion) |

> Note: `//` (floor division) is **not** a standard SQL operator.

---

> **Tricky Scenario**
>
> Why does `SELECT * FROM users WHERE age != NULL` return **zero results**, even if there are users with no age listed?
>
> **Answer:** `NULL` represents **"Unknown"** — not zero, not empty. You cannot compare with `NULL` using `!=` or `=`.
>
> Correct approach:
> ```sql
> SELECT * FROM users WHERE age IS NULL;
> SELECT * FROM users WHERE age IS NOT NULL;
> ```

---

## 8. Functions

### a. Aggregate Functions

| Function | Description |
|----------|-------------|
| `COUNT()` | Counts rows |
| `SUM()` | Sum of values |
| `AVG()` | Average of values |
| `MIN()` | Minimum value |
| `MAX()` | Maximum value |

**Miscellaneous:**

| Function | Description |
|----------|-------------|
| `ABS()` | Absolute value |
| `ROUND()` | Rounds a number |
| `CEIL()` / `CEILING()` | Rounds up |
| `FLOOR()` | Rounds down |

---

> **Tricky Scenario: COUNT(*) vs COUNT(column)**
>
> | | COUNT(*) | COUNT(column_name) |
> |--|----------|-------------------|
> | Counts | Every row | Only rows where column is **NOT NULL** |

> **Random 10 Rows:**
> ```sql
> SELECT * FROM table_name ORDER BY RAND() LIMIT 10;
> ```

> **Handling NULL with default value:**
> ```sql
> -- Returns 50 if price is NULL
> SELECT name, COALESCE(price, 50) FROM products;
> -- MySQL specific
> SELECT name, IFNULL(price, 50) FROM products;
> ```

---

### b. Date & Time Functions

| Function | Description |
|----------|-------------|
| `NOW()` | Current date and time |
| `CURDATE()` / `CURRENT_DATE()` | Current date |
| `CURTIME()` / `CURRENT_TIME()` | Current time |
| `DATE()` | Extracts date part |
| `DATE_ADD()` | Adds interval to date |
| `DATE_SUB()` | Subtracts interval from date |
| `DATEDIFF()` | Difference between two dates |
| `TO_DAYS()` | Converts date to day number |

### DATE_FORMAT() Specifiers

| Specifier | Output |
|-----------|--------|
| `%a` | Abbreviated weekday (Mon, Tue...) |
| `%b` | Abbreviated month (Jan–Dec) |
| `%c` | Month numeric (1–12) |
| `%d` | Day of month (01–31) |
| `%H` | Hour 24-hour clock |
| `%h` | Hour 12-hour clock |
| `%i` | Minutes |
| `%S` / `%s` | Seconds |

---

### c. String Functions

| Function | Description |
|----------|-------------|
| `CONCAT()` | Joins strings |
| `CHAR_LENGTH()` | Number of **characters** |
| `LENGTH()` | Number of **bytes** |
| `UPPER()` | Converts to uppercase |
| `LOWER()` | Converts to lowercase |
| `REPLACE()` | Replaces substring |
| `SUBSTRING()` / `SUBSTR()` | Extracts part of string |
| `LEFT()` | Left N characters |
| `RIGHT()` | Right N characters |
| `TRIM()` | Removes leading/trailing spaces |
| `REVERSE()` | Reverses string |
| `ASCII()` | ASCII value of character |
| `CHAR()` | Character from ASCII number |
| `LPAD()` | Left-pads string |
| `RPAD()` | Right-pads string |

---

> **Interview Questions**
>
> **CHAR_LENGTH() vs LENGTH()**
>
> | | CHAR_LENGTH() | LENGTH() |
> |--|---------------|----------|
> | Counts | Number of **characters** | Number of **bytes** |
> | Difference | Same for ASCII | Different for multi-byte characters (e.g., UTF-8 emojis) |

> **ASCII() vs CHAR()**
>
> | | ASCII() | CHAR() |
> |--|---------|--------|
> | Input | A character | A number |
> | Output | Its ASCII number | The character for that ASCII number |

---

### d. Window Functions

#### Ranking Functions

| Function | Behavior on Ties |
|----------|-----------------|
| `RANK()` | Skips next rank(s) after a tie |
| `DENSE_RANK()` | Does **not** skip ranks after a tie |
| `ROW_NUMBER()` | Always unique, no tie handling |
| `PERCENT_RANK()` | Relative rank as a percentage |

#### Syntax

```sql
function_name() OVER (
    PARTITION BY column    -- divides data into groups
    ORDER BY column        -- specifies order within each group
)
```

#### Other Window Functions

| Function | Description |
|----------|-------------|
| `NTILE(n)` | Divides rows into n buckets |
| `LAG()` | Access previous row's value |
| `LEAD()` | Access next row's value |

---

> **Interview Question**
>
> **RANK() vs DENSE_RANK() — Tie at 1st place (3 people)**
>
> | Position | RANK() | DENSE_RANK() |
> |----------|--------|--------------|
> | Tied 1st | 1 | 1 |
> | Tied 1st | 1 | 1 |
> | Tied 1st | 1 | 1 |
> | Next | 4 (skips 2, 3) | 2 |

---

## 9. Order of Execution

| Writing Order | Execution Order |
|---------------|-----------------|
| `SELECT` | `FROM` |
| `FROM` | `WHERE` |
| `WHERE` | `GROUP BY` |
| `GROUP BY` | `HAVING` |
| `HAVING` | `SELECT` |
| `ORDER BY` | `ORDER BY` |
| `LIMIT` | `LIMIT` |

---

> **Interview Questions**
>
> **The "Why": SELECT is written first but executed almost last?**
>
> Because the database must first **know which table** to pull from (`FROM`), then **filter rows** (`WHERE`), then **group them** (`GROUP BY`), before it can **select/compute** the columns (`SELECT`).

> **Tricky Scenario: Alias in WHERE vs ORDER BY**
>
> Why can't you use a `SELECT` alias in `WHERE`, but you can in `ORDER BY`?
>
> **Answer:** `WHERE` executes **before** `SELECT`, so the alias doesn't exist yet. `ORDER BY` executes **after** `SELECT`, so it can see the alias.

---

## 10. Joins

| Join Type | Returns |
|-----------|---------|
| `INNER JOIN` | Only matching rows from both tables |
| `LEFT JOIN` | All left rows + matching right rows |
| `RIGHT JOIN` | All right rows + matching left rows |
| `FULL OUTER JOIN` | All rows from both tables |
| **Left Exclusive** | All left rows **minus** matching rows |
| **Right Exclusive** | All right rows **minus** matching rows |
| **Outer Exclusive** | All rows from both **minus** matching rows |
| `CROSS JOIN` | Cartesian product (m × n rows) |
| `SELF JOIN` | Table joined with itself |

---

> **Interview Questions**
>
> **Can we join tables without a Foreign Key?**
>
> **Answer:** Yes. A `JOIN` only needs a common column with matching values. Foreign Key is a constraint, not a requirement for joining.

> **The "Why": LEFT JOIN vs INNER JOIN**
>
> Use `LEFT JOIN` when you want **all records from the left table** even if there's no match in the right table.
>
> **Real-world example:** Get all customers and their orders — including customers who have placed **no orders yet**.
> ```sql
> SELECT customers.name, orders.order_id
> FROM customers
> LEFT JOIN orders ON customers.id = orders.customer_id;
> ```

> **Tricky Scenario: Self Join**
>
> When would you absolutely need a `SELF JOIN`?
>
> **Answer:** In an **employee-manager hierarchy** where both employees and managers live in the same table:
> ```sql
> SELECT e.name AS Employee, m.name AS Manager
> FROM employees e
> JOIN employees m ON e.manager_id = m.id;
> ```

---

## 11. Set Operations

| Operation | Description |
|-----------|-------------|
| `UNION` | Combines results, removes duplicates |
| `UNION ALL` | Combines results, keeps duplicates |
| `INTERSECT` | Returns only common rows |

---

## 12. Views & Stored Procedures

| Concept | Description |
|---------|-------------|
| **VIEW** | A virtual table based on a saved `SELECT` query |
| **STORED PROCEDURE** | A saved block of SQL code that can be executed on demand |

---

## 13. Subqueries, Derived Tables, CTEs & CASE Statement

| Concept | Description |
|---------|-------------|
| **Subquery** | A query nested inside another query |
| **Derived Table** | A subquery used in the `FROM` clause |
| **CTE** (Common Table Expression) | A named temporary result set using `WITH` |
| **CASE Statement** | Conditional logic inside SQL |

---

> **Interview Question**
>
> **The "Why": CTE vs Subquery**
>
> | | Subquery | CTE |
> |--|----------|-----|
> | **Readability** | Can get nested and hard to read | Clean, named, readable |
> | **Reusability** | Must repeat if needed multiple times | Can be referenced multiple times |
> | **Debugging** | Hard to isolate | Easier to test step by step |
> | **Recursion** | Not supported | Supported |

---

## 14. ACID Properties & Triggers

| Property | Meaning |
|----------|---------|
| **Atomicity** | All operations succeed or none do |
| **Consistency** | Data remains valid before and after transaction |
| **Isolation** | Transactions don't interfere with each other |
| **Durability** | Committed data persists even after a crash |

---

> **Tricky Scenario**
>
> If a system crashes mid-transaction, which ACID property ensures no "half-finished" data?
>
> **Answer:** **Atomicity** — the transaction is either fully completed or fully rolled back. No partial state is saved.

---

## 15. SQL Normalization

### Normal Forms Overview

| Form | Rule |
|------|------|
| **0NF** | Raw, unnormalized data |
| **1NF** | Every cell must hold **one value** — no multi-valued cells (e.g., no `"Laptop, Mouse"` in one cell) |
| **2NF** | Every non-key column must depend on the **whole** primary key — no partial dependency |
| **3NF** | Every non-key column must depend **only on the primary key** — no transitive dependency |
| **BCNF** (3.5NF) | For every functional dependency A → B, A must be a **superkey** |

### Key Terms

| Term | Definition |
|------|-----------|
| **Superkey** | A single or combination of columns that uniquely identifies rows |
| **Functional Dependency** | A → B means knowing A determines B |
| **Partial Dependency** | A non-key column depends on only **part** of a composite key |
| **Transitive Dependency** | A non-key column depends on another non-key column |

---

> **Interview Questions**
>
> **The "Why": Can a database be "too normalized"?**
>
> **Answer:** Yes. The performance cost of 3NF:
> - More tables → more `JOIN` operations
> - `JOIN`s are expensive on large datasets
> - Sometimes **denormalization** is intentional for read-heavy systems (e.g., data warehouses)

> **Tricky Scenario: Single-column PK and 2NF**
>
> If a table has a single-column Primary Key, is it automatically in 2NF?
>
> **Answer:** **Yes** — 2NF only concerns **partial dependencies**, which can only exist with **composite keys**. A single-column PK has no parts to be partially dependent on, so 2NF is automatically satisfied.

---

