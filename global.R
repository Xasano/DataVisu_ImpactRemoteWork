# Chargement des packages nécessaires
library(shiny)
library(shinydashboard)  # Pour dashboardPage et autres composants dashboard
library(plotly)          # Pour les visualisations
library(dplyr)          # Pour la manipulation de données
library(data.table)     # Pour l'optimisation des données
library(fresh)          # Pour la personnalisation du thème
library(shinyjs)        # Pour les interactions JavaScript
library(ggplot2)        # Pour les graphiques

# Configuration de base de Shiny
options(shiny.maxRequestSize = 30 * 1024^2)  # Limite de 30MB pour les fichiers
options(shiny.fullstacktrace = TRUE)         # Pour le debugging
options(shiny.reactlog = TRUE)               # Pour le debugging

# Définition des couleurs globales pour l'application
MENTAL_HEALTH_COLORS <- list(
  "Anxiety" = "#FF6B6B",     # Rouge
  "Depression" = "#4A90E2",   # Bleu
  "Burnout" = "#FFB236",     # Orange
  "Happy" = "#66BB6A"        # Vert
)

# Configuration des groupes d'âge
AGE_GROUPS <- c("22-30", "31-40", "41-50", "50+")

# Création du thème personnalisé
app_theme <- create_theme(
  adminlte_color(
    light_blue = "#007D9C",
    red = "#FF6B6B",
    green = "#66BB6A",
    yellow = "#FFB236"
  ),
  adminlte_sidebar(
    width = "240px",
    dark_bg = "#2C3E50",
    dark_hover_bg = "#34495E",
    dark_color = "#ECF0F1"
  ),
  adminlte_global(
    content_bg = "#F8F9FA",
    box_bg = "#FFFFFF",
    info_box_bg = "#FFFFFF"
  )
)