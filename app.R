# Charger les bibliothèques nécessaires
library(shiny)
library(plotly)
library(dplyr)
library(ggplot2)
library(shinydashboard)
library(shinyjs)
library(fresh)
library(DT)
library(data.table)
library(tidyr)
library(bslib)
library(igraph)
library(ggraph)
library(ggrepel)
library(forcats)

# Configuration globale
options(shiny.maxRequestSize = 30 * 1024^2)
options(shiny.fullstacktrace = TRUE)

# Charger les composants UI et fonctions globales
source("R/ui_components.R")
# Source des modules
source("modules/sunburst/module_ui.R")
source("modules/sunburst/module_server.R")
source("modules/sunburst/module_uibis.R")
source("modules/sunburst/module_serverbis.R")
source("modules/circularPacking/module_ui.R")
source("modules/circularPacking/module_server.R")
source("modules/circularPacking/module_uibis.R")
source("modules/circularPacking/module_serverbis.R")
source("modules/barchart/module_ui.R")
source("modules/barchart/module_server.R")
source("modules/barchart/module_uibis.R")
source("modules/barchart/module_serverbis.R")
source("modules/parallelset/module_ui.R")
source("modules/parallelset/module_server.R")
source("modules/parallelset/module_serverbis.R")
source("modules/parallelset/module_uibis.R")
source("modules/multiplesBarChart/module_ui.R")
source("modules/multiplesBarChart/module_server.R")
source("modules/multiplesBarChart/module_uibis.R")
source("modules/multiplesBarChart/module_serverbis.R")

# Source du dashboard principal
source("dashboard/ui.R")
source("dashboard/server.R")

# Lancer l'application
shinyApp(ui = dashboardUI, server = dashboardServer)