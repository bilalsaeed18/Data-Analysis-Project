-- select data using location and date wise

select location, date, total_cases, new_cases, total_deaths from CovidDeaths
order by 1, 2

-- Total Cases Vs Total Deaths

select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths where location like '%States%'
order by 1, 2


-- Total Cases vs Population

select location, date, population, total_cases,(total_cases/population)*100 as CasesPercentage
from CovidDeaths 
order by 1, 2

-- Countries with highest Covid Rate to population

select location, population, Max(total_cases) as highestCovidRate, Max((total_cases/population))*100 as CasesPercentage
from CovidDeaths 
group by location, population
order by CasesPercentage desc


-- Countries with highest Death Rate to population

select location, MAX(cast(total_deaths as int)) AS TotalDeaths
from CovidDeaths 
where continent is not null
group by location
order by TotalDeaths desc



-- Continent with highest Death Rate to population

select location, MAX(cast(total_deaths as int)) AS TotalDeaths
from CovidDeaths 
where continent is  null
group by location
order by TotalDeaths desc

-- Global Numbers

select date, SUM(new_cases) as TotalNewCases
from CovidDeaths 
where continent is not null
group by date
order by TotalNewCases desc


select date, SUM(new_cases) as TotalNewCases, SUM(cast(new_deaths as int)) AS TotalNewDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from CovidDeaths 
where continent is not null
group by date
order by 1, 2

-- without date let's see the total numbers

select SUM(new_cases) as TotalNewCases, SUM(cast(new_deaths as int)) AS TotalNewDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from CovidDeaths 
where continent is not null
--group by date
order by 1, 2


----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Joining both tables

select * from CovidDeaths cd
join CovidVaccinations cv
on cd.location = cv.location
and cd.date = cv.date


-- Total Populations Vs Vaccinations
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
SUM(CONVERT (int,cv.new_vaccinations)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as RollingPeopleVaccinated
from CovidDeaths cd
join CovidVaccinations cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null
order by 2,3


-- by using CTE

With PopulationVsVaccinated (continent, location, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select cd.continent, cd.location, cd.population, cv.new_vaccinations, 
SUM(CONVERT (int,cv.new_vaccinations)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as RollingPeopleVaccinated
from CovidDeaths cd
join CovidVaccinations cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null
)
select *, (RollingPeopleVaccinated/population)*100 as RollingPeopleVaccinatedPercentage  from PopulationVsVaccinated



-- Create view for data visualization

CREATE VIEW PercentagePopulationVaccinated as
select cd.continent, cd.location, cd.population, cv.new_vaccinations, 
SUM(CONVERT (int,cv.new_vaccinations)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as RollingPeopleVaccinated
from CovidDeaths cd
join CovidVaccinations cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null