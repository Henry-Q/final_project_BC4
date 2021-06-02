library(shiny)
library(tidyverse)
library(stringr)
library(gghighlight)
library(maps)


server <- function(input, output, session) {
  # Clean data
  hp <- read.csv('data/joined_data.csv') 
  hp <- hp %>% select(-X) 
  hp <- hp %>% rename(Economy = Economy..GDP.per.Capita., 
                      Health = Health..Life.Expectancy.,
                      Freedom = Freedom, 
                      Family = Family,
                      Trust = Trust..Government.Corruption.,
                      Generosity = Generosity)
  
  # Map Section
  ## Map data and happiness data
  dt <- hp %>% rename(region = Country,
                      Happiness = Happiness.Score)
  world <- map_data("world") 
  ## Change some subregion to region
  world$region[world$subregion == "Hong Kong"] <- "Hong Kong (China)"
  world$region[world$region == "Taiwan"] <- "Taiwan (China)"
  world$region[world$subregion == "Northern Cyprus"] <- "Northern Cyprus"
  world$region[world$subregion == "Somaliland"] <- "Somaliland"
  ## Check for disagreements between the two datasets
  diff <- setdiff(dt$region,world$region)
  ## Change the hp's region name
  dt$region[dt$region == "Congo (Brazzaville)"] <- 
    "Republic of Congo"
  dt$region[dt$region == "Congo (Kinshasa)"] <-
    "Democratic Republic of the Congo"
  dt$region[dt$region == "Hong Kong"] <- 
    "Hong Kong (China)"
  dt$region[dt$region == "Taiwan"] <-  
    "Taiwan (China)"
  dt$region[dt$region == "Palestinian Territories"] <- 
    "Palestine"
  dt$region[dt$region == "North Cyprus"] <- 
    "Northern Cyprus"
  dt$region[dt$region == "Somaliland Region"] <- 
    "Somaliland"
  dt$region[dt$region == "Somaliland region"] <- 
    "Somaliland"
  dt$region[dt$region == "Trinidad and Tobago"] <- 
    "Trinidad"
  dt$region[dt$region == "United Kingdom"] <- "UK"
  dt$region[dt$region == "United States"] <- "USA"
  ## join long and lat
  dt <- inner_join(world, dt, by = "region")
  
  ## output the happiness map
  output$hpMap <- renderPlot({
    dtMap <- dt %>%
      filter(year == input$year2)
    p <- ggplot(dtMap, aes(long, lat, group=group, fill = Happiness)) +
      geom_polygon(col="black") +
      ggtitle(paste0("Happiness map for ",input$year)) +
      coord_quickmap() +
      theme(plot.title = element_text(size = 16, face = "bold"))
    return(p)
  })
  
  ## output the index map
  output$mapPlot <- renderPlot({
    dtMap <- dt %>%
      filter(year == input$year2)
    if (input$index == "Health") {
      p <- ggplot(dtMap, aes(long, lat, group=group, fill = Health)) +
        geom_polygon(col="black") +
        ggtitle(paste0("Health map for ",input$year2)) +
        coord_quickmap()
    } else if (input$index == "Freedom") {
      p <- ggplot(dtMap, aes(long, lat, group=group, fill = Freedom)) +
        geom_polygon(col="black") +
        ggtitle(paste0("Freedom map for ",input$year2)) +
        coord_quickmap()
    } else if (input$index == "Family") {
      p <- ggplot(dtMap, aes(long, lat, group=group, fill = Family)) +
        geom_polygon(col="black") +
        ggtitle(paste0("Family map for ",input$year2)) +
        coord_quickmap()
    } else if (input$index == "Trust") {
      p <- ggplot(dtMap, aes(long, lat, group=group, fill = Trust)) +
        geom_polygon(col="black") +
        ggtitle(paste0("Trust map for ",input$year2)) +
        coord_quickmap()
    } else if (input$index == "Generosity") {
      p <- ggplot(dtMap, aes(long, lat, group=group, fill = Generosity)) +
        geom_polygon(col="black") +
        ggtitle(paste0("Generosity map for ",input$year2)) +
        coord_quickmap()
    }
    p <- p+theme(plot.title = element_text(size = 16, face = "bold"))
    return(p)
  })
  
  ## output the map message 
  output$message <- renderText({
    message <- paste0("We can have a bigger picture of how does the ", 
                      input$index, " is correlated to the Happiness Score 
                          with the worlf map.")
    if (input$index == "Health") {
      message <- paste0(message, " The color of the Health map at each 
                              reigon is very close to the color of the Happiness
                              map. Therefore, the Health has a strong positive 
                              relation with Happiness.")
    } else if (input$index == "Freedom") {
      message <- paste0(message, " The color of the Freedom map at each 
                              reigon is very close to the color of the Happiness
                              map. Therefore, the Freedom has a strong positive 
                              relation with Happiness.")
    } else if (input$index == "Family") {
      message <- paste0(message, " The color of the Family map at each 
                              reigon is very close to the color of the Happiness
                              map. Therefore, the Family has a strong positive 
                              relation with Happiness.")
    } else if  (input$index == "Trust") {
      message <- paste0(message, " The color of the Trust map at each 
                              reigon is very close to the color of the Happiness
                              map. Therefore, the Trust has a strong negative 
                              relation with Happiness.")
    } else if  (input$index == "Generosity") {
      message <- paste0(message, " The color of the Generosity map at each 
                              reigon is very close to the color of the Happiness
                              map. Therefore, the Generosity has a strong 
                              negative relation with Happiness.")
    }
    
    return(message)
  })
  
  
  # Scartter plot section
  ## data
  
  d <- reactive({
    hp %>%
      filter(year == input$year)
  }) 
  
  ## output the country
  output$country <- renderUI({
    selectizeInput(inputId = "country", label = strong("Choose country"), 
                   choices = c("All Countries", unique(d()$Country)),
                   selected = "All Countries")  
  })
  
  ## output the scartter plot
  output$scartterPlot <- renderPlot({
    if(input$country == "All Countries") {
      if(input$factor == "Economy"){
        p <- ggplot(d())+geom_point(aes(Happiness.Score, Economy))
      } else if(input$factor == "Health"){
        p <- ggplot(d())+geom_point(aes(Happiness.Score, Health))
      } else if(input$factor == "Freedom"){
        p <- ggplot(d())+geom_point(aes(Happiness.Score, Freedom))
      } else if(input$factor == "Family"){
        p <- ggplot(d())+geom_point(aes(Happiness.Score, Family))
      } else if(input$factor == "Trust"){
        p <- ggplot(d())+geom_point(aes(Happiness.Score, Trust))
      } else{
        p <- ggplot(d())+geom_point(aes(Happiness.Score, Generosity))
      }
    } else{
      if(input$factor == "Economy"){
        p <- ggplot(d())+geom_point(aes(Happiness.Score, Economy)) +
          gghighlight(Country == input$country)
      } else if(input$factor == "Health"){
        p <- ggplot(d())+geom_point(aes(Happiness.Score, Health)) +
          gghighlight(Country == input$country)
      } else if(input$factor == "Freedom"){
        p <- ggplot(d())+geom_point(aes(Happiness.Score, Freedom)) +
          gghighlight(Country == input$country)
      } else if(input$factor == "Family"){
        p <- ggplot(d())+geom_point(aes(Happiness.Score, Family)) +
          gghighlight(Country == input$country)
      } else if(input$factor == "Trust"){
        p <- ggplot(d())+geom_point(aes(Happiness.Score, Trust)) +
          gghighlight(Country == input$country)
      } else{
        p <- ggplot(d())+geom_point(aes(Happiness.Score, Generosity)) +
          gghighlight(Country == input$country)
      }
    } 
    p <- p+ggtitle(paste0("Scartter plot of ",input$factor, 
                          " vs Happiness Score in ", input$year)) +
      theme(plot.title = element_text(size = 16, face = "bold"))
    return(p)
  })
  
  ## output scartter plot description 
  output$desc <- renderText({
    # calculate the correlation
    if(input$factor == "Economy"){
      c <- round(cor(d()$Happiness.Score, d()$Economy), digits = 4)
    } else if(input$factor == "Health"){
      c <- round(cor(d()$Happiness.Score, d()$Health), digits = 4)
    } else if(input$factor == "Freedom"){
      c <- round(cor(d()$Happiness.Score, d()$Freedom), digits = 4)
    } else if(input$factor == "Family"){
      c <- round(cor(d()$Happiness.Score, d()$Family), digits = 4)
    } else if(input$factor == "Trust"){
      c <- round(cor(d()$Happiness.Score, d()$Trust), digits = 4)
    } else{
      c <- round(cor(d()$Happiness.Score, d()$Generosity), digits = 4)
    }
    ### correlation description
    if(c>0.7) {
      t0 <- paste0("It shows that Happiness Score and ", input$factor, " are strong correlation.")
    } else if(c<=0.7 & c>0.5) {
      t0 <- paste0("It shows that Happiness Score and ", input$factor, " are moderate correlation.")
    } else {
      t0 <- paste0("It shows that Happiness Score and ", input$factor, " are weak correlation.")
    }
    
    if(input$country!="All Countries"){
      d3 <- hp %>%
        filter(year == input$year) %>%
        filter(Country == input$country)
    } else{
      d3 <- d()
    }
    t1 <- paste0("This is the scatter plot of Happiness Score and ", input$factor, 
                 " for all countries in ", input$year, ". If these points are 
                 concentrated in the upper right part, it means that a high happiness 
                 score is related to a high ",input$factor, " level. The correlation 
                 coefficient between these two variable is ", c, ".") 
    t2 <- paste0("This is the point of ", input$country, ". Its happiess score is ", 
                 d3$Happiness.Score, " and rank in ", d3$Happiness.Rank, ".")
    
    if(input$country == "All Countries"){
      return(paste(t1, t0))
    } else{
      return(t2)
    }
  })
  
  
  # Bar chart 1 
  ## data clean
  hp_Country <- reactive({
    hp %>%
      filter(Country == input$country2)
  })
  
  ## output the factor bar chart
  output$distPlot <- renderPlot({
    bars <- hp_Country()[hp_Country()$year %in%
                           c(2015, 2016),
                         c("Economy", "Health", "Family", "Freedom", 
                           "Trust", "Generosity")] %>%
      as.matrix()
    barplot(bars, beside=TRUE, col=c("skyblue", "blue"), 
            ylab="Score", xlab="Factors", 
            main=paste0("Factors of ",input$country2," in 2015 and 2016"))
    legend("topright", 
           legend = c(2015,2016), 
           fill = c("skyblue", "blue"))
  })
  
  output$table <- renderTable ({
    d <- hp %>% 
      filter(Country == input$country2) %>%
      rename(Rank = Happiness.Rank,
             Happiness_Score = Happiness.Score)
    return(d[c(1,2,5,4,7,8,9,10,11,12)])
    
  })
  
  ## output the factor bar chart description 
  output$describe <- renderText({ 
    paste("The side by side bar compares the score of 6 factors influencing hapiness score 
              from 2015 and 2016 data in all the countries in the dataset. Besides, a table that 
              displays the score values is also provided to help viewers better compare and compute 
              the scores. These chart and table are attempting to help viewers understand which factors
              are rise or decline between 2015 and 2016 and which factor has contributed to the change of 
              total happiness score the most by providing clear visual exhibition and statistics. The 
              bar on the left side allows viewers to choose countries they are interested in.")
  })
  
  
  # Bar chart 2 
  ## data clean
  d_region <- reactive({
    hp %>%
      filter(year == input$year3) %>%
      group_by(Region) %>%
      summarize(avg = mean(Happiness.Score))
  })
  
  ## output the region happiness score bar chart
  output$distplot2 <- renderPlot({
    p <- ggplot(d_region()) +
      geom_col(aes(Region, avg), fill = input$color) +
      ylab("Average Happiness Score") +
      ggtitle(paste0("Average Happiness Score by Region in ", input$year3)) +
      theme(axis.text.x = element_text(angle = 45)) +
      theme(plot.title = element_text(size = 16, face = "bold"))
    return(p)
  })
  
  ## output the region happiness score bar chart description 
  output$descrip <- renderText({
    paste("This bar chart shows the average happiness score based on the regions in the year 2015 and 2016. 
          Australia and New Zealand have the highest happiness score both in the year 2015 and 2016.")
  })
  
}

shinyServer(server) 
