
Use NewProj2

Delete 
from
NewProJ1..CovidDeaths
where
 location = 'North Korea'

 select * 
from
NewProJ2..CovidDeaths
order by 3,4

-- Global Number

select max(total_cases) as Casecount, max(Total_deathsConverted) as DeathsCount, (max(Total_deathsConverted)/max(total_cases))*100 As DeathsvsCasesPercent
from
NewProj2..CovidDeaths


-- Cases and Deaths by location, top 10 deaths

select top 10  location, max( total_cases) as Total_cases1, max(Total_deathsConverted) as Total_deaths1
from
NewProj2..CovidDeaths
where continent is not null
group by location
order by Total_deaths1 desc


-- Cases and Deaths by Continent

select  location, max( total_cases) as Total_cases1, max(Total_deathsConverted) as Total_deaths1
from
NewProj2..CovidDeaths
where continent is null
and location not like '%income'
group by location
order by Total_deaths1 desc



-- Total Population VS Vaccinations

with PopvsVac as
(
select dea.continent , dea.location, dea.date, dea.population, convert(bigint,vac.new_vaccinations) as New_vaccinations1,
sum(cast( vac.new_vaccinations as bigint)) over (Partition by dea.location order by dea.location,convert(date,dea.date)) as Total_vaccinations1
from NewProj2..CovidDeaths dea
join NewProj2..CovidVaccinations vac
on  dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by dea.location, dea.date
)
select *, (Total_vaccinations1/population)*100 as VacVsPopPercent
from PopvsVac


--Temp Table

Drop table if exists PopVacPercent
Create table PopVacPercent
(
Continent nvarchar(255),
Location nvarchar(255),
Date Date,
Population numeric,
New_Vacined numeric,
Total_vaccinations1 numeric
)

insert into PopVacPercent
select dea.continent , dea.location, dea.date, dea.population, convert(bigint,vac.new_vaccinations) as New_vaccinations1,
sum(cast( vac.new_vaccinations as bigint)) over (Partition by dea.location order by dea.location,convert(date,dea.date)) as Total_vaccinations1
from NewProj2..CovidDeaths dea
join NewProj2..CovidVaccinations vac
on  dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null

select *, (Total_vaccinations1/population)*100 as VacVsPopPercent
from PopVacPercent


-- Creating View to Store Data
Drop view if exists PopVacPercentage1
Create View PopVacPercentage1 as 
select dea.continent , dea.location, dea.date, dea.population, convert(bigint,vac.new_vaccinations) as New_vaccinations1,
sum(cast( vac.new_vaccinations as bigint)) over (Partition by dea.location order by dea.location,convert(date,dea.date)) as Total_vaccinations1
from NewProj2..CovidDeaths dea
join NewProj2..CovidVaccinations vac
on  dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null

select * from PopVacPercentage1

