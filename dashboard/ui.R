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
    tags$style(HTML("
      .logo {background-color: #2C3E50 !important;}
      .sidebar-menu > li.active > a {
        background-color: #3c8dbc !important;
        border-left-color: #2C3E50 !important;
      }
    ")),
    sidebarMenu(
      id = "sidebar_menu",
      menuItem("Vue d'ensemble", tabName = "overview", icon = icon("dashboard")),
      menuItem("Santé Mentale", tabName = "sunburst", icon = icon("brain")),
      menuItem("Relations", tabName = "parallelset", icon = icon("project-diagram")),
      menuItem("Distribution Horaire", tabName = "barchart", icon = icon("clock"))
    )
  ),
  
  dashboardBody(
    useShinyjs(),
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "css/custom.css"),
      tags$script(src = "js/custom.js"),
      tags$style(HTML("
        /* Style global */
        .content-wrapper { 
          background-color: #f4f6f9; 
          padding: 20px;
        }
        
        /* Style des cartes de visualisation */
        .vis-card {
          background: white;
          border-radius: 8px;
          box-shadow: 0 2px 10px rgba(0,0,0,0.1);
          margin-bottom: 20px;
          height: calc(100vh - 100px);
          display: flex;
          flex-direction: column;
        }
        
        /* En-têtes personnalisés */
        .vis-header-mental {
          background: linear-gradient(135deg, #3498db, #2980b9);
          color: white;
          padding: 15px;
          border-radius: 8px 8px 0 0;
        }
        
        .vis-header-relations {
          background: linear-gradient(135deg, #2ecc71, #27ae60);
          color: white;
          padding: 15px;
          border-radius: 8px 8px 0 0;
        }
        
        .vis-header-time {
          background: linear-gradient(135deg, #9b59b6, #8e44ad);
          color: white;
          padding: 15px;
          border-radius: 8px 8px 0 0;
        }
        
        .vis-content {
          flex: 1;
          padding: 20px;
          overflow: hidden;
          position: relative;
        }
        
        /* Style optimisé pour les filtres */
        .filter-sidebar {
          position: absolute;
          left: 0;
          top: 0;
          width: 200px;
          padding: 10px;
          background: rgba(255,255,255,0.9);
          border-radius: 0 0 8px 0;
          box-shadow: 2px 2px 5px rgba(0,0,0,0.1);
          z-index: 1000;
        }
        
        /* Style des visualisations */
        .visualization-container {
          height: 100%;
          width: 100%;
        }
        
        /* Footer avec bouton Explorer */
        .vis-footer {
          padding: 10px 15px;
          border-top: 1px solid #eee;
          text-align: right;
        }
        
        .explore-btn {
          color: #3498db;
          text-decoration: none;
          transition: all 0.3s ease;
        }
        
        .explore-btn:hover {
          color: #2980b9;
          transform: translateX(5px);
        }
      "))
    ),
    
    tabItems(
      # Vue d'ensemble
      tabItem(
        tabName = "overview",
        fluidRow(
          column(
            width = 4,
            div(class = "vis-card",
              div(class = "vis-content",
                sunburstUI("overview_sunburst")
              ),
              div(class = "vis-footer",
                actionLink("goto_sunburst", 
                         HTML("Explorer en détail <i class='fa fa-arrow-right ml-2'></i>"),
                         class = "explore-btn")
              )
            )
          ),
          column(
            width = 4,
            div(class = "vis-card",
              div(class = "vis-content",
                parallelsetUI("overview_parallel")
              ),
              div(class = "vis-footer",
                actionLink("goto_parallel", 
                         HTML("Explorer en détail <i class='fa fa-arrow-right ml-2'></i>"),
                         class = "explore-btn")
              )
            )
          ),
          column(
            width = 4,
            div(class = "vis-card",
              div(class = "vis-content",
                barchartUI("overview_barchart")
              ),
              div(class = "vis-footer",
                actionLink("goto_barchart", 
                         HTML("Explorer en détail <i class='fa fa-arrow-right ml-2'></i>"),
                         class = "explore-btn")
              )
            )
          )
        )
      ),
      
      # Vue détaillée Sunburst
      tabItem(
        tabName = "sunburst",
        div(class = "vis-card",
          div(class = "vis-content",
            sunburstUI("sunburst")
          )
        )
      ),
      
      # Vue détaillée Parallelset
      tabItem(
        tabName = "parallelset",
        div(class = "vis-card",
          div(class = "vis-content",
            parallelsetUI("parallelset")
          )
        )
      ),
      
      # Vue détaillée Distribution Horaire
      tabItem(
        tabName = "barchart",
        div(class = "vis-card",
          div(class = "vis-content",
            barchartUI("barchart")
          )
        )
      )
    )
  )
)