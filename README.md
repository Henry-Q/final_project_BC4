# **World Happiness Comparison and Analysis Between 2015 and 2016**

---

## App 

To use our app, clike [here](https://henryq.shinyapps.io/final_project_bc4/). 

## Data and Audience 

  The dataset we will be working with is The World Happiness Report conducted since 2012 and still updated nowadays, but we will choose data conducted in 2015 and 2016 to analyze specifically. The reports review the state of happiness in the world today and show how the new science of happiness explains personal and national variations in happiness. The data was collected by the US government from the Gallup World Poll. The scores are based on answers to the main life evaluation question asked in the poll. The columns following the happiness score estimate the extent to which each of six factors – economic production, social support, life expectancy, freedom, absence of corruption, and generosity – contribute to making life evaluations higher in each country than they are in Dystopia, a hypothetical country that has values equal to the world’s lowest national averages for each of the six factors. We accessed this dataset from the [DATA.GOV.IE](https://data.gov.ie/dataset/suggest/a4329b2f-c692-45a4-91a9-90e7060c4d67) by searching keyword “world happiness report” on the Internet. 

Varables in the datasets:
- **Country:** Country name
- **Region**: The region in the global certain country belongs to
- **Happiness score:** based on responses collected in the poll, the score is measured in a 0-10 scale
- **Happiness rank:** Ranked using happiness score
- **Economy (GDP per Capita):** Measured in scores higher than score of Dystopia, which is 0
- **Family:** Stand for social support, measured in same way above
- **Health (Life Expectancy):** Measured in same way above
- **Freedom:** Measured in same way above
- **Trust:** absence of government corruption, measured in same way above
- **Generosity:** Measured in same way above
- **Dystopia Residual:** Residuals, or unexplained components, differ for each country, reflecting the extent to which the six variables either over- or under-explain average 2014-2016 life evaluations. These residuals have an average value of approximately zero over the whole set of countries

The target audience is the politicians. They will use the world happiness report to inform their policy-making decisions. Leading the politicians describe how measurements of well-being can be used effectively to assess the progress of nations.

We want our audience to learn:
- The annual growth rate of the happiness scores between the year 2015 and 2016. 
- Average happiness scores based on the regions (We will classify the regions into western Europe, Eastern Asia etc.). 
- What factors affect the happiness scores the most. 


## Technical Description 

  We will read in two static CSV files for our project. These files contain the happiness data in 2015 and 2016 for 157 countries in the world. Since these datasets are separately collected by year, we need to join these two datasets for our comparison and analysis. We noticed that the data for 2016 is one country less than the data for 2015, so we will have the data of that country only for 2015. In addition, data for 2015 has the variable of standard error while data for 2016 has the variables of lower confidence and upper confidence interval, so we will calculate the confidence interval for both 2015 and 2016 before we join them into a data frame. 
  
  We will use the tidyverse library which will load ggplot2, dplyr, tidyr, stringr and other packages to manage and visualize our data. Also, we need the maps library to plot the happiness scores fitted in the global map to visualize the difference between countries. 
  
  We will answer the following questions via the datasets: Which region has the highest average happiness scores for each year? Is there any correlation between happiness scores and other factors (like economy, health, family, freedom, etc.)? 
  
  We anticipate that our main challenge will be making clear and motivated charts and plots to show the relationship between happiness scores and other factors as well as  compare the happiness score of each country for different years. 

