barchartUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    fluidRow(
      box(
        width = 12,
        title = "Analyse équilibre Travail-Vie Personnelle",
        status = "primary",
        solidHeader = TRUE,
        
        fluidRow(
          # Panneau des filtres
          column(
            width = 3,
            div(
              class = "filters-section",
              style = "background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05);",
              
              # Filtre des heures
              sliderInput(
                ns("hoursRange"),
                "Plage d'heures travaillées:",
                min = 0,
                max = 60,
                value = c(0, 60),
                step = 1
              ),
              
              # Filtre de satisfaction
              sliderInput(
                ns("satisfactionRange"),
                "Niveau de satisfaction:",
                min = 1,
                max = 5,
                value = c(1, 5),
                step = 1
              ),
              
              # Boutons
              div(
                style = "margin-top: 20px;",
                actionButton(
                  ns("generate"),
                  "Générer le graphique",
                  class = "btn-primary btn-block"
                )
              )
            )
          ),
          
          # Zone du graphique
          column(
            width = 9,
            div(
              class = "chart-section",
              style = "background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05);",
              plotlyOutput(ns("barChart"), height = "600px")
            )
          )
        )
      )
    )
    )
}