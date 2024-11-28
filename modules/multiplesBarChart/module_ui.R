multiplesBarChartUI <- function(id) {
  ns <- NS(id)
  
  fluidPage(
    titlePanel("Fréquence de l'activité physique en fonction du mode de travail"),
    
    sidebarLayout(
      sidebarPanel(
        selectInput(ns("region"), "Région:",
                    choices = c("All", "Europe", "North America", "Asia", 
                                "Oceania", "South America", "Africa"),
                    selected = "All")
      ),
      
      mainPanel(
        plotOutput(ns("dailyActivityPlot")),
        plotOutput(ns("weeklyActivityPlot")),
        plotOutput(ns("noActivityPlot"))
      )
    )
  )
}