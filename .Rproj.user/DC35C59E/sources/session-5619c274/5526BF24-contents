sunburstServer <- function(id, shared_data) {
  moduleServer(id, function(input, output, session) {
    # Cache des données
    data_cache <- reactiveVal(NULL)
    
    # Observation des données partagées
    observe({
      data <- shared_data()$data
      if (!is.null(data) && is.null(data_cache())) {
        data_cache(data)
      }
    })
    
    # Logique des filtres
    observe({
      data <- data_cache()
      req(data)
      
      # Vérifiez que la colonne 'age_group' existe et mettez à jour le filtre
      if ("age_group" %in% colnames(data)) {
        age_choices <- sort(unique(data$age_group))
        if (length(age_choices) > 0) {
          updateCheckboxGroupInput(session, "age_group",
                                   choices = age_choices,
                                   selected = age_choices)
        } else {
          updateCheckboxGroupInput(session, "age_group",
                                   choices = NULL,
                                   selected = NULL)
          warning("Aucune valeur valide pour 'age_group'.")
        }
      } else {
        warning("La colonne 'age_group' est absente des données.")
        updateCheckboxGroupInput(session, "age_group", choices = NULL, selected = NULL)
      }
      
      # Mise à jour des autres filtres
      updateFilters(session, data)
    })
    
    # Gestion des données pour le Sunburst
    sunburst_data <- reactive({
      data <- data_cache()
      req(data, input$mental_health, input$industry, input$job_role, input$age_group)
      
      # Filtrer les données en fonction des sélections
      filtered_data <- data %>%
        filter(
          Mental_Health_Condition %in% input$mental_health,
          Industry %in% input$industry,
          Job_Role %in% input$job_role,
          age_group %in% input$age_group
        )
      
      if (nrow(filtered_data) == 0) {
        return(NULL)
      }
      
      prepare_sunburst_data(
        filtered_data,
        mental_health = input$mental_health,
        industry = input$industry,
        job_role = input$job_role,
        age_group = input$age_group
      )
    })
    
    # Rendu du graphique
    output$sunburstPlot <- renderPlotly({
      plot_data <- sunburst_data()
      if (is.null(plot_data)) {
        return(empty_plot("Aucune donnée à afficher pour la sélection actuelle"))
      }
      
      create_sunburst_plot(plot_data)
    })
    
    # Gestion des boutons de sélection
    observeEvent(input$select_all, {
      data <- data_cache()
      req(data)
      select_all_filters(session, data)
    })
    
    observeEvent(input$clear_all, {
      clear_all_filters(session)
    })
  })
}
