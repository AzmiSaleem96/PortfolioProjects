select *
From[Portfolio Project]..CovidDeaths
where continent is not null
Order by 3,4

select *
From [Portfolio Project]..CovidVaccinations
where continent is not null
Order by 3,4

--Selecting data that we are going to be using
select location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project]..CovidDeaths
where continent is not null
order by 1,2

--Looking at Total cases vs Total Deaths
SELECT 
    location, 
    date, 
    total_cases, 
    total_deaths, 
    CAST(total_deaths AS FLOAT) / NULLIF(CAST(total_cases AS FLOAT), 0) * 100 AS death_rate
FROM [Portfolio Project]..CovidDeaths
where continent is not null
AND location like '%india%'
ORDER BY 1, 2;

--Looking at Total Cases vs Population
--shows what percentage of population got covid
SELECT location, date, total_cases, population, (CAST(total_cases AS FLOAT) /Population) * 100 as PercentPopulationInfected
FROM [Portfolio Project]..CovidDeaths
where location like '%india%'
AND continent is not null
ORDER BY 1, 2;

--Looking at countries with highest Infection Rate compared to population
SELECT 
    location, 
    population, 
    MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount, 
    MAX(CAST(total_cases AS FLOAT) / NULLIF(CAST(population AS FLOAT), 0)) * 100 AS InfectionRate
FROM [Portfolio Project]..CovidDeaths
where continent is not null
GROUP BY location, population
ORDER BY InfectionRate desc;

--Showing Countries with Highest Death Count per population
select location, MAX(CAST(total_deaths as int)) as TotalDeathCount
from[Portfolio Project]..CovidDeaths
where continent is not null
AND location <> 'World' 
Group by location
order by TotalDeathCount desc

--LETS BREAK THINGS DOWN BY CONTINENT
--Showing continents with the highest death count per population 
SELECT 
    continent, 
    MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL  
AND continent <> ''  -- Exclude empty continent names 
GROUP BY continent
ORDER BY TotalDeathCount DESC;

--GLOBAL NUMBERS


SELECT 
    date, 
    SUM(CAST(new_cases AS INT)) AS TotalNewCases,
    SUM(CAST(new_deaths AS INT)) AS TotalNewDeaths, 
    FORMAT(SUM(CAST(new_deaths AS INT)) * 100.0 / NULLIF(SUM(CAST(new_cases AS INT)), 0), 'N2') AS DeathRate
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL  
AND continent <> ''  
GROUP BY date
ORDER BY CAST(date AS DATETIME)
select *
from [Portfolio Project]..CovidVaccinations

SELECT DISTINCT * -- to remove duplicates
FROM [Portfolio Project]..CovidVaccinations;

SELECT DISTINCT * -- saving it as a new table
INTO [Portfolio Project]..CovidVaccinations_noduplicates
FROM [Portfolio Project]..CovidVaccinations;

--looking at Total Population vs Vaccinations
select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int))OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations_noduplicates vac
    on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent <> ''
	order by 2,3

-- USE CTE
WITH popvsvac (continent, location, date, population, New_vaccinations, RollingPeopleVaccinated) AS (
    SELECT 
        dea.continent,
        dea.location,
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
    FROM [Portfolio Project]..CovidDeaths dea
    JOIN [Portfolio Project]..CovidVaccinations_noduplicates vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent <> ''
)
SELECT *, 
       (CAST(RollingPeopleVaccinated AS FLOAT) / NULLIF(CAST(population AS FLOAT), 0)) * 100 AS VaccinationRate
FROM popvsvac;



-- Create Temp Table with Correct Data Types

-- Drop temp table if it already exists
    DROP TABLE if exists #PercentPopulationVaccinated;

-- Create Temp Table
CREATE TABLE #PercentPopulationVaccinated (
    continent NVARCHAR(255),
    location NVARCHAR(255),
    Date DATE,
    Population FLOAT,  -- Changed to FLOAT to allow division
    New_vaccinations FLOAT,  -- Changed to FLOAT
    RollingPeopleVaccinated FLOAT  -- Changed to FLOAT
);

-- Insert Data into Temp Table
INSERT INTO #PercentPopulationVaccinated
SELECT 
    dea.continent,
    dea.location,
    CAST(dea.date AS DATE) AS Date, 
    CAST(dea.population AS FLOAT),  -- Ensure numeric type
    CAST(vac.new_vaccinations AS FLOAT),  -- Ensure numeric type
    SUM(CAST(vac.new_vaccinations AS FLOAT)) 
        OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations_noduplicates vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent <> ''
SELECT 
    continent,
    location,
    FORMAT(Date, 'yyyy-MM-dd') AS FormattedDate,  -- Ensures date format is correct
    Population,
    New_vaccinations,
    RollingPeopleVaccinated,
    (RollingPeopleVaccinated / NULLIF(Population, 0)) * 100 AS VaccinationRate  -- Prevent division by zero
FROM #PercentPopulationVaccinated
ORDER BY location, Date;  -- Ensures chronological order

--creating view to store data for later visualisations

-- Drop the existing view if it exists
DROP VIEW IF EXISTS PercentPopulationsVaccinated;

create view PercentPopulationsVaccinated AS 
SELECT 
        dea.continent,
        dea.location,
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
    FROM [Portfolio Project]..CovidDeaths dea
    JOIN [Portfolio Project]..CovidVaccinations_noduplicates vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent <> ''
	

	SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'PercentPopulationsVaccinated';
	SELECT * FROM PercentPopulationsVaccinated;

















