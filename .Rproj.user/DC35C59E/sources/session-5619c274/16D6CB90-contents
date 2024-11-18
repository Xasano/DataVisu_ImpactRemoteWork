homeServer <- function(id, shared_data) {
  moduleServer(id, function(input, output, session) {
    # Navigation
    observeEvent(input$goto_sunburst, {
      updateTabItems(session$parent, "sidebar_menu", "sunburst")
    })
    
    observeEvent(input$goto_geo, {
      updateTabItems(session$parent, "sidebar_menu", "technique2")
    })
    
    observeEvent(input$goto_productivity, {
      updateTabItems(session$parent, "sidebar_menu", "technique3")
    })
    
    # Résumé des statistiques
    output$stats_summary <- renderUI({
      data <- shared_data()$data
      req(shared_data()$data_loaded, data)
      
      fluidRow(
        # Total des employés
        div(
          class = "col-md-3",
          div(
            class = "analysis-card",
            style = "text-align: center; padding: 20px;",
            icon("users", style = "font-size: 2em; color: #007D9C;"),
            h3(format(nrow(data), big.mark = ","), 
               style = "margin: 15px 0; color: #2C3E50;"),
            p("Employés Total", style = "color: #666;")
          )
        ),
        
        # Travail à distance
        div(
          class = "col-md-3",
          div(
            class = "analysis-card",
            style = "text-align: center; padding: 20px;",
            icon("laptop-house", style = "font-size: 2em; color: #66BB6A;"),
            h3(sprintf("%.1f%%", 
                       mean(data$Work_Location == "Remote", na.rm = TRUE) * 100),
               style = "margin: 15px 0; color: #2C3E50;"),
            p("Travail à Distance", style = "color: #666;")
          )
        ),
        
        # Santé mentale
        div(
          class = "col-md-3",
          div(
            class = "analysis-card",
            style = "text-align: center; padding: 20px;",
            icon("brain", style = "font-size: 2em; color: #FF6B6B;"),
            h3(sprintf("%.1f%%", 
                       mean(data$Mental_Health_Condition != "Happy", na.rm = TRUE) * 100),
               style = "margin: 15px 0; color: #2C3E50;"),
            p("Enjeux de Santé Mentale", style = "color: #666;")
          )
        ),
        
        # Niveau de stress
        div(
          class = "col-md-3",
          div(
            class = "analysis-card",
            style = "text-align: center; padding: 20px;",
            icon("chart-line", style = "font-size: 2em; color: #FFB236;"),
            h3(sprintf("%.1f", 
                       mean(as.numeric(factor(data$Stress_Level)), na.rm = TRUE)),
               style = "margin: 15px 0; color: #2C3E50;"),
            p("Niveau de Stress Moyen", style = "color: #666;")
          )
        )
      )
    })
  })
}