# Server Component
parallelsetServerbis <- function(id, shared_data) {
  moduleServer(id, function(input, output, session) {
    plot_data <- reactive({
      req(shared_data()$data)
      
      df <- shared_data()$data %>%
        # Utiliser l'Europe comme région par défaut
        filter(Region == "Europe") %>%
        select(Work_Location, Stress_Level, Mental_Health_Condition)
      
      calculate_positions <- function(data, group_col) {
        data %>%
          count(!!sym(group_col)) %>%
          arrange(desc(n)) %>%
          mutate(
            y_start = lag(cumsum(n), default = 0),
            y_end = cumsum(n),
            y_center = (y_start + y_end) / 2,
            height = n
          )
      }
      
      work_location_pos <- calculate_positions(df, "Work_Location")
      stress_level_pos <- calculate_positions(df, "Stress_Level")
      mental_health_pos <- calculate_positions(df, "Mental_Health_Condition")
      
      total_height <- max(c(
        sum(work_location_pos$height),
        sum(stress_level_pos$height),
        sum(mental_health_pos$height)
      ))
      
      nodes <- data.frame(
        node = c(work_location_pos$Work_Location,
                stress_level_pos$Stress_Level,
                mental_health_pos$Mental_Health_Condition),
        x = c(rep(0, nrow(work_location_pos)),
              rep(0.5, nrow(stress_level_pos)),
              rep(1, nrow(mental_health_pos))),
        y = c(work_location_pos$y_center,
              stress_level_pos$y_center,
              mental_health_pos$y_center),
        count = c(work_location_pos$n,
                 stress_level_pos$n,
                 mental_health_pos$n),
        y_start = c(work_location_pos$y_start,
                   stress_level_pos$y_start,
                   mental_health_pos$y_start),
        y_end = c(work_location_pos$y_end,
                 stress_level_pos$y_end,
                 mental_health_pos$y_end)
      )
      
      links_work_to_stress <- df %>%
        group_by(Work_Location, Stress_Level) %>%
        summarise(value = n(), .groups = 'drop')
      
      links_stress_to_mental <- df %>%
        group_by(Stress_Level, Mental_Health_Condition) %>%
        summarise(value = n(), .groups = 'drop')
      
      links_work_to_stress$source <- match(links_work_to_stress$Work_Location, nodes$node) - 1
      links_work_to_stress$target <- match(links_work_to_stress$Stress_Level, nodes$node) - 1
      
      links_stress_to_mental$source <- match(links_stress_to_mental$Stress_Level, nodes$node) - 1
      links_stress_to_mental$target <- match(links_stress_to_mental$Mental_Health_Condition, nodes$node) - 1
      
      all_links <- rbind(
        links_work_to_stress %>% select(source, target, value),
        links_stress_to_mental %>% select(source, target, value)
      )
      
      list(nodes = nodes, links = all_links, total_height = total_height)
    })
    
    output$plot <- renderPlotly({
        req(plot_data())
        
        title_annotations <- list(
            list(x = 0, y = 1.02, xref = "paper", yref = "paper", # Ajustement de la position des titres
                text = "Mode de Travail", showarrow = FALSE, font = list(size = 14)),
            list(x = 0.5, y = 1.02, xref = "paper", yref = "paper",
                text = "Niveau de Stress", showarrow = FALSE, font = list(size = 14)),
            list(x = 1, y = 1.02, xref = "paper", yref = "paper",
                text = "Santé Mentale", showarrow = FALSE, font = list(size = 14))
        )
        
        plot_ly(
            type = "sankey",
            orientation = "h",
            node = list(
            label = paste0(plot_data()$nodes$node, "<br>Count: ", plot_data()$nodes$count),
            x = plot_data()$nodes$x,
            y = plot_data()$nodes$y / plot_data()$total_height,
            pad = 15,
            thickness = plot_data()$nodes$count / plot_data()$total_height * 40,
            line = list(color = "black", width = 0.5),
            color = colorRampPalette(c("#E6F3FF", "#2171B5"))(nrow(plot_data()$nodes))
            ),
            link = list(
            source = plot_data()$links$source,
            target = plot_data()$links$target,
            value = plot_data()$links$value,
            hoverlabel = list(bgcolor = "white", font = list(size = 10))
            )
        ) %>%
            layout(
            title = list(
            text = "Analyse de la productivité selon le lieu de travail et le stress",
            font = list(size = 16),
            y = 0.98
            ),
            font = list(size = 12),
            xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
            yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
            hovermode = "closest",
            annotations = title_annotations,
            margin = list(l = 20, r = 20, t = 40, b = 20),
            autosize = TRUE,
            height = 600 # Augmentation de la hauteur du graphique
            ) %>%
            config(displayModeBar = FALSE, responsive = TRUE)
        })
    })
}
