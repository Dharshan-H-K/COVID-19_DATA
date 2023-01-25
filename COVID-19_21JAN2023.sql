SELECT
    *
FROM
    COVID_VAX.VACCINATION_DETAILS.COVID_DEATHS;



--Starting Data

SELECT
    Continent, Location, date, total_cases, new_cases, total_deaths, population
From 
    COVID_DEATHS
Where 
    continent is not null 
order by 1,2




-- Total Cases vs Total Deaths
-- To determine the percentage of dying in "INDIA" if you are infected with Covid

Select 
    Location, date, total_cases,total_deaths, ((total_deaths/total_cases)*100) as Death_Percentage
From 
    COVID_DEATHS
Where 
    location like '%India%'and continent is not null 
order by 1,2;




-- Total Cases vs Population
-- Shows what percentage of population infected with Covid in "INDIA"

Select 
    Location, date, Population, total_cases,  ((total_cases/population)*100) as Percent_Population_Infected
From 
    COVID_DEATHS
Where 
    location like '%India%'
order by 1,2;




-- Countries with Highest Infection Rate compared to Population

Select 
    Location, Population, MAX(total_cases) as Highest_Infection_Count,  Max((total_cases/population))*100 as Percent_Population_Infected
From
    COVID_DEATHS
Group by 
    Location, Population
order by 
    Percent_Population_Infected desc;




-- Countries with Highest Death Count per Population

Select 
    Location, MAX(Total_deaths) as Total_Death_Count
From 
    Covid_Deaths
Where 
    continent is not null 
Group by 
    Location
order by 
    Total_Death_Count desc;





-- Showing contintents with the highest death count per population

Select 
    continent, MAX(Total_deaths) as Total_Death_Count
From  
    Covid_Deaths
Where 
    continent is not null 
Group by 
    continent
order by 
    Total_Death_Count desc;





-- GLOBAL NUMBERS

Select 
    SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, (SUM(new_deaths)/SUM(New_Cases)*100) as Death_Percentage
From 
    Covid_Deaths
where 
    continent is not null 
order by 1,2;

Select 
    *
From 
    Covid_Deaths CD Join Covid_Vaccines CV ON CD.location = CV.location and CD.date = CV.date;
where d.continent is not null 
order by 2,3;






-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select 
    D.continent, D.location, D.date, D.population, V.new_vaccinations, SUM(V.new_vaccinations) OVER (Partition by d.Location Order by d.location, d.Date) as                        Rolling_People_Vaccinated --Comment(Rolling_People_Vaccinated gives the sum of new vaccination + old vaccinations)
From 
    Covid_Deaths D Join Covid_Vaccines V On D.location = V.location and D.date = V.date
where 
    D.continent is not null 
order by 2,3;





-- Using CTE to perform Calculation on Partition By in previous query

With 
    PopVsVax (Continent, Location, Date, Population, New_Vaccinations, Rolling_People_Vaccinated)
as
    (
    Select 
        D.continent, D.location, D.date, D.population, V.new_vaccinations,
        SUM(V.new_vaccinations) OVER (Partition by D.Location Order by D.location, D.Date) as Rolling_People_Vaccinated
    From 
        Covid_Deaths as D Join Covid_Vaccines as V On D.location = V.location and D.date = V.date
    where 
        D.continent is not null 
    )
    
Select 
    *, (Rolling_People_Vaccinated/Population)*100
From 
    PopVsVax;



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
    Continent nvarchar(255),
    Location nvarchar(255),
    Date Date,
    Population number(20,0),
    New_vaccinations number(20,0),
    RollingPeopleVaccinated number(20,0)
);


Insert into PercentPopulationVaccinated
Select 
    CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations,
    SUM(CV.new_vaccinations) OVER (Partition by CD.Location Order by CD.location, CD.Date) as Rolling_People_Vaccinated
From Covid_Deaths CD Join Covid_Vaccines as CV On CD.location = CV.location and CD.date = CV.date;


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinatedViews as
Select 
    CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations,
    SUM(CV.new_vaccinations) OVER (Partition by CD.Location Order by CD.location, CD.Date) as Rolling_People_Vaccinated
From Covid_Deaths CD Join Covid_Vaccines as CV On CD.location = CV.location and CD.date = CV.date
where CD.continent is not null; 