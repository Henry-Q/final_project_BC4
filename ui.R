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
                          h3("Happiness app"),
                          br(),
                          p(strong("Our app is to analyze how happiness score is related 
                            to some factors behind it in all over the world during 2015 and 2016.")),
                          br(),
                          img(src = "happiness.jpeg", height = 120, width = 200),
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
                          h3("Data"),
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
                          p("We read in two static CSV files for our project. 
                            These files contain the happiness data in 2015 and 2016 
                            for 157 countries in the world. Since these datasets are 
                            separately collected by year, we join these two 
                            datasets for our comparison and analysis. We noticed that 
                            the data for 2016 is one country less than the data for 
                            2015, so we consider to plot countries in the specific year. 
                            In addition, data for 2015 has the variable of standard 
                            error while data for 2016 has the variables of lower confidence 
                            and upper confidence interval, so we calculate the confidence 
                            interval for both 2015 and 2016 before we join them into a data frame."),
                          p("We use the tidyverse library which will load ggplot2, dplyr, 
                            tidyr, stringr, gghighlight and other packages to manage and visualize our data. 
                            We use the maps library to plot the happiness scores fitted 
                            in the global map to visualize the difference between countries.
                            We host our app on ShinyApps.io."),
                          br(),
                          br(),
                          br()
                        )
                      )
             ),
             
            # Tab 1 Happiness bar by region
             tabPanel("Happiness by Region",
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
                 tabPanel("Map",
                          sidebarLayout(
                            sidebarPanel(
                              ## help text above the side bar
                              helpText("This will output a world map of happiness score 
                                      and factor index with selected 
                                      year and factor. 
                                      Select which year and which index 
                                      do you want to plot"),
                              ## Let user choose which month to select
                              radioButtons("year2", label = "Select a year",
                                           choices = c(2015,2016),
                                           selected = 2015),
                              ## Let user choose which shape of the UFO to select
                              selectInput("index", label = "Select a factor",
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
                              helpText("This will output a scartter plot of happiness 
                                      score vs factor with selected year, factor and country. 
                                      Select which year which factor and which country do 
                                      you want to plot. You can click the point in the plot 
                                       to find the happiness score and factor index."),
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
                              plotOutput(outputId = "scartterPlot", click = "plot_click"),
                              verbatimTextOutput("info"),
                              br(),
                              textOutput(outputId = "desc"),
                              br(),
                              br()
                            )
                          )
                 ),
             
             # Tab 4 Factors changes between year
             tabPanel("Factors Change",
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
             ),
            
            # Tab 5 Summary 
            tabPanel("Summary",
              sidebarLayout(
                sidebarPanel(
                  h3("Some Analysis"),
                  br(),
                  p("Finally, we expect you can learn these information in the aspect of 
                    region and factors that related to happiness score from our app."),
                  br()
                ),
                mainPanel(
                  h2("Summary about the data"),
                  br(),
                  h4("Insight"),
                  p("From Happiness Score by Region bar chart we see that 
                    in both 2015 and 2016, the rank of average happiness score by 
                    region does not change. Rank from the highest to the lowest: 
                    Australia and New Zealand, North America, Western Europe, 
                    Latin America and Caribbean, Eastern Asia, Middle East and 
                    Northern Africa, Central and Eastern Europe, Southeastern Asia, 
                    Southern Asia, and Sub-Saharan Africa."),
                  p("From the Map and the Scartter Plot we see that factors 
                    Economy, Health, Family have strong correlation with happiness score, 
                    while Freedom has moderate correlation, and Trust and Generosity 
                    have weak correlation. Economy has the highest correlation with 
                    happiness score, which means a country's economy most affect 
                    the happiness of its citizens. "),
                  p("From the change index of factors between two years bar chart we see that 
                    only one factor increase or decrease does not impact the happiness score. 
                    But in general, increase in economy, health and family index will increase 
                    the happiness score and its rank."),
                  br(),
                  h4("Data Quality"),
                  p("In general, the data we used is reasonable and could provide complex 
                    insight regarding to the world happiness score. However, some places 
                    that belong to certain countries are extracted out, which makes the 
                    result in those places unrepresentative. For example, Hongkong and 
                    Taiwan are places belong to China, but the collector extracted out 
                    and calculated their individual happiness score in the dataset. 
                    The economy, health and other standard are not enough to represent 
                    a country, which makes the result in these places biased. This issues 
                    could also cause harm to population living in those region because 
                    split their hometown from their nation is contradicting the patriotism. 
                    Despite this issue, the quality of the data is decent."),
                  br(),
                  h4("Future Ideas and Implication"),
                  p("The results obtained from this project could be used by politicians 
                    to get an insight about the happiness level around the world and 
                    make policy decision based on it. For example, if the happiness 
                    rank in a country dropped drastically compare to previous year 
                    and the economy decreased the most among all the factors, government 
                    should think about some solution to boost the GDP to improve happiness 
                    level. To make this project more helpful and convincing, maybe data 
                    from a longer period, like 20 years, should be analyzed. So that 
                    a more obvious trend of the rise and drop of happiness score 
                    could be obtained. There is no much difference between scores 
                    from 2015 and 2016 data, but if the data is conducted in a longer 
                    period, viewers could better tell the trend of happiness level in 
                    each country."),
                  br(),
                  br(),
                  br()
                )
              )
            )
                 
))

shinyUI(ui) 
