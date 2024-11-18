#' Fonction pour créer un graphique vide avec un message
#' @param message Le message à afficher
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

#' Mettre à jour tous les filtres
#' @param session Session Shiny
#' @param data Données complètes
updateFilters <- function(session, data) {
  updateCheckboxGroupInput(session, "mental_health",
                           choices = sort(unique(data$Mental_Health_Condition)),
                           selected = sort(unique(data$Mental_Health_Condition)))
  
  updateCheckboxGroupInput(session, "industry",
                           choices = sort(unique(data$Industry)),
                           selected = sort(unique(data$Industry)))
  
  updateCheckboxGroupInput(session, "job_role",
                           choices = sort(unique(data$Job_Role)),
                           selected = sort(unique(data$Job_Role)))
  
  updateCheckboxGroupInput(session, "age_group",
                           choices = AGE_GROUPS,
                           selected = AGE_GROUPS)
}

#' Sélectionner tous les filtres
#' @param session Session Shiny
#' @param data Données complètes
select_all_filters <- function(session, data) {
  updateCheckboxGroupInput(session, "mental_health",
                           selected = sort(unique(data$Mental_Health_Condition)))
  
  updateCheckboxGroupInput(session, "industry",
                           selected = sort(unique(data$Industry)))
  
  updateCheckboxGroupInput(session, "job_role",
                           selected = sort(unique(data$Job_Role)))
  
  updateCheckboxGroupInput(session, "age_group",
                           selected = AGE_GROUPS)
}

#' Désélectionner tous les filtres
#' @param session Session Shiny
clear_all_filters <- function(session) {
  updateCheckboxGroupInput(session, "mental_health", selected = character(0))
  updateCheckboxGroupInput(session, "industry", selected = character(0))
  updateCheckboxGroupInput(session, "job_role", selected = character(0))
  updateCheckboxGroupInput(session, "age_group", selected = character(0))
}