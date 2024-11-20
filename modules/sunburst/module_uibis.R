sunburstUIbis <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      class = "visualization-section",
      style = "background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); height: 400px; margin-bottom: 10px;", # Hauteur augmentée
      div(
        style = "width: 100%; height: calc(100% - 20px); padding: 20px;", 
        plotlyOutput(ns("sunburstPlot"), height = "100%")
      )
    )
  )
}