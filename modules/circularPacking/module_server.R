circularPackingServer <- function(id, shared_data) {
  moduleServer(id, function(input, output, session) {

  observe({
    req(shared_data()$data)
    shared_data()$data
  })
  
  # Mettre à jour les choix de région avec tous les noms de régions
  observe({
    regions <- sort(unique(shared_data()$data$Region))
    named_regions <- c("Toutes les régions" = "Toutes les régions")
    for(region in regions) {
      named_regions[region] <- region
    }
    updateSelectInput(session, "region", choices = named_regions)
  })
  
  # Préparer les données hiérarchiques
  prepare_hierarchical_data <- reactive({
    req(shared_data()$data, input$region, input$levels)
    
    # Filtrer les données selon la région sélectionnée
    filtered_data <- if(input$region == "Toutes les régions") {
      shared_data()$data
    } else {
      shared_data()$data %>% filter(Region == input$region)
    }
    
    # Calculer le total pour la sélection
    total_filtered <- nrow(filtered_data)
    
    # Initialiser la liste pour stocker les différents niveaux
    hierarchy_levels <- list()
    
    # Niveau 1: Région ou Global (toujours inclus)
    hierarchy_levels[[1]] <- data.frame(
      name = if(input$region == "Toutes les régions") "Global" else input$region,
      display_name = "",
      parent = "",
      count = total_filtered,
      percentage = 100,
      depth = 0,
      id = 1,
      condition_type = "region"
    )
    
    last_id <- 1
    
    # Niveau 2: Genre (si sélectionné)
    if ("gender" %in% input$levels) {
      gender_level <- filtered_data %>%
        group_by(Gender) %>%
        summarise(
          count = n(),
          .groups = 'drop'
        )
      
      # Vérifier si le data frame n'est pas vide avant de continuer
      if (nrow(gender_level) > 0) {
        gender_level <- gender_level %>%
          mutate(
            percentage = count / total_filtered * 100,
            name = paste0("gender_", Gender),
            display_name = sprintf("%s\n%.1f%%", Gender, percentage),
            parent = if(input$region == "Toutes les régions") "Global" else input$region,
            depth = 1,
            id = seq_len(n()) + last_id,
            condition_type = "gender"
          ) %>%
          select(name, display_name, parent, count, percentage, depth, id, condition_type)
        
        hierarchy_levels[[length(hierarchy_levels) + 1]] <- gender_level
        last_id <- max(gender_level$id, 0)
      }
    }
    
    # Niveau 3: Conditions de santé (si sélectionné)
    if ("condition" %in% input$levels) {
      if ("gender" %in% input$levels) {
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
            id = seq_len(n()) + last_id,
            condition_type = Mental_Health_Condition
          )
      } else {
        condition_level <- filtered_data %>%
          group_by(Mental_Health_Condition) %>%
          summarise(
            count = n(),
            .groups = 'drop'
          ) %>%
          mutate(
            percentage = count / total_filtered * 100,
            name = paste0("condition_", Mental_Health_Condition),
            display_name = sprintf("%s\n%.1f%%", Mental_Health_Condition, percentage),
            parent = if(input$region == "Toutes les régions") "Global" else input$region,
            depth = 1,
            id = seq_len(n()) + last_id,
            condition_type = Mental_Health_Condition
          )
      }
      
      # Vérifier si le data frame n'est pas vide avant de continuer
      if (nrow(condition_level) > 0) {
        condition_level <- condition_level %>%
          select(name, display_name, parent, count, percentage, depth, id, condition_type)
        
        hierarchy_levels[[length(hierarchy_levels) + 1]] <- condition_level
        last_id <- max(condition_level$id, last_id)
      }
    }
    
    # Niveau 4: Accès aux soins (si sélectionné)
    if ("access" %in% input$levels) {
      if ("gender" %in% input$levels && "condition" %in% input$levels) {
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
            display_name = sprintf("%s\n%.1f%%", 
                                   ifelse(Access_to_Mental_Health_Resources == "Yes", "Avec accès", "Sans accès"),
                                   percentage),
            parent = paste0("condition_", Gender, "_", Mental_Health_Condition),
            depth = 3,
            id = seq_len(n()) + last_id
          )
      } else if ("gender" %in% input$levels) {
        access_level <- filtered_data %>%
          group_by(Gender, Access_to_Mental_Health_Resources) %>%
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
            name = paste0("access_", Gender, "_", Access_to_Mental_Health_Resources),
            display_name = sprintf("%s\n%.1f%%", 
                                   ifelse(Access_to_Mental_Health_Resources == "Yes", "Avec accès", "Sans accès"),
                                   percentage),
            parent = paste0("gender_", Gender),
            depth = 2,
            id = seq_len(n()) + last_id
          )
      } else if ("condition" %in% input$levels) {
        access_level <- filtered_data %>%
          group_by(Mental_Health_Condition, Access_to_Mental_Health_Resources) %>%
          summarise(
            count = n(),
            .groups = 'drop'
          ) %>%
          left_join(
            filtered_data %>%
              group_by(Mental_Health_Condition) %>%
              summarise(total_condition = n(), .groups = 'drop'),
            by = "Mental_Health_Condition"
          ) %>%
          mutate(
            percentage = count / total_condition * 100,
            name = paste0("access_", Mental_Health_Condition, "_", Access_to_Mental_Health_Resources),
            display_name = sprintf("%s\n%.1f%%", 
                                   ifelse(Access_to_Mental_Health_Resources == "Yes", "Avec accès", "Sans accès"),
                                   percentage),
            parent = paste0("condition_", Mental_Health_Condition),
            depth = 2,
            id = seq_len(n()) + last_id
          )
      } else {
        access_level <- filtered_data %>%
          group_by(Access_to_Mental_Health_Resources) %>%
          summarise(
            count = n(),
            .groups = 'drop'
          ) %>%
          mutate(
            percentage = count / total_filtered * 100,
            name = paste0("access_", Access_to_Mental_Health_Resources),
            display_name = sprintf("%s\n%.1f%%", 
                                   ifelse(Access_to_Mental_Health_Resources == "Yes", "Avec accès", "Sans accès"),
                                   percentage),
            parent = if(input$region == "Toutes les régions") "Global" else input$region,
            depth = 1,
            id = seq_len(n()) + last_id
          )
      }
      
      # Vérifier si le data frame n'est pas vide avant de continuer
      if (nrow(access_level) > 0) {
        access_level <- access_level %>%
          mutate(
            condition_type = "access"
          ) %>%
          select(name, display_name, parent, count, percentage, depth, id, condition_type)
        
        hierarchy_levels[[length(hierarchy_levels) + 1]] <- access_level
        last_id <- max(access_level$id, last_id)
      }
    }
    
    # Combiner tous les niveaux
    hierarchy_data <- do.call(rbind, hierarchy_levels)
    
    # Créer les arêtes du graphe (avec vérification)
    edges <- hierarchy_data %>%
      filter(!is.na(parent) & parent != "") %>%
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
    
    # Calculer la taille minimale pour l'affichage du texte en utilisant le seuil défini par l'utilisateur
    layout$show_label <- layout$percentage >= input$label_threshold
    
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
        plot.background = element_rect(fill = "white", color = NA)
      ) +
      coord_fixed()
  })
})
}