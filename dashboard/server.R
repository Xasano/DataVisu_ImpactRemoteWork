dashboardServer <- function(input, output, session) {
  # Création d'un reactive value pour stocker l'état global
  app_state <- reactiveValues(
    current_tab = "home",
    data_loaded = FALSE,
    last_update = Sys.time(),
    error_message = NULL
  )
  
  # Chargement initial des données globales
  global_data <- reactive({
    withProgress(
      message = "Chargement des données...",
      detail = "Cette opération peut prendre quelques instants",
      value = 0,
      {
        tryCatch({
          data <- read_and_process_data("Impact_of_Remote_Work_on_Mental_Health.csv")
          app_state$data_loaded <- TRUE
          app_state$last_update <- Sys.time()
          return(data)
        }, error = function(e) {
          app_state$error_message <- paste("Erreur de chargement:", e$message)
          return(NULL)
        })
      }
    )
  })
  
  # Gestionnaire d'onglets
  observeEvent(input$sidebar_menu, {
    app_state$current_tab <- input$sidebar_menu
    
    # Mise à jour du titre de la page
    tab_titles <- list(
      home = "Accueil",
      sunburst = "Analyse de la Santé Mentale",
      technique2 = "Répartition Géographique",
      technique3 = "Analyse de Productivité",
      technique4 = "Analyse par Âge",
      technique5 = "Équilibre Travail-Vie"
    )
    
    updateQueryString(
      queryString = paste0("?tab=", app_state$current_tab),
      mode = "push"
    )
    
    # Notification lors du changement d'onglet
    showNotification(
      paste("Chargement de", tab_titles[[app_state$current_tab]]),
      type = "message",
      duration = 2
    )
  })
  
  # Gestion des erreurs globales
  observe({
    if (!is.null(app_state$error_message)) {
      showNotification(
        app_state$error_message,
        type = "error",
        duration = NULL,
        id = "error_notification"
      )
      app_state$error_message <- NULL
    }
  })
  
  # Initialisation du module Home
  homeServer(
    "home",
    reactive({
      list(
        data = global_data(),
        data_loaded = app_state$data_loaded,
        last_update = app_state$last_update
      )
    })
  )
  
  # Initialisation du module Sunburst
  sunburstServer(
    "sunburst",
    reactive({
      list(
        data = global_data(),
        current_tab = app_state$current_tab == "sunburst"
      )
    })
  )
  
  # Gestion des statistiques globales
  output$stats_summary <- renderUI({
    req(global_data())
    data <- global_data()
    
    fluidRow(
      class = "stats-container",
      column(
        width = 3,
        valueBox(
          value = formatC(nrow(data), format = "d", big.mark = ","),
          subtitle = "Employés Total",
          icon = icon("users"),
          color = "blue",
          width = 12
        )
      ),
      column(
        width = 3,
        valueBox(
          value = paste0(round(mean(data$Work_Location == "Remote") * 100, 1), "%"),
          subtitle = "Travail à Distance",
          icon = icon("laptop-house"),
          color = "green",
          width = 12
        )
      ),
      column(
        width = 3,
        valueBox(
          value = paste0(round(mean(data$Mental_Health_Condition != "Happy") * 100, 1), "%"),
          subtitle = "Problèmes de Santé Mentale",
          icon = icon("brain"),
          color = "red",
          width = 12
        )
      ),
      column(
        width = 3,
        valueBox(
          value = round(mean(as.numeric(factor(data$Stress_Level))), 2),
          subtitle = "Niveau de Stress Moyen",
          icon = icon("chart-line"),
          color = "yellow",
          width = 12
        )
      )
    )
  })
  
  # Gestionnaire de téléchargement des données
  output$download_data <- downloadHandler(
    filename = function() {
      paste("mental_health_analysis_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      req(global_data())
      write.csv(global_data(), file, row.names = FALSE)
    }
  )
  
  # Nettoyage de la mémoire
  observe({
    if (app_state$current_tab != "sunburst") {
      gc()
    }
  })
  
  # Gestionnaire de fin de session
  session$onSessionEnded(function() {
    gc()
  })
  
  # Retour des réactifs pour les tests et le debugging
  return(
    list(
      app_state = app_state,
      global_data = global_data
    )
  )
}