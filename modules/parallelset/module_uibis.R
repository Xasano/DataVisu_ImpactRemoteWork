# Pour le parallel set
parallelsetUIbis <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      class = "visualization-section",
      style = "background: white; padding: 0; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); height: 400px; position: relative;",
      div(
        style = "width: 100%; height: calc(100% - 30px); padding: 15px;",
        plotlyOutput(ns("plot"), height = "100%")
      ),
      div(
        style = "position: absolute; bottom: 10px; right: 15px;",
        tags$a(href = "#", class = "explore-btn", "Explorer →")
      )
    )
  )
}