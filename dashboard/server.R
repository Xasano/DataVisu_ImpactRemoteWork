dashboardServer <- function(input, output, session) {
  # Chargement des données
  global_data <- reactive({
    withProgress(
      message = "Chargement des données...",
      detail = "Cette opération peut prendre quelques instants",
      value = 0,
      {
        tryCatch({
          data <- read_and_process_data("Impact_of_Remote_Work_on_Mental_Health.csv")
          return(data)
        }, error = function(e) {
          showNotification(paste("Erreur de chargement:", e$message), 
                         type = "error", duration = NULL)
          return(NULL)
        })
      }
    )
  })

  # Mise à jour des choix du filtre région
  observe({
    req(global_data())
    updateSelectInput(session, "global_region",
                     choices = sort(unique(global_data()$Region)),
                     selected = "Europe")
  })

  # Données filtrées pour le dashboard uniquement
  filtered_dashboard_data <- reactive({
    req(global_data(), input$global_region)
    global_data() %>%
      filter(Region == input$global_region)
  })

  # Initialisation des modules du dashboard avec données filtrées
  sunburstServerbis("overview_sunburst", reactive(list(data = filtered_dashboard_data())))
  parallelsetServerbis("overview_parallel", reactive(list(data = filtered_dashboard_data())))
  barchartServerbis("overview_barchart", reactive(list(data = filtered_dashboard_data())))
  circularPackingServerBis("circularPackingBis", reactive(list(data = filtered_dashboard_data())))
  multiplesBarChartServerBis("multiplesBarChartBis", reactive(list(data = filtered_dashboard_data())))
  
  # Initialisation des modules détaillés avec données complètes
  sunburstServer("sunburst", reactive(list(data = global_data())))
  parallelsetServer("parallelset", reactive(list(data = global_data())))
  barchartServer("barchart", reactive(list(data = global_data())))
  circularPackingServer("circularPacking", reactive(list(data = global_data())))
  multiplesBarChartServer("multiplesBarChart", reactive(list(data = global_data())))

  # Navigation
  observeEvent(input$goto_sunburst, {
    updateTabItems(session, "sidebar_menu", "sunburst")
  })

  observeEvent(input$goto_parallel, {
    updateTabItems(session, "sidebar_menu", "parallelset")
  })

  observeEvent(input$goto_barchart, {
    updateTabItems(session, "sidebar_menu", "barchart")
  })

  observeEvent(input$goto_circular, {
    updateTabItems(session, "sidebar_menu", "circularPacking")
  })

  observeEvent(input$goto_multiplesBarChart, {
    updateTabItems(session, "sidebar_menu", "multiplesBarChart")
  })
}
