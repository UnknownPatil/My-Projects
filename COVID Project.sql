SELECT * 
FROM Covid_Deaths
ORDER BY 3,4

SELECT *
FROM Covid_Vaccinations
ORDER BY 3,4

--Looking for Data I will be working on
SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM Covid_Deaths
Order by 1,2


--Looking for Total Cases VS Total Deaths in My Country 
--Death %

SELECT location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
FROM Covid_Deaths
WHERE location = 'India'
and continent is not null
Order by 1,2


--Looking for Total Cases VS Population
--Population Infected in Percentage
SELECT location, date, total_cases, Population, (total_cases/Population)*100 as 'PopulationInfected%' 
FROM Covid_Deaths
--WHERE location like 'India'
Order by 1,2


--Countries with Highest Infection Rate Compared to Population

SELECT location, Population, Max(total_cases) AS HighestInfectionCount, MAX(total_cases/Population)*100 as 'PopulationInfected%' 
FROM Covid_Deaths
--WHERE location like 'India'
GROUP BY location, Population
Order by 'PopulationInfected%' desc



--Countries with Highest Death Count Per Population

SELECT location, Max(total_deaths) AS TotalDeathCount
FROM Covid_Deaths
--WHERE location like 'India'
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC



--CONTINENT with Highest Death Count Per Population 

SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM Covid_Deaths
--WHERE location like 'India'
WHERE continent is not null
GROUP BY continent
Order by TotalDeathCount desc


--Global Numbers

SELECT SUM(new_cases) as Total_Cases, SUM(new_deaths) as Total_Deaths, SUM(new_deaths)/SUM(new_cases)*100 as 'DeathPercentage'
FROM Covid_Deaths
WHERE continent is not null
--and location = 'India' 
--Group by date


-- Total Population VS Vaccinations

SELECT dt.continent, dt.location, dt.date, dt.population, vc.new_vaccinations, SUM(vc.new_vaccinations) OVER (PARTITION BY dt.location 
order by dt.location, dt.date) as rolling
FROM Covid_Deaths dt
JOIN Covid_Vaccinations vc
     ON dt.location = vc.location
	 and dt.date = vc.date
WHERE dt.continent is not null
order by 2,3


--temp Tables

DROP Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population float,
New_Vaccinations float,
RollingPeopleVaccinated float
)

INSERT INTO #PercentPopulationVaccinated
SELECT dt.continent, dt.location, dt.date, dt.population, vac.[new_vaccinations],
SUM(CONVERT(int,vac.[new_vaccinations])) OVER (PARTITION BY dt.location ORDER BY dt.location, dt.date) as RollingPeopleVaccinated
FROM [PortfolioProject].[dbo].[Covid_Deaths] dt
JOIN [PortfolioProject].[dbo].[Covid_Vaccinations] vac
     ON  dt.location = vac.location
	 and dt.date = vac.date
WHERE dt.continent is not null

SELECT *, (RollingPeopleVaccinated/Population) * 100
FROM #PercentPopulationVaccinated


--Creating View

CREATE VIEW PercentPopulationVaccinated AS
SELECT dt.continent, dt.location, dt.date, dt.population, vac.[new_vaccinations],
SUM(CONVERT(int,vac.[new_vaccinations])) OVER (PARTITION BY dt.location ORDER BY dt.location, dt.date) as RollingPeopleVaccinated
FROM [PortfolioProject].[dbo].[Covid_Deaths] dt
JOIN [PortfolioProject].[dbo].[Covid_Vaccinations] vac
     ON  dt.location = vac.location
	 and dt.date = vac.date
WHERE dt.continent is not null


SELECT *
FROM PercentPopulationVaccinated



