library(shiny)
library(tidyverse)
library(stringr)
library(gghighlight)
library(maps)

# data
hp <- read.csv('data/joined_data.csv') 

ui <- fluidPage(
  titlePanel("World Happiness Between 2015 and 2016"), 
  navbarPage("",
            # Tab 0 Intro
             tabPanel("Intro",
                      sidebarLayout(
                        sidebarPanel(
                          h2("Happiness app"),
                          br(),
                          p(strong("Our app is to analyze how happiness score is related 
                            to some factors behind it in all over the world during 2015 and 2016.")),
                          br(),
                          br(),
                          h5("Developed by:"),
                          p("Yubo Ding"),
                          p("Xiaofu Li"),
                          p("Zehua Qiu"),
                          p("Yining Wang")
                          
                        ),
                        mainPanel(
                          h2("Intoduction of our app"),
                          br(),
                          h5(strong("We want our audience to learn:")),
                          p("- Average happiness scores based on the regions (We will classify the regions into western Europe, Eastern Asia etc.)."),
                          p("- Visualization happiness scores and factors (economy, family, health etc.) in a world map."),
                          p("- Are there any factors related to happiness score for a country?"),
                          p("- How factors change affect a country happiness score change between 2015 and 2016?"),
                          br(),
                          h3("Data and Audience"),
                          p("The dataset we will be working with is The World 
                            Happiness Report conducted since 2012 and still updated 
                            nowadays, but we will choose data conducted in 2015 
                            and 2016 to analyze specifically. The reports review 
                            the state of happiness in the world today and show 
                            how the new science of happiness explains personal 
                            and national variations in happiness. The data was 
                            collected by the US government from the Gallup World 
                            Poll. The scores are based on answers to the main life 
                            evaluation question asked in the poll. The columns 
                            following the happiness score estimate the extent to 
                            which each of six factors – economic production, 
                            social support, life expectancy, freedom, absence of 
                            corruption, and generosity – contribute to making life 
                            evaluations higher in each country than they are in 
                            Dystopia, a hypothetical country that has values equal 
                            to the world’s lowest national averages for each of 
                            the six factors. We accessed this dataset from the ",
                            a("DATA.GOV.IE ", 
                              href = "https://data.gov.ie/dataset/suggest/a4329b2f-c692-45a4-91a9-90e7060c4d67"),
                             "by searching keyword “world happiness report” 
                            on the Internet."),
                          p("The target audience is the politicians. They will use 
                            the world happiness report to inform their policy-making 
                            decisions. Leading the politicians describe how measurements 
                            of well-being can be used effectively to assess the progress of nations."),
                          br(),
                          h3("Varables in the datasets: "),
                          p(strong("- Country"),": Country name"),
                          p(strong("- Region"), ": The region in the global certain country belongs to"),
                          p(strong("- Happiness score"), ": based on responses collected in the poll, the score is measured in a 0-10 scale"),
                          p(strong("- Happiness rank"), ": Ranked using happiness score"),
                          p(strong("- Economy (GDP per Capita)"), ": Measured in scores higher than score of Dystopia, which is 0"),
                          p(strong("- Family"), ": Stand for social support, measured in same way above"),
                          p(strong("- Health (Life Expectancy)"), ": Measured in same way above"),
                          p(strong("- Freedom"), ": Measured in same way above"),
                          p(strong("- Trust"), ": absence of government corruption, measured in same way above"),
                          p(strong("- Generosity"), ": Measured in same way above"),
                          p(strong("- Dystopia Residual"), ": Residuals, or unexplained components, differ for 
                            each country, reflecting the extent to which the six variables either over- or 
                            under-explain average 2014-2016 life evaluations. These residuals have an average 
                            value of approximately zero over the whole set of countries"),
                          br(),
                          h3("Technical Description"),
                          p("We will read in two static CSV files for our project. 
                            These files contain the happiness data in 2015 and 2016 
                            for 157 countries in the world. Since these datasets are 
                            separately collected by year, we need to join these two 
                            datasets for our comparison and analysis. We noticed that 
                            the data for 2016 is one country less than the data for 
                            2015, so we will have the data of that country only for 
                            2015. In addition, data for 2015 has the variable of standard 
                            error while data for 2016 has the variables of lower confidence 
                            and upper confidence interval, so we will calculate the confidence 
                            interval for both 2015 and 2016 before we join them into a data frame."),
                          p("We will use the tidyverse library which will load ggplot2, dplyr, 
                            tidyr, stringr and other packages to manage and visualize our data. 
                            Also, we need the maps library to plot the happiness scores fitted 
                            in the global map to visualize the difference between countries."),
                          p("We will answer the following questions via the datasets: 
                            Which region has the highest average happiness scores for each year? 
                            Is there any correlation between happiness scores and other factors 
                            (like economy, health, family, freedom, etc.)?"),
                          p("We anticipate that our main challenge will be making clear and 
                            motivated charts and plots to show the relationship between happiness 
                            scores and other factors as well as compare the happiness score of 
                            each country for different years."),
                          br(),
                          br(),
                          br()
                        )
                      )
             ),
             
            # Tab 1 Happiness bar by region
             tabPanel("Happiness Score by Region",
                      sidebarLayout(
                        sidebarPanel(
                          ## help text above the side bar
                          helpText("This will output bar chart to show average 
                                    happiness score by region. 
                                    Select which year and which color 
                                    do you want to plot"),
                          ## Let user choose which month to select
                          radioButtons("year3", "Select the year",
                                       choices = c("2015", "2016"),
                                       selected = "2015"),
                          radioButtons("color", label = "Bar color", 
                                       choices = list("Blue" = "skyblue", "Red" = "indianred1", 
                                                      "Yellow" = "Khaki1"),
                                       selected = "skyblue")
                        ),
                        mainPanel(
                          plotOutput("distplot2"),
                          br(),
                          textOutput("descrip"),
                          br(),
                          br()
                        )
                      )
             ),
             
             
                 # Tab 2 Map
                 tabPanel("Happiness Score World Map",
                          sidebarLayout(
                            sidebarPanel(
                              ## help text above the side bar
                              helpText("This will output a world map with selected 
                                      year and index. Select which year and which index 
                                      do you want to plot"),
                              ## Let user choose which month to select
                              radioButtons("year2", label = "Select a year",
                                           choices = c(2015,2016),
                                           selected = 2015),
                              ## Let user choose which shape of the UFO to select
                              selectInput("index", label = "Select a index",
                                          choices = list("Health" = "Health",
                                                         "Freedom" = "Freedom",
                                                         "Family" = "Family",
                                                         "Trust" = "Trust",
                                                         "Generosity" = "Generosity"),
                                          selected = "Health")
                            ),
                            mainPanel(
                              plotOutput("hpMap"),
                              plotOutput("mapPlot"),
                              textOutput("message"),
                              br(),
                              br()
                            )
                          )
                 ),
                 
                 # Tab 3 Scartter Plot
                 tabPanel("Factors Scartter Plot",
                          sidebarLayout(
                            sidebarPanel(
                              helpText("This will output a scartter plot with 
                              selected year, factor and country. 
                              Select which year which 
                              factor and which country do you want to plot"),
                              # Select a year
                              radioButtons(inputId = "year", label = strong("Year"),
                                           choices = c(2015, 2016), selected = 2015), 
                              # Select a factor 
                              selectizeInput(inputId = "factor", label = strong("Choose a factor"),
                                             choices = c("Economy", "Health", "Freedom", "Family", "Trust", "Generosity"),
                                             selected = "Economy"),
                              
                              # Select a country
                              uiOutput("country")
                            ),
                            mainPanel(
                              plotOutput(outputId = "scartterPlot"),
                              br(),
                              textOutput(outputId = "desc"),
                              br(),
                              br()
                            )
                          )
                 ),
             
             # Tab 4 Factors changes between year
             tabPanel("Factors bar chart",
                      sidebarLayout(
                        sidebarPanel(
                          helpText("This will output a bar chart and a table of factors 
                                  and happiness change between year 2015 and 2016. 
                                  Select which year which country do you want to plot"),
                          # Select a year
                          selectInput("country2", label = "Country", choices = unique(hp$Country),
                                      selected = "United States")
                        ),
                        mainPanel(
                          plotOutput("distPlot"),
                          tableOutput("table"), 
                          br(),
                          textOutput("describe"),
                          br(),
                          br()
                        )
                      )
             )
                 
                 
))

shinyUI(ui) 
