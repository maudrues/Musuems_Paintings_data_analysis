# Musuems_Paintings_data_analysis

## Introduction
picture

The following document outlines the process and outcomes of a project focused on creating a database for paintings ,artists and museums using SQL then to analyze data. The project involved downloading the famous paintings dataset from Kaggle and then upload data from CSV files to a PostgreSQL database tables using a simple Python script and executing various queries to extract meaningful insights from the dataset.l then used SQL queries to answer over 20 problems related to the famous paintings dataset.


## Data Collection and Database Creation:
l downloaded the the famous paintings dataset from Kaggle(https://www.kaggle.com/datasets/mexwell/famous-paintings) and it consisted of 8 CSV files namely :

- ***artist*** :This file have all information about 421 artists from their name to the day they died ,
- ***canvas_size*** :This file consist of 200 canvas sizes that the artists could have used to paint their paintings,
- ***image_link*** : All links to the paintings are in this file,
- ***museum_hours*** : This has information about the days  when the museums are open and the timings when the museums open and close,
- ***museum*** : Information about 57 museums are in this file,from the location to their website,
- ***product_size*** : This file has 110347 products or paintings,showing their sizes and prices,
- ***subject*** :This file shows the subject of the paintings painted by the artists eg potraits,still life,flowers etc,
- ***work*** : This shows the paintings name,their artists and the museum you can find them.


  
Python script was used to collect data on paintings and museums from various sources, including web scraping and API calls.
The collected data was structured into appropriate tables representing entities such as paintings, artists, museums, and exhibitions.
SQL queries were executed to create a relational database schema that efficiently stored and organized the data.


## Data Uploading to SQL:
Instead of manually creating the tables and importing data for each of the tables l uploaded the csv files into python using a Python script then from python the dataframe was connected to  a PostgreSQL database by the name paintings.
Python's SQLAlchemy and Pandas library was utilized to connect to the PostgreSQL database and upload the collected data.No data preprocessing techniques were applied to clean or transform the raw data before uploading it to SQL.
The uploaded data was validated to ensure data integrity and consistency within the database.Below are examples of two tables that were successfully connected :

## Work Table
## Artist Table


## Python script used for upload
As shown below in the picture the first 5 lines of code connect python to PostgreSQL database.To load from CSV to python pandas module is used and then to connect to PostgreSQL database ,SQLAlchemy module is used.


## SQL Query Execution:
l answered a series of SQL queries which were designed to extract relevant information and perform analysis on the paintings and museums dataset.
Examples of queries include:
Retrieving a list of all paintings by a specific artist.
Finding the total number of paintings in each museum.
Identifying the most common painting genres across all museums.
Calculating the average value of paintings in each museum.
Determining the museums with the highest and lowest number of paintings.


Data Visualization and Reporting:
Results from the SQL queries were visualized using Python libraries such as Matplotlib or Plotly to create insightful charts and graphs.
A comprehensive report summarizing the findings, methodology, and recommendations was generated to communicate the project's outcomes effectively.


Project Evaluation and Future Considerations:
The project's success was evaluated based on the accuracy, efficiency, and relevance of the extracted insights.
Areas for improvement, such as optimizing query performance, enhancing data quality, and expanding the scope of analysis, were identified for future iterations of the project.
Feedback from stakeholders and end-users was gathered to iteratively refine the database design and analysis techniques for enhanced usability and value.


Conclusion:
The SQL project on paintings and museums demonstrated the effective utilization of Python for data collection and SQL for database management and analysis. By leveraging these tools and techniques, valuable insights were extracted, providing a deeper understanding of the relationships between paintings, artists, and museums. Moving forward, continued refinement and expansion of the project will further enrich its utility and impact in the domain of art history and museum management.
