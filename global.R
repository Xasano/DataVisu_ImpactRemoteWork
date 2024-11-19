# Chargement des packages nécessaires
library(shiny)
library(shinydashboard)
library(plotly)
library(DT)
library(dplyr)
library(data.table)
library(shinyjs)
library(tidyr)
library(bslib)

# Configuration globale
options(shiny.maxRequestSize = 30 * 1024^2)
options(shiny.fullstacktrace = TRUE)

# Constantes
COLORS <- list(
  primary = "#007D9C",
  secondary = "#2C3E50",
  success = "#66BB6A",
  warning = "#FFB236",
  danger = "#FF6B6B"
)


# Fonctions utilitaires
format_number <- function(x) {
  format(x, big.mark = ",", scientific = FALSE)
}

calculate_percentage <- function(x, total) {
  paste0(round(x / total * 100, 1), "%")
}

# Couleurs pour les visualisations
MENTAL_HEALTH_COLORS <- list(
  "Anxiety" = "#FF6B6B",
  "Depression" = "#4A90E2",
  "Burnout" = "#FFB236",
  "Happy" = "#66BB6A"
)

WORK_LOCATION_COLORS <- list(
  "Remote" = "#4CAF50",
  "Office" = "#2196F3",
  "Hybrid" = "#FF9800"
)

# Fonction pour créer un graphique vide
empty_plot <- function(message) {
  plot_ly() %>% 
    layout(
      title = list(
        text = message,
        font = list(size = 16, color = "#666666")
      ),
      paper_bgcolor = 'rgba(0,0,0,0)',
      plot_bgcolor = 'rgba(0,0,0,0)'
    )
}