# Python Project 1 – User Guide

## Introduction

This guide explains how to set up and run my Python data pipeline project. The project uses Python to generate sample data, Docker to run the applications, PostgreSQL to store the data, and Apache NiFi to process the files. The goal is to take data from different file formats, load it into a database, and verify that the information was processed correctly.

## Software Needed

Before running the project, you will need:

- Python 3
- Docker Desktop
- A web browser
- The project files from GitHub

## Step 1: Set Up the Project

Download the project files from GitHub and open the project folder.

Install the required Python packages using:

`pip install -r requirements.txt`

Create a `.env` file using `.env.example` as a guide. Replace the example values with your own database credentials. The `.env` file should not be uploaded to GitHub because it contains private information.

## Step 2: Generate the Data

Run the Python script:

`python scripts/generate_data.py`

The script uses the Faker library to generate 1,000 customers, 1,000 products, and 1,000 orders. Each dataset is saved in CSV, JSON, and YAML formats, creating nine files in the `data` folder.

After running the script, open the `data` folder and confirm that all nine files were created.

## Step 3: Start Docker

Make sure Docker Desktop is open and running.

Start the containers using:

`docker compose up -d`

Docker runs the PostgreSQL database and Apache NiFi. These applications work together to store and process the generated data.

You can check whether the containers are running by opening Docker Desktop or entering:

`docker ps`

Both the PostgreSQL and NiFi containers should appear in the results.

## Step 4: Set Up PostgreSQL

Use the SQL commands in `sql/schema.sql` to create the customers, products, and orders tables.

The customers table stores customer information, the products table stores product information, and the orders table stores order information. The orders table also contains a foreign key that connects each order to a customer.

I used two databases while working on the project. The `project1` database contains the original records, while `project1_test` was used for testing the NiFi processes without changing the original data.

Before loading records, make sure the tables exist and that the database connection information matches the settings used in NiFi.

## Step 5: Use Apache NiFi

Open Apache NiFi in a web browser and sign in.

The `ETL_Pipeline` process group contains the processors used to identify, convert, load, and validate the generated files.

The project includes separate processing sections for CSV, JSON, and YAML files.

For CSV files, NiFi uses GetFile and ConvertRecord to read and prepare the records before sending them to PostgreSQL.

For JSON files, NiFi uses a JSON reader to process the records and prepare them for database loading.

For YAML files, I used an ExecuteScript processor with Groovy to convert YAML data into JSON. This was necessary because NiFi did not have a built-in YAML reader available for the process I was using.

The PutDatabaseRecord processors are used to insert records into the appropriate PostgreSQL tables.

When running the pipeline, make sure the correct database connection and destination table are selected. I used the test database when checking the processors so that I could troubleshoot problems without affecting the original database.

The processors can be started individually when testing different sections of the pipeline. After processing, check the connections and processor status for any failures.

## Step 6: Validate the Data

After loading the records, I used SQL queries to confirm that the expected information was stored in PostgreSQL.

Run the following queries:

`SELECT COUNT(*) FROM customers;`

`SELECT COUNT(*) FROM products;`

`SELECT COUNT(*) FROM orders;`

Each table should contain 1,000 records, for a total of 3,000 records.

I also checked that the orders referenced valid customers and that required order information was not missing.

These checks helped confirm that the data was loaded correctly and that the relationships between tables were maintained.

## Step 7: Check Logs and Audit Records

Apache NiFi includes LogAttribute processors that can be used to review information about processed files and troubleshoot errors.

The pipeline also includes an audit process that records information in the PostgreSQL `etl_audit` table.

The audit table stores the pipeline name, processing status, timestamps, and number of records processed.

During testing, I confirmed that a successful audit entry was saved with a record count of 1,000.

These logs and audit records make it easier to review what happened during processing.

## Troubleshooting

I encountered several problems while building and testing this project.

**Database connection issues:** Some processors initially had trouble connecting to PostgreSQL. I checked the database settings, JDBC driver, and NiFi controller services to correct the connection.

**Order date formatting:** NiFi had trouble reading the order date field because of a timestamp format difference. I adjusted the schema and database settings so the records could be processed correctly.

**Foreign key errors:** Some order records initially failed because their customer IDs did not match existing customers. I corrected the data and tested the orders again to confirm the relationships were valid.

**YAML conversion:** YAML files required an additional step because they could not be processed using the same reader as CSV and JSON files. I used a Groovy script to convert the YAML content before database loading.

**Duplicate records:** Running the same files again can cause problems when the records already exist in the database. I used a separate test database to check the loading process while keeping the original records.

If a file fails to process, I would first check the NiFi error messages and processor connections. I would then review the database connection, file format, and destination table to identify the problem.

## Conclusion

This project helped me practice using Python, Docker, PostgreSQL, and Apache NiFi together. Before this project, I had not worked with all of these tools as part of one data pipeline.

One of the biggest things I learned was how important it is to test each part of the process before moving on. Even when a processor appeared to be working, I still needed to check the database to confirm the records were actually saved.

Working through the connection issues, data formatting problems, and foreign key errors helped me understand how the different parts of a pipeline depend on each other. I also became more comfortable using NiFi to process different file formats and using SQL to verify the results.
