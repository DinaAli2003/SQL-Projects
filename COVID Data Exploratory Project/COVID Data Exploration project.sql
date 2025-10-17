-- COVID 2019 Data Exploration project
-- ====================================
DROP DATABASE IF EXISTS COVID19;
-- CREATING DATABASE
CREATE DATABASE IF NOT EXISTS COVID19;
USE COVID19;
-- ====================================


CREATE TABLE CovidDeaths (
    iso_code VARCHAR(10),
    continent VARCHAR(50),
    location VARCHAR(100),
    -- Converted to a proper date format (YYYY-MM-DD)
    date DATE, 
    -- Large counts of cases/deaths/population are BIGINT to handle NULLs and large numbers
    total_cases BIGINT,
    new_cases BIGINT,
    new_cases_smoothed FLOAT,
    total_deaths BIGINT,
    new_deaths BIGINT,
    new_deaths_smoothed FLOAT,
    -- Rates and metrics are best stored as FLOAT or DECIMAL
    total_cases_per_million FLOAT,
    new_cases_per_million FLOAT,
    new_cases_smoothed_per_million FLOAT,
    total_deaths_per_million FLOAT,
    new_deaths_per_million FLOAT,
    new_deaths_smoothed_per_million FLOAT,
    reproduction_rate FLOAT,
    -- ICU/Hospital numbers are best as BIGINT
    icu_patients BIGINT,
    icu_patients_per_million FLOAT,
    hosp_patients BIGINT,
    hosp_patients_per_million FLOAT,
    weekly_icu_admissions FLOAT,
    weekly_icu_admissions_per_million FLOAT,
    weekly_hosp_admissions FLOAT,
    weekly_hosp_admissions_per_million FLOAT,
    -- Test data counts are best as BIGINT
    new_tests BIGINT,
    total_tests BIGINT,
    total_tests_per_thousand FLOAT,
    new_tests_per_thousand FLOAT,
    new_tests_smoothed BIGINT,
    new_tests_smoothed_per_thousand FLOAT,
    positive_rate FLOAT,
    tests_per_case FLOAT,
    tests_units VARCHAR(50),
    -- Vaccination data counts are best as BIGINT
    total_vaccinations BIGINT,
    people_vaccinated BIGINT,
    people_fully_vaccinated BIGINT,
    new_vaccinations BIGINT,
    new_vaccinations_smoothed BIGINT,
    total_vaccinations_per_hundred FLOAT,
    people_vaccinated_per_hundred FLOAT,
    people_fully_vaccinated_per_hundred FLOAT,
    new_vaccinations_smoothed_per_million FLOAT,
    -- Socio-economic and other metrics are FLOAT
    stringency_index FLOAT,
    population BIGINT,
    population_density FLOAT,
    median_age FLOAT,
    aged_65_older FLOAT,
    aged_70_older FLOAT,
    gdp_per_capita FLOAT,
    extreme_poverty FLOAT,
    cardiovasc_death_rate FLOAT,
    diabetes_prevalence FLOAT,
    female_smokers FLOAT,
    male_smokers FLOAT,
    handwashing_facilities FLOAT,
    hospital_beds_per_thousand FLOAT,
    life_expectancy FLOAT,
    human_development_index FLOAT
);


CREATE TABLE CovidVaccinations (
    iso_code VARCHAR(10),
    continent VARCHAR(50),
    location VARCHAR(100),
    -- Converted to a proper date format (YYYY-MM-DD)
    date DATE,
    -- Test data counts are best as BIGINT
    new_tests BIGINT,
    total_tests BIGINT,
    total_tests_per_thousand FLOAT,
    new_tests_per_thousand FLOAT,
    new_tests_smoothed BIGINT,
    new_tests_smoothed_per_thousand FLOAT,
    positive_rate FLOAT,
    tests_per_case FLOAT,
    tests_units VARCHAR(50),
    -- Vaccination data counts are best as BIGINT
    total_vaccinations BIGINT,
    people_vaccinated BIGINT,
    people_fully_vaccinated BIGINT,
    new_vaccinations BIGINT,
    new_vaccinations_smoothed BIGINT,
    total_vaccinations_per_hundred FLOAT,
    people_vaccinated_per_hundred FLOAT,
    people_fully_vaccinated_per_hundred FLOAT,
    new_vaccinations_smoothed_per_million FLOAT,
    -- Socio-economic and other metrics are FLOAT
    stringency_index FLOAT,
    population_density FLOAT,
    median_age FLOAT,
    aged_65_older FLOAT,
    aged_70_older FLOAT,
    gdp_per_capita FLOAT,
    extreme_poverty FLOAT,
    cardiovasc_death_rate FLOAT,
    diabetes_prevalence FLOAT,
    female_smokers FLOAT,
    male_smokers FLOAT,
    handwashing_facilities FLOAT,
    hospital_beds_per_thousand FLOAT,
    life_expectancy FLOAT,
    human_development_index FLOAT
);



LOAD DATA LOCAL INFILE 'D:/Dina Projects/Data Analysis Projects/Data sets/COVID/CovidDeaths.csv'
INTO TABLE CovidDeaths
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



LOAD DATA LOCAL INFILE 'D:/Dina Projects/Data Analysis Projects/Data sets/COVID/CovidVaccinations.csv'
INTO TABLE CovidVaccinations
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



Select * FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 3,4;

-- ====================================
-- Select data that we will start with
SELECT location , date , total_cases ,new_cases ,total_deaths,population
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2 ;
-- =======================================
-- Total cases Vs Total Deaths
-- likelihood of dying in the USA
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths
Where location like '%states%'
and continent is not null 
order by 1,2;  

-- ======================================
-- Total cases Vs Population
-- Shows what percentage of population infected with Covid
SELECT location , date ,population, total_cases ,(total_cases/population)*100 as PercentPopulationInfected
FROM coviddeaths
ORDER BY 1,2 ; 
 
 -- ========================================
 -- Countries with the Highest infection Rate compared to population
 SELECT location ,population, Max(total_cases) as HighestInfectionCount,Max((total_cases/population))*100 as PercentPopulationInfected
 FROM coviddeaths
 GROUP BY  location,population
 ORDER BY PercentPopulationInfected DESC;
 
 
 -- ==============================================
 -- Countries with highest death count per Population
SELECT 
    location,
    MAX(CONVERT(Total_deaths, SIGNED)) AS TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;


-- ========================================
-- Showing continents with the highest death count per population
SELECT 
    continent,
    MAX(CONVERT(Total_deaths, SIGNED)) AS TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;


-- =======================================
-- Global Number
SELECT SUM(new_cases) as TotalCases,SUM(new_deaths) AS TotalDeaths,(SUM(new_deaths ) /SUM(new_cases) )*100 as DeathPercentage
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2 DESC;


-- ========================================
-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3;


-- =======================================
-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac ;


-- ===========================================
-- Using Temp Table to perform Calculation on Partition By in previous query
DROP Table if exists PercentPopulationVaccinated;
Create Table  PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);

Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date;

Select *, (RollingPeopleVaccinated/Population)*100
From  PercentPopulationVaccinated ;

 -- ==========================================
-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null ;

