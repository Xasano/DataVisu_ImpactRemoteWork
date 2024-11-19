parallelsetUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    fluidRow(
      box(
        width = 12,
        title = "Analyse de la productivité en fonction du lieu de travail et du stress",
        status = "primary",
        solidHeader = TRUE,
        
        fluidRow(
          column(
            width = 3,
            div(
              class = "filters-section",
              style = "background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05);",
              selectInput(ns("region"), "Région", choices = NULL)
            )
          ),
          column(
            width = 9,
            div(
              class = "chart-section",
              style = "background: white; padding: 20px; border-radius: 8px;",
              plotlyOutput(ns("plot"), height = "700px")
            )
          )
        )
      )
    )
  )
}