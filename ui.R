library(shiny)
library(plotly)

ui <- fluidPage(
  titlePanel("Distribution des employés par intervalle d'heures travaillées et niveau de satisfaction"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("hoursRange", "Sélectionnez la plage d'heures travaillées:",
                  min = 0, max = 60, value = c(0, 60), step = 1),
      
      sliderInput("satisfactionRange", "Sélectionnez le niveau de satisfaction:",
                  min = 1, max = 5, value = c(1, 5), step = 1),
      
      downloadButton("downloadPlot", "Télécharger le graphique")
    ),
    
    mainPanel(
      plotlyOutput("barChart", height = "600px")
    )
  )
)
