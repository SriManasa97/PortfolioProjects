--select 
--count(*)
--from CovidDeaths1
--order by 3,4

--Creating indexes 
Create Index continent_ind
on coviddeaths (continent)
--alter table coviddeaths 
--alter column total_cases ;

--looking at total_Cases vs population
--percentage of population who got covid
--select 
--location,
--population,total_cases,
--(total_cases)*100/(population) as perc 
--from CovidDeaths
--order by 1,2

--countries with highest covid cases w.r.t total population
select 
location,sum(population) as total_population,
sum(total_cases) as total_Cases,
sum(total_cases)*100.00/sum(population) as infected_percentage 
from CovidDeaths
group by location
order by 4 desc

--countries with highest infection rate compared to population
select 
location,isnull(population,0) as total_population,
isnull(max(total_cases),0) as total_cases,
cast(Round(max((total_cases)*100.00/(population)),2) as float) as infected_percentage 
from CovidDeaths
group by location,population
order by 4 desc

--showing continent with highest death count per population
select 
continent,
isnull(max(total_deaths),0) as total_cases
from CovidDeaths
where continent is not null
group by continent
order by 2 desc

--global numbers
select 
sum(new_cases),
sum(new_deaths), Round(sum(new_deaths)*100.00/sum(new_cases),2) as deathpercentage
from CovidDeaths
where continent is not null
order by 1,2 desc

--total population vs vaccinations
--Temp table
DROP TABLE IF EXISTS #Percent_Population_Vaccinated

CREATE TABLE #Percent_Population_Vaccinated
(
Continent nvarchar(50),
location nvarchar(50),
date date,
population numeric,
new_vaccinations bigint,
rollingpeople_vaccinated numeric
)
insert into #Percent_Population_Vaccinated
select 
d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(v.new_vaccinations) over (partition by d.location order by d.location,d.date) 
as rollingpeople_vaccinated
from CovidDeaths d
join covidvaccinations v on d.location = v.location and d.date = v.date
where d.continent is not null 


--Create view for visualisation purpose
CREATE VIEW [Percent_Population_Vaccinated] as 
select 
d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(v.new_vaccinations) over (partition by d.location order by d.location,d.date) 
as rollingpeople_vaccinated
from CovidDeaths d
join covidvaccinations v on d.location = v.location and d.date = v.date
where d.continent is not null 

select * from [Percent_Population_Vaccinated]

