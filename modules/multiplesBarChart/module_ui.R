ui <- fluidPage(
  titlePanel("Analyse de l'impact du travail à distance sur la santé mentale"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("region", "Région:",
                  choices = c("All", "Europe", "North America", "Asia", 
                              "Oceania", "South America", "Africa"),
                  selected = "All")
    ),
    
    mainPanel(
      plotOutput("noActivityPlot", height = "300px"),
      plotOutput("weeklyActivityPlot", height = "300px"),
      plotOutput("dailyActivityPlot", height = "300px")
    )
  )
)