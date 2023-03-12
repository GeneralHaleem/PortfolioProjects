#OVERVIEW OF THE ENTIRE DATASET
SELECT 
    *
FROM
    portfolioproject.sales;

#Creating duplicate
CREATE TABLE dup_sales AS SELECT * FROM
    sales;

#BRANCH
#Branch with the highest sales
SELECT 
    Branch, City, ROUND(SUM(Total), 2) AS Total_Sales
FROM
    sales
GROUP BY Branch
ORDER BY Branch;

#Branch with the most customers
SELECT 
    Branch, City, COUNT(InvoiceID) AS Sales_Count
FROM
    sales
GROUP BY Branch
ORDER BY Branch;

#Day of the week with the most and higest sales
SELECT 
    DAYNAME(Date) AS Weekday,
    COUNT(InvoiceID) AS Sales_Count,
    ROUND(SUM(Total), 2) AS Total_Sales
FROM
    sales
GROUP BY Weekday
ORDER BY FIELD(Weekday,
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday');

#Proportion of members to normal customer in each branch
SELECT 
    Branch,
    City,
    Customertype,
    COUNT(Customertype) AS Customertype_Count
FROM
    sales
GROUP BY Branch , Customertype
ORDER BY Branch;

#Proportion of male to female customer in each branch
SELECT 
    Branch, City, Gender, COUNT(Gender) AS Gender_Count
FROM
    sales
GROUP BY Branch , Gender
ORDER BY Branch;

#Payment method used in each branch
SELECT 
    Branch, City, Payment, COUNT(Payment) AS Paymentmethod_Count
FROM
    sales
GROUP BY Branch , Payment
ORDER BY Branch;

#Average ratings of each branch
SELECT 
    Branch, City, ROUND(AVG(Rating), 2) AS Average_ratings
FROM
    sales
GROUP BY Branch
ORDER BY Branch;

#Product sold in each Branch
SELECT 
    Branch,
    City,
    Productline,
    COUNT(Productline) AS Product_count
FROM
    sales
GROUP BY Branch , Productline
ORDER BY Branch , Product_count DESC;


#Customer type
#Identifying which customer type spends the most
SELECT 
    Customertype, ROUND(SUM(Total), 2) AS Total_purchase
FROM
    sales
GROUP BY Customertype
ORDER BY Total_purchase DESC;

#Proportion of male to female in each customer type
SELECT 
    Customertype, Gender, COUNT(Gender) AS Gender_Count
FROM
    sales
GROUP BY Customertype , Gender
ORDER BY Customertype , Gender_Count DESC;

#Product each customer type buys the most
SELECT 
    Customertype,
    Productline,
    COUNT(Productline) AS Count,
    ROUND(AVG(Total), 2) AS Average_purchase
FROM
    sales
GROUP BY Customertype , Productline
ORDER BY Customertype , Count DESC;

#Proportion of customer type
SELECT 
    Customertype, COUNT(Customertype) AS Count
FROM
    sales
GROUP BY Customertype;

#Figuring out what day of the week each member spends the most 
SELECT 
    Customertype,
    DAYNAME(Date) AS Weekday,
    COUNT(Customertype) AS Customer_count,
    ROUND(AVG(Total), 2) AS Average_Purchase
FROM
    sales
GROUP BY Customertype , Weekday
ORDER BY Customertype , Customer_count DESC;

#GENDER
#Gender by Productline
SELECT 
    Gender, Productline, ROUND(AVG(Total), 2) AS Total_Average
FROM
    sales
GROUP BY Gender , Productline
ORDER BY Gender , Total_Average DESC;

#Gender count
SELECT 
    Gender, COUNT(Gender) AS Count
FROM
    sales
GROUP BY Gender;

#Which Gender spends the most
SELECT 
    Gender, ROUND(SUM(Total), 2) AS Total_Purchase
FROM
    sales
GROUP BY Gender
ORDER BY Total_Purchase DESC;

#Payment Option by Gender
SELECT 
    Gender, Payment, COUNT(Payment) AS Count
FROM
    sales
GROUP BY Gender , Payment
ORDER BY Gender , Count DESC;

#PRODUCTLINE
#Finding out which of the productline makes the higest sales
SELECT 
    Productline, ROUND(SUM(Total), 2) AS Total_sales
FROM
    sales
GROUP BY Productline
ORDER BY Total_sales DESC;

#Which product have the highest sales
SELECT 
    Productline, COUNT(Productline) AS Product_count
FROM
    sales
GROUP BY Productline
ORDER BY Product_count DESC;

#Average ratings per productline
SELECT 
    Productline, ROUND(AVG(Rating), 2) AS Average_ratings
FROM
    sales
GROUP BY Productline
ORDER BY Average_ratings DESC;

#Percentage Each Productline have in COG
WITH ProductlineCTE AS
 (
SELECT 
    Productline, SUM(cogs) AS Total_COG
FROM
    sales
GROUP BY Productline
) 
SELECT 
    Productline,
    ROUND((Total_COG / (SELECT 
                    SUM(cogs)
                FROM
                    sales)) * 100,
            2) AS percentage_in_Totalcogs
FROM
    ProductlineCTE
ORDER BY percentage_in_Totalcogs DESC;

#Percentage Each Gender have in COG
WITH GenderCTE AS
 (
SELECT 
    Gender, SUM(cogs) AS Total_COG
FROM
    sales
GROUP BY Gender
) 
SELECT 
    Gender,
    ROUND((Total_COG / (SELECT 
                    SUM(cogs)
                FROM
                    sales)) * 100,
            2) AS percentage_in_Totalcogs
FROM
    GenderCTE
ORDER BY percentage_in_Totalcogs DESC;

#Percentage Each City have in COG
WITH CityCTE AS 
(
SELECT 
    Branch, City, SUM(cogs) AS Total_COG
FROM
    sales
GROUP BY City
) 
SELECT 
    Branch,
    City,
    ROUND((Total_COG / (SELECT 
                    SUM(cogs)
                FROM
                    sales)) * 100,
            2) AS percentage_in_Totalcogs
FROM
    CityCTE
ORDER BY percentage_in_Totalcogs DESC;

#Percentage Each Customertype have in COG
WITH CustomertypeCTE AS 
(
SELECT 
    Customertype, SUM(cogs) AS Total_COG
FROM
    sales
GROUP BY Customertype
) 
SELECT 
    Customertype,
    ROUND((Total_COG / (SELECT 
                    SUM(cogs)
                FROM
                    sales)) * 100,
            2) AS percentage_in_Totalcogs
FROM
    CustomertypeCTE
ORDER BY percentage_in_Totalcogs DESC;

#Finding out which day of the week do customers spends the most
SELECT 
    DAYNAME(Date) AS Weekday, ROUND(AVG(Total), 2) AS Average_Sales
FROM
    sales
GROUP BY Weekday
ORDER BY Average_Sales DESC;

#Finding out which day of the week do customers shop the most
SELECT 
    DAYNAME(Date) AS Weekday, COUNT(InvoiceID) AS CustomerCount
FROM
    sales
GROUP BY Weekday
ORDER BY CustomerCount DESC;

#Sales per month
SELECT 
    MONTHNAME(Date) AS Monthname,
    Date,
    ROUND(SUM(Total), 2) AS Total_Sales
FROM
    sales
GROUP BY Monthname
ORDER BY FIELD(Monthname,
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December');
        
#Salescount per month
SELECT 
    MONTHNAME(Date) AS Monthname,
    Date,
    COUNT(InvoiceID) AS Salescount
FROM
    sales
GROUP BY Monthname
ORDER BY FIELD(Monthname,
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December');















