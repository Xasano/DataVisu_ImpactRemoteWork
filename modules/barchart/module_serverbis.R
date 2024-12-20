barchartServerbis <- function(id, shared_data) {
  moduleServer(id, function(input, output, session) {
    
    filtered_data <- reactive({
      req(shared_data()$data)
      
      shared_data()$data %>%
        mutate(
          Work_Life_Balance_Rating = factor(
            as.numeric(Work_Life_Balance_Rating),
            levels = 1:5,
            labels = c("Très Faible", "Faible", "Moyen", "Bon", "Excellent")
          ),
          Hours_Interval = factor(
            case_when(
              Hours_Worked_Per_Week >= 51 ~ "51-60",
              Hours_Worked_Per_Week >= 41 ~ "41-50",
              Hours_Worked_Per_Week >= 31 ~ "31-40",
              Hours_Worked_Per_Week >= 21 ~ "21-30",
              TRUE ~ "0-20"
            ),
            levels = c("0-20", "21-30", "31-40", "41-50", "51-60")
          )
        )
    })
    
    output$barChart <- renderPlotly({
      data_summary <- filtered_data() %>%
        group_by(Hours_Interval, Work_Life_Balance_Rating) %>%
        summarize(Employee_Count = n(), .groups = "drop")
      
      p <- ggplot(
        data_summary,
        aes(
          x = Employee_Count,
          y = Hours_Interval,
          fill = Work_Life_Balance_Rating,
          text = paste("Nombre d'employés:", Employee_Count)
        )
      ) +
        geom_bar(stat = "identity", position = "stack", color = "black") +
        scale_fill_manual(
          values = c(
            "Très Faible" = "#FF4C4C",
            "Faible" = "#FFA500",
            "Moyen" = "#FFD700",
            "Bon" = "#ADFF2F",
            "Excellent" = "#32CD32"
          )
        ) +
        labs(
          x = "Nombre d'employés",
          y = "Heures travaillées par semaine",
          fill = "Satisfaction"
        ) +
        theme_minimal() +
        theme(
          plot.title = element_text(size = 14, margin = margin(b = 20)),
          axis.text = element_text(size = 12),
          axis.title = element_text(size = 12),
          legend.position = "bottom",
          legend.title = element_text(size = 11),
          legend.text = element_text(size = 10),
          plot.margin = margin(10, 10, 40, 10),
          panel.grid.major.x = element_line(color = "grey90"),
          panel.grid.major.y = element_blank()
        )
      
      ggplotly(p, tooltip = "text") %>%
        layout(
          paper_bgcolor = "rgba(0,0,0,0)",  # Fond transparent
          plot_bgcolor = "rgba(0,0,0,0)",   # Fond transparent
          title = list(
            text = "Analyse de l'équilibre travail-vie personnelle",
            font = list(size = 14),
            y = 0.98,
            x = 0.5,
            xanchor = "center"
          ),
          showlegend = TRUE,
          margin = list(l = 50, r = 20, t = 50, b = 80), 
          legend = list(
            orientation = "h",
            y = -0.2,
            x = 0.5,
            xanchor = "center",
            font = list(size = 10)
          ),
          hovermode = "closest",
          autosize = TRUE,
          height = 460 
        ) %>%
        config(displayModeBar = FALSE, responsive = TRUE)
    })
  })
}