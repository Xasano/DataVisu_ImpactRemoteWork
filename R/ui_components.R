#' Crée un groupe de filtres collapsible
#' @param id Identifiant unique du groupe
#' @param title Titre du groupe
#' @param icon_name Nom de l'icône FontAwesome
#' @return Un élément UI Shiny
filterGroupUI <- function(id, title, icon_name) {
  div(
    class = "filter-group",
    div(
      class = "filter-header",
      `data-toggle` = "collapse",
      `data-target` = paste0("#", id, "-content"),
      style = "cursor: pointer; padding: 10px; background: #f8f9fa; border-radius: 4px; display: flex; justify-content: space-between; align-items: center;",
      tags$span(
        icon(icon_name), 
        title,
        style = "font-weight: 500; color: #2C3E50;"
      ),
      icon("chevron-down", class = "toggle-icon")
    ),
    div(
      id = paste0(id, "-content"),
      class = "filter-content collapse",
      style = "padding: 15px 10px 5px 10px;",
      checkboxGroupInput(
        id,
        label = NULL,
        choices = NULL
      )
    )
  )
}

#' Crée une légende personnalisée pour le graphique
#' @param id Identifiant unique de la légende
#' @return Un élément UI Shiny
customLegendUI <- function(id) {
  div(
    class = "custom-legend",
    style = "
      display: flex;
      justify-content: center;
      gap: 20px;
      margin-top: 20px;
      padding: 10px;
      background: #f8f9fa;
      border-radius: 4px;
    ",
    # Anxiety
    div(
      style = "display: flex; align-items: center; gap: 8px;",
      div(style = "width: 20px; height: 20px; background-color: #FF6B6B; border-radius: 4px;"),
      span("Anxiety", style = "color: #2C3E50;")
    ),
    # Depression
    div(
      style = "display: flex; align-items: center; gap: 8px;",
      div(style = "width: 20px; height: 20px; background-color: #4A90E2; border-radius: 4px;"),
      span("Depression", style = "color: #2C3E50;")
    ),
    # Burnout
    div(
      style = "display: flex; align-items: center; gap: 8px;",
      div(style = "width: 20px; height: 20px; background-color: #FFB236; border-radius: 4px;"),
      span("Burnout", style = "color: #2C3E50;")
    ),
    # Happy
    div(
      style = "display: flex; align-items: center; gap: 8px;",
      div(style = "width: 20px; height: 20px; background-color: #66BB6A; border-radius: 4px;"),
      span("Happy", style = "color: #2C3E50;")
    )
  )
}

#' Lecture et prétraitement des données
#' @param file_path Chemin vers le fichier CSV
read_and_process_data <- function(file_path) {
  if (!file.exists(file_path)) {
    stop("Le fichier de données n'existe pas")
  }
  
  df <- read.csv(file_path, stringsAsFactors = FALSE)
  
  # Remplacer "None" par "Happy" dans Mental_Health_Condition
  df$Mental_Health_Condition[df$Mental_Health_Condition == "None"] <- "Happy"
  
  # Créer les groupes d'âge
  df$age_group <- case_when(
    df$Age <= 30 ~ "22-30",
    df$Age <= 40 ~ "31-40",
    df$Age <= 50 ~ "41-50",
    TRUE ~ "50+"
  )
  
  return(df)
}


