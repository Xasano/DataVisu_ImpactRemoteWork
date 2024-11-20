# Charger les bibliothèques nécessaires
library(shiny)
library(plotly)
library(dplyr)
library(ggplot2)
library(shinydashboard)
library(shinyjs)
library(fresh)

# Charger les composants UI et fonctions globales
source("R/ui_components.R")
source("global.R")
# Source des modules
source("modules/sunburst/module_ui.R")
source("modules/sunburst/module_server.R")
source("modules/sunburst/module_uibis.R")
source("modules/sunburst/module_serverbis.R")
source("modules/barchart/module_ui.R")
source("modules/barchart/module_server.R")
source("modules/parallelset/module_ui.R")
source("modules/parallelset/module_server.R")
source("modules/parallelset/module_serverbis.R")
source("modules/parallelset/module_uibis.R")

# Source du dashboard principal
source("dashboard/ui.R")
source("dashboard/server.R")

# Lancer l'application
shinyApp(ui = dashboardUI, server = dashboardServer)