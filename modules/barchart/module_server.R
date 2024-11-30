barchartServer <- function(id, shared_data) {
  moduleServer(id, function(input, output, session) {
    
    filtered_data <- reactive({
      req(shared_data()$data)
      
      shared_data()$data %>%
        filter(
          Hours_Worked_Per_Week >= input$hoursRange[1],
          Hours_Worked_Per_Week <= input$hoursRange[2],
          as.numeric(Work_Life_Balance_Rating) >= input$satisfactionRange[1],
          as.numeric(Work_Life_Balance_Rating) <= input$satisfactionRange[2]
        ) %>%
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
          fill = "Niveau de satisfaction"
        ) +
        theme_minimal() +
        theme(
          plot.title = element_text(size = 14, hjust = 0.5),
          axis.text = element_text(size = 12),
          axis.title = element_text(size = 12),
          legend.position = "top"
        )
      
      ggplotly(p, tooltip = "text") %>%
        layout(
          margin = list(l = 20, r = 20, t = 40, b = 20),
          legend = list(orientation = "h", y = 1.1)
        )
    })
    
  })
}