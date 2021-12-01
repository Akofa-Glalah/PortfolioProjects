Select *
From PortfolioProject..['owid-covid-data$']
Order by 3,4 
Select Location, date, total_cases, new_cases, total_deaths, population 
From PortfolioProject..['owid-covid-data$']
Order by 1,2
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..['owid-covid-data$']
Where date = '2021-11-09'
Order by 5 
--Shows the likelihood of dying if you contract covid in your country 
--Total Cases vs Total Death

Select Location, date, total_cases, population, population_density , (total_cases/population)*100 as TotalCasePercentage
From PortfolioProject..['owid-covid-data$']
Where date = '2021-11-09'
Order by 6
--Total Cases vs Population
--Shows the likelihood of contracting covid in each respective country. 


--Countries with high infection rate compared to population

Select Location,  MAX(total_cases) as LatestPopulationInfectionNumber, population, MAX((total_cases)/population)*100 as TotalCasePercentage
From PortfolioProject..['owid-covid-data$']
Group by Location, population
Order by 4

-- this figure or line of SQL code will produce the same results as Total Cases Vs Population run above


Select Location,  MAX(total_deaths) as LatestDeathNumber, population, MAX((total_deaths)/population)*100 as TotalDeathPercentage
From PortfolioProject..['owid-covid-data$']
Group by Location, population
Order by 4
-- Total Deaths Vs Population

Select Location, MAX(cast(total_deaths as int)) as LatestDeathCount
From PortfolioProject..['owid-covid-data$']
Where continent is not null AND date = '2021-11-09'
Group by Location, total_deaths
Order by LatestDeathCount desc
-- Amount of People lost to Covid 19 since the initial pandemic 



-- Lets Break it up by Continent

Select continent, MAX(cast(total_deaths as int)) as LatestDeathCount
From PortfolioProject..['owid-covid-data$']
Where continent is not null AND date = '2021-11-09'
Group by continent
Order by LatestDeathCount desc

-- Gives less accurate breakdown of data but this is showing the loss of lives grouped by continent


Select location, MAX(cast(total_deaths as int)) as LatestDeathCount
From PortfolioProject..['owid-covid-data$']
Where continent is null AND date = '2021-11-09'
Group by location
Order by LatestDeathCount desc

--this is the accurate representation of the breakdown of lives lost by continents


Select location, MAX(cast(total_deaths as int)) as LatestDeathCount, (MAX(cast(total_deaths as int))/total_cases)* 100 as DeathPercentage
From PortfolioProject..['owid-covid-data$']
Where continent is null AND date = '2021-11-09'
Group by location, total_cases
Order by LatestDeathCount desc




Select location, MAX(cast(total_cases as int))as LatestCaseCount , population, (MAX(cast(total_cases as int))/population)* 100 as TotalCasePercentage
From PortfolioProject..['owid-covid-data$']
Where continent is null AND date = '2021-11-09'
Group by location, population
Order by LatestCaseCount desc


--Global Breakdown

Select date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage 
From PortfolioProject..['owid-covid-data$']
Where continent is not null
Group By date
Order by 1,2 

-- Global Daily Death Percentage


Select SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage 
From PortfolioProject..['owid-covid-data$']
Where continent is not null
Order by 1,2 

-- Global Death Rate 




Select *
From PortfolioProject..['owid-covid-data$'] covid
Join PortfolioProject..['covid-vaccination-global-projec$'] vac
    On covid.location = vac.Entity
Where covid.date = '2021-11-09'
Order by covid.continent DESC, covid.total_cases DESC 

--Shows individual countries covid cases and vaccination target
	

Select *
From PortfolioProject..['owid-covid-data$'] covid
Join PortfolioProject..['covid-vaccination-global-projec$'] vac
    On covid.location = vac.Entity
Where covid.date = '2021-11-09' AND continent is null
Order by covid.continent DESC, covid.total_cases DESC

-- Breakdown of Vacconation targets within various continents and income levels

Create Table [TheVaccinationTargets]
(
"covid.location" varchar(250),
"covid.continent" varchar(250),
"covid.total_cases" int,
"covid.tottal_deaths" int,
"vac.status" varchar(250)
)
Select *
From PortfolioProject..['owid-covid-data$'] covid
Join PortfolioProject..['covid-vaccination-global-projec$'] vac
    On covid.location = vac.Entity
Order by covid.continent DESC, covid.total_cases DESC 

--Table showing effectiveness of vaccine rollout within respective countries 

Create Table [TheVaccinationTargetsRollingFigures5]
(
"covid.location" varchar(250),
"covid.continent" varchar(250),
"covid.total_cases" int,
"covid.total_deaths" int,
"vac.status" varchar(250)
)
Select covid.continent, covid.location, covid.date, covid.population, vac.status
, SUM(covid.total_cases) OVER (Partition by covid.location
Order by covid.location,covid.date) as Rollingtotalcases
, (covid.total_cases/population)*100 as PercentageofCases
From PortfolioProject..['owid-covid-data$'] covid
Join PortfolioProject..['covid-vaccination-global-projec$'] vac
    On covid.location = vac.entity 
Where covid.date = '2021-11-09' AND continent is null
Order by covid.continent DESC, covid.total_cases DESC 

--Creation of rolling figures vaccine rollout table per continent  plus percentage of total cases within population 

Create Table [TheVaccinationTargetsRollingFigures4]
(
"covid.location" varchar(250),
"covid.continent" varchar(250),
"covid.total_cases" int,
"covid.tottal_deaths" int,
"vac.status" varchar(250)
)
Select covid.continent, covid.location, covid.date, covid.population, vac.status
, SUM(covid.total_cases) OVER (Partition by covid.location
Order by covid.location,covid.date) as Rollingtotalcases
, (covid.total_cases/population)*100 as PercentageofCases
From PortfolioProject..['owid-covid-data$'] covid
Join PortfolioProject..['covid-vaccination-global-projec$'] vac
    On covid.location = vac.entity 
Where covid.date = '2021-11-09' AND continent is not null

-- Individual country breakdown of previous table 
Order by covid.continent DESC, covid.total_cases DESC 










	

