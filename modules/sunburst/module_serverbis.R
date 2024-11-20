# Server Component
sunburstServerbis <- function(id, shared_data) {
  moduleServer(id, function(input, output, session) {
    mental_health_colors <- list(
      "Anxiety" = "#FF6B6B",
      "Depression" = "#4A90E2",
      "Burnout" = "#FFB236",
      "Happy" = "#66BB6A"
    )
    
    data_sunburst <- reactive({
      req(shared_data()$data)
      
      df <- shared_data()$data
      
      if (nrow(df) == 0) return(NULL)

      industries <- df %>%
        group_by(Industry) %>%
        summarise(count = n(), .groups = 'drop') %>%
        mutate(
          ids = Industry,
          labels = Industry,
          parents = "",
          colors = "lightgray",
          tooltip = sprintf("Secteur : %s<br>Total : %d employés", Industry, count)
        )

      roles <- df %>%
        group_by(Industry, Job_Role) %>%
        summarise(count = n(), .groups = 'drop') %>%
        mutate(
          ids = paste(Industry, Job_Role, sep="-"),
          labels = Job_Role,
          parents = Industry,
          colors = "lightgray",
          tooltip = sprintf("Poste : %s<br>Total : %d employés", Job_Role, count)
        )

      ages <- df %>%
        group_by(Industry, Job_Role, age_group) %>%
        summarise(count = n(), .groups = 'drop') %>%
        mutate(
          ids = paste(Industry, Job_Role, age_group, sep="-"),
          labels = age_group,
          parents = paste(Industry, Job_Role, sep="-"),
          colors = "lightgray",
          tooltip = sprintf("Tranche d'âge : %s<br>Total : %d employés", age_group, count)
        )

      mental_health <- df %>%
        group_by(Industry, Job_Role, age_group) %>%
        mutate(total_group = n()) %>%
        group_by(Industry, Job_Role, age_group, Mental_Health_Condition) %>%
        summarise(
          count = n(),
          percentage = round((n() / first(total_group)) * 100, 1),
          .groups = 'drop'
        ) %>%
        mutate(
          ids = paste(Industry, Job_Role, age_group, Mental_Health_Condition, sep="-"),
          labels = sprintf("%s\n%.1f%%", Mental_Health_Condition, percentage),
          parents = paste(Industry, Job_Role, age_group, sep="-"),
          colors = unlist(mental_health_colors[Mental_Health_Condition]),
          tooltip = sprintf(
            "État : %s<br>Nombre : %d<br>Pourcentage : %.1f%%",
            Mental_Health_Condition, count, percentage
          )
        )

      bind_rows(
        industries %>% select(ids, labels, parents, values = count, colors, tooltip),
        roles %>% select(ids, labels, parents, values = count, colors, tooltip),
        ages %>% select(ids, labels, parents, values = count, colors, tooltip),
        mental_health %>% select(ids, labels, parents, values = count, colors, tooltip)
      )
    })

    output$sunburstPlot <- renderPlotly({
        plot_data <- data_sunburst()
        
        if (is.null(plot_data)) {
            return(plot_ly() %>% 
                    layout(title = "Aucune donnée à afficher"))
        }
        
        plot_ly(
            data = plot_data,
            ids = plot_data$ids,
            labels = plot_data$labels,
            parents = plot_data$parents,
            values = plot_data$values,
            type = 'sunburst',
            branchvalues = 'total',
            maxdepth = 4,
            insidetextorientation = 'radial',
            textfont = list(size = 12),
            marker = list(
            colors = plot_data$colors,
            line = list(color = 'white', width = 1)
            ),
            hovertemplate = paste(
            "%{customdata}",
            "<extra></extra>"
            ),
            customdata = plot_data$tooltip
        ) %>%
            layout(
            title = list(
                text = "Analyse de la Santé Mentale par Profil",
                font = list(size = 14),
                y = 0.98,  # Position du titre ajustée plus haut
                yref = "container"
            ),
            margin = list(l = 20, r = 20, t = 40, b = 20),  # Marges augmentées
            autosize = TRUE,
            showlegend = FALSE,
            paper_bgcolor = 'rgba(0,0,0,0)',
            plot_bgcolor = 'rgba(0,0,0,0)',
            width = NULL,
            height = NULL
            ) %>%
            config(
            displayModeBar = FALSE,
            responsive = TRUE
            )
        })
    })
}
