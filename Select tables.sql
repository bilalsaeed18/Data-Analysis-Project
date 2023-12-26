/*select all data from the tables */

select * from CovidDeaths
select * from CovidVaccinations

-- select data using location and date wise
select location, date, total_cases, new_cases, total_deaths from CovidDeaths
order by 1, 2

