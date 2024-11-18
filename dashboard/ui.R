dashboardUI <- dashboardPage(
  skin = "blue",
  
  # Header
  dashboardHeader(
    title = span(
      tags$img(src = "https://cdn-icons-png.flaticon.com/512/1786/1786971.png", 
               height = "30px", 
               style = "margin-right: 10px;"),
      "Télétravail & Santé Mentale"
    ),
    titleWidth = 300
  ),
  
  # Sidebar
  dashboardSidebar(
    width = 240,
    tags$style(".logo {background-color: #2C3E50 !important;}"),
    
    # Menu de la sidebar avec les id corrects
    sidebarMenu(
      id = "sidebar_menu",  # Important : ajout de l'id
      menuItem(
        "Accueil",
        tabName = "home",
        icon = icon("home")
      ),
      menuItem(
        "Santé Mentale (Sunburst)",
        tabName = "sunburst",
        icon = icon("chart-pie")
      ),
      menuItem(
        "Répartition Géographique",
        tabName = "technique2",
        icon = icon("globe")
      ),
      menuItem(
        "Analyse Productivité",
        tabName = "technique3",
        icon = icon("chart-line")
      ),
      menuItem(
        "Analyse par Âge",
        tabName = "technique4",
        icon = icon("users")
      ),
      menuItem(
        "Équilibre Travail-Vie",
        tabName = "technique5",
        icon = icon("balance-scale")
      )
    )
  ),
  
  # Body
  dashboardBody(
    useShinyjs(),
    # Inclure les styles personnalisés
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "css/custom.css"),
      tags$script(src = "js/custom.js")
    ),
    
    # Contenu des onglets
    tabItems(
      # Onglet Accueil
      tabItem(
        tabName = "home",
        fluidRow(
          box(
            width = 12,
            title = "Impact du Télétravail sur la Santé Mentale et la Productivité",
            status = "primary",
            solidHeader = TRUE,
            
            # Contenu de la page d'accueil
            div(
              class = "welcome-content",
              style = "padding: 20px;",
              h3("Objectif de l'étude", 
                 class = "text-primary", 
                 style = "margin-bottom: 20px; font-weight: 300;"),
              p("Cette étude vise à explorer l'impact du télétravail sur la santé mentale 
                et la productivité des employés à travers une analyse approfondie utilisant 
                différentes techniques de visualisation.", 
                style = "font-size: 16px; line-height: 1.6;")
            )
          )
        ),
        
        # Statistiques globales
        fluidRow(
          uiOutput("stats_summary")
        )
      ),
      
      # Onglet Sunburst
      tabItem(
        tabName = "sunburst",
        sunburstUI("sunburst")
      ),
      
      # Autres onglets
      tabItem(
        tabName = "technique2",
        h2("Répartition Géographique - En développement")
      ),
      
      tabItem(
        tabName = "technique3",
        h2("Analyse de Productivité - En développement")
      ),
      
      tabItem(
        tabName = "technique4",
        h2("Analyse par Âge - En développement")
      ),
      
      tabItem(
        tabName = "technique5",
        h2("Équilibre Travail-Vie - En développement")
      )
    )
  )
)