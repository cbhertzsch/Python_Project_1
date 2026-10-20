# Python Project 1 – Data Pipeline

## Project Overview

The purpose of this project was to create a data pipeline using Python, Docker, PostgreSQL, and Apache NiFi. The project involved generating sample data, saving it in different file formats, creating database tables, and processing the data through NiFi.

The main goal was to understand how data moves between different applications and how to make sure the records are loaded correctly. I also worked on data validation, error handling, and keeping track of processing results.

## Tools Used

- **Python:** Used to generate sample data with the Faker library.
- **Docker Desktop:** Used to run PostgreSQL and Apache NiFi in containers.
- **PostgreSQL:** Used to store customer, product, and order records.
- **Apache NiFi:** Used to process files, convert data formats, and load records into PostgreSQL.
- **GitHub:** Used to organize and submit the project files and documentation.

## Data Generation

I created a Python script called `generate_data.py` using the Faker library.

The script generated 1,000 customers, 1,000 products, and 1,000 orders. Each dataset was saved in CSV, JSON, and YAML formats, resulting in nine generated files in the `data` folder.

Using three different formats allowed me to practice processing data that was structured differently but contained the same types of information.

## PostgreSQL Database

I created a PostgreSQL database named `project1` with three tables: `customers`, `products`, and `orders`.

The database schema is saved in `sql/schema.sql`.

The orders table includes a foreign key connecting each order to a customer. This helped maintain the relationships between the records.

I verified that each table contained 1,000 records, for a total of 3,000 records.

I also created a separate database called `project1_test` to test the NiFi processes without changing the original records.

## Apache NiFi Pipeline

I created an ETL process group in Apache NiFi called `ETL_Pipeline`.

The pipeline includes processors for identifying files, reading different formats, converting data, loading records into PostgreSQL, and checking the results.

I used ListFile and RouteOnAttribute to identify the project files. I also configured separate processing sections for CSV, JSON, and YAML.

For CSV files, I used GetFile and ConvertRecord to read the files and prepare the records for loading. JSON files were processed using a JSON reader.

YAML required an additional step because I could not use the same reader as CSV or JSON. I used an ExecuteScript processor with Groovy to convert YAML into JSON before loading the records.

I connected NiFi to PostgreSQL using PutDatabaseRecord. After troubleshooting the connection settings and data formats, I successfully tested loading the customer, product, and order records.

The pipeline also includes logging and audit components to help track processing results and identify errors.

## Data Validation and Audit Logging

After loading the data, I used SQL queries to verify the records in PostgreSQL.

I confirmed that the customers, products, and orders tables each contained 1,000 records. I also checked for invalid customer references in the orders table and verified that required order information was not missing.

I added an `etl_audit` table to record information about pipeline activity, including the pipeline name, status, timestamps, and number of records processed.

During testing, I confirmed that a successful audit entry was saved in PostgreSQL with a record count of 1,000.

These checks helped me make sure the data was being stored correctly rather than relying only on NiFi showing a successful processor run.

## Project Structure

- `scripts/` – Python data generation script
- `data/` – Generated CSV, JSON, and YAML files
- `sql/` – PostgreSQL database schema
- `nifi/` – NiFi flow export and configuration files
- `docs/` – Project documentation and screenshots
- `docker-compose.yml` – Docker container configuration
- `requirements.txt` – Python packages needed for the project
- `.env.example` – Example database settings without sharing actual passwords
- `README.md` – Project overview and setup information

## Running the Project

The project uses Python and Docker Desktop.

First, download the project files and install the required Python packages:

`pip install -r requirements.txt`

Generate the sample data by running:

`python scripts/generate_data.py`

Start the PostgreSQL and NiFi containers using:

`docker compose up -d`

After the containers are running, open Apache NiFi and use the `ETL_Pipeline` process group to process the generated files.

The NiFi processors must be configured with the correct database connection and destination tables before loading data.

The database records can then be checked using PostgreSQL queries.

More detailed setup and troubleshooting instructions are included in `docs/User_Guide.md`.

## Testing and Results

During this project, I completed the following tests:

- Generated all nine CSV, JSON, and YAML files.
- Verified that PostgreSQL contained 1,000 customers, 1,000 products, and 1,000 orders.
- Successfully tested CSV and JSON processing in NiFi.
- Successfully tested YAML conversion and loading using Groovy.
- Confirmed that the test database contained the expected records.
- Checked for invalid customer references and missing required order information.
- Tested audit logging and confirmed successful records were saved in PostgreSQL.
- Used NiFi logging and error messages to troubleshoot processing issues.

Some of the biggest challenges involved database connections, order date formatting, foreign key relationships, and converting YAML files.

I worked through these issues by testing individual processors, reviewing error messages, adjusting settings, and checking the database results.

## Conclusion

This project helped me understand how Python, Docker, PostgreSQL, and Apache NiFi can work together in a data processing environment.

I learned that getting a processor to run successfully does not always mean the data was loaded correctly. I still needed to verify the records in PostgreSQL and check that the relationships between tables were accurate.

Although troubleshooting took more time than I expected, it helped me become more comfortable working with data pipelines and understanding how the different tools connect.
