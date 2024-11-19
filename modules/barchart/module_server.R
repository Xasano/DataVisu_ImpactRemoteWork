barchartServer <- function(id, shared_data) {
  moduleServer(id, function(input, output, session) {
    
    # Données filtrées
    filtered_data <- reactive({
      req(shared_data()$data)
      
      data <- shared_data()$data %>%
        mutate(
          Hours_Worked_Per_Week = as.numeric(Hours_Worked_Per_Week),
          Work_Life_Balance_Rating = as.numeric(Work_Life_Balance_Rating)
        ) %>%
        filter(
          Hours_Worked_Per_Week >= input$hoursRange[1],
          Hours_Worked_Per_Week <= input$hoursRange[2],
          Work_Life_Balance_Rating >= input$satisfactionRange[1],
          Work_Life_Balance_Rating <= input$satisfactionRange[2]
        ) %>%
        mutate(
          Work_Life_Balance_Rating = factor(
            Work_Life_Balance_Rating,
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
      
      return(data)
    })
    
    # Graphique principal
    output$barChart <- renderPlotly({
      req(input$generate, filtered_data())
      
      data_summary <- filtered_data() %>%
        group_by(Hours_Interval, Work_Life_Balance_Rating) %>%
        summarize(Employee_Count = n(), .groups = "drop")
      
      p <- ggplot(
        data_summary,
        aes(
          x = Employee_Count,
          y = Hours_Interval,
          fill = Work_Life_Balance_Rating,
          text = paste(
            "Nombre d'employés:", Employee_Count,
            "<br>Heures:", Hours_Interval,
            "<br>Satisfaction:", Work_Life_Balance_Rating
          )
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
          title = "Distribution des employés par heures travaillées",
          x = "Nombre d'employés",
          y = "Heures travaillées par semaine",
          fill = "Niveau de satisfaction"
        ) +
        theme_minimal() +
        theme(
          plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
          axis.text = element_text(size = 12),
          axis.title = element_text(size = 12),
          legend.position = "right"
        )
      
      ggplotly(p, tooltip = "text") %>%
        layout(hoverlabel = list(bgcolor = "white"))
    })
})
}