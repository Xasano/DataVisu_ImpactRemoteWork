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

#' Préparation des données pour le graphique Sunburst
#' @param df DataFrame source
#' @param mental_health Filtres de santé mentale sélectionnés
#' @param industry Filtres d'industrie sélectionnés
#' @param job_role Filtres de rôle sélectionnés
#' @param age_group Filtres de groupe d'âge sélectionnés
prepare_sunburst_data <- function(df, mental_health, industry, job_role, age_group) {
  # Filtrage des données
  df <- df %>%
    filter(
      Mental_Health_Condition %in% mental_health,
      Industry %in% industry,
      Job_Role %in% job_role,
      age_group %in% age_group
    )
  
  if (nrow(df) == 0) {
    return(NULL)
  }
  
  # Construction des niveaux
  industries <- df %>%
    group_by(Industry) %>%
    summarise(count = n(), .groups = 'drop') %>%
    mutate(
      ids = Industry,
      labels = Industry,
      parents = "",
      colors = "lightgray",
      tooltip = sprintf("Secteur : %s<br>Total : %d employés", Industry, count)
    )
  
  roles <- df %>%
    group_by(Industry, Job_Role) %>%
    summarise(count = n(), .groups = 'drop') %>%
    mutate(
      ids = paste(Industry, Job_Role, sep="-"),
      labels = Job_Role,
      parents = Industry,
      colors = "lightgray",
      tooltip = sprintf("Poste : %s<br>Total : %d employés", Job_Role, count)
    )
  
  ages <- df %>%
    group_by(Industry, Job_Role, age_group) %>%
    summarise(count = n(), .groups = 'drop') %>%
    mutate(
      ids = paste(Industry, Job_Role, age_group, sep="-"),
      labels = age_group,
      parents = paste(Industry, Job_Role, sep="-"),
      colors = "lightgray",
      tooltip = sprintf("Tranche d'âge : %s<br>Total : %d employés", age_group, count)
    )
  
  mental_health <- df %>%
    group_by(Industry, Job_Role, age_group) %>%
    mutate(total_group = n()) %>%
    group_by(Industry, Job_Role, age_group, Mental_Health_Condition) %>%
    summarise(
      count = n(),
      percentage = round((n() / first(total_group)) * 100, 1),
      .groups = 'drop'
    ) %>%
    mutate(
      ids = paste(Industry, Job_Role, age_group, Mental_Health_Condition, sep="-"),
      labels = sprintf("%s\n%.1f%%", Mental_Health_Condition, percentage),
      parents = paste(Industry, Job_Role, age_group, sep="-"),
      colors = unlist(MENTAL_HEALTH_COLORS[Mental_Health_Condition]),
      tooltip = sprintf(
        "État : %s<br>Nombre : %d<br>Pourcentage : %.1f%%",
        Mental_Health_Condition, count, percentage
      )
    )
  
  bind_rows(
    industries %>% select(ids, labels, parents, values = count, colors, tooltip),
    roles %>% select(ids, labels, parents, values = count, colors, tooltip),
    ages %>% select(ids, labels, parents, values = count, colors, tooltip),
    mental_health %>% select(ids, labels, parents, values = count, colors, tooltip)
  )
}

#' Création du graphique Sunburst
#' @param plot_data Données préparées pour le graphique
create_sunburst_plot <- function(plot_data) {
  plot_ly(
    data = plot_data,
    ids = ~ids,
    labels = ~labels,
    parents = ~parents,
    values = ~values,
    type = 'sunburst',
    branchvalues = 'total',
    maxdepth = 4,
    insidetextorientation = 'radial',
    textfont = list(size = 14),
    marker = list(
      colors = plot_data$colors,
      line = list(color = 'white', width = 2)
    ),
    hovertemplate = paste(
      "%{customdata}",
      "<extra></extra>"
    ),
    customdata = ~tooltip
  ) %>%
    layout(
      title = list(
        text = "Analyse de la Santé Mentale par Profil",
        font = list(size = 22, family = "Helvetica Neue", color = "#2C3E50"),
        y = 0.98
      ),
      showlegend = FALSE,
      margin = list(l = 0, r = 0, b = 0, t = 80),
      paper_bgcolor = 'rgba(0,0,0,0)',
      plot_bgcolor = 'rgba(0,0,0,0)'
    ) %>%
    config(
      displayModeBar = FALSE,
      displaylogo = FALSE,
      responsive = TRUE
    )
}