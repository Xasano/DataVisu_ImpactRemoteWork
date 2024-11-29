# Pour le parallel set
parallelsetUIbis <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      class = "visualization-section",
      style = "background: white; padding: 0; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); height: 520px; position: relative;", # Augmenté à 520px
      div(
        style = "width: 100%; height: calc(100% - 20px); padding: 15px;", # Réduit le calc pour augmenter l'espace de visualisation
        plotlyOutput(ns("plot"), height = "100%")
      ),
      div(
        style = "position: absolute; bottom: 5px; right: 15px;", # Réduit le bottom à 5px
        tags$a(href = "#", class = "explore-btn", "Explorer →")
      )
    )
  )
}