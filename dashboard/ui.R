dashboardUI <- dashboardPage(
  skin = "blue",
  dashboardHeader(
    title = span(
      tags$img(src = "https://cdn-icons-png.flaticon.com/512/1786/1786971.png", 
               height = "30px", 
               style = "margin-right: 10px;"),
      "Télétravail & Santé Mentale"
    ),
    titleWidth = 300
  ),
  
  dashboardSidebar(
    width = 240,
    sidebarMenu(
      id = "sidebar_menu",
      menuItem("Vue d'ensemble", tabName = "overview", icon = icon("dashboard")),
      menuItem("Santé Mentale", tabName = "sunburst", icon = icon("brain")),
      menuItem("Relations", tabName = "parallelset", icon = icon("project-diagram")),
      menuItem("Distribution Horaire", tabName = "barchart", icon = icon("clock")),
      menuItem("Hiérarchie des Soins", tabName = "circularPacking", icon = icon("medkit"))
      menuItem("Activité Physique", tabName = "multiplesBarChart", icon = icon("running"))
    )
  ),
  
  dashboardBody(
    useShinyjs(),
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "css/custom.css"),
      tags$style(HTML("
        .row {
          margin-left: -5px;
          margin-right: -5px;
          margin-bottom: 10px;
        }
        .col-sm-6 {
          padding-left: 5px;
          padding-right: 5px;
        }
        .vis-card {
          height: 480px !important;
          margin-bottom: 10px !important;
        }
        .filter-bar {
          background: white;
          padding: 15px;
          border-radius: 8px;
          box-shadow: 0 2px 10px rgba(0,0,0,0.05);
          margin-bottom: 20px;
        }
      "))
    ),
    
    tabItems(
      # Vue d'ensemble
      tabItem(
        tabName = "overview",
        
        # Barre de filtres globaux
        div(class = "filter-bar",
          fluidRow(
            column(
              width = 3,
              selectInput(
                "global_region",
                "Région",
                choices = NULL,
                selected = "Europe",
                width = "100%"
              )
            )
          )
        ),
        
        # Première rangée
        fluidRow(
          column(
            width = 6,
            div(class = "vis-card",
              style = "height: 450px; margin-bottom: 20px;",
              div(class = "vis-content",
                style = "position: relative;",
                sunburstUIbis("overview_sunburst"),
                div(
                  style = "position: absolute; bottom: 10px; right: 15px;",
                  actionLink("goto_sunburst", 
                          HTML("Explorer →"),
                          class = "explore-btn")
                )
              )
            )
          ),
          
          column(
            width = 6,
            div(class = "vis-card",
              style = "height: 450px; margin-bottom: 20px;",
              div(class = "vis-content",
                style = "position: relative;",
                circularPackingUIBis("circularPackingBis"),
                div(
                  style = "position: absolute; bottom: 10px; right: 15px;",
                  actionLink("goto_circular", 
                          HTML("Explorer →"),
                          class = "explore-btn")
                )
              )
            )
          )
        ),

        # Deuxième rangée
        fluidRow(
          column(
            width = 6,
            div(class = "vis-card",
              style = "height: 450px;",
              div(class = "vis-content",
                style = "position: relative;",
                parallelsetUIbis("overview_parallel"),
                div(
                  style = "position: absolute; bottom: 10px; right: 15px;",
                  actionLink("goto_parallel", 
                          HTML("Explorer →"),
                          class = "explore-btn")
                )
              )
            )
          ),
          
          column(
            width = 6,
            div(class = "vis-card",
              style = "height: 450px;",
              div(class = "vis-content",
                style = "position: relative;",
                barchartUIbis("overview_barchart"),
                div(
                  style = "position: absolute; bottom: 10px; right: 15px;",
                  actionLink("goto_barchart", 
                          HTML("Explorer →"),
                          class = "explore-btn")
                )
              )
            )
          )
        )
      ),
      
      # Vues détaillées
      tabItem(tabName = "sunburst",
        div(class = "vis-cardbis",
          div(class = "vis-contentbis",
            sunburstUI("sunburst")
          )
        )
      ),
      
      tabItem(tabName = "parallelset",
        div(class = "vis-cardbis",
          div(class = "vis-contentbis",
            parallelsetUI("parallelset")
          )
        )
      ),
      
      tabItem(tabName = "barchart",
        div(class = "vis-cardbis",
          div(class = "vis-contentbis",
            barchartUI("barchart")
          )
        )
      ),

      tabItem(tabName = "circularPacking",
        div(class = "vis-cardbis",
          div(class = "vis-contentbis",
            circularPackingUI("circularPacking")
          )
        )
      )
    )
  )
)