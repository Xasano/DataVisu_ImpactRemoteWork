# UI Component
parallelsetUIbis <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      class = "visualization-section",
      style = "background: white; padding: 0; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); height: 550px; margin: -20px;", # Hauteur réduite à 550px
      div(
        style = "background: #A8C5E5; padding: 15px;",
        h4("Analyse des Relations", 
           style = "margin: 0; color: #2C3E50;")
      ),
      div(
        style = "width: 100%; height: calc(100% - 50px); padding: 20px;",
        plotlyOutput(ns("plot"), height = "100%")
      )
    )
  )
}

