#DATA VISUALISATION 

## Authors
FERNANDES DE FARIA Patrick
LE BORGNE Killian
BRANDI Julien
LEFUMEUX Bastien
BOCOUM Allaye

## Description

Une application Shiny interactive pour visualiser et analyser l'impact du télétravail sur la santé mentale et le bien-être des employés. Cette application propose différentes visualisations pour explorer les relations entre le mode de travail, le stress, la productivité et la santé mentale.


## Fonctionnalités

### Vue d'ensemble
- Filtrage par région
- Visualisations interactives multiples :
  - Analyse de la santé mentale par profil (Sunburst)
  - Hiérarchie des soins de santé mentale (Circle Packing)
  - Distribution de l'activité physique par mode de travail (Multiple Bar Chart)
  - Analyse de la productivité (Parallel Sets)
  - Analyse de l'équilibre travail-vie (Bar Chart)


### Visualisations détaillées
- **Sunburst** : Explore la distribution de la santé mentale selon l'industrie, le rôle et l'âge
- **Parallel Sets** : Montre les relations entre le mode de travail, le niveau de stress, la santé mentale et la productivité
- **Bar Chart** : Analyse l'équilibre travail-vie selon les heures travaillées
- **Circle Packing** : Visualise la hiérarchie des soins de santé mentale
- **Multiple Bar Chart** : Compare l'activité physique selon le mode de travail


## Pour lancer l'application

Option 1 : Lancer app.R depuis RStudio
Option 2 : Exécuter les commandes suivantes dans la console R ou depuis le terminal 

```R
Rscript -e "shiny::runApp('app.R')"
```

