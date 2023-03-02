--SELECT *
--FROM Portfolio11..CovidDeaths
--ORDER BY 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio11..CovidDeaths
--WHERE continent is not null
ORDER BY 1,2  

-- Looking at Total Cases vs Total Deaths 
-- United States


SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM Portfolio11..CovidDeaths
WHERE location = 'United States'
--and continent is not null
ORDER BY 1,2 

-- Nigeria

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM Portfolio11..CovidDeaths
WHERE location = 'Nigeria'
ORDER BY 1,2 


-- Total Cases vs Population
-- USA

SELECT Location, date, population, total_cases, (total_cases/population)*100 AS CasePercentage
FROM Portfolio11..CovidDeaths
WHERE location = 'United States'
ORDER BY 1,2 

-- Nigeria

SELECT Location, date, population, total_cases, (total_cases/population)*100 AS CasePercentage
FROM Portfolio11..CovidDeaths
WHERE location = 'Nigeria'
ORDER BY 1,2 

-- Higest Infection Rate Compared to Population by Countries


SELECT Location, population, MAX(total_cases) AS HighestInfectionCount, (MAX(total_cases)/population)*100 AS InfectionPercentage
FROM Portfolio11..CovidDeaths
--WHERE continent is not 
GROUP BY Location, population
ORDER BY InfectionPercentage Desc

-- Higest Infection Rate Compared to Population BY Continent


SELECT continent, population, MAX(total_cases) AS HighestInfectionCount, (MAX(total_cases)/population)*100 AS InfectionPercentage
FROM Portfolio11..CovidDeaths
--WHERE continent is not null
GROUP BY continent, population
ORDER BY InfectionPercentage Desc

-- Total Deaths Vs Population by Country

SELECT Location, MAX(Cast(total_deaths as Int)) AS TotalDeaths, MAX((total_deaths)/population)*100 AS DeathPercentage
FROM Portfolio11..CovidDeaths
WHERE continent is not null
GROUP BY Location
ORDER BY DeathPercentage Desc
 
---- Total Deaths Vs Population BY CONTINENT

SELECT continent, MAX(Cast(total_deaths as Int)) AS TotalDeaths, MAX((total_deaths)/population)*100 AS DeathPercentage
FROM Portfolio11..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY DeathPercentage Desc

-- BY COUNTRY

SELECT location, MAX(Cast(total_deaths as Int)) AS TotalDeathCount
FROM Portfolio11..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount Desc

-- BREAKING DOWN BY CONTINENT
 -- Highest Death Count


SELECT continent, MAX(Cast(total_deaths as Int)) AS TotalDeathCount
FROM Portfolio11..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount Desc

-- GLOBAL NUMBERS
--Death_Percentage

SELECT SUM(new_cases) AS Total_Cases, SUM(Cast(new_deaths as int)) AS Total_Deaths
,( SUM(Cast(new_deaths as int))/ SUM(new_cases))*100 AS Death_Percentage
FROM Portfolio11..CovidDeaths
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2

-- BY DATE

SELECT date SUM(new_cases) AS Total_Cases, SUM(Cast(new_deaths as int)) AS Total_Deaths 
,( SUM(Cast(new_deaths as int))/ SUM(new_cases))*100 AS Death_Percentage
FROM Portfolio11..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY 1,2

-- Total Popilation vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(new_vaccinations AS int)) OVER (PARTITION BY dea.date ORDER BY dea.location, dea.date) AS VacTotal
FROM Portfolio11..CovidDeaths dea
JOIN Portfolio11..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 1,2,3

DROP TABLE if exists  #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location Nvarchar(255),
Date DateTime,
Population numeric,
new_vaccinations numeric,
VacTotal numeric
)

INSERT INTO  #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(new_vaccinations AS int)) OVER (PARTITION BY dea.date ORDER BY dea.location, dea.date) AS VacTotal
FROM Portfolio11..CovidDeaths dea
JOIN Portfolio11..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 1,2,3

SELECT *,(VacTotal/Population)*100
FROM  #PercentPopulationVaccinated

SELECT location, SUM(CAST(new_vaccinations AS int)) AS VacTotal
FROM Portfolio11..CovidVaccinations
WHERE Continent is not null
GROUP BY location, new_vaccinations
ORDER BY location

--For DataViz

CREATE VIEW TotalDeathCount AS
SELECT continent, MAX(Cast(total_deaths as Int)) AS TotalDeathCount
FROM Portfolio11..CovidDeaths
WHERE continent is not null
GROUP BY continent

CREATE VIEW  VacVSPop AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(new_vaccinations AS int)) OVER (PARTITION BY dea.date ORDER BY dea.location, dea.date) AS VacTotal
FROM Portfolio11..CovidDeaths dea
JOIN Portfolio11..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null