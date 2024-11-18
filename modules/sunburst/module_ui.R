sunburstUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(
        width = 3,
        div(
          class = "filters-section",
          style = "background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05);",
          h4("Filtres", style = "margin-top: 0; margin-bottom: 20px; color: #2C3E50;"),
          
          # Boutons de sélection rapide
          div(
            style = "display: flex; gap: 10px; margin-bottom: 20px;",
            actionButton(ns("select_all"), "Tout sélectionner", 
                         class = "btn-primary",
                         style = "flex: 1; background-color: #007D9C; color: white;"),
            actionButton(ns("clear_all"), "Tout désélectionner",
                         class = "btn-secondary",
                         style = "flex: 1; background-color: #6c757d; color: white;")
          ),
          
          # Filtres collapsibles
          filterGroupUI(ns("mental_health"), "État de santé mentale", "brain"),
          filterGroupUI(ns("industry"), "Secteur d'industrie", "building"),
          filterGroupUI(ns("job_role"), "Type de poste", "briefcase"),
          filterGroupUI(ns("age_group"), "Tranche d'âge", "user")
        )
      ),
      
      column(
        width = 9,
        div(
          class = "visualization-section",
          style = "background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05);",
          h4("Visualisation Sunburst", 
             style = "margin-top: 0; margin-bottom: 20px; color: #2C3E50;"),
          customLegendUI(ns("legend")),
          div(
            style = "width: 100%; height: 700px;",
            plotlyOutput(ns("sunburstPlot"), height = "100%")
          )
        )
      )
    )
  )
}