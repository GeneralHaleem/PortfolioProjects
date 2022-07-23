#SELECTING MY ENTIRE DATA
SELECT 
    *
FROM
    coviddeaths;
    
#CREATING DUPLICATE TABLE AS BACKUP
CREATE TABLE dup_coviddeaths AS SELECT * FROM
    coviddeaths;
    
#SELECTING THE DATA I'D BE WORKING ON
SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    coviddeaths
ORDER BY location , date;

#TOTAL CASES vs TOTAL DEATHS

#Likelihood of dying if you had contarcted COVID in a country
SELECT 
    location,
    MAX(total_cases) AS Total_Cases,
    MAX(total_deaths) AS Total_Deaths,
    (MAX(total_deaths) / MAX(total_cases)) * 100 AS DeathPercentage
FROM
    coviddeaths
WHERE continent IS NOT NULL    
GROUP BY location
ORDER BY location , date;

#Likelihood of dying if you had contarcted COVID in my country
SELECT 
    location,
    date,
    (total_cases) AS Total_Cases,
    (total_deaths) AS Total_Deaths,
    (total_deaths) / (total_cases) * 100 AS DeathPercentage
FROM
    coviddeaths
WHERE location = 'Nigeria' AND continent IS NOT NULL 
ORDER BY location , date;

#TOTAL CASES vs POPULATION

# Percentage of People that contacted COVID in my Country
SELECT 
    location,
    date,
    population,
    total_cases,
    (total_cases / population) * 100 AS CasePercentage
FROM
    coviddeaths
WHERE
    location = 'Nigeria' AND continent IS NOT NULL
ORDER BY date;

# Percentage of population that contracted COVID
SELECT 
    location,
    date,
    population,
    total_cases,
    (total_cases / population) * 100 AS CasePercentage
FROM
    coviddeaths 
WHERE continent IS NOT NULL   
ORDER BY location , date;  

#Percentage of population that contracted COVID in My Country
SELECT 
    location,
    date,
    total_cases,
    (total_cases / population) * 100 AS CasePercentage
FROM
    coviddeaths 
WHERE location = 'Nigeria'  AND continent IS NOT NULL  
ORDER BY location , date;


#Countries with highest Infection Rate
SELECT 
    location,
    population,
    MAX(total_cases) AS Total_Cases,
    MAX(total_cases / population) * 100 AS Percentage_PopulationInfected
FROM
    coviddeaths
WHERE continent IS NOT NULL    
GROUP BY location
ORDER BY Percentage_PopulationInfected DESC;

#Countries with highest Death Count per Population
SELECT 
    location, population, MAX(total_deaths) AS Total_Deaths
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY Total_Deaths DESC;


#GLOBAL NUMBERS

#Continent with Highest Death Count per Population
SELECT continent, SUM(new_deaths) AS Total_DeathCount
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent;

# Total cases, deaths and deaths_percentage each day
SELECT 
    date,
    SUM(new_cases) AS Total_Cases,
    SUM(new_deaths) AS Total_Deaths,
    (SUM(new_deaths) / SUM(new_cases)) * 100 AS DeathPercentage
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY date
ORDER BY date;

#Total cases, deaths and deaths_percentage
SELECT 
    SUM(new_cases) AS Total_Cases,
    SUM(new_deaths) AS Total_Deaths,
    (SUM(new_deaths) / SUM(new_cases)) * 100 AS DeathPercentage
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
ORDER BY date;
#Life Expentancy
SELECT 
    iso_code, location, population, life_expectancy
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY life_expectancy DESC;

# % of Male Smokers
SELECT 
    iso_code, location, population, male_smokers
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY male_smokers DESC;


# % of Female Smokers
SELECT 
    iso_code, location, population, female_smokers
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY female_smokers DESC;

#Vaccinations:  
  
SELECT 
    continent, location, date, population, new_vaccinations
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
ORDER BY  location, date;

#Total Vaccinations
SELECT 
    location, population, MAX(total_vaccinations) AS Total_Vaccinations
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY location , date;

#Total Vaccination by Partitioning 
SELECT  
	continent, 
	location, 
    date, 
    population, 
    new_vaccinations, 
    SUM(new_vaccinations) OVER (partition by location ORDER BY location, date) AS Total_Vaccinations
FROM coviddeaths
WHERE continent is not null
ORDER BY location, date;

#Total_Population VS Vaccinations USING CTE
WITH PopVac ( continent, location, date, population, new_vaccinations, Total_Vaccinations) AS 
(
SELECT  continent, location, date, population, new_vaccinations, SUM(new_vaccinations) OVER (partition by location ORDER BY location, date) AS Total_Vaccinations
FROM coviddeaths
WHERE continent is not null
ORDER BY location, date
)
SELECT *, Total_Vaccinations/ population * 100 AS  Percentage_of_Vaccination FROM PopVac;


#VIEWS FOR LATER VISUALIZATION

#View for Continent with Highest Death Count per Population
CREATE VIEW DeathCount_PER_Continent AS
    SELECT 
        continent, SUM(new_deaths) AS Total_DeathCount
    FROM
        coviddeaths
    WHERE
        continent IS NOT NULL
    GROUP BY continent;

#Likelihood of dying if you had contarcted COVID in a country
CREATE VIEW likelihood_of_dying AS
    SELECT 
        location,
        MAX(total_cases) AS Total_Cases,
        MAX(total_deaths) AS Total_Deaths,
        (MAX(total_deaths) / MAX(total_cases)) * 100 AS DeathPercentage
    FROM
        coviddeaths
    WHERE
        continent IS NOT NULL
    GROUP BY location
    ORDER BY location , date;

# Percentage of People that contacted COVID in Nigeria
CREATE VIEW Infected_people_IN_Nigeria AS
    SELECT 
        location,
        date,
        population,
        total_cases,
        (total_cases / population) * 100 AS CasePercentage
    FROM
        coviddeaths
    WHERE
        location = 'Nigeria' AND continent IS NOT NULL 
    ORDER BY date;
 
#Countries with highest Infection Rate
CREATE VIEW Infection_Rate AS
    SELECT 
        location,
        population,
        MAX(total_cases) AS Total_Cases,
        MAX(total_cases / population) * 100 AS Percentage_PopulationInfected
    FROM
        coviddeaths
    WHERE continent IS NOT NULL    
    GROUP BY location
    ORDER BY Percentage_PopulationInfected DESC;

#Countries with highest Death Count per Population
CREATE VIEW DeathCount AS
    SELECT 
        location, population, MAX(total_deaths) AS Total_Deaths
    FROM
        coviddeaths
    WHERE
        continent IS NOT NULL
    GROUP BY location
    ORDER BY Total_Deaths DESC;

# Total cases, deaths and deaths_percentage each day
CREATE VIEW cases_deaths_DeathPercentage AS
    SELECT 
        date,
        SUM(new_cases) AS Total_Cases,
        SUM(new_deaths) AS Total_Deaths,
        (SUM(new_deaths) / SUM(new_cases)) * 100 AS DeathPercentage
    FROM
        coviddeaths
    WHERE
        continent IS NOT NULL
    GROUP BY date
    ORDER BY date;

#Total cases, deaths and deaths_percentage
CREATE VIEW Total_cases_deaths_Death_Percentage AS
SELECT 
    SUM(new_cases) AS Total_Cases,
    SUM(new_deaths) AS Total_Deaths,
    (SUM(new_deaths) / SUM(new_cases)) * 100 AS DeathPercentage
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
ORDER BY date; 

#Life Expentancy
CREATE VIEW Life_Expentancy AS
SELECT 
    iso_code, location, population, life_expectancy
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY life_expectancy DESC;

#Male Smokers
CREATE VIEW Male_Smokers AS
SELECT 
    iso_code, location, population, male_smokers
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY male_smokers DESC;

#Female Smokers
CREATE VIEW Female_Smokers AS
SELECT 
    iso_code, location, population, female_smokers
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY female_smokers DESC;


#Total Vaccinations
CREATE VIEW Total_Vaccination AS
    SELECT 
        location,
        population,
        MAX(total_vaccinations) AS Total_Vaccinations
    FROM
        coviddeaths
    WHERE
        continent IS NOT NULL
    GROUP BY location
    ORDER BY location , date;

