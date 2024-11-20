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
