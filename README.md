Project Overview

In this project, I analyzed COVID-19 data from two main datasets: one containing information on COVID-19 deaths and cases, and another containing vaccination data. The goal was to derive insights into infection rates, death rates, vaccination progress, and overall pandemic trends.

Data Selection

I started by selecting relevant data from the CovidDeaths table, which included columns like location, date, total cases, new cases, total deaths, and population. I filtered out rows where the continent was NULL to focus on specific regions or countries.

Total Cases vs Total Deaths

One of the first analyses I conducted was to compare total cases and total deaths. By calculating the death rate as the percentage of total deaths relative to total cases, I could gauge the severity of the pandemic in different regions. For example, I focused on India to observe how its death rate evolved over time.

Total Cases vs Population

Next, I looked at the total number of cases relative to population size. This helped me understand what percentage of each population had been infected by COVID-19. This analysis provided valuable insights into the widespread impact of the virus on different populations.

Identifying Most Affected Countries

To identify the countries most affected by COVID-19, I examined countries with the highest infection rates. I did this by finding the maximum total cases for each country and then calculating the infection rate, which is the percentage of the population that had contracted the virus. I then sorted the results to highlight the countries with the highest infection rates.

Countries with Highest Death Counts

Similarly, I investigated countries with the highest death counts. By aggregating the total deaths in each country, I was able to identify the worst-hit nations.

Continental Analysis

The analysis was expanded to continents, where I aggregated total deaths by continent and identified the continents most impacted by the pandemic.

Global Numbers

For global trends, I summed new cases and new deaths on a daily basis to observe how the pandemic evolved over time. I also calculated the global death rate, which is the proportion of new deaths compared to new cases.


Vaccination Data Cleaning

I cleaned the CovidVaccinations table by removing duplicate records. I used the SELECT DISTINCT command to ensure there was only one entry per record, and stored this cleaned data in a new table. This was important for maintaining accurate vaccination data.

Merging Death, Case, and Vaccination Data

Next, I merged the cleaned vaccination data with the death and case data by joining the CovidDeaths and CovidVaccinations_noduplicates datasets on location and date. This allowed me to track the cumulative number of vaccinations over time using a rolling sum.

Vaccination Rate Calculation

To make the analysis more efficient, I used a Common Table Expression (CTE) to calculate the rolling sum of vaccinations and the vaccination rate, which is the percentage of the population vaccinated. The formula for the vaccination rate is:

vaccination rate = (RollingPeopleVaccinated / Population) * 100

Using Temporary Tables for Efficiency

In addition to the CTE, I created a temporary table to store the vaccination-related calculations. This allowed me to run multiple queries on the dataset without recalculating the values each time, improving the performance of the analysis.

Creating a View for Future Use
Finally, I created a view called PercentPopulationsVaccinated to store the vaccination progress data. This view can easily be queried in the future and integrated with data visualization tools, such as Power BI or Tableau, to create interactive visualizations of the vaccination progress.

Conclusion
Overall, this project helped me gain deeper insights into the progression of COVID-19, including infection rates, death rates, and vaccination trends. By using SQL techniques like joins, CTEs, temporary tables, and views, I was able to efficiently organize the data and prepare it for future analysis and visualization.
