# PostgreSQL-Essential-Training_LL

based on Course on Linkedin Learning

- [PostgreSQL-Essential-Training_LL](#postgresql-essential-training_ll)
  - [Getting started with PostgreSQL](#getting-started-with-postgresql)
  - [An Introduction to Relational Databases](#an-introduction-to-relational-databases)
    - [Native Data Types](#native-data-types)
    - [Join tables together with relationships](#join-tables-together-with-relationships)
  - [Building a database](#building-a-database)
  - [Retrieve Information with Queries](#retrieve-information-with-queries)
    - [Join table](#join-table)
    - [Save query as a database view](#save-query-as-a-database-view)
  - [Managing data](#managing-data)
    - [Table Indexes](#table-indexes)
    - [Automatically fill in default values](#automatically-fill-in-default-values)
    - [Constrain acceptable input values](#constrain-acceptable-input-values)
    - [challenge](#challenge)
  - [Database Administration in PostgreSQL](#database-administration-in-postgresql)
    - [Backup Strategy](#backup-strategy)
  - [Conclusion](#conclusion)


## Getting started with PostgreSQL

Relational Database Management System (RDBMS)

Structured Query Language (SQL)

columns: atrributes, fields (descriptive adjectives)

Nouns: people places events that you store information about

`CREATE DATABASE favoritecolors;`

`CREATE TABLE colors (ColorID int, ColorName char(20));`

`INSERT INTO color VALUES (1, 'red') (2, 'blue') (3, 'green')`

## An Introduction to Relational Databases

* Unique value for each row in the table 

* Typically do not have real world significance

* Do not imply a ranking, sequence, or count of items

* Common primary keys include credit card and phone number

A table's primary key is only used to ensure each row can be uniquely identified as a separate entity from every other row in the table

Most PostgreSQL databases use names with all lowercase characters and an underscore between words.

### Native Data Types 

Numeric, Monetary, Binary, Boolean, Date/Time, Character, Geometric

Numeric: integer, smallint, bigint; numeric, decimal for numbers with decimal points; real, double precision for floating point values

numeric(total,decimal)

Character: fixed length character(n), char(n); state abbr char(2); variable length strings character varying(n) or varchar(n)

Date and time: date, time, timestamp for both, timestamp with time zone

### Join tables together with relationships

Multiple tables separate information out by topic, but would allow information to be cross referenced by following a thread between matching values in the primary and foreign key columns 


## Building a database

Schema: categories, mimic the department of the business; secure permission


`CREATE SCHEMA human_resources AUTHORIZATION postgres;`

`SELECT * FROM manufacturing.products;`

When adding a constraint to a table, `Validated` option will check existing data to ensure that it meets the new constraints.

## Retrieve Information with Queries

-- Select all columns from products table

```
SELECT *
FROM manufacturing.products;
```

-- Select specific columns

```
SELECT name, manufacturing_cost
FROM manufacturing.products;
```

-- Filter the rows returned

```
SELECT name, manufacturing_cost, category_id
FROM manufacturing.products
WHERE category_id = 3;
```

-- Make sure your data types agree in the WHERE clause!

```
SELECT name, manufacturing_cost
FROM manufacturing.products
WHERE manufacturing_cost < '$10';
```


### Join table

```
SELECT products.product_id,
	products.name AS products_name,
	products.manufacturing_cost,
	categories.name AS category_name,
	categories.market
	
FROM manufacturing.products JOIN manufacturing.categories 
	ON categories.category_id = products.category_id
WHERE market = 'industrial';
```

### Save query as a database view

view object


View dont actually store or duplicate any data, they actually just create a shortcut that points to the original data source in your data tables. But they act like tables. You can run queries against them.

```
CREATE VIEW manufacturing.product_details AS
SELECT products.product_id,
	products.name AS products_name,
	products.manufacturing_cost,
	categories.name AS category_name,
	categories.market
	
FROM manufacturing.products JOIN manufacturing.categories 
	ON categories.category_id = products.category_id
;
```

`SELECT * FROM manufacturing.product_details;`

```
SELECT employees.first_name,
	employees.last_name,
	departments.department_name,
	departments.building
FROM human_resources.employees JOIN human_resources.departments
	ON employees.department_id = departments.department_id
WHERE building = 'South';
```

## Managing data

### Table Indexes

* Like indexes in a textbook, they point to content in the table

* Help the PostgreSQL database engine find records faster

* Without an index, Postgres performs a full table scan

* Created on one or more columns in a table

common access method btree: branching, tree like structure, that can speed up searches

columns, primary key

name convention: table_name_column_name_idx

```
CREATE INDEX products_product_id_idx
    ON manufacturing.products USING btree
    (product_id ASC NULLS LAST)
;
```

### Automatically fill in default values

```
ALTER TABLE IF EXISTS manufacturing.products
    ALTER COLUMN category_id SET DEFAULT 4;
```

when most of the information have same value for a column

### Constrain acceptable input values

check constraint

table-> constraints-> market = 'domestic' OR market = 'industrial', no in `don't validate`

```
ALTER TABLE IF EXISTS manufacturing.categories
    ADD CONSTRAINT categories_market_check CHECK (market = 'domestic' OR market = 'industrial');
```

### challenge

```
CREATE INDEX employees_employee_id_idx
    ON human_resources.employees USING btree
    (employee_id ASC NULLS LAST)
;
```

`ALTER COLUMN department_id SET DEFAULT 800;`

```
ALTER TABLE IF EXISTS human_resources.employees
    ADD CONSTRAINT employees_hire_date_check CHECK (hire_date > '2020-01-01');
```

Don't validate ?: check old data or not

```
ALTER TABLE IF EXISTS human_resources.employees
    ADD CONSTRAINT employees_hire_date_check CHECK (hire_date > '2020-01-01')
    NOT VALID;
```

## Database Administration in PostgreSQL

Roles

Roles can be granted to specific users, so they can perform these specific tasks

Postgres roles, superuser account, used to login to the server with

The super user has the ability to do anything on the server, so it has the most priviledges of any user account

This includes the ability to create new roles, and assign permissions

```
CREATE ROLE hr_manager WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1
	PASSWORD 'xxxxxx';
```


-- View tables from the KinetEco database

```
SELECT * FROM manufacturing.products;
SELECT * FROM human_resources.employees;
```

-- Impersonate the hr_manager

```
SET ROLE hr_manager;
```

-- Switch permissions back to posgres super user

```
RESET ROLE;
```

-- Give hr_manager permissions in database

```
GRANT USAGE ON SCHEMA human_resources TO hr_manager;
GRANT SELECT ON ALL TABLES IN SCHEMA human_resources TO hr_manager;
GRANT ALL ON ALL TABLES IN SCHEMA human_resources TO hr_manager;
```

-- Remove the hr_manager role from Postgres Server

```
RESET ROLE;
REVOKE ALL ON ALL TABLES IN SCHEMA human_resources FROM hr_manager;
REVOKE USAGE ON SCHEMA human_resources FROM hr_manager;
DROP ROLE hr_manager;
```



### Backup Strategy

pre-data: table structure and schemas of the database

.backup

tar

## Conclusion

Additional resources

https://wiki.postgresql.org/wiki/Main_Page

Learning SQL programming

Relational Database Essential Training





