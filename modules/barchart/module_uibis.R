barchartUIbis <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      class = "visualization-section",
      style = "background: white; padding: 0; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); height: 480px; position: relative;",
      div(
        style = "width: 100%; ; padding: 5px;",
        plotlyOutput(ns("barChart"), height = "100%")
      )
    )
  )
}