#working is MySQL WORKBENCH;
#CREATING A NEW DATABASE called pmg;
CREATE DATABASE `pmg` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
#Creating two new tables called store_revenue and marketing_data;
#Then importing data from the actual csv files from GitHub using the 'Data Table Import Wizard';
CREATE TABLE store_revenue( id int not null primary key auto_increment, 
							date datetime, 
                            brand_id int, 
                            store_location varchar(250), 
                            revenue float);
                            
CREATE TABLE marketing_data ( id int not null primary key auto_increment, 
							  date datetime, 
							  geo varchar(2), 
							  impressions float, 
                              clicks float );
                              
#Checking if the right data was imported to our newly created tables;
SELECT * FROM marketing_data;
SELECT * FROM store_revenue;

#Question 0;
SELECT * FROM marketing_data LIMIT 2;

#QUESTION 1;
SELECT SUM(clicks)
FROM marketing_data;
#Answer 1792;

#QUESTION 2;
SELECT store_location, SUM(revenue)
FROM store_revenue
GROUP BY store_location;
#Answer: 
#United States-CA	235237
#United States-TX	9629
#United States-NY	51984

#QUESTION 3;
#Changing the format of the store_location column, so it matches the marketing_data one
#We remove the substring "United States-" from that column, so only the names of states are displayed
UPDATE store_revenue
set store_location=REPLACE(store_location, "United States-", "");

#Because I am working on MySQL I can't use Full Outer Join,
#Insead I have to use Right Join UNION Left Join in order to ensure that each table is accounted for
#Creating a new table called merged_data with the selected data
CREATE TABLE merged_data
SELECT s.date, s.store_location, m.impressions, m.clicks, s.revenue
FROM marketing_data m
RIGHT JOIN store_revenue s
ON m.date = s.date AND m.geo=s.store_location
UNION
SELECT m.date, m.geo as store_location, m.impressions, m.clicks, s.revenue
FROM marketing_data m
LEFT JOIN store_revenue s
ON m.date = s.date AND m.geo=s.store_location
;

#QUESTION 4;

SELECT geo, SUM(impressions), SUM(clicks)
FROM marketing_data
GROUP BY geo;

SELECT store_location, sum(revenue)
FROM store_revenue
GROUP BY store_location;


#In terms of revenue, it seems like California is the leader
#In terms of impressions it is California again
#In terms of clicks the store in Minnesota was the leader

#It is hard to say which store is more efficient because the data is incomplete
#We don't know the revenue for Minnesota and also what parameters affect efficiency
#From the data we have for revenue, California is the most efficient because it brought the most money
#However if the higher number of clicks or higher impressions mean potentially higher revenue, 
#then Minnesota might bring a lot bigger revenue, but it is unknown 

#QUESTION 5;
#Ranking all the stores in the merged dataset by the overall sum of revenue per store_location
#Ordering it to be from the highest value descending to the lowest
#Due to the insufficiency of the data, we only have 4 stores in total and only 3 that actually have some revenue
SELECT store_location, SUM(revenue) as total_revenue
FROM merged_data
GROUP BY store_location
ORDER BY total_revenue DESC
LIMIT 10;