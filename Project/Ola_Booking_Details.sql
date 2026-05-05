CREATE DATABASE OLA_BOOKING_Details;

USE OLA_BOOKING_DETAILS

Select * from Ola_booking_dataset

--#1.Retrive All Successful Bookings
CREATE VIEW Successfull_Booking AS
SELECT *from Ola_booking_dataset
WHERE Booking_status= 'Success'

SELECT *From Successfull_Booking

SELECT *from Ola_booking_dataset
WHERE Booking_status= 'Success'

--#2.Find the Average Ride distance for each vehicle type 
CREATE View ride_distance as
SELECT Vehicle_Type, AVG(Ride_Distance)
as avg_distance from Ola_booking_dataset
GROUP BY Vehicle_Type;  

Select *from ride_distance;

--#3 Get the total number of canceled ride by customers 
CREATE View Canceled_ride AS 
select count(*) from ola_booking_dataset
where Booking_status= 'Cancelled';

select count(*) from ola_booking_dataset
where Booking_status= 'Cancelled';

--#4.List the top 5 customers who booked the highest number of rides
CREATE VIEW TOP_5_CUSTOMERS AS 
select Customer_Id, count(Booking_ID) as total_rides
FROM Ola_booking_dataset 
GROUP BY Customer_ID 
ORDER BY total_rides DESC ; 


--#5 Get The number OF rides canceled by drivers due to personal and car related issues:
Create View Rides_Canceled As 
SELECT COUNT(*) FROM Ola_booking_dataset
WHERE Canceled_ride = 'Personal & car related issue';

--#6. FIND THE maximum and MiNIMUM driver rating for Prime sedan Booking 
CREATE VIEW MAX_MIN_Driver_RATING AS
SELECT MAX(Driver_Rating) as max_rating,
MIN(Driver_Ratings) as min_ratig
FROM Booking WHERE Vehicle_Type =' PrimeSedan';

--#7.Retrive All rides where Payment was made using UPI:
CREATE VIEW UPI_Payment AS 
SELECT *from Ola_Booking_dataset
WHERE Payment_Method='UPI';

--#.8.Find the Average Customer rating per vehicle type:
CREATE VIEW AVG_CUST_Rating AS 
SELECT Vehicle_Type ,AVG(Customer_Rating) as avg_Customer_rating
FROM Ola_Booking_dataset
GROUP BY Vehicle_Type;

--#9.Calculate the total Booking value of rides completed successfully
CREATE VIEW total_successful_ride_vakue AS 
SELECT SUM(Booking_Values) AS total_successful_ride_value
FROM Ola_Booking_dataset
WHERE Booking_Status='Success';

--#10.List All Imcomplete rides along with the reason:
CREATE VIEW Incomplete_rides
SELECT Booking_ID, INcomplete_RIDES_REASON
FROM Ola_Booking_dataset 
WHERE Incomplete_Rides= 'Yes';




