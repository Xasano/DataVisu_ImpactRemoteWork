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
source("R/utils.R")
source("R/data_processing.R")

# Source des modules
source("modules/sunburst/module_ui.R")
source("modules/sunburst/module_server.R")

# Source du dashboard principal
source("dashboard/ui.R")
source("dashboard/server.R")

# Lancer l'application
shinyApp(ui = dashboardUI, server = dashboardServer)