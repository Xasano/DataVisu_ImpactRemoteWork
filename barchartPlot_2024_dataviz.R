# Load necessary packages
library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)  # For interactive tooltips

# Load data
data <- read.csv("C:/Users/allay/Documents/projetDataVizualisation_2024/Impact_of_Remote_Work_on_Mental_Health.csv")

# User interface
ui <- fluidPage(
  titlePanel("Distribution des employés par intervalle d'heures travaillées et niveau de satisfaction"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("hoursRange", "Sélectionnez la plage d'heures travaillées:",
                  min = min(data$Hours_Worked_Per_Week, na.rm = TRUE),
                  max = max(data$Hours_Worked_Per_Week, na.rm = TRUE),
                  value = c(min(data$Hours_Worked_Per_Week, na.rm = TRUE), max(data$Hours_Worked_Per_Week, na.rm = TRUE)),
                  step = 1),
      
      sliderInput("satisfactionRange", "Sélectionnez le niveau de satisfaction:",
                  min = 1, max = 5, value = c(1, 5), step = 1),
      
      actionButton("generate", "Générer le graphique"),
      downloadButton("downloadPlot", "Télécharger le graphique")
    ),
    
    mainPanel(
      plotlyOutput("barChart", height = "600px")
    )
  )
)

# Server function
server <- function(input, output) {
  
  # Reactive expression to filter data
  filtered_data <- reactive({
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
        
        # Use descriptive labels for hours worked intervals
        Hours_Interval = case_when(
          Hours_Worked_Per_Week >= 50 ~ "50-60",
          Hours_Worked_Per_Week >= 40 ~ "40-50",
          Hours_Worked_Per_Week >= 30 ~ "30-40",
          Hours_Worked_Per_Week >= 20 ~ "20-30",
          TRUE ~ "<20"
        )
      )
  })
  
  # Generate the bar chart
  output$barChart <- renderPlotly({
    req(input$generate)  # Wait for button click
    
    data_summary <- filtered_data() %>%
      group_by(Hours_Interval, Work_Life_Balance_Rating) %>%
      summarize(Employee_Count = n(), .groups = "drop")
    
    # Create the bar chart with Plotly for interactivity
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
        axis.text.y = element_text(size = 12),  # Make y-axis text larger for readability
        axis.title = element_text(size = 12),
        legend.position = "right"
      )
    
    ggplotly(p, tooltip = "text")  # Add tooltips for exact count
  })
  
  # Download the plot as a PNG
  output$downloadPlot <- downloadHandler(
    filename = function() { paste("employee_distribution", Sys.Date(), ".png", sep = "") },
    content = function(file) {
      ggsave(file, plot = last_plot(), device = "png")
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)

