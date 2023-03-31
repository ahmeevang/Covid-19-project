# Covid 19 project
 
### Purpose
The goal of this project was to perform an analysis on Covid-19's worldwide metrics using SQL and Tableau. Using the Covid-19 dataset, I extracted two tables of data pertaining to information on deaths and vaccinations with a multitude of variables.
In order to explore the data, I wrote a variety of SQL queries, including but not limited to aggregate functions and JOINs.

View the complete exploration SQL syntax [here](https://github.com/ahmeevang/Covid-19-project/blob/main/Covid19.sql).

The four main queries used to create the [Tableau dashboard](https://public.tableau.com/app/profile/ahmee5206/viz/CovidDashboard_16787380947350/Dashboard1):
 
 ```sql
 SELECT SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, SUM(CAST(new_deaths as REAL))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent is not null
ORDER BY 1, 2
```

```sql
SELECT location, SUM(new_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE continent is null
and location not in ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC
```

```sql
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX(CAST(total_cases as REAL)/population)*100 AS PercentPopInfected
FROM CovidDeaths
GROUP BY location, population
ORDER BY PercentPopInfected DESC
```

```sql
SELECT location, population, date, MAX(total_cases) AS HighestInfectionCount, MAX(CAST(total_cases AS REAL)/population)*100 AS PercentPopInfected
FROM CovidDeaths
GROUP BY location, population, date
ORDER BY PercentPopInfected DESC
```
