ui <- fluidPage(
  titlePanel("Analyse de l'impact du travail à distance sur la santé mentale"),
    mainPanel(
      plotOutput("noActivityPlot", height = "300px"),
      plotOutput("weeklyActivityPlot", height = "300px"),
      plotOutput("dailyActivityPlot", height = "300px")
    )
)