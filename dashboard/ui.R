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
        
        # Première rangée avec 3 visualisations
        fluidRow(
          # Sunburst (1/3 de la largeur)
          column(
            width = 4,
            div(class = "vis-card",
              style = "height: 400px;",
              div(class = "vis-content",
                sunburstUIbis("overview_sunburst")
              ),
              div(class = "vis-footer",
                actionLink("goto_sunburst", 
                        HTML("Explorer <i class='fa fa-arrow-right ml-2'></i>"),
                        class = "explore-btn")
              )
            )
          ),
          
          # Circular Packing (1/3 de la largeur)
          column(width = 4,
            div(class = "vis-card",
              style = "height: 400px;",
              div(class = "vis-content",
                circularPackingUIBis("circularPackingBis")
              ),
              div(class = "vis-footer",
                actionLink("goto_circular", 
                        HTML("Explorer <i class='fa fa-arrow-right ml-2'></i>"),
                        class = "explore-btn")
              )
            )
          ),

          # Placeholder (1/3 de la largeur)
          column(width = 4)
        ),
        
        # Deuxième rangée avec parallel set et barchart
        fluidRow(
          # Parallel set
          column(
            width = 6,
            div(class = "vis-card",
              style = "height: 500px;",
              div(class = "vis-content",
                parallelsetUIbis("overview_parallel")
              ),
              div(class = "vis-footer",
                actionLink("goto_parallel", 
                        HTML("Explorer <i class='fa fa-arrow-right ml-2'></i>"),
                        class = "explore-btn")
              )
            )
          ),
          
          # Barchart
          column(
            width = 6,
            div(class = "vis-card",
              style = "height: 500px;",
              div(class = "vis-content",
                barchartUIbis("overview_barchart")
              ),
              div(class = "vis-footer",
                actionLink("goto_barchart", 
                        HTML("Explorer <i class='fa fa-arrow-right ml-2'></i>"),
                        class = "explore-btn")
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