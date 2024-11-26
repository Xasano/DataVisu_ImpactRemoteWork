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
    )
  ),
  
  dashboardBody(
    useShinyjs(),
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "css/custom.css")
    ),
    
    tabItems(
      # Vue d'ensemble
      tabItem(
        tabName = "overview",
        
        # Première rangée avec 4 visualisations
        fluidRow(
          # Première rangée
          column(
            width = 6,
            div(class = "vis-card",
              style = "height: 450px; margin-bottom: 20px;", # Hauteur augmentée
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
              style = "height: 450px; margin-bottom: 20px;", # Hauteur augmentée
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
              style = "height: 450px;", # Hauteur augmentée
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
              style = "height: 450px;", # Hauteur augmentée
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
      
      # Autres onglets inchangés...
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