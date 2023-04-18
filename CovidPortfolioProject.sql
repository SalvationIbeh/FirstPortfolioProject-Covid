/* Script 1: Select Covid-19 deaths data by continent, order by columns 3 and 4 */
Select *
From CovidPortfolioProject..covid_deaths$
where continent is not Null
order by 3,4

/* Script 2: Select Covid-19 vaccinations data, order by columns 3 and 4 */
Select *
From CovidPortfolioProject..covid_vaccinations$
order by 3,4

/* Script 3: Select Covid-19 deaths data by location and date, order by columns 1 and 2 */
Select location, date, total_cases,new_cases,total_deaths, population
From CovidPortfolioProject..covid_deaths$
where continent is not Null
Order by 1,2

/* Script 4: Select Covid-19 deaths data for Nigeria, calculate death percentage, order by columns 1 and 2 */
Select location, date, total_cases, total_deaths, (convert(Float, total_deaths)/convert(Float, total_cases))*100 as DeathPercentage
From CovidPortfolioProject..covid_deaths$
Where location = 'Nigeria' and continent is not Null
Order by 1,2

/* Script 5: Select Covid-19 deaths data for Nigeria, calculate percentage of population infected, order by columns 1 and 2 */
Select location, date, population, total_cases, (convert(Float, total_cases)/population)*100 as PercentPopulationInfected
From CovidPortfolioProject..covid_deaths$
Where location = 'Nigeria' and continent is not Null
Order by 1,2

/* Script 6: Select Covid-19 deaths data by location, population, highest infection count, and percentage population infected, order by percentage population infected in descending order */
Select location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/Population))*100 as PercentPopulationInfected
From CovidPortfolioProject..covid_deaths$
where continent is not Null
--Where location = 'Nigeria'
Group by location,population
Order by 4 desc

/* Script 7: Select Covid-19 deaths data by continent, calculate total death count, order by total death count in descending order */
Select continent, Max(convert(Float, total_deaths)) as TotalDeathCount
From CovidPortfolioProject..covid_deaths$
where continent is not Null
--Where location = 'Nigeria'
Group by continent
Order by 2 desc

/* Script 8: Calculate Covid-19 deaths data by date, order by columns 1 and 2 */
Select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/NULLIF(SUM(new_cases), 0)*100 as DeathPrecentage
From CovidPortfolioProject..covid_deaths$
where continent is not Null
--Where location = 'Nigeria'
--Group by date
Order by 1,2

/* Script 9: Select Covid-19 deaths and vaccinations data by location and date, calculate rolling people vaccinated, order by columns 2 and 3 */
Select cdea.continent, cdea.location, cdea.date, cdea.population, cvac.new_vaccinations,
sum(convert (float , cvac.new_vaccinations)) over (partition by cdea.location order by cdea.location, cdea.date)
as RollingPeopleVaccinated
From CovidPortfolioProject..covid_deaths$ cdea
Join CovidPortfolioProject..covid_vaccinations$ cvac
on cdea.location = cvac.location
and cdea.date = cvac.date
Where cdea.continent is not null
Order by 2,3