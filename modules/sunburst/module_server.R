source("R/ui_components.R")

sunburstServer <- function(id, shared_data) {
  moduleServer(id, function(input, output, session) {
    mental_health_colors <- list(
      "Anxiety" = "#FF6B6B",
      "Depression" = "#4A90E2",
      "Burnout" = "#FFB236",
      "Happy" = "#66BB6A"
    )
    
    observe({
      req(shared_data()$data)
      updateCheckboxGroupInput(
        session, "mental_health",
        choices = c("Anxiety", "Depression", "Burnout", "Happy"),
        selected = c("Anxiety", "Depression", "Burnout", "Happy")
      )
      updateCheckboxGroupInput(
        session, "industry",
        choices = sort(unique(shared_data()$data$Industry)),
        selected = sort(unique(shared_data()$data$Industry))
      )
      updateCheckboxGroupInput(
        session, "job_role",
        choices = sort(unique(shared_data()$data$Job_Role)),
        selected = sort(unique(shared_data()$data$Job_Role))
      )
      updateCheckboxGroupInput(
        session, "age_group",
        choices = c("22-30", "31-40", "41-50", "50+"),
        selected = c("22-30", "31-40", "41-50", "50+")
      )
    })
    
    # Gestion des sélections
    observeEvent(input$select_all, {
      updateCheckboxGroupInput(session, "mental_health",
                             selected = c("Anxiety", "Depression", "Burnout", "Happy"))
      updateCheckboxGroupInput(session, "industry",
                             selected = sort(unique(shared_data()$data$Industry)))
      updateCheckboxGroupInput(session, "job_role",
                             selected = sort(unique(shared_data()$data$Job_Role)))
      updateCheckboxGroupInput(session, "age_group",
                             selected = c("22-30", "31-40", "41-50", "50+"))
    })
    
    observeEvent(input$clear_all, {
      updateCheckboxGroupInput(session, "mental_health", selected = character(0))
      updateCheckboxGroupInput(session, "industry", selected = character(0))
      updateCheckboxGroupInput(session, "job_role", selected = character(0))
      updateCheckboxGroupInput(session, "age_group", selected = character(0))
    })

    data_sunburst <- reactive({
      req(input$mental_health, input$industry, input$job_role, input$age_group, shared_data()$data)
      
      df <- shared_data()$data %>%
        filter(
          Mental_Health_Condition %in% input$mental_health,
          Industry %in% input$industry,
          Job_Role %in% input$job_role,
          age_group %in% input$age_group
        )
      
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
                 layout(title = "Aucune donnée à afficher pour la sélection actuelle"))
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
        textfont = list(size = 14),
        marker = list(
          colors = plot_data$colors,
          line = list(color = 'white', width = 2)
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
            font = list(size = 22)
          ),
          margin = list(l = 0, r = 0, b = 0, t = 80),
          showlegend = FALSE
        )
    })
  })
}