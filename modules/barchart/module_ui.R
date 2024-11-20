# UI Module
barchartUI <- function(id) {
  ns <- NS(id)
  tagList(

    div(
      class = "visualization-section",
      style = "background: white; padding: 0; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); height: 550px; margin: -20px;",
      div(
        style = "background: #A8C5E5; padding: 15px;",
        h4("Distribution des employés", 
           style = "margin: 0; color: #2C3E50;")
      ),
      fluidRow(
        column(
          width = 3,
          div(
            style = "padding: 20px;",
            sliderInput(
              ns("hoursRange"),
              "Plage d'heures travaillées",
              min = 0, max = 60,
              value = c(0, 60),
              step = 1
            ),
            sliderInput(
              ns("satisfactionRange"),
              "Niveau de satisfaction",
              min = 1, max = 5,
              value = c(1, 5),
              step = 1
            )
          )
        ),
        column(
          width = 9,
          div(
            style = "padding: 20px; height: calc(100% - 50px);",
            plotlyOutput(ns("barChart"), height = "100%")
          )
        )
      )
    )
  )
}