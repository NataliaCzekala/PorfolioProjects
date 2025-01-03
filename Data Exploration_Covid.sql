SELECT *
FROM PortfolioProject..CovidDeaths
where continent is not null
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

-- Selecting Data that I am going to be using

Select Location,date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
ORDER BY 1,2

-- Total Cases vs Total Deaths
Select Location,date, total_cases, total_deaths,(Total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%poland%'
ORDER BY 1,2
--what percentage of populations got Covid

Select Location,date, population,total_cases,(Total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%poland%'
where continent is not null
ORDER BY 1,2

-- looking at countries with the highest infection rate compared to populatiom

Select location, population,Max(total_cases) as HighestInfectionCount,Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
where continent is not null
group by location,population
ORDER BY PercentPopulationInfected desc
--Poland on the 27th place in the ranking 

-- showing countries with the highest death count per population(1.USA 2.Brazil 3.Mexico and 13.Poland)
Select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
ORDER BY TotalDeathCount desc


-- selecting by continent
Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
ORDER BY TotalDeathCount desc

--prepering data fot the tableau visualisation
--showing continents with the highest death count per percentage 

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
ORDER BY TotalDeathCount desc

-- global numbers
Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_death,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
--group by date
ORDER BY 1,2
-- across the world over 2% of whole population died because of Covid, which is 3 180 206

--looking at total population vs vaccinations
select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by  dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
order by 2,3

--using CTE
with PopvsVac ( Continent, Location, date, population,New_Vaccinations, RollingPeopleVaccinated)
as
(select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by  dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

--TEMP TABLE
 
 create table #PercentPopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric)

 insert into #PercentPopulationVaccinated
 select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by  dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3
select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

--Creating View to store data for later visualizations
Create View PercentPopulationVaccinated1 as
select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over (partition by  dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null;
--order by 2,3

SELECT * 
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME = 'PercentPopulationVaccinated1';

select *
from PercentPopulationVaccinated1
