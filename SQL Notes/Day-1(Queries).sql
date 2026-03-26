-- ==================================================Question-1==========================================================================
CREATE DATABASE PRODUCT_DETAILS;
USE PRODUCT_DETAILS;
drop database product_details;

CREATE TABLE PRODUCT(
PRODUCT_ID INT PRIMARY KEY,
PRODUCT_NAME VARCHAR(100),
CATEGORY VARCHAR(50),
PRICE DECIMAL(8,2)
);

INSERT INTO PRODUCT(PRODUCT_ID,PRODUCT_NAME,CATEGORY,PRICE)VALUES
(1,'LAPTOP','ELECTRONICS',1200.00),
(2,'HEADPHONES','ELECTRONICS',99.99),
(3,'T-SHIRT','APPAREL',19.99),
(4,'COFFEE MAKER','APPLIANCES',49.99);
SELECT * FROM PRODUCT;
Insert into product values
(5, 'laptop', 'elec', 1300.00);

select product_id
from product
where product_name = "LaPTOP";

select product_id
from product
where Binary product_name = "LaPTOP";