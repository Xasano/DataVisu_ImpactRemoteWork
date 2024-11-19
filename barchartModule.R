library(ggplot2)
library(dplyr)
library(plotly)

barchartModuleServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    
    # Données filtrées
    filtered_data <- reactive({
      req(data)
      data %>%
        filter(
          Hours_Worked_Per_Week >= input$hoursRange[1],
          Hours_Worked_Per_Week <= input$hoursRange[2],
          as.numeric(Work_Life_Balance_Rating) >= input$satisfactionRange[1],
          as.numeric(Work_Life_Balance_Rating) <= input$satisfactionRange[2]
        ) %>%
        mutate(
          Work_Life_Balance_Rating = factor(as.numeric(Work_Life_Balance_Rating),
                                            levels = 1:5,
                                            labels = c("Très Faible", "Faible", "Moyen", "Bon", "Excellent")),
          
          Hours_Interval = factor(case_when(
            Hours_Worked_Per_Week >= 51 ~ "51-60",
            Hours_Worked_Per_Week >= 41 ~ "41-50",
            Hours_Worked_Per_Week >= 31 ~ "31-40",
            Hours_Worked_Per_Week >= 21 ~ "21-30",
            TRUE ~ "0-20"
          ), levels = c("0-20", "21-30", "31-40", "41-50", "51-60"))
        )
    })
    
    # Graphique principal
    output$barChart <- renderPlotly({
      req(filtered_data())
      data_summary <- filtered_data() %>%
        group_by(Hours_Interval, Work_Life_Balance_Rating) %>%
        summarize(Employee_Count = n(), .groups = "drop")
      
      p <- ggplot(data_summary, aes(x = Employee_Count, y = Hours_Interval, fill = Work_Life_Balance_Rating, text = paste("Nombre d'employés:", Employee_Count))) +
        geom_bar(stat = "identity", position = "stack", color = "black") +
        scale_fill_manual(values = c("Très Faible" = "#FF4C4C", "Faible" = "#FFA500", 
                                     "Moyen" = "#FFD700", "Bon" = "#ADFF2F", "Excellent" = "#32CD32")) +
        labs(
          title = "Distribution des employés par intervalle d'heures travaillées et niveau de satisfaction",
          x = "Nombre d'employés",
          y = "Intervalle d'heures travaillées par semaine",
          fill = "Niveau de satisfaction"
        ) +
        theme_minimal() +
        theme(
          plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
          axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          axis.text.y = element_text(size = 12),
          axis.title = element_text(size = 12),
          legend.position = "right"
        )
      
      ggplotly(p, tooltip = "text")
    })
    
    # Téléchargement du graphique
    output$downloadPlot <- downloadHandler(
      filename = function() { paste("employee_distribution", Sys.Date(), ".png", sep = "") },
      content = function(file) {
        ggsave(file, plot = last_plot(), device = "png")
      }
    )
  })
}
