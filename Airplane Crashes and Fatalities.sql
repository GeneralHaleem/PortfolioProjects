#OVERVIEW OF THE DATASET
SELECT 
    *
FROM
    airplane_crashes_and_fatalities;
    
#Total Crashed Planes, Crashed Planes Fatalities, Crashed Planes Survivors, Ground Causilities 
SELECT 
    COUNT(Date) AS Crashed_Planes,
    SUM(Fatalities) AS Fatalities,
    SUM(Survived) AS Survived, 
    SUM(Ground) AS Ground
FROM
    airplane_crashes_and_fatalities;
    
#%Of survivors and Fatalities
WITH CTE AS(
SELECT 
    SUM(Aboard) AS Aboard,
    SUM(Survived) AS Survived,
    SUM(Fatalities) AS Fatalities
FROM
    airplane_crashes_and_fatalities
)
SELECT 
    ROUND(Survived / Aboard * 100, 2) AS Survivors,
    ROUND(Fatalities / Aboard * 100, 2) AS Fatalities
FROM CTE; 
        
#Crashed PLanes by Year
SELECT 
    Year, COUNT(Aboard) AS Crash_Count
FROM
    airplane_crashes_and_fatalities
GROUP BY Year;

#PLane Crash by Month
SELECT 
    Month, COUNT(Aboard) AS Crash_Count
FROM
    airplane_crashes_and_fatalities
GROUP BY Month
ORDER BY FIELD(Month,
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'); 
        
#Crashed Planes by Day of the Week
SELECT 
    Day, COUNT(Aboard) AS Crash_Count
FROM
    airplane_crashes_and_fatalities
GROUP BY Day
ORDER BY FIELD(Day,
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun');
        
#Count Passengers aboard, survived, fatalities aboard, fatalitie on Ground by Year
SELECT 
    Year,
    SUM(Aboard) AS Aboard,
    SUM(Fatalities) AS Fatalities,
    SUM(Survived) AS Survived,
    SUM(Ground) AS Ground
FROM
    airplane_crashes_and_fatalities
GROUP BY Year;

#Count of crashes, Fatalities, Survivors and Ground Airplane by Operator
SELECT 
    Operator,
    COUNT(Date) AS Crash_count,
    SUM(Fatalities) AS Fatalities,
    SUM(Survived) AS Survived,
    SUM(Ground) AS Ground
    FROM
    airplane_crashes_and_fatalities
GROUP BY Operator
ORDER BY Crash_count DESC;


#Count of Crashes, Fatalities, Survivors and Ground Airplane by Types
SELECT 
    Type,
    COUNT(Date) AS Crash_count,
    SUM(Fatalities) AS Fatalities,
    SUM(Survived) AS Survived,
    SUM(Ground) AS Ground
FROM
    airplane_crashes_and_fatalities
GROUP BY Type
ORDER BY Crash_count DESC;

#Time against Crash
SELECT 
    COUNT(Date) AS Crash_count,
    CASE
        WHEN Time BETWEEN '07:00:00' AND '11:59:00' THEN 'Morning'
        WHEN Time BETWEEN '12:00:00' AND '18:59:00' THEN 'Afternoon'
        WHEN Time BETWEEN '19:00:00' AND '23:59:00' THEN 'Evening'
        WHEN Time BETWEEN '00:00:00' AND '03:59:00' THEN 'Midnight'
        WHEN Time BETWEEN '04:00:00' AND '06:59:00' THEN 'Early-Morning'
        ELSE 'Unknown'
    END AS Day_Time
FROM
    airplane_crashes_and_fatalities
GROUP BY Day_Time
ORDER BY Crash_count DESC;


#Comparing location to crash count
SELECT 
    Location, COUNT(Date) AS Crash_count
FROM
    airplane_crashes_and_fatalities
GROUP BY Location
ORDER BY Crash_count DESC;

#Comparing route to crash count
SELECT 
    Route, COUNT(Date) AS Crash_count
FROM
    airplane_crashes_and_fatalities
GROUP BY Route
ORDER BY Crash_count DESC;

#CREATING VIEWS FOR VIZUALIZATION

#Identifying how many airplanes have crashed, how many survived, and how suffered the casuality both on ground or onboard
CREATE VIEW Total_Count AS
    SELECT 
        COUNT(Date) AS Crashed_Planes,
        SUM(Fatalities) AS Fatalities,
        SUM(Survived) AS Survived,
        SUM(Ground) AS Ground
    FROM
        airplane_crashes_and_fatalities;
	
#Comparing survival rate to casuality in Percentage
CREATE VIEW Percentage_Survived_Casualities AS
WITH CTE AS(
SELECT 
    SUM(Aboard) AS Aboard,
    SUM(Survived) AS Survived,
    SUM(Fatalities) AS Fatalities
FROM
    airplane_crashes_and_fatalities
)
SELECT 
    ROUND(Survived / Aboard * 100, 2) AS Survivors,
    ROUND(Fatalities / Aboard * 100, 2) AS Fatalities
FROM CTE; 

#Identifying how many planes crashed by Year
CREATE VIEW crashed_planes_per_year AS
    SELECT 
        Year, COUNT(Aboard) AS Crash_Count
    FROM
        airplane_crashes_and_fatalities
    GROUP BY Year;

#Identifying how many planes crashed by month
CREATE VIEW crashed_planes_per_month AS
    SELECT 
        Month, COUNT(Aboard) AS Crash_Count
    FROM
        airplane_crashes_and_fatalities
    GROUP BY Month
    ORDER BY FIELD(Month,
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec');
            
#Identifying how many planes crashed by day of the week
CREATE VIEW crashed_planes_per_day AS
    SELECT 
        Day, COUNT(Aboard) AS Crash_Count
    FROM
        airplane_crashes_and_fatalities
    GROUP BY Day
    ORDER BY FIELD(Day,
            'Mon',
            'Tue',
            'Wed',
            'Thu',
            'Fri',
            'Sat',
            'Sun');
            
#Identifying how many passengers were on board, survived, died, and died on the ground by Year
CREATE VIEW aboard_fatalities_survived_ground AS
    SELECT 
        Year,
        SUM(Aboard) AS Aboard,
        SUM(Fatalities) AS Fatalities,
        SUM(Survived) AS Survived,
        SUM(Ground) AS Ground
    FROM
        airplane_crashes_and_fatalities
    GROUP BY Year;

#Identifying how many planes crashed, fatalities, survivor, and ground casualities by operator
CREATE VIEW crashed_fatalities_survived_ground AS
    SELECT 
        Operator,
        COUNT(Date) AS Crash_count,
        SUM(Fatalities) AS Fatalities,
        SUM(Survived) AS Survived,
        SUM(Ground) AS Ground
    FROM
        airplane_crashes_and_fatalities
    GROUP BY Operator
    ORDER BY Crash_count DESC;
    

#Identifying how many planes crashed, fatalities, survivor, and ground casualities by type
#CREATE VIEW crashed_fatalities_survived_ground_by_type AS
    SELECT 
        Type,
        COUNT(Date) AS Crash_count,
        SUM(Fatalities) AS Fatalities,
        SUM(Survived) AS Survived,
        SUM(Ground) AS Ground
    FROM
        airplane_crashes_and_fatalities
    GROUP BY Type
    ORDER BY Crash_count DESC;
    
#Identifying what time of the day has the heighest crash count#
CREATE VIEW time_crash AS
    SELECT 
        COUNT(Date) AS Crash_count,
        CASE
            WHEN Time BETWEEN '07:00:00' AND '11:59:00' THEN 'Morning'
            WHEN Time BETWEEN '12:00:00' AND '18:59:00' THEN 'Afternoon'
            WHEN Time BETWEEN '19:00:00' AND '23:59:00' THEN 'Evening'
            WHEN Time BETWEEN '00:00:00' AND '03:59:00' THEN 'Midnight'
            WHEN Time BETWEEN '04:00:00' AND '06:59:00' THEN 'Early-Morning'
            ELSE 'Unknown'
        END AS Day_Time
    FROM
        airplane_crashes_and_fatalities
    GROUP BY Day_Time
    ORDER BY Crash_count DESC;


#Identifying which location has the highest crash count
CREATE VIEW crash_count_by_location AS
    SELECT 
        Location, COUNT(Date) AS Crash_count
    FROM
        airplane_crashes_and_fatalities
    GROUP BY Location
    ORDER BY Crash_count DESC;
    
#Identifying which location has the highest route
CREATE VIEW crash_count_by_route AS
    SELECT 
        Route, COUNT(Date) AS Crash_count
    FROM
        airplane_crashes_and_fatalities
    GROUP BY Route
    ORDER BY Crash_count DESC;
