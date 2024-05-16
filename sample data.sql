drop user DEMO cascade;

create user DEMO identified by "JIAguwen--1234" DEFAULT TABLESPACE tbs1 quota unlimited on tbs1;

grant DBA to DEMO;




-- DROP TABLE DEMO.SALES ;

CREATE TABLE DEMO.SALES 
    ( 
     PROD_ID       NUMBER  NOT NULL , 
     CUST_ID       NUMBER  NOT NULL , 
     TIME_ID       DATE  NOT NULL , 
     CHANNEL_ID    NUMBER  NOT NULL , 
     PROMO_ID      NUMBER  NOT NULL , 
     QUANTITY_SOLD NUMBER (10,2)  NOT NULL , 
     AMOUNT_SOLD   NUMBER (10,2)  NOT NULL 
    ) TABLESPACE TBS1
;


COMMENT ON TABLE DEMO.SALES IS 'facts table, without a primary key; all rows are uniquely identified by the combination of all foreign keys';

COMMENT ON COLUMN DEMO.SALES.PROD_ID IS 'FK to the products dimension table' ;
COMMENT ON COLUMN DEMO.SALES.CUST_ID IS 'FK to the customers dimension table' ;
COMMENT ON COLUMN DEMO.SALES.TIME_ID IS 'FK to the times dimension table' ;
COMMENT ON COLUMN DEMO.SALES.CHANNEL_ID IS 'FK to the channels dimension table' ;
COMMENT ON COLUMN DEMO.SALES.PROMO_ID IS 'promotion identifier, without FK constraint (intentionally) to show outer join optimization' ;
COMMENT ON COLUMN DEMO.SALES.QUANTITY_SOLD IS 'product quantity sold with the transaction' ;
COMMENT ON COLUMN DEMO.SALES.AMOUNT_SOLD IS 'invoiced amount to the customer' ;

INSERT INTO DEMO.SALES (PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD) 
VALUES (101, 201, TO_DATE('2024-05-01', 'YYYY-MM-DD'), 1, 301, 5, 100.50);

INSERT INTO DEMO.SALES (PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD) 
VALUES (102, 202, TO_DATE('2024-05-02', 'YYYY-MM-DD'), 2, 302, 8, 150.75);

INSERT INTO DEMO.SALES (PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD) 
VALUES (103, 203, TO_DATE('2024-05-03', 'YYYY-MM-DD'), 1, 303, 10, 200.00);

INSERT INTO DEMO.SALES (PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD) 
VALUES (104, 204, TO_DATE('2024-05-04', 'YYYY-MM-DD'), 2, 304, 6, 120.25);

INSERT INTO DEMO.SALES (PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD) 
VALUES (105, 205, TO_DATE('2024-05-05', 'YYYY-MM-DD'), 1, 305, 12, 250.00);

INSERT INTO DEMO.SALES (PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD) 
VALUES (106, 206, TO_DATE('2024-05-06', 'YYYY-MM-DD'), 2, 306, 4, 90.75);

INSERT INTO DEMO.SALES (PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD) 
VALUES (107, 207, TO_DATE('2024-05-07', 'YYYY-MM-DD'), 1, 307, 7, 150.50);

INSERT INTO DEMO.SALES (PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD) 
VALUES (108, 208, TO_DATE('2024-05-08', 'YYYY-MM-DD'), 2, 308, 9, 180.25);

INSERT INTO DEMO.SALES (PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD) 
VALUES (109, 209, TO_DATE('2024-05-09', 'YYYY-MM-DD'), 1, 309, 3, 60.00);

INSERT INTO DEMO.SALES (PROD_ID, CUST_ID, TIME_ID, CHANNEL_ID, PROMO_ID, QUANTITY_SOLD, AMOUNT_SOLD) 
VALUES (110, 210, TO_DATE('2024-05-10', 'YYYY-MM-DD'), 2, 310, 11, 220.75);


CREATE TABLE DEMO.CUSTOMERS 
    ( 
     CUST_ID                NUMBER , 
     CUST_FIRST_NAME        VARCHAR2 (20)  NOT NULL , 
     CUST_LAST_NAME         VARCHAR2 (40)  NOT NULL , 
     CUST_GENDER            CHAR (1)  NOT NULL , 
     CUST_YEAR_OF_BIRTH     NUMBER (4)  NOT NULL , 
     CUST_MARITAL_STATUS    VARCHAR2 (20) , 
     CUST_STREET_ADDRESS    VARCHAR2 (40)  NOT NULL , 
     CUST_POSTAL_CODE       VARCHAR2 (10)  NOT NULL , 
     CUST_CITY              VARCHAR2 (30)  NOT NULL , 
     CUST_CITY_ID           NUMBER  NOT NULL , 
     CUST_STATE_PROVINCE    VARCHAR2 (40)  NOT NULL , 
     CUST_STATE_PROVINCE_ID NUMBER  NOT NULL , 
     COUNTRY_ID             NUMBER  NOT NULL , 
     CUST_MAIN_PHONE_NUMBER VARCHAR2 (25)  NOT NULL , 
     CUST_INCOME_LEVEL      VARCHAR2 (30) , 
     CUST_CREDIT_LIMIT      NUMBER , 
     CUST_EMAIL             VARCHAR2 (50) , 
     CUST_TOTAL             VARCHAR2 (14)  NOT NULL , 
     CUST_TOTAL_ID          NUMBER  NOT NULL , 
     CUST_SRC_ID            NUMBER , 
     CUST_EFF_FROM          DATE , 
     CUST_EFF_TO            DATE , 
     CUST_VALID             VARCHAR2 (1) 
    ) 
    TABLESPACE TBS1
;


COMMENT ON TABLE DEMO.CUSTOMERS IS 'dimension table';

COMMENT ON COLUMN DEMO.CUSTOMERS.CUST_ID IS 'primary key' ;
COMMENT ON COLUMN DEMO.CUSTOMERS.CUST_FIRST_NAME IS 'first name of the customer' ;
COMMENT ON COLUMN DEMO.CUSTOMERS.CUST_LAST_NAME IS 'last name of the customer' ;
COMMENT ON COLUMN DEMO.CUSTOMERS.CUST_GENDER IS 'gender; low cardinality attribute' ;
COMMENT ON COLUMN DEMO.CUSTOMERS.CUST_YEAR_OF_BIRTH IS 'customer year of birth' ;
COMMENT ON COLUMN DEMO.CUSTOMERS.CUST_MARITAL_STATUS IS 'customer marital status; low cardinality attribute' ;
COMMENT ON COLUMN DEMO.CUSTOMERS.CUST_STREET_ADDRESS IS 'customer street address' ;
COMMENT ON COLUMN DEMO.CUSTOMERS.CUST_POSTAL_CODE IS 'postal code of the customer' ;
COMMENT ON COLUMN DEMO.CUSTOMERS.CUST_CITY IS 'city where the customer lives' ;
COMMENT ON COLUMN DEMO.CUSTOMERS.CUST_STATE_PROVINCE IS 'customer geography: state or province' ;
COMMENT ON COLUMN DEMO.CUSTOMERS.COUNTRY_ID IS 'foreign key to the countries table (snowflake)' ;
COMMENT ON COLUMN DEMO.CUSTOMERS.CUST_MAIN_PHONE_NUMBER IS 'customer main phone number' ;
COMMENT ON COLUMN DEMO.CUSTOMERS.CUST_INCOME_LEVEL IS 'customer income level' ;
COMMENT ON COLUMN DEMO.CUSTOMERS.CUST_CREDIT_LIMIT IS 'customer credit limit' ;
COMMENT ON COLUMN DEMO.CUSTOMERS.CUST_EMAIL IS 'customer email id' ;


INSERT INTO DEMO.CUSTOMERS VALUES (1, 'John', 'Doe', 'M', 1985, 'Single', '123 Main St', '12345', 'Anytown', 1, 'AnyState', 1, 1, '123-456-7890', 'Low', 10000, 'john@example.com', '100.00', 1, 1, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-01', 'YYYY-MM-DD'), 'Y');
INSERT INTO DEMO.CUSTOMERS VALUES (2, 'Jane', 'Smith', 'F', 1990, 'Married', '456 Oak Ave', '54321', 'Othertown', 2, 'OtherState', 2, 2, '456-789-0123', 'Medium', 20000, 'jane@example.com', '200.00', 2, 2, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-01', 'YYYY-MM-DD'), 'Y');
INSERT INTO DEMO.CUSTOMERS VALUES (3, 'Michael', 'Johnson', 'M', 1980, 'Single', '789 Pine Rd', '67890', 'Anycity', 3, 'Anyprovince', 3, 3, '789-012-3456', 'High', 30000, 'michael@example.com', '300.00', 3, 3, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-01', 'YYYY-MM-DD'), 'Y');
INSERT INTO DEMO.CUSTOMERS VALUES (4, 'Emily', 'Brown', 'F', 1988, 'Married', '101 Elm St', '98765', 'Somecity', 4, 'Someprovince', 4, 4, '101-112-1314', 'Low', 15000, 'emily@example.com', '400.00', 4, 4, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-01', 'YYYY-MM-DD'), 'Y');
INSERT INTO DEMO.CUSTOMERS VALUES (5, 'Christopher', 'Wilson', 'M', 1975, 'Divorced', '202 Maple Dr', '56789', 'Anothercity', 5, 'Anotherprovince', 5, 5, '202-213-2425', 'Medium', 25000, 'chris@example.com', '500.00', 5, 5, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-01', 'YYYY-MM-DD'), 'Y');
INSERT INTO DEMO.CUSTOMERS VALUES (6, 'Amanda', 'Martinez', 'F', 1983, 'Single', '303 Cedar Ln', '34567', 'Somewhere', 6, 'Somewhereprovince', 6, 6, '303-314-3536', 'High', 35000, 'amanda@example.com', '600.00', 6, 6, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-01', 'YYYY-MM-DD'), 'Y');
INSERT INTO DEMO.CUSTOMERS VALUES (7, 'David', 'Anderson', 'M', 1970, 'Married', '404 Birch Rd', '12398', 'Nowhere', 7, 'Nowhereprovince', 7, 7, '404-415-4647', 'Low', 20000, 'david@example.com', '700.00', 7, 7, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-01', 'YYYY-MM-DD'), 'Y');
INSERT INTO DEMO.CUSTOMERS VALUES (8, 'Sarah', 'Garcia', 'F', 1978, 'Divorced', '505 Walnut St', '87654', 'Here', 8, 'Hereprovince', 8, 8, '505-516-5658', 'Medium', 30000, 'sarah@example.com', '800.00', 8, 8, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-01', 'YYYY-MM-DD'), 'Y');
INSERT INTO DEMO.CUSTOMERS VALUES (9, 'Daniel', 'Lopez', 'M', 1982, 'Single', '606 Pineapple Ave', '23456', 'There', 9, 'Thereprovince', 9, 9, '606-617-6869', 'High', 40000, 'daniel@example.com', '900.00', 9, 9, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-01', 'YYYY-MM-DD'), 'Y');
INSERT INTO DEMO.CUSTOMERS VALUES (10, 'Jessica', 'Rodriguez', 'F', 1976, 'Married', '707 Peachtree Blvd', '76543', 'Everywhere', 10, 'Everywhereprovince', 10, 10, '707-718-7879', 'Low', 25000, 'jessica@example.com', '1000.00', 10, 10, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-01', 'YYYY-MM-DD'), 'Y');
