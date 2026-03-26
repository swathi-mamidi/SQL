create database day_2;
use day_2;

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name       VARCHAR(50),
    department VARCHAR(30),
    age        INT
);

CREATE TABLE Marks (
    mark_id    INT PRIMARY KEY,
    student_id INT,
    subject    VARCHAR(30),
    marks      INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

INSERT INTO Students VALUES 
(1, 'Riya',  'CSE',  20),
(2, 'Arjun', 'ECE',  21),
(3, 'Sneha', 'CSE',  22),
(4, 'Kiran', 'MECH', 20);

INSERT INTO Marks VALUES 
(1, 1, 'Math',    88),
(2, 2, 'Math',    74),
(3, 3, 'Science', 92),
(4, 1, 'Science', 95),
(5, 4, 'Math',    60),
(6, 2, 'Science', 81);



-- ===================================================================================================OTHER TOPIC
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