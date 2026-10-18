# Python Project 1 – Data Pipeline

## Project Overview

The purpose of this project is to create a data pipeline using Python, Docker, PostgreSQL, and Apache NiFi. The project involves generating sample data, storing it in different file formats, creating database tables, and testing data processing.

## Tools Used

- **Python:** Generates sample data using the Faker library.
- **Docker:** Runs the PostgreSQL and Apache NiFi containers.
- **PostgreSQL:** Stores customer, product, and order records.
- **Apache NiFi:** Processes files and converts data between formats.

## Data Generation

I created a Python script called `generate_data.py` to generate 1,000 customers, 1,000 products, and 1,000 orders.

Each dataset was saved in three formats: CSV, JSON, and YAML. This resulted in nine generated data files stored in the `data` folder.

## PostgreSQL Database

I created a PostgreSQL database named `project1` with three tables: `customers`, `products`, and `orders`.

The database schema is saved in `sql/schema.sql`.

I verified that each table contains 1,000 records, for a total of 3,000 records.

## Apache NiFi Pipeline

I created an ETL process group in Apache NiFi called `ETL_Pipeline`.

The pipeline uses ListFile and RouteOnAttribute to identify project files. I also configured GetFile and ConvertRecord to read CSV files and convert them into JSON.

The conversion test successfully processed all three CSV files with zero failures. I inspected the converted customer data to verify that the JSON structure and fields were preserved.

The PostgreSQL tables were populated separately. The NiFi-to-PostgreSQL loading stage has not yet been demonstrated.

## Project Structure

- `scripts/` – Python data generation script
- `data/` – Generated CSV, JSON, and YAML files
- `sql/` – PostgreSQL database schema
- `nifi/` – NiFi configuration backup
- `docs/` – Project documentation
- `docker-compose.yml` – Docker container configuration
- `README.md` – Project overview and instructions

## Running the Project

The project uses Python and Docker Desktop. After configuring the required environment variables and Python dependencies, the data generation script can be run using:

`python scripts/generate_data.py`

Docker Compose is used to start the PostgreSQL and NiFi services:

`docker compose up -d`

The generated files can then be processed using the NiFi pipeline, and the database records can be verified through PostgreSQL.

## Testing and Results

- Generated all nine data files successfully.
- Confirmed PostgreSQL contains 3,000 records.
- Confirmed NiFi converted all three CSV files into JSON.
- Verified the converted JSON content.
- Saved screenshots of the database results and NiFi pipeline.

## Conclusion

This project helped me understand how Python, Docker, PostgreSQL, and Apache NiFi can work together in a data processing environment. I practiced generating data, working with different file formats, creating database tables, and configuring an ETL pipeline. The project also helped me become more familiar with troubleshooting and verifying results.
