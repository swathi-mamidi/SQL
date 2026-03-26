create database joins;
use joins;

-- Creating the table(departments)
CREATE TABLE departments (
    dept_id   INT         PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL
);

-- Creating employees table
CREATE TABLE employees (
    emp_id    INT         PRIMARY KEY,
    emp_name  VARCHAR(50) NOT NULL,
    dept_id   INT                       -- nullable FK
);

INSERT INTO departments VALUES
    (1, 'Engineering'),
    (2, 'Marketing'),
    (3, 'HR'),
    (4, 'Finance');
    
INSERT INTO employees VALUES
    (101, 'Ravi',   1),    
    (102, 'Priya',  2),    
    (103, 'Arjun',  1),    
    (104, 'Sneha',  3),    
    (105, 'Kiran',  NULL);
    
/* ===================================================INNER JOIN ==========================================*/
SELECT d.dept_id, d.dept_name, e.emp_name
FROM   departments d
INNER JOIN employees e ON d.dept_id = e.dept_id;

/* ===================================================LEFT JOIN ============================================*/
SELECT d.dept_id, d.dept_name, e.emp_name
FROM   departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id;

/* ==================================================RIGHT JOIN =============================================*/
SELECT d.dept_name, e.emp_id, e.emp_name
FROM   departments d
RIGHT JOIN employees e ON d.dept_id = e.dept_id;

/* ==================================================FULL OUTER JOIN ========================================*/
-- LEFT JOIN+ UNION +RIGHT JOIN
SELECT d.dept_id, d.dept_name, e.emp_name
FROM   departments d
LEFT JOIN  employees e ON d.dept_id = e.dept_id

UNION

SELECT d.dept_id, d.dept_name, e.emp_name
FROM   departments d
RIGHT JOIN employees e ON d.dept_id = e.dept_id;
/* ======================================================LEFT EXCLUSIVE ==========================================*/
SELECT d.dept_id, d.dept_name, e.emp_name
FROM   departments d
LEFT JOIN  employees e ON d.dept_id = e.dept_id
WHERE e.dept_id is null;

/* =======================================================RIGHT EXCLUSIVE =========================================*/
SELECT d.dept_name, e.emp_id, e.emp_name
FROM   departments d
RIGHT JOIN employees e ON d.dept_id = e.dept_id
where e.dept_id is null;

/* =======================================================OUTER EXCLUSIVE =========================================*/
SELECT d.dept_id, d.dept_name, e.emp_name
FROM   departments d
LEFT JOIN  employees e ON d.dept_id = e.dept_id
WHERE  e.dept_id IS NULL   -- unmatched LEFT rows

UNION

SELECT d.dept_id, d.dept_name, e.emp_name
FROM   departments d
RIGHT JOIN employees e ON d.dept_id = e.dept_id
WHERE  d.dept_id IS NULL;  -- unmatched RIGHT rows

-- =======================================================CROSS JOIN ==============================================
SELECT d.dept_name, e.emp_name
FROM   departments d
CROSS JOIN employees e;-- (M*N)

-- -- ====================================================JOINS========================================================
-- Join 
-- 1. self JOIN
create table employees1(
emp_id int primary key,
name varchar(50),
mgr_id int
);

insert into employees1 values
(1, 'nagaraju Sir', NULL),
(2, 'Manoj Sir', 1),
(3, 'Noor Mam', 1),
(4, 'Karthik sir', 2);

select emp.name as em_name,
mgr.name as mng_name
from employees1 emp 
JOIN EMPLOYEES1 mgr
on emp.emp_id = mgr.mgr_id;


insert into employees1 values
(5, 'Afroz sir', NULL);

/* =================================================UNION ALL==========================================================*/
SELECT dept_id -- 'from departments' AS source
FROM departments

UNION ALL

SELECT dept_id -- 'from employees'
FROM employees
WHERE dept_id IS NOT NULL;

-- ==========================================INTERSECT(Explicitly we didn't have , so instead we will go with INNER JOIN)================




