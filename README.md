# COVID-19_DATA
Agenda of this project - To compare total deaths before & after vaccination from all-around the globe.
Data is downloaded till 21JAN2023 from https://ourworldindata.org/coronavirus in CSV format (Excel file).
Create 2 excel files (CovidDeaths & CovidVaccines).
CovidDeaths  columns -  Population, Date, Country, Total Deaths. 
CovidVaccines columns - Population,  Date, Country, Total Deaths,Total vaccinations.
Cloud SQL tool (SNOWFLAKE) is used to create the database, Schema & Tables.
Create Column names in Snowflake DB with the Column_names, datatype & datalength in Excel.
  Example : create or replace transient table customer_validation (
                  customer_pk number(38,0),
                  first_name varchar(50),
                  day_of_birth date,
                  birth_country varchar(60),
                  email_address varchar(50),
                  city_name varchar(60),
                  zip_code varchar(10),
                  country_name varchar(20),
                  gmt_timezone_offset number(10),
                  preferred_cust_flag boolean,
                  registration_time timestamp_ltz(9)
            );
