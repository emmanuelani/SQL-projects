-- SELECT *
-- FROM ..CovidDeaths;

-- SELECT *  
-- FROM .."Covid vaccination"
-- ORDER BY 3, 4;

-- Select the data that we'll be using
-- Select location, date, total_cases, new_cases, total_deaths, population
-- from ..CovidDeaths

-- Looking at the total cases vs the total deaths
select MAX(death_percent) as max_death_percent,
       MIN(death_percent) as min_death_percent
from (Select location, date, total_cases, total_deaths, 
        round(cast(total_deaths as float)/cast(total_cases as float), 3) as death_percent
        from ..CovidDeaths
        where location = 'Africa') as t

         
-- sub as (select death_percent
-- from Select location, date, total_cases, total_deaths, 
--         round(cast(total_deaths as float)/cast(total_cases as float), 3) as death_percent
--         from ..CovidDeaths
--         where location = 'Africa')

-- this shows the chances of dying if you contract covid in your country
select location, date, total_cases, total_deaths, 
round(cast(total_deaths as float)/cast(total_cases as float) * 100, 5) as death_percent
from ..CovidDeaths
where location like '%states%';

-- select *
-- from ..CovidDeaths

-- looking at the total cases vs the population
select location, date, population, total_deaths, 
round(cast(total_deaths as float)/cast(population as float) * 100, 5) as death_percent
from ..CovidDeaths
where location like '%states%';

select distinct(location), population, 
       round(cast(total_deaths as float)/cast(population as float) * 100, 5) as death_percent
from ..CovidDeaths
where 1 is not NULL;

-- getting the country with the highest infection rate
select location, population, max(total_cases) as no_of_cases,
       max(round(cast(total_cases as float)/cast(population as float) * 100, 5)) as cases_percent
from ..CovidDeaths
-- where 1 is not NULL
group by location, population
order by cases_percent desc 

-- getting the country with the highest death rate
select location, population, max(total_deaths) as no_of_deaths,
       max(round(cast(total_deaths as float)/cast(population as float) * 100, 5)) as death_percent
from ..CovidDeaths
where continent is not NULL
group by location, population
order by no_of_deaths desc;

-- getting the continent with the highest death rate
select sum(no_of_deaths)
from (select continent, max(total_deaths) as no_of_deaths
        from ..CovidDeaths
        where continent is not NULL
        group by continent) as t

-- looking at the vaccination table
select * 
from ..CovidDeaths deaths
join ..[Covid vaccination] vacc
   on deaths.location = vacc.location 
   and deaths.date = vacc.date 
go

-- getting the number of people vaccinated
select deaths.continent, deaths.location, deaths.date, deaths.population,
       vacc.new_vaccinations, 
	   sum(cast(vacc.new_vaccinations as float)) over (partition by deaths.location) as people_vaccinated
from ..CovidDeaths deaths
join ..[Covid vaccination] vacc
   on deaths.location = vacc.location 
   and deaths.date = vacc.date 
where deaths.continent is not null;

