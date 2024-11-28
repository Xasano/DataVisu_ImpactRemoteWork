multiplesBarChartServer <- function(id, shared_data) {
  moduleServer(id, function(input, output, session) {
    
    # Créer une liste réactive des régions sélectionnées
    selected_regions <- reactive({
      if(input$region == "All") {
        c("Europe", "North America", "Asia", "Oceania", "South America", "Africa")
      } else {
        input$region
      }
    })
    
    # Filtrer et calculer les effectifs par type d'activité
    filtered_data <- reactive({
      req(shared_data()$data)
      
      shared_data()$data %>%
        filter(Region %in% selected_regions()) %>%
        count(Physical_Activity, Work_Location, Mental_Health_Condition) %>%
        group_by(Physical_Activity, Work_Location) %>%
        mutate(percentage = round((n / sum(n)) * 100, 1)) %>%
        ungroup()
    })
    
    # Fonction pour créer un graphique pour une activité spécifique
    create_activity_plot <- function(data, activity, title_text) {
      activity_data <- data %>%
        filter(Physical_Activity == activity)
      
      ggplot(activity_data) +
        geom_col(
          aes(x = Work_Location,
              y = n,
              fill = fct_relevel(Mental_Health_Condition, "Depression", "Burnout", "Anxiety", "Happy")),
          position = "stack",
          width = 0.7
        ) +
        geom_text(
          aes(x = Work_Location,
              y = n,
              label = paste0(n, "\n", percentage, "%"),
              group = Mental_Health_Condition),
          position = position_stack(vjust = 0.5),
          color = "black",
          size = 4
        ) +
        theme_minimal() +
        labs(
          x = "Mode de travail",
          y = "Nombre de personnes",
          fill = "État mental",
          title = title_text
        ) +
        theme(
          plot.title = element_text(hjust = 0.5, size = 12),
          axis.text = element_text(size = 12),
          legend.text = element_text(size = 10),
          legend.title = element_text(size = 10),
          panel.grid.major.x = element_blank()
        ) +
        scale_fill_manual(values = c("Anxiety" = "#9999FF",
                                     "Depression" = "#FF9999",
                                     "Burnout" = "#FFCC99",
                                     "Happy" = "#99FF99"))
    }
    
    # Création des graphiques
    output[["noActivityPlot"]] <- renderPlot({
      req(filtered_data())
      create_activity_plot(filtered_data(), "None", 
                           "Personnes ne pratiquant aucune activité physique")
    })

    output[["weeklyActivityPlot"]] <- renderPlot({
      req(filtered_data())
      create_activity_plot(filtered_data(), "Weekly", 
                           "Personnes pratiquant une activité physique hebdomadaire")
    })
    
    output[["dailyActivityPlot"]] <- renderPlot({
      req(filtered_data())
      create_activity_plot(filtered_data(), "Daily", 
                           "Personnes pratiquant une activité physique quotidienne")
    })

  })
}