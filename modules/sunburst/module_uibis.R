sunburstUIbis <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      class = "visualization-section",
      style = "background: white; padding: 0; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); height: 440px; position: relative;", # Augmenté de 400px à 440px
      div(
        style = "width: 100%; height: calc(100% - 20px); padding: 20px;", 
        plotlyOutput(ns("sunburstPlot"), height = "100%")
      )
    )
  )
}