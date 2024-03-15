# 🏠 Nashville-Housing

## Table of Contents
- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools Used](#Tools-Used)
- [Data Cleaning](#Data-Cleaning)
- [Exploratory Data Analysis](#Exploratory-Data-Analysis)
- [Data Visualization](#Data-Visualization)
- [Insights](#Insights)
  
## Project Overview
This project involves the cleaning, analysis and visualization of data relating to housing in Nahsville, United States. The project aims to generate actionable insights regarding housing in Nashville.

## Data Sources
Nashville Housing Data: The primary dataset for this project is the "Nashville Housing.xlsx" file. This file comprises of data about the Slaes Price, Sales Date, Owner Name, Owner Address, Property Address, Land Value and Building Value amongst other relevant data points relating to houses in Nahsville over a number of years

## Tools Used
1. Microsoft Excel - Loading of Original Data and Loading of Results of SQL Queries 
2. Microsoft SQL Server Management Studios (SSMS) - Data Cleaning and Exploratory Data Analysis
3. Microsoft Power BI - Data Visualization

## Data Cleaning
This stage of the project was performed using a number of SQL functions in SSMS to prepare the data for Exploratory Data Analysis. Some of the SQL functions used are substring, select, where, join, update, alter table, parsename, Common Table Expressions (CTEs), row_number etc. These functions were used to write SQL Queries to perform the following tasks for data cleaning;
- Populating null property address value based on the parcelid
- Breaking down owner address and property address into seperate columns
- Changing Y and N to Yes and No in Sold As Vacant column
- Removing Duplicates using CTEs
- Deleting Unused Columns

## Exploratory Data Analysis
This stage of the project was performed using a number of SQL functions in SSMS to answer relevant questions for Exploratory Data Analysis. Some of the SQL functions used are substring, select, where, join, update, order by, group by, case statements etc. These functions were used to write SQL Queries to answer the following questions for Exploratory Data Analysis;
- What years saw the highest and lowest value and number of house sales per year?
- What is the month with the highest number and value of sales across the 4 years?
- What is the quarter with the highest number and value of sales across the 4 years?
- What is the number and value of sales per Land Use?
- What is the count per price range of sales?
- What is the number and value of sales per Tax District?
- What is the number and value of sales per Property City?
- What is the number and value of sales per Owner City?
- What is the average price per land use?

## Insights
The findings and insights from this project can be summarized as follows;
- 2015 saw the highest number and value of sales while 2013 saw the lowest value and number of sales
- Across all the months for the 4 years, June saw the highest number of sales while January saw the highest value of house sales with $2.1 billion
- Across all the quarters for the 4 years, Q2 saw the highest number and value of house sales
- Single Family land use brought about the most number and the highest value of house sales in Nashville
- 90% of houses sold were not Sold As Vacant
- The Urban Services Tax District saw the highest value and number of house sales across the 4 years
- Nashville is the property and owner city with the most house sales
- Vancant Commercial Land is the most expensive Land Use with an average sales price of $3.2 million while Mobile Homes are the cheapest Land Use with ana average sales price of $36,963







