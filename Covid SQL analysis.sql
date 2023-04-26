/*select*
from coviddeaths
order by 3,4

/*
Select*
from covidvaccination
orderby 3,4 
*/

select location, date, population, total_cases,new_cases,total_deaths
from coviddeaths
order by 1,2

/* Looking at total_cases VS total_deaths*/
/*shows the likelihood of death if infected*/
select location, date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where Location like 'United States'
order by 1,2

/* Looking for Total_cases vs population
showing what percentage of population got covid*/
select location, date, total_cases, population, (total_cases/population)*100 as PeopleInfected
from coviddeaths
where Location like 'United States'
order by 1,2,5

/* Checking the which contry is highly infected compared to their population*/
select location, population, MAX(total_cases) as HighestInfectionCount,
MAX((total_cases/population))*100 as PercentPopulationInfected
from coviddeaths
group by population, location
order by PercentPopulationInfected desc;

/* Showing countries with higest deathcount per porpulation*/
select location, max(total_deaths) as TotalDeathCount
from coviddeaths
where continent is not null
group by location
order by TotalDeathCount desc;

-- let's break things by continent
select continent, max(total_deaths) as TotalDeathCount
from coviddeaths
where continent is not null
group by continent
order by TotalDeathCount desc;

-- GLOBAL BREAKDOWN
-- checking the deaths over infected people around the world grouping by date
select date, SUM(new_cases) as totalCases, SUM(new_deaths) as TotalDeaths, 
(SUM(new_deaths)/sum(new_cases))*100 as DeathPercentage
from coviddeaths
where continent is not null
group by date
order by 1

-- checking the total deaths over total infected people GLOBALLY
select date, SUM(new_cases) as totalCases, SUM(new_deaths) as TotalDeaths, 
(SUM(new_deaths)/sum(new_cases))*100 as DeathPercentage
from coviddeaths
where continent is not null
order by 1

-- JOINING TWO TABLES VACCINATION AND DEATH
-- Checking how many people in the world got vaccinated i.e. total population vs vaccination
WITH PopvsVac (continent, location, date, population, new_vaccinations, rollingCountOfVaccinatedPeople)
as 
(
SELECT coviddeaths.continent, coviddeaths.location, 
coviddeaths.date, coviddeaths.population,covidvaccination.new_vaccinations, SUM(covidvaccination.new_vaccinations)
OVER (Partition by coviddeaths.location order by coviddeaths.location) as rollingCountOfVaccinatedPeople
from coviddeaths join covidvaccination
on coviddeaths.location = covidvaccination.location
and coviddeaths.date = covidvaccination.date
)

Select*, (rollingCountOfVaccinatedPeople/population)*100
from PopvsVac

--- TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent text(255),
Location text(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
rollingCountOfVaccinatedPeople numeric
)

INSERT INTO # percentpopulationvaccinated
SELECT coviddeaths.continent, coviddeaths.location, 
coviddeaths.date, coviddeaths.population,covidvaccination.new_vaccinations, SUM(covidvaccination.new_vaccinations)
OVER (Partition by coviddeaths.location order by coviddeaths.location) as rollingCountOfVaccinatedPeople
from coviddeaths join covidvaccination
on coviddeaths.location = covidvaccination.location
and coviddeaths.date = covidvaccination.date

Select *, (rollingCountOfVaccinatedPeople/Population)*100
From #PercentPopulationVaccinated

-- Creating the view
Create View PercentPopulationVaccinated as

SELECT coviddeaths.continent, coviddeaths.location, 
coviddeaths.date, coviddeaths.population,covidvaccination.new_vaccinations, SUM(covidvaccination.new_vaccinations)
OVER (Partition by coviddeaths.location order by coviddeaths.location) as rollingCountOfVaccinatedPeople
from coviddeaths join covidvaccination
on coviddeaths.location = covidvaccination.location
and coviddeaths.date = covidvaccination.date










