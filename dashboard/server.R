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

  # Initialisation des modules pour la vue d'ensemble
  sunburstServer("overview_sunburst", reactive(list(data = global_data())))
  parallelsetServer("overview_parallel", reactive(list(data = global_data())))
  barchartServer("overview_barchart", reactive(list(data = global_data())))

  # Initialisation des modules pour les vues détaillées
  sunburstServer("sunburst", reactive(list(data = global_data())))
  parallelsetServer("parallelset", reactive(list(data = global_data())))
  barchartServer("barchart", reactive(list(data = global_data())))

  # Navigation vers les détails
  observeEvent(input$goto_sunburst, {
    updateTabItems(session, "sidebar_menu", "sunburst")
  })

  observeEvent(input$goto_parallel, {
    updateTabItems(session, "sidebar_menu", "parallelset")
  })

  observeEvent(input$goto_barchart, {
    updateTabItems(session, "sidebar_menu", "barchart")
  })
}