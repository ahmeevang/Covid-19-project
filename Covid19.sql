--Data on Covid Deaths and Covid Vaccinations

SELECT *
FROM CovidDeaths
WHERE continent is not null;


-- The likelihood of dying if you contract Covid in your country

SELECT location, date, total_cases, total_deaths, CAST(total_deaths as REAL)/total_cases*100 AS DeathPercentage
FROM CovidDeaths
WHERE location like '%states%'
ORDER BY 1, 2;


--Total Cases vs Population
--What percentage of the population got Covid

SELECT location, date, population, total_cases, CAST(total_cases as REAL)/population*100 AS PercentPopInfected
FROM CovidDeaths
ORDER BY 1, 2;


--Countries with the highest infection rate compared to population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX(CAST(total_cases as REAL)/population)*100 AS PercentPopInfected
FROM CovidDeaths
GROUP BY location, population
ORDER BY PercentPopInfected DESC;

SELECT location, population, date, MAX(total_cases) AS HighestInfectionCount, MAX(CAST(total_cases AS REAL)/population)*100 AS PercentPopInfected
FROM CovidDeaths
GROUP BY location, population, date
ORDER BY PercentPopInfected DESC;


--Countries with the highest death count per population

SELECT location, SUM(new_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE continent is null
and location not in ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;


--Continents with the highest death count per population

SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC;


--Global numbers
--Death percentage across the world

SELECT SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, SUM(CAST(new_deaths as REAL))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent is not null
ORDER BY 1, 2;


--Death percentage across the world by day

SELECT date, SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, SUM(CAST(new_deaths as REAL))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1, 2;
   

--Total population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2, 3;


--Percentage of population that has received at least one vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as REAL)) OVER (Partition by dea.location ORDER BY dea.location
, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2, 3;


--Creating CTE to perform calculation
--People that have received at least one vaccine

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as REAL)) OVER (Partition by dea.location ORDER BY dea.location
, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac;


--Creating VIEW to store data for visualization later

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as REAL)) OVER (Partition by dea.location ORDER BY dea.location
, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null;

SELECT *
FROM PercentPopulationVaccinated;
