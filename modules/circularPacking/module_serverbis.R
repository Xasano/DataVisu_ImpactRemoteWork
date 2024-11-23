circularPackingServerBis <- function(id, shared_data) {
  moduleServer(id, function(input, output, session) {
    
    observe({
      req(shared_data()$data)
      shared_data()$data
    })
    
    # Préparer les données hiérarchiques
    prepare_hierarchical_data <- reactive({
      req(shared_data()$data)
      
      # Utiliser toutes les données
      filtered_data <- shared_data()$data
      
      # Calculer le total
      total_filtered <- nrow(filtered_data)
      
      # Initialiser la liste pour stocker les différents niveaux
      hierarchy_levels <- list()
      
      # Niveau 1: Global
      hierarchy_levels[[1]] <- data.frame(
        name = "Global",
        display_name = "",
        parent = "",
        count = total_filtered,
        percentage = 100,
        depth = 0,
        id = 1,
        condition_type = "root"
      )
      
      # Niveau 2: Genre
      gender_level <- filtered_data %>%
        group_by(Gender) %>%
        summarise(
          count = n(),
          .groups = 'drop'
        ) %>%
        mutate(
          percentage = count / total_filtered * 100,
          name = paste0("gender_", Gender),
          display_name = sprintf("%s\n%.1f%%", Gender, percentage),
          parent = "Global",
          depth = 1,
          id = row_number() + 1,
          condition_type = "level1"
        ) %>%
        select(name, display_name, parent, count, percentage, depth, id, condition_type)
      
      hierarchy_levels[[2]] <- gender_level
      last_id <- max(gender_level$id)
      
      # Niveau 3: Conditions de santé
      condition_level <- filtered_data %>%
        group_by(Gender, Mental_Health_Condition) %>%
        summarise(
          count = n(),
          .groups = 'drop'
        ) %>%
        left_join(
          filtered_data %>%
            group_by(Gender) %>%
            summarise(total_gender = n(), .groups = 'drop'),
          by = "Gender"
        ) %>%
        mutate(
          percentage = count / total_gender * 100,
          name = paste0("condition_", Gender, "_", Mental_Health_Condition),
          display_name = sprintf("%s\n%.1f%%", Mental_Health_Condition, percentage),
          parent = paste0("gender_", Gender),
          depth = 2,
          id = row_number() + last_id,
          condition_type = "level2"
        ) %>%
        select(name, display_name, parent, count, percentage, depth, id, condition_type)
      
      hierarchy_levels[[3]] <- condition_level
      last_id <- max(condition_level$id)
      
      # Niveau 4: Accès aux soins
      access_level <- filtered_data %>%
        group_by(Gender, Mental_Health_Condition, Access_to_Mental_Health_Resources) %>%
        summarise(
          count = n(),
          .groups = 'drop'
        ) %>%
        left_join(
          filtered_data %>%
            group_by(Gender, Mental_Health_Condition) %>%
            summarise(total_condition = n(), .groups = 'drop'),
          by = c("Gender", "Mental_Health_Condition")
        ) %>%
        mutate(
          percentage = count / total_condition * 100,
          name = paste0("access_", Gender, "_", Mental_Health_Condition, "_", Access_to_Mental_Health_Resources),
          display_name = sprintf("%s\n%.1f%%", Access_to_Mental_Health_Resources, percentage),
          parent = paste0("condition_", Gender, "_", Mental_Health_Condition),
          depth = 3,
          id = row_number() + last_id,
          condition_type = "level3"
        ) %>%
        select(name, display_name, parent, count, percentage, depth, id, condition_type)
      
      hierarchy_levels[[4]] <- access_level
      
      # Combiner tous les niveaux
      hierarchy_data <- do.call(rbind, hierarchy_levels)
      
      # Créer les arêtes du graphe
      edges <- hierarchy_data %>%
        filter(parent != "") %>%
        select(from = parent, to = name)
      
      # Créer le graphe
      graph <- graph_from_data_frame(edges, vertices = hierarchy_data)
      
      return(list(
        graph = graph,
        vertices_data = hierarchy_data
      ))
    })
    
    output$circle_plot <- renderPlot({
      data <- prepare_hierarchical_data()
      graph <- data$graph
      vertices_data <- data$vertices_data
      
      # Créer le layout
      layout <- create_layout(graph, 'circlepack', weight = vertices_data$percentage)
      
      # Fusionner les données de profondeur avec le layout
      layout$depth <- vertices_data$depth[match(layout$name, vertices_data$name)]
      layout$condition_type <- vertices_data$condition_type[match(layout$name, vertices_data$name)]
      layout$display_name <- vertices_data$display_name[match(layout$name, vertices_data$name)]
      
      # Afficher les labels pour les points avec un pourcentage supérieur à 5%
      layout$show_label <- layout$percentage >= 5
      
      # Créer le graphique avec titre
      ggraph(layout) +
        geom_node_circle(aes(alpha = -depth)) +
        scale_alpha_continuous(range = c(0.8, 0.2)) +
        geom_text_repel(
          data = subset(layout, show_label),
          aes(
            x = x, 
            y = y,
            label = display_name,
            size = -depth
          ),
          max.overlaps = 20,
          box.padding = 0.5,
          point.padding = 0.5,
          segment.size = 0.2,
          min.segment.length = 0.2,
          force = 2,
          direction = "both"
        ) +
        scale_size_continuous(range = c(2.5, 4.5)) +
        theme_void() +
        theme(
          legend.position = "none",
          plot.background = element_rect(fill = "white", color = NA),
          plot.title = element_text(hjust = 0.5, size = 16, face = "bold", margin = margin(b = 20))
        ) +
        coord_fixed() +
        labs(title = "Circle Packing - Hiérarchie des Soins de Santé Mentale")
    })
  })
}