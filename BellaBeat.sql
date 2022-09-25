#OVERVIEW OF THE DATASET
SELECT 
    *
FROM
    dailyactivity;  
    
SELECT 
    *
FROM
    hourlysteps;
    
SELECT 
    *
FROM
    dailysleep;
    
SELECT 
    *
FROM
    weightloginfo;
    
SELECT 
    *
FROM
    heartrate_seconds;
    

    
#Identifying how each user use the their fitbit tracker
SELECT 
    COUNT(Id) AS Count,
    Id,
    CASE
        WHEN COUNT(Id) > 22 THEN 'Vigorous User'
        WHEN COUNT(Id) BETWEEN 12 AND 21 THEN 'Moderate User'
        WHEN COUNT(Id) < 11 THEN 'Gentle User'
    END AS User_Type
FROM
    dailyactivity
GROUP BY Id;

#Identifying how users use their tracker by day of the week
SELECT 
    COUNT(Id) AS Count, Day
FROM
    dailyactivity
GROUP BY Day
ORDER BY FIELD(Day,
        'Sun',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat');
        
#Identifying how many users use the tracker to monitor their sleep activity, steps, daily activity, and weight 
WITH CTE AS (
SELECT 
    COUNT(DISTINCT (Id)) AS Count_Sleep,
    (SELECT 
            COUNT(DISTINCT (Id))
        FROM
            dailyactivity) AS Count_Activity,
    (SELECT 
            COUNT(DISTINCT (Id))
        FROM
            hourlysteps) AS Count_Steps,
    (SELECT 
            COUNT(DISTINCT (Id))
        FROM
            weightloginfo) AS Count_Weightloginfo
FROM
    dailysleep
        )
   SELECT 
    (Count_Sleep / Count_Activity) * 100 AS sleeptracker_percentage,
    (Count_Steps / Count_Activity) * 100 AS stepstracker_percentage,
    (Count_Weightloginfo / Count_Activity) * 100 AS weighttracker_percentage
FROM
    CTE;

#Identifying how users walk by day of the week
SELECT 
    Day,
    ROUND(AVG(TotalSteps), 2) AS TotalSteps,
    ROUND(AVG(TotalDistance), 2) AS TotalDistance
FROM
    dailyactivity
GROUP BY Day
ORDER BY FIELD(Day,
        'Sun',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat');
        
#Idetifying how customers walk by the hour
WITH CTE AS (
SELECT ActivityHour, StepTotal, 
CASE
WHEN ActivityHour BETWEEN "07:00:00" AND "11:59:00" THEN 'Morning'
WHEN ActivityHour BETWEEN "12:00:00" AND "18:59:00" THEN 'Afternoon'
WHEN ActivityHour BETWEEN "19:00:00" AND "23:59:00" THEN 'Evening'
WHEN ActivityHour BETWEEN "00:00:00" AND "03:59:00" THEN 'Midnight'
WHEN ActivityHour BETWEEN "04:00:00" AND "06:59:00" THEN 'EarlyMorning'
END AS Day_Time
FROM hourlysteps
)
SELECT SUM(StepTotal) AS StepTotal, Day_Time FROM CTE
GROUP BY Day_Time
ORDER BY FIELD(Day_Time,
        'EarlyMorning',
        'Morning',
        'Afternoon',
        'Evening',
        'Midnight');
        
#Active Minute by day of the week
SELECT 
    Day,
    ROUND(SUM(VeryActiveDistance), 2) AS VeryActiveDistance,
    ROUND(SUM(ModeratelyActiveDistance), 2) AS ModeratelyActiveDistance,
    ROUND(SUM(LightActiveDistance), 2) AS LightActiveDistance,
    ROUND(SUM(SedentaryActiveDistance), 2) AS SedentaryActiveDistance
FROM
    dailyactivity
GROUP BY Day
ORDER BY FIELD(Day,
        'Sun',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat');
        
SELECT 
    Day,
    ROUND(AVG(VeryActiveMinutes), 2) AS VeryActiveMinutes,
    ROUND(AVG(FairlyActiveMinutes), 2) AS FairlyActiveMinutes,
    ROUND(AVG(LightlyActiveMinutes), 2) AS LightlyActiveMinutes,
    ROUND(AVG(SedentaryMinutes), 2) AS SedentaryMinutes
FROM
    dailyactivity
GROUP BY Day
ORDER BY FIELD(Day,
        'Sun',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat');
        
#Steps and Calories by day Id, and Day of the week
SELECT 
    Id,
    Day,
    AVG(TotalSteps) AS TotalSteps,
    AVG(Calories) AS Calories
FROM
    dailyactivity
GROUP BY Id , Day
ORDER BY FIELD(Day,
        'Sun',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat');
        
        
#Trying to find Correlation
SELECT 
    Id, ROUND(AVG(TotalSteps), 2) AS TotalSteps, ROUND(AVG(Calories), 2) AS Calories
FROM
    dailyactivity
GROUP BY Id
ORDER BY FIELD(Day,
        'Sun',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat');
	
#Identifying how users sleep by day of the week
SELECT 
    Day,
    AVG(TotalMinutesAsleep) AS TotalMinutesAsleep,
    AVG(TotalTimeInBed) AS TotalTimeInBed,
    AVG(TotalTimeInBed - TotalMinutesAsleep) AS TotalMinuteInBed_NotAsleep
FROM
    dailysleep
GROUP BY Day
ORDER BY FIELD(Day,
        'Sun',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat');
        
#Identifying the weight and BMI of each users        
SELECT 
    Id, AVG(WeightKg) AS WeightKg, AVG(BMI) AS BMI
FROM
    weightloginfo
GROUP BY Id;

#VIEWS FOR VISUALIZATION


#Fitbits Tracker Usage
CREATE VIEW Tracker_Usage AS
    SELECT 
        COUNT(Id) AS Count,
        Id,
        CASE
            WHEN COUNT(Id) > 22 THEN 'Vigorous User'
            WHEN COUNT(Id) BETWEEN 12 AND 21 THEN 'Moderate User'
            WHEN COUNT(Id) < 11 THEN 'Gentle User'
        END AS User_Type
    FROM
        dailyactivity
    GROUP BY Id;
    
#Fitbits % usage
CREATE VIEW percentage_customer_using_tracker AS
WITH CTE AS (
SELECT 
    COUNT(DISTINCT (Id)) AS Count_Sleep,
    (SELECT 
            COUNT(DISTINCT (Id))
        FROM
            dailyactivity) AS Count_Activity,
    (SELECT 
            COUNT(DISTINCT (Id))
        FROM
            hourlysteps) AS Count_Steps,
    (SELECT 
            COUNT(DISTINCT (Id))
        FROM
            weightloginfo) AS Count_Weightloginfo
FROM
    dailysleep
        )
   SELECT 
    (Count_Sleep / Count_Activity) * 100 AS sleeptracker_percentage,
    (Count_Steps / Count_Activity) * 100 AS stepstracker_percentage,
    (Count_Weightloginfo / Count_Activity) * 100 AS weighttracker_percentage
FROM
    CTE;
    
#Steps and Distance Covered by users per day of the week
CREATE VIEW user_steps_and_distance_per_day AS
    SELECT 
        Day,
        ROUND(AVG(TotalSteps), 2) AS TotalSteps,
        ROUND(AVG(TotalDistance), 2) AS TotalDistance
    FROM
        dailyactivity
    GROUP BY Day
    ORDER BY FIELD(Day,
            'Sun',
            'Mon',
            'Tue',
            'Wed',
            'Thu',
            'Fri',
            'Sat');
#Steps Covered by users per time of the day
CREATE VIEW user_steps_per_time_of_day AS
WITH CTE AS (
SELECT ActivityHour, StepTotal, 
CASE
WHEN ActivityHour BETWEEN "07:00:00" AND "11:59:00" THEN 'Morning'
WHEN ActivityHour BETWEEN "12:00:00" AND "18:59:00" THEN 'Afternoon'
WHEN ActivityHour BETWEEN "19:00:00" AND "23:59:00" THEN 'Evening'
WHEN ActivityHour BETWEEN "00:00:00" AND "03:59:00" THEN 'Midnight'
WHEN ActivityHour BETWEEN "04:00:00" AND "06:59:00" THEN 'EarlyMorning'
END AS Day_Time
FROM hourlysteps
)
SELECT SUM(StepTotal) AS StepTotal, Day_Time FROM CTE
GROUP BY Day_Time
ORDER BY FIELD(Day_Time,
        'EarlyMorning',
        'Morning',
        'Afternoon',
        'Evening',
        'Midnight');
        
#Active Distance by day of the week
CREATE VIEW active_distance AS
    SELECT 
        Day,
        ROUND(AVG(VeryActiveMinutes), 2) AS VeryActiveMinutes,
        ROUND(AVG(FairlyActiveMinutes), 2) AS FairlyActiveMinutes,
        ROUND(AVG(LightlyActiveMinutes), 2) AS LightlyActiveMinutes,
        ROUND(AVG(SedentaryMinutes), 2) AS SedentaryMinutes
    FROM
        dailyactivity
    GROUP BY Day
    ORDER BY FIELD(Day,
            'Sun',
            'Mon',
            'Tue',
            'Wed',
            'Thu',
            'Fri',
            'Sat');

#Active minuite by day of the week
CREATE VIEW active_minute AS
    SELECT 
        Day,
        ROUND(AVG(VeryActiveMinutes), 2) AS VeryActiveMinutes,
        ROUND(AVG(FairlyActiveMinutes), 2) AS FairlyActiveMinutes,
        ROUND(AVG(LightlyActiveMinutes), 2) AS LightlyActiveMinutes,
        ROUND(AVG(SedentaryMinutes), 2) AS SedentaryMinutes
    FROM
        dailyactivity
    GROUP BY Day
    ORDER BY FIELD(Day,
            'Sun',
            'Mon',
            'Tue',
            'Wed',
            'Thu',
            'Fri',
            'Sat');

#Steps and Calories of each user by the day of the week
CREATE VIEW steps_calories_per_day AS
    SELECT 
        Id,
        Day,
        AVG(TotalSteps) AS TotalSteps,
        AVG(Calories) AS Calories
    FROM
        dailyactivity
    GROUP BY Id , Day
    ORDER BY FIELD(Day,
            'Sun',
            'Mon',
            'Tue',
            'Wed',
            'Thu',
            'Fri',
            'Sat');
            
#Correlation between steps and calories
CREATE VIEW correlation AS
    SELECT 
        Id,
        ROUND(AVG(TotalSteps), 2) AS TotalSteps,
        ROUND(AVG(Calories), 2) AS Calories
    FROM
        dailyactivity
    GROUP BY Id
    ORDER BY FIELD(Day,
            'Sun',
            'Mon',
            'Tue',
            'Wed',
            'Thu',
            'Fri',
            'Sat');
            
#Sleeptime by day of the week
CREATE VIEW sleep_time AS
    SELECT 
        Day,
        AVG(TotalMinutesAsleep) AS TotalMinutesAsleep,
        AVG(TotalTimeInBed) AS TotalTimeInBed,
        AVG(TotalTimeInBed - TotalMinutesAsleep) AS TotalMinuteInBed_NotAsleep
    FROM
        dailysleep
    GROUP BY Day
    ORDER BY FIELD(Day,
            'Sun',
            'Mon',
            'Tue',
            'Wed',
            'Thu',
            'Fri',
            'Sat');
            
#Users Weights and Body Mass Index
CREATE VIEW weight_bmi AS
    SELECT 
        Id, AVG(WeightKg) AS WeightKg, AVG(BMI) AS BMI
    FROM
        weightloginfo
    GROUP BY Id;

        
        
               




