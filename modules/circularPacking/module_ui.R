circularPackingUi <- function(id) {
  ns <- NS(id)
  fluidPage(
  titlePanel("Circle Packing - Hiérarchie des Soins de Santé Mentale"),
  sidebarLayout(
    sidebarPanel(
      selectInput(ns("region"), "Sélectionnez une région:", choices = NULL),
      
      checkboxGroupInput(ns("levels"), "Niveaux à afficher:",
                         choices = list(
                           "Genre" = "gender",
                           "Conditions de santé" = "condition",
                           "Accès aux soins" = "access"
                         ),
                         selected = c("gender", "condition", "access")
      ),
      
      sliderInput(ns("label_threshold"), "Seuil d'affichage des labels (%)",
                  min = 0, max = 100, value = 5, step = 1)
    ),
    mainPanel(
      plotOutput(ns("circle_plot"), height = "600px")
    )
  ))
}