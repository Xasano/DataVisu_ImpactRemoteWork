#install.packages("shiny")
#install.packages("bslib")
#install.packages("dplyr")
#install.packages("plotly")

library(shiny)
library(bslib)
library(dplyr)
library(plotly)

ui <- page_fluid(
  fluidRow(
    column(3,
           selectInput("region", "Region", choices = NULL)
    ),
    column(9,
           plotlyOutput("plot", height = "600px")
    )
  )
)

server <- function(input, output, session) {
  data <- reactive({
    csv <- read.csv("Impact_of_Remote_Work_on_Mental_Health.csv",
                    header = TRUE, 
                    sep = ",", 
                    dec = ".",
                    stringsAsFactors = TRUE)
    
    csv$Stress_Level <- factor(csv$Stress_Level, 
                              levels = c("High", "Medium", "Low"))
    csv
  })
  
  observe({
    updateSelectInput(session, "region",
                     choices = unique(data()$Region))
  })
  
  plot_data <- reactive({
    req(input$region)
    
    df <- data() %>%
      filter(Region == input$region) %>%
      select(Work_Location, Stress_Level, Mental_Health_Condition)
    
    # Calculer les positions pour chaque colonne
    calculate_positions <- function(data, group_col) {
      counts <- data %>%
        count(!!sym(group_col)) %>%
        arrange(desc(n)) %>%
        mutate(
          y_start = lag(cumsum(n), default = 0),
          y_end = cumsum(n),
          y_center = (y_start + y_end) / 2,
          height = n
        )
      return(counts)
    }
    
    # Calculer les positions pour chaque groupe
    work_location_pos <- calculate_positions(df, "Work_Location")
    stress_level_pos <- calculate_positions(df, "Stress_Level")
    mental_health_pos <- calculate_positions(df, "Mental_Health_Condition")
    
    # Calculer le maximum global pour l'échelle
    total_height <- max(c(
      sum(work_location_pos$height),
      sum(stress_level_pos$height),
      sum(mental_health_pos$height)
    ))
    
    # Créer les nœuds avec les positions exactes
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
    
    # Calculer les liens entre les nœuds
    links_work_to_stress <- df %>%
      group_by(Work_Location, Stress_Level) %>%
      summarise(value = n(), .groups = 'drop')
    
    links_stress_to_mental <- df %>%
      group_by(Stress_Level, Mental_Health_Condition) %>%
      summarise(value = n(), .groups = 'drop')
    
    # Ajouter les indices des nœuds aux liens
    links_work_to_stress$source <- match(links_work_to_stress$Work_Location, nodes$node) - 1
    links_work_to_stress$target <- match(links_work_to_stress$Stress_Level, nodes$node) - 1
    
    links_stress_to_mental$source <- match(links_stress_to_mental$Stress_Level, nodes$node) - 1
    links_stress_to_mental$target <- match(links_stress_to_mental$Mental_Health_Condition, nodes$node) - 1
    
    # Combiner les liens
    all_links <- rbind(
      links_work_to_stress %>% select(source, target, value),
      links_stress_to_mental %>% select(source, target, value)
    )
    
    list(
      nodes = nodes,
      links = all_links,
      total_height = total_height
    )
  })
  
  output$plot <- renderPlotly({
    req(plot_data())
    
    # Créer des graduations régulières pour l'axe y
    max_value <- plot_data()$total_height
    
    title_annotations <- list(
      list(
        x = 0,
        y = 1.05,
        xref = "paper",
        yref = "paper",
        text = "Work Location",
        showarrow = FALSE,
        font = list(size = 14)
      ),
      list(
        x = 0.5,
        y = 1.05,
        xref = "paper",
        yref = "paper",
        text = "Stress Level",
        showarrow = FALSE,
        font = list(size = 14)
      ),
      list(
        x = 1,
        y = 1.05,
        xref = "paper",
        yref = "paper",
        text = "Mental Health",
        showarrow = FALSE,
        font = list(size = 14)
      )
    )
    
    # Créer le graphique Sankey
    plot_ly(
      type = "sankey",
      orientation = "h",
      
      node = list(
        label = paste0(plot_data()$nodes$node, 
                      "<br>Count: ", plot_data()$nodes$count),
        x = plot_data()$nodes$x,
        y = plot_data()$nodes$y / max_value,
        pad = 10,
        thickness = plot_data()$nodes$count / max_value * 50,
        line = list(
          color = "black",
          width = 0.5
        ),
        color = colorRampPalette(c("#E6F3FF", "#2171B5"))(nrow(plot_data()$nodes))
      ),
      
      link = list(
        source = plot_data()$links$source,
        target = plot_data()$links$target,
        value = plot_data()$links$value,
        hoverlabel = list(
          bgcolor = "white",
          font = list(size = 10)
        )
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
}

shinyApp(ui = ui, server = server)