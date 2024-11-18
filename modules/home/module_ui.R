homeUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Section d'en-tête
    fluidRow(
      box(
        width = 12,
        title = "Impact du Télétravail sur la Santé Mentale et la Productivité",
        status = "primary",
        solidHeader = TRUE,
        
        div(
          class = "welcome-content",
          style = "padding: 20px;",
          h3("Objectif de l'étude", 
             class = "text-primary", 
             style = "margin-bottom: 20px; font-weight: 300;"),
          p("Cette étude explore l'impact du télétravail sur la santé mentale et la productivité 
            des employés à travers différentes techniques d'analyse et de visualisation.", 
            style = "font-size: 16px; line-height: 1.6;")
        )
      )
    ),
    
    # Section des cartes d'analyse
    fluidRow(
      style = "margin-top: 20px;",
      
      # Carte 1 - Sunburst
      div(
        class = "col-md-4",
        div(
          class = "analysis-card",
          style = "margin-bottom: 20px;",
          h4("Santé Mentale par Profil", style = "color: #007D9C;"),
          p("Analyse de la santé mentale selon le poste, l'âge et l'industrie via un diagramme Sunburst"),
          actionLink(ns("goto_sunburst"), "Explorer →", 
                     style = "color: #007D9C; text-decoration: none;")
        )
      ),
      
      # Carte 2 - Géographie
      div(
        class = "col-md-4",
        div(
          class = "analysis-card",
          style = "margin-bottom: 20px;",
          h4("Répartition Géographique", style = "color: #007D9C;"),
          p("Visualisation de la distribution géographique et l'accès aux ressources de santé mentale"),
          actionLink(ns("goto_geo"), "Explorer →", 
                     style = "color: #007D9C; text-decoration: none;")
        )
      ),
      
      # Carte 3 - Productivité
      div(
        class = "col-md-4",
        div(
          class = "analysis-card",
          style = "margin-bottom: 20px;",
          h4("Analyse de Productivité", style = "color: #007D9C;"),
          p("Étude de la productivité en fonction du lieu de travail et du niveau de stress"),
          actionLink(ns("goto_productivity"), "Explorer →", 
                     style = "color: #007D9C; text-decoration: none;")
        )
      )
    ),
    
    # Section des statistiques globales
    fluidRow(
      style = "margin-top: 20px;",
      uiOutput(ns("stats_summary"))
    )
  )
}