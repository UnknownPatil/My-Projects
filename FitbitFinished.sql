--Which feature is being most used by users; the distance tracker, sleep or weight?
--Here, I joined the tables for “daily_activity”, “sleep_day”, and “weightLog_info” 
--to get a total count of unique Ids for each table:


SELECT
Count(Distinct(Activity.Id)) AS TotalActivityId,
Count(Distinct(Sleep.Id)) AS TotalSleepId,
Count(Distinct(Weight.Id)) AS TotalWeightId
FROM dailyActivity AS Activity
Full Outer JOIN
sleepDay AS Sleep
ON
Activity.Id = Sleep.Id
Full Outer JOIN
weightLog AS Weight
ON
Activity.Id = Weight.Id

CREATE VIEW FeatureMostlyUsed_DistanceTracker_Sleep_Weight AS
SELECT
Count(Distinct(Activity.Id)) AS TotalActivityId,
Count(Distinct(Sleep.Id)) AS TotalSleepId,
Count(Distinct(Weight.Id)) AS TotalWeightId
FROM dailyActivity AS Activity
Full Outer JOIN
sleepDay AS Sleep
ON
Activity.Id = Sleep.Id
Full Outer JOIN
weightLog AS Weight
ON
Activity.Id = Weight.Id





--To see how many users are using all 3 of the features, I ran the same query, but used inner joins instead:


SELECT
Count(Distinct(Activity.Id)) AS TotalActivityId,
Count(Distinct(Sleep.Id)) AS TotalSleepId,
Count(Distinct(Weight.Id)) AS TotalWeightId
FROM dailyActivity AS Activity
JOIN
sleepDay AS Sleep
ON
Activity.Id = Sleep.Id
JOIN
weightLog AS Weight
ON
Activity.Id = Weight.Id






--how much total distance was spent in each intensity category ?
SELECT
--Id,
round(SUM(VeryActiveDistance),2) AS Very,
round(SUM(ModeratelyActiveDistance),2) AS Moderate,
round(SUM(LightActiveDistance),2) AS Light,
round(SUM(SedentaryActiveDistance),2) AS Sedentary
FROM dailyactivity
--group by Id
--order by Id


--how much total distance was spent in each intensity category (Per User)?
SELECT
Id,
round(SUM(VeryActiveDistance),2) AS Very,
round(SUM(ModeratelyActiveDistance),2) AS Moderate,
round(SUM(LightActiveDistance),2) AS Light,
round(SUM(SedentaryActiveDistance),2) AS Sedentary
FROM dailyactivity
group by Id
order by Id


--CREATING VIEWS OF BOTH..
CREATE VIEW totaldistanceInIntensityCategory AS
SELECT
--Id,
round(SUM(VeryActiveDistance),2) AS Very,
round(SUM(ModeratelyActiveDistance),2) AS Moderate,
round(SUM(LightActiveDistance),2) AS Light,
round(SUM(SedentaryActiveDistance),2) AS Sedentary
FROM dailyactivity
--group by Id
--order by Id



CREATE VIEW totaldistanceInIntensityCategory_PerUser AS
SELECT
Id,
round(SUM(VeryActiveDistance),2) AS Very,
round(SUM(ModeratelyActiveDistance),2) AS Moderate,
round(SUM(LightActiveDistance),2) AS Light,
round(SUM(SedentaryActiveDistance),2) AS Sedentary
FROM dailyactivity
group by Id
--order by Id








--calculating the same with time
SELECT
--Id,
round(SUM(VeryActiveMinutes/24),2) AS Very,
round(SUM(FairlyActiveMinutes/24),2) AS Moderate,
round(SUM(LightlyActiveMinutes/24),2) AS Light,
round(SUM(SedentaryMinutes/24),2) AS Sedentary
FROM dailyactivity
--group by Id
--order by Id


SELECT
Id,
round(SUM(VeryActiveMinutes/24),2) AS Very,
round(SUM(FairlyActiveMinutes/24),2) AS Moderate,
round(SUM(LightlyActiveMinutes/24),2) AS Light,
round(SUM(SedentaryMinutes/24),2) AS Sedentary
FROM dailyactivity
group by Id
order by Id



--creating views
CREATE VIEW totalHoursInIntensityCategory AS
SELECT
--Id,
round(SUM(VeryActiveMinutes/24),2) AS Very,
round(SUM(FairlyActiveMinutes/24),2) AS Moderate,
round(SUM(LightlyActiveMinutes/24),2) AS Light,
round(SUM(SedentaryMinutes/24),2) AS Sedentary
FROM dailyactivity
--group by Id
--order by Id


CREATE VIEW totalHoursInIntensityCategory_PerUser AS
SELECT
Id,
round(SUM(VeryActiveMinutes/24),2) AS Very,
round(SUM(FairlyActiveMinutes/24),2) AS Moderate,
round(SUM(LightlyActiveMinutes/24),2) AS Light,
round(SUM(SedentaryMinutes/24),2) AS Sedentary
FROM dailyactivity
group by Id
--order by Id


--Total and average distance per user:
SELECT
Id,
round(SUM(TotalDistance),2) AS TotalDistance,
round(AVG(TotalDistance),2) AS AverageDistance 
FROM dailyActivity
GROUP BY Id 
ORDER BY Id 

--Average distance for all users, the max and min distance.
SELECT
AVG(TotalDistance) AS AverageDistance,
MIN(TotalDistance) AS ShortestDistance,
MAX(TotalDistance) AS LongestDistance
FROM dailyActivity

--Creating view
CREATE VIEW Total_and_average_Distance_PerUser AS
SELECT
Id,
round(SUM(TotalDistance),2) AS TotalDistance,
round(AVG(TotalDistance),2) AS AverageDistance 
FROM dailyActivity
GROUP BY Id 
--ORDER BY Id 



--How many days did each user use their watch?
SELECT
Id,
Count(ActivityDate) AS DaysUsed
FROM dailyActivity
Group BY Id
ORDER BY (DaysUsed) DESC, Id 


--creating view
Create view Active_Watch_Users as
SELECT
Id,
Count(ActivityDate) AS DaysUsed
FROM dailyActivity
Group BY Id
--ORDER BY (DaysUsed) DESC, Id 


--What time of the day and what days of the week are the users most active?
-- Here we find user activity by hour:

create table temp_byHour (
ttime time,
Sum_CaloriesTotal int,
Sum_StepsTotal int)

INSERT INTO temp_byHour
SELECT 
cast(activityhour as time),
Sum(calories),
Sum(steps_total)
FROM steps_calories_intensity
Group By activityhour

select ttime,
SUM(Sum_caloriesTotal) as Total_Calories_By_Hour,
SUM(Sum_StepsTotal) as Total_Steps_By_Hour
from temp_byHour
Group By ttime
ORDER BY ttime



--CREATING VIEW
CREATE VIEW Total_Calories_and_Steps_By_Hour as
select ttime,
SUM(Sum_caloriesTotal) as Total_Calories_By_Hour,
SUM(Sum_StepsTotal) as Total_Steps_By_Hour
from temp_byHour
Group By ttime
--ORDER BY ttime

Drop Table temp_byHour



--How many users used the logged distance function?
SELECT
Count(Distinct(Id)) AS NumberOfLoggedActivities
FROM dailyActivity
WHERE LoggedActivitiesDistance > 0


--…and how much distance did each of those users record with that feature?
SELECT
Id,
Sum(LoggedActivitiesDistance) AS LoggedActivities
FROM dailyActivity
WHERE LoggedActivitiesDistance > 0
Group BY Id
ORDER BY (LoggedActivities) DESC



--What is the average hours of sleep for all users and the max and min?
SELECT
AVG(TotalMinutesAsleep/60) AS Average,
MIN(TotalMinutesAsleep/60) AS Least,
MAX(TotalMinutesAsleep/60) AS Most
FROM sleepDay




/* 
Given the high usage of the distance and steps tracker, it would be wise for the marketing team to prioritize this feature in their strategy. 
If the company decides to create new wearable devices in the future, they could consider pricing models that are based on the usage of specific features. 
For instance, a more expensive model could include all three features (movement, sleep, and weight tracking) while a cheaper model could solely track movement.

However, it's important to note that not all participants utilized the sleep tracking feature, 
which warrants further investigation to determine if the device is not comfortable to wear while sleeping or if users are not interested in tracking their sleep patterns. 
In addition, the weight tracking feature was underutilized, with only eight participants using it. 
The reason for this low usage should be studied to determine if it is due to a lack of interest or if the feature is not user-friendly.

Based on the data, it's clear that the wearable device is being used throughout the day and not solely during workouts. 
Therefore, the marketing team should also focus on this aspect and create a more versatile device that is comfortable and suitable for daily activities. 
The team could emphasize the device's various options and styles that cater to different lifestyles and situations, 
highlighting how it can seamlessly transition from morning activity to lunchtime workouts and then productive work after the day is done.

Furthermore, the marketing team could leverage the information on when users are most and least active to develop targeted marketing campaigns. 
For instance, they could promote the device as an all-day companion that can help users maintain an active lifestyle throughout the day, from morning to night. 
/*