create database queries;
use queries;

CREATE TABLE worker (
    worker_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

CREATE TABLE bonus (
    worker_ref_id INT,
    bonus_amount INT
);

INSERT INTO worker VALUES
(1, 'Ravi',   'HR',       50000),
(2, 'Priya',  'HR',       60000),
(3, 'Arjun',  'IT',       80000),
(4, 'Sneha',  'IT',       90000),
(5, 'Kiran',  'Finance',  70000),
(6, 'Divya',  'Finance',  70000),
(7, 'Amit',   'IT',       90000),
(8, 'Neha',   'HR',       55000);

INSERT INTO bonus VALUES
(1, 5000),
(3, 7000),
(5, 6000);

-- ===============================================Second Highest Salary==========================================================
SELECT MAX(salary)
FROM worker
WHERE salary NOT IN (SELECT MAX(salary) FROM worker);

-- =============================================one row twice=========================================

