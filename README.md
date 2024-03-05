# Cyclistic-Google-Case-Studyy
Case study from Google Data Analytics 

BACKGROUND: The analysis is based on the case study of the Google Data Analytics Certificate that we have to do independently. The aim of the analysis is to understand how casual riders and annual members use Cyclistic bikes differently. Analyzing the behaviors between the two would create insights on how to design a new marketing strategy to convert casual riders into annual members.

The dataset will be cleaned and analyzed using SQL and then, I will further analyse the data using Tableau and Microsoft Excel and will follow Google’s six-step process of processing data: ask, prepare, clean and process, analyze, share, and act.

# Ask

In this phase, it is important to understand what are the major questions that drive the analysis. Given that the company has a problem with increasing its membership numbers and it has data about its users, the question that I came up with was
“How do annual members and casual riders use Cyclistic bikes differently?", "What are their riding trends across both weeks and months?"

# Prepare

The data that I collected from is from [here](https://divvy-tripdata.s3.amazonaws.com/index.html). 

For data analysis using SQL, I collected the data which ranged from January to June in 2023 and imported to BigQuery. Then I combined the data into one table using SQL.

# Clean and Process

To ensure data integrity in the table that I created using SQL, I first checked for duplicate rows and rows with NULL values so as to remove them. 

I also included data that have a valid time length (more than 1 minute and less than 24 hours)

To further analyse my data to conduct trends across both weeks and months, I modified the tables and added new columns;  Ride Length,Time of ride, Day of the Week, Month and Year per Ride ID

For Excel, i cleaned the December 2023 dataset by formatting cell data types, removing rows with empty cells and created new columns using excel aggregate functions

# Analyze

For the analysis portion of the code, I calculated the following in SQL:

1. Average length of ride between casual and member riders
2. Greatest number of riders in which days in a week for casual and member riders.
   


# Share

Using Tableau to conduct my data visualisation, I have created line graphs, pie charts, and bar charts for different visualisations purposes to analyze data on both casual and member riders which ranged from January to June.
Using Excel, I have only conducted data analysis and visualisation based on the data on December 2023 only, where I utilised pivot tables, slicers, and charts to create a dynamic dashboard for visualisation purposes.

# Act 

These are my key takeaways from my Analysis on the case study between casual riders and member riders: 
1. There is almost double the amount of member riders as compared to casual riders 
2. Both casual riders and member riders prefer electronic bikes over classic bikes
3. Casual riders ride the most on weekends which they peak on Sundays while for member riders, it remains rather consistent throughout the days aside from Thursday where it is the highest
4. Both Casual and Member riders can be seen to have a sharp increase in riders 
5. Casual riders always ride longer on average as compared to member riders throughout the months.

Recommendations based on analysis: 
1. Market electric bikes as the main bike of cyclistic as looking at the whole picture, both casual and member risers significantly ride electric bikes more which would indicate their preferences for the classic bikes
2. Ensure that supplies of bikes are increased in heavy periods starting from May onwards as there is a steep increase in riders from May-June as compared to Jan-April.
3. Discounted membership prices can be implemented for casual riders whose riding time  exceeds 10min which appears to be the trend while 10mins appears to be the time frame that members are riding their bikes
