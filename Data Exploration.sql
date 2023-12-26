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
