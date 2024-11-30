parallelsetServer <- function(id, shared_data) {
  moduleServer(id, function(input, output, session) {
    
    observe({
      req(shared_data()$data)
      updateSelectInput(session, "region",
                        choices = unique(shared_data()$data$Region))
    })
    
    plot_data <- reactive({
      req(input$region, shared_data()$data)
      
      df <- shared_data()$data %>%
        filter(Region == input$region) %>%
        select(Work_Location, Stress_Level, Mental_Health_Condition, Productivity_Change)
      
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
      productivity_pos <- calculate_positions(df, "Productivity_Change")
      
      total_height <- max(c(
        sum(work_location_pos$height),
        sum(stress_level_pos$height),
        sum(mental_health_pos$height),
        sum(productivity_pos$height)
      ))
      
      nodes <- data.frame(
        node = c(work_location_pos$Work_Location,
                 stress_level_pos$Stress_Level,
                 mental_health_pos$Mental_Health_Condition,
                 productivity_pos$Productivity_Change),
        x = c(rep(0, nrow(work_location_pos)),
              rep(0.33, nrow(stress_level_pos)),
              rep(0.66, nrow(mental_health_pos)),
              rep(1, nrow(productivity_pos))),
        y = c(work_location_pos$y_center,
              stress_level_pos$y_center,
              mental_health_pos$y_center,
              productivity_pos$y_center),
        count = c(work_location_pos$n,
                  stress_level_pos$n,
                  mental_health_pos$n,
                  productivity_pos$n),
        y_start = c(work_location_pos$y_start,
                    stress_level_pos$y_start,
                    mental_health_pos$y_start,
                    productivity_pos$y_start),
        y_end = c(work_location_pos$y_end,
                  stress_level_pos$y_end,
                  mental_health_pos$y_end,
                  productivity_pos$y_end)
      )
      
      links_work_to_stress <- df %>%
        group_by(Work_Location, Stress_Level) %>%
        summarise(value = n(), .groups = 'drop')
      
      links_stress_to_mental <- df %>%
        group_by(Stress_Level, Mental_Health_Condition) %>%
        summarise(value = n(), .groups = 'drop')
      
      links_mental_to_productivity <- df %>%
        group_by(Mental_Health_Condition, Productivity_Change) %>%
        summarise(value = n(), .groups = 'drop')
      
      links_work_to_stress$source <- match(links_work_to_stress$Work_Location, nodes$node) - 1
      links_work_to_stress$target <- match(links_work_to_stress$Stress_Level, nodes$node) - 1
      
      links_stress_to_mental$source <- match(links_stress_to_mental$Stress_Level, nodes$node) - 1
      links_stress_to_mental$target <- match(links_stress_to_mental$Mental_Health_Condition, nodes$node) - 1
      
      links_mental_to_productivity$source <- match(links_mental_to_productivity$Mental_Health_Condition, nodes$node) - 1
      links_mental_to_productivity$target <- match(links_mental_to_productivity$Productivity_Change, nodes$node) - 1
      
      all_links <- rbind(
        links_work_to_stress %>% select(source, target, value),
        links_stress_to_mental %>% select(source, target, value),
        links_mental_to_productivity %>% select(source, target, value)
      )
      
      list(nodes = nodes, links = all_links, total_height = total_height)
    })
    
    output$plot <- renderPlotly({
      req(plot_data())
      
      title_annotations <- list(
        list(x = 0, y = 1.05, xref = "paper", yref = "paper",
             text = "Mode de Travail", showarrow = FALSE, font = list(size = 14)),
        list(x = 0.33, y = 1.05, xref = "paper", yref = "paper",
             text = "Niveau de Stress", showarrow = FALSE, font = list(size = 14)),
        list(x = 0.66, y = 1.05, xref = "paper", yref = "paper",
             text = "Santé Mentale", showarrow = FALSE, font = list(size = 14)),
        list(x = 1, y = 1.05, xref = "paper", yref = "paper",
             text = "Productivité", showarrow = FALSE, font = list(size = 14))
      )
      
      plot_ly(
        type = "sankey",
        orientation = "h",
        node = list(
          label = paste0(plot_data()$nodes$node, "<br>Count: ", plot_data()$nodes$count),
          x = plot_data()$nodes$x,
          y = plot_data()$nodes$y / plot_data()$total_height,
          pad = 10,
          thickness = plot_data()$nodes$count / plot_data()$total_height * 50,
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
          font = list(size = 12),
          xaxis = list(showgrid = FALSE, zeroline = FALSE),
          yaxis = list(showgrid = FALSE, zeroline = FALSE),
          hovermode = "closest",
          annotations = title_annotations,
          margin = list(t = 40)
        ) %>%
        config(displayModeBar = FALSE)
    })
  })
}