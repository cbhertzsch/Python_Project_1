# Python Project 1 – User Guide

## Introduction

This guide explains how to set up and run my Python data pipeline project. The project uses Python to generate sample data, Docker to run the applications, PostgreSQL to store the data, and Apache NiFi to process the files.

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

Create a `.env` file using `.env.example` as a guide. Replace the example password with your own database password.

## Step 2: Generate the Data

Run the Python script:

`python scripts/generate_data.py`

The script generates 1,000 customers, 1,000 products, and 1,000 orders. Each dataset is saved as CSV, JSON, and YAML, creating nine files in the `data` folder.

## Step 3: Start Docker

Make sure Docker Desktop is running.

Start the containers using:

`docker compose up -d`

Docker is used to run PostgreSQL and Apache NiFi.

## Step 4: Set Up PostgreSQL

Use the SQL commands in `sql/schema.sql` to create the customers, products, and orders tables in the `project1` database.

These tables are used to store the generated records.

## Step 5: Use Apache NiFi

Open Apache NiFi in your web browser and sign in.

The ETL_Pipeline process group is used to work with the generated files. I configured processors to identify files, convert CSV data into JSON, and test loading records into PostgreSQL.

The database loading process was tested by selecting the appropriate table and adjusting the CSVReader settings when needed.

## Step 6: Verify the Results

After loading the data, run the following SQL query for each table:

`SELECT COUNT(*) FROM customers;`

`SELECT COUNT(*) FROM products;`

`SELECT COUNT(*) FROM orders;`

Each table should contain 1,000 records, for a total of 3,000 records.

## Troubleshooting

While working on this project, I encountered a few issues with the PostgreSQL connection and how NiFi read the order dates. I corrected the database connection settings and adjusted the CSVReader schema to handle the timestamp field.

If a file fails to process, check the NiFi error messages, database connection, and CSVReader settings.

## Conclusion

This project helped me practice working with Python, Docker, PostgreSQL, and Apache NiFi together. It also helped me understand the importance of testing each part of a data pipeline and checking the results before moving on.