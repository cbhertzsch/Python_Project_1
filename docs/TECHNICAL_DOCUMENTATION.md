# Python Project 1 – Technical Documentation

## 1. Project Overview

The purpose of this project was to build a data pipeline using Python, Docker, PostgreSQL, and Apache NiFi. The project involved generating sample data, saving it in different file formats, processing the files, and loading the records into a database.

I used Python with the Faker library to generate 1,000 customers, 1,000 products, and 1,000 orders. Each dataset was saved in CSV, JSON, and YAML formats, creating nine files.

PostgreSQL was used to store the records, while Apache NiFi was used to process the different file formats and load the information into the database. Docker was used to run PostgreSQL and NiFi in containers.

I also worked on validating the data, handling processing errors, and recording audit information. These steps helped me check whether the records were being processed and stored correctly.

The main goal of this project was to understand how the different tools work together in a data pipeline and how to troubleshoot problems when something does not work as expected.

## 2. Project Architecture

My project uses four main tools: Python, Docker, PostgreSQL, and Apache NiFi. Each tool has a different purpose in the data pipeline.

Python is used with the Faker library to create sample customer, product, and order records. The generated records are saved as CSV, JSON, and YAML files.

Docker Desktop is used to run PostgreSQL and Apache NiFi in separate containers. This allows both applications to run in the same environment without needing to install and configure each one directly on my Mac.

Apache NiFi is responsible for reading the generated files, converting the data into formats it can process, and loading the records into PostgreSQL.

PostgreSQL stores the customer, product, and order information in database tables. I also created an audit table to keep track of processing results.

I used a separate test database while troubleshooting so I could test the pipeline without changing the original records.

### Architecture Diagram

The following diagram shows how the main tools connect and how the data moves through the project.

```text
Python + Faker
      |
      v
Generated Data Files
(CSV, JSON, YAML)
      |
      v
Apache NiFi
(File Processing and Conversion)
      |
      v
PostgreSQL
(Customers, Products, Orders)
      |
      v
Data Validation and Audit Logging
```

Docker is used to run the Apache NiFi and PostgreSQL services.

## 3. Database Design

For this project, I used PostgreSQL to store the generated data. I created a database called `project1` with three main tables: `customers`, `products`, and `orders`.

The `customers` table stores customer information, while the `products` table stores the generated product records. The `orders` table stores order information and connects each order to a customer through a foreign key.

The customer ID in the orders table must match an existing customer ID in the customers table. This helps maintain referential integrity and prevents orders from referencing customers who do not exist.

I also created an `etl_audit` table to record information about pipeline processing. This table includes the pipeline name, start and end timestamps, processing status, and number of records processed.

### Database Schema Diagram

CUSTOMERS                    ORDERS
------------------           ------------------
customer_id (PK) -------->   customer_id (FK)
first_name                   order_id (PK)
last_name                    order_date
email                        order_status
phone                        payment_method
city                         total_amount
registration_date            discount_amount
customer_type                shipping_cost

PRODUCTS                     ETL_AUDIT
------------------           ------------------
product_id (PK)              dag_name
product_name                 start_time
category                     end_time
brand                        status
unit_price                   records_processed
stock_quantity
is_active

The products table is separate because the current database schema does not include a foreign key connecting products to orders.

The customers and orders tables have a one-to-many relationship because one customer can have multiple orders.

The audit table is separate from the customer, product, and order data because it is used to track pipeline activity rather than store generated records.

### Database Testing

After creating the tables and loading the data, I used SQL queries to check the number of records in each table.

The results showed 1,000 customers, 1,000 products, and 1,000 orders, for a total of 3,000 records.

I also tested the relationships between the tables and confirmed that there were no invalid customer references in the orders table.

During troubleshooting, I created a second database called `project1_test`. This allowed me to test the NiFi processors without affecting the original database records.

## 4. Apache NiFi Data Processing

Apache NiFi was used to process the generated files and load the records into PostgreSQL. I created a process group called `ETL_Pipeline` to organize the different processors.

The pipeline includes separate sections for CSV, JSON, and YAML files. Although the files contain similar information, each format requires different settings to read and process the data.

### File Identification

I used ListFile and RouteOnAttribute to identify the generated files. ListFile checks the folder for available files, while RouteOnAttribute checks the filenames to identify the correct project files.

I also used LogAttribute to view file information and help with troubleshooting.

### CSV Processing

For CSV files, I used GetFile to retrieve the files and ConvertRecord to prepare the data for loading.

The CSVReader controller service reads the records, and PutDatabaseRecord sends them to PostgreSQL.

During testing, I had to adjust some settings to make sure the fields matched the database tables correctly.

### JSON Processing

For JSON files, I used GetFile and ConvertRecord with a JSONTreeReader to process the records.

After converting the records into a format NiFi could use, PutDatabaseRecord was used to load them into PostgreSQL.

This helped me understand that NiFi can work with different file formats by changing the reader settings.

### YAML Processing

YAML required a different approach because I could not use the same reader settings as CSV and JSON.

I used an ExecuteScript processor with Groovy to convert the YAML content into JSON. The converted records were then processed through ConvertRecord and PutDatabaseRecord.

This was one of the more challenging parts of the project because I needed to make sure the converted records still matched the PostgreSQL tables.

After testing and making adjustments, I successfully processed the YAML files and confirmed that the expected records were loaded into the test database.

### Database Loading

PutDatabaseRecord was used to insert the processed records into PostgreSQL.

I tested the customer, product, and order data separately to make sure each file was loaded into the correct table.

I also had to consider the order in which records were loaded because orders reference existing customers.

### Processing Results

After testing the different file formats, I verified the results using PostgreSQL queries.

The test database contained 1,000 customers, 1,000 products, and 1,000 orders. This confirmed that the generated data could be processed and stored correctly.

I also used NiFi processor status information and logging to help identify problems during testing.

## 5. Data Validation, Error Handling, and Audit Logging

An important part of this project was checking that the data was processed correctly. I learned that even when a NiFi processor runs successfully, it is still important to check the database to make sure the records were saved as expected.

### Data Validation

I created three validation checks using ExecuteSQL processors in NiFi.

The first check counted the records in the customers, products, and orders tables. The results showed 1,000 records in each table, for a total of 3,000 records.

The second check looked for orders that referenced customers who did not exist. The result showed zero invalid customer references.

The third check looked for missing required information in the orders table. This helped me check the quality of the data after loading.

### Error Handling

I added failure and retry connections to help manage processing errors. I also used LogAttribute processors to review information about FlowFiles when problems occurred.

During testing, I encountered issues with database connections, timestamp formatting, and foreign key relationships. These errors helped me understand why error handling is important.

Rather than assuming every file would process correctly, I used NiFi error messages and PostgreSQL queries to find and correct problems.

### Audit Logging

I created an `etl_audit` table in PostgreSQL to record information about pipeline activity.

The table stores the pipeline name, start time, end time, processing status, and number of records processed.

I used UpdateAttribute to assign audit information to FlowFiles and PutSQL to insert audit entries into PostgreSQL.

During testing, I confirmed that an audit entry was saved with a status of `SUCCESS` and a record count of 1,000.

The current audit process records timestamps when the SQL statement runs. It does not yet measure the actual time taken to process each file from beginning to end.

### Why These Checks Matter

The validation and audit steps helped me understand the difference between processing a file and confirming that the data is correct.

The validation queries checked the records stored in PostgreSQL, while the logging and audit components provided information about processing activity.

These checks were useful when troubleshooting because they helped me identify whether a problem involved the file, the NiFi processor, or the database.

## 6. Design Decisions and Challenges

Throughout this project, I had to make several decisions about how to organize the data pipeline and troubleshoot problems. Some parts worked as expected, while others required several attempts before I could get them working correctly.

### Using Docker

I used Docker Desktop to run PostgreSQL and Apache NiFi. This allowed me to work with both applications on my Mac without installing each one separately.

At first, I had to become familiar with starting the containers and making sure the applications were running before using them. Once everything was set up, Docker made it easier to access the same environment when continuing the project.

### Using a Separate Test Database

One decision was to create a second PostgreSQL database called `project1_test`.

My original database already contained the generated records, and I did not want to accidentally change or duplicate them while testing NiFi.

Using a separate database allowed me to clear tables, reload records, and troubleshoot problems while keeping the original database available.

### Processing Different File Formats

Although CSV, JSON, and YAML contained the same types of information, they could not all be processed using the exact same settings.

CSV and JSON were easier to configure using NiFi's record readers. YAML was more challenging because I needed to use a Groovy script to convert the files into JSON before loading them.

This helped me understand that the format of a file affects how the data needs to be processed.

### Troubleshooting Database Errors

I ran into several problems while connecting NiFi to PostgreSQL and loading records.

One issue involved the order date field because NiFi and PostgreSQL were not interpreting the timestamp in the same way. I had to adjust the configuration before the records could load successfully.

Another problem involved foreign keys. Some order records referenced customers that were not available in the database, which caused the records to fail.

I worked through these problems by reviewing error messages, checking the data, and testing the processors again after making changes.

### Testing the Pipeline in Sections

I tested the pipeline in smaller sections instead of trying to run everything at once.

This made it easier to identify which processor was causing a problem. For example, I could check whether a file was being read correctly before testing whether its records were being inserted into PostgreSQL.

I also used SQL queries to confirm the results instead of relying only on the processor status in NiFi.

### What I Learned

One of the biggest things I learned was how many different parts need to work together for a data pipeline to function correctly.

Before starting this project, I was more familiar with using Python to work with data on its own. This project introduced me to using Python alongside databases, containers, and data processing tools.

I also learned that troubleshooting is an important part of building a pipeline. Even small issues with file formats, database connections, or field types can prevent records from loading correctly.

Although some parts took longer than expected, working through these problems helped me better understand how the tools connect and why testing is necessary.

## 7. Testing Results and Conclusion

### Testing Results

Throughout this project, I tested the different parts of the data pipeline to make sure they were working correctly.

I started by checking the Python data generation script. The script successfully created 1,000 customers, 1,000 products, and 1,000 orders. Each dataset was saved in CSV, JSON, and YAML formats, resulting in nine files.

Next, I verified the PostgreSQL database. I used SQL queries to confirm that the customers, products, and orders tables each contained 1,000 records, for a total of 3,000 records.

I also tested the CSV, JSON, and YAML processing sections in Apache NiFi. The YAML files required additional conversion, but I was eventually able to process them and load the records into the test database.

After loading the data, I ran validation queries to check the results. The record counts matched what I expected, and the foreign key validation showed zero invalid customer references.

I also tested the audit logging process and confirmed that PostgreSQL saved an entry with a successful status and 1,000 records processed.

### Final Results

The main results of the project included:

- Nine generated data files in CSV, JSON, and YAML formats.
- Three PostgreSQL tables containing 3,000 records in total.
- Successful testing of the three file formats in Apache NiFi.
- Data validation checks for record counts, customer references, and missing order information.
- Logging and error-handling components in NiFi.
- Successful testing of audit records saved in PostgreSQL.
- A separate test database used for troubleshooting.

The processing sections were tested individually. A complete automatic run from beginning to end still needs to be demonstrated, so I would not describe that part as fully verified yet.

### Conclusion

Overall, this project gave me experience working with several tools that I had not previously used together. I learned how to generate data with Python, use Docker to run applications, create database tables in PostgreSQL, and process different file formats using Apache NiFi.

The most challenging part was troubleshooting the connections and making sure the records were being loaded correctly. I learned that a successful processor run does not always mean the entire process is correct, which is why checking the database results was important.

Although I still have more to learn about building data pipelines, I have a better understanding of how the different components work together and how to identify problems when something does not work as expected.