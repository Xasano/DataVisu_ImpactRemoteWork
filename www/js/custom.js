$(document).ready(function () {
  let isInitialized = false;
  let activeNotifications = 0; // Compteur pour limiter les notifications actives
  const recentErrors = new Set(); // Journal des erreurs récentes
  const ERROR_TIMEOUT = 5000; // Temps avant qu'une erreur similaire puisse être affichée

  function initCollapsibleFilters() {
    console.log("Initialisation des filtres collapsibles...");

    // Retirer les gestionnaires d'événements existants
    $('.collapsible-header').off('click');
    $('.checkbox, input[type="checkbox"], label').off('click');

    // Ajouter un gestionnaire pour les en-têtes
    $('.collapsible-header').on('click', function (e) {
        // Empêche la propagation si l'utilisateur clique sur une checkbox ou un label
        if (
            $(e.target).closest('.collapsible-content').length ||
            $(e.target).is('input[type="checkbox"]') ||
            $(e.target).is('label') ||
            $(e.target).closest('.checkbox').length
        ) {
            return;
        }

        // Basculer l'affichage du contenu associé
        const collapsibleContent = $(this).next('.collapsible-content');
        collapsibleContent.slideToggle(300); // Animation pour masquer/afficher

        // Ajouter une classe active pour styliser l'en-tête
        $(this).toggleClass('active');

        // Basculer l'icône (si vous avez une icône pour indiquer l'état ouvert/fermé)
        $(this).find('.toggle-icon').toggleClass('rotate');
    });

    // Gestion des clics spécifiques sur les checkboxes (pour éviter les conflits)
    $('.collapsible-content').on('click', 'input[type="checkbox"], label', function (e) {
        e.stopPropagation(); // Empêcher la propagation vers l'en-tête
    });

    // Ouvrir le premier groupe de filtres à l'initialisation (facultatif)
    if (!isInitialized) {
        $('.filter-group:first .collapsible-header').click();
        isInitialized = true;
    }
}


  // Initialisation initiale
  initCollapsibleFilters();

  // Observer modifié pour les nouveaux éléments
  const observer = new MutationObserver(function (mutations) {
    mutations.forEach(function (mutation) {
      if (mutation.addedNodes.length) {
        const newFilterGroups = $(mutation.addedNodes).find('.filter-group');
        if (newFilterGroups.length > 0 && !isInitialized) {
          initCollapsibleFilters();
          console.log("Initialisation des filtres après ajout au DOM.");
        }
      }
    });
  });

  // Configuration de l'observer
  observer.observe(document.body, {
    childList: true,
    subtree: true,
  });

  // Gestion du redimensionnement des graphiques
  function resizePlots() {
    if (typeof Plotly !== 'undefined' && $('.plotly-graph-div').length > 0) {
      try {
        Plotly.Plots.resize();
      } catch (error) {
        console.warn("Erreur lors du redimensionnement des graphiques : ", error);
      }
    }
  }

  // Écouter les changements de taille de fenêtre
  let resizeTimeout;
  window.addEventListener('resize', function () {
    clearTimeout(resizeTimeout);
    resizeTimeout = setTimeout(function () {
      resizePlots();
    }, 100); // Debounce de 100ms
  });

  // Gestion des transitions d'onglets
  $(document).on('shown.bs.tab', 'a[data-toggle="tab"]', function (e) {
    setTimeout(function () {
      resizePlots();
    }, 10); // Petit délai pour assurer que le contenu est affiché
  });

  // Animation douce pour le défilement
  $(document).on('click', 'a[href^="#"]', function (event) {
    event.preventDefault();
    const target = $($.attr(this, 'href'));
    if (target.length) {
      $('html, body').animate(
        {
          scrollTop: target.offset().top - 60, // 60px de décalage pour la navbar
        },
        {
          duration: 500,
          easing: 'swing', // Utilisez 'swing' pour éviter les erreurs
        }
      );
    }
  });

  // Gestion des états de survol pour les cartes
  $('.analysis-card').hover(
    function () {
      $(this).addClass('hover');
    },
    function () {
      $(this).removeClass('hover');
    }
  );

  // Optimisation du scroll pour les contenus collapsibles
  $('.collapsible-content').on('scroll', function () {
    let scrollTimeout;
    clearTimeout(scrollTimeout);
    scrollTimeout = setTimeout(function () {
      // Code à exécuter après le scroll
    }, 150);
  });

  // Gestion de la barre de navigation responsive
  $(window).on('scroll', function () {
    let scrollTimeout;
    clearTimeout(scrollTimeout);
    scrollTimeout = setTimeout(function () {
      if ($(window).scrollTop() > 50) {
        $('.main-header').addClass('scrolled');
      } else {
        $('.main-header').removeClass('scrolled');
      }
    }, 100);
  });

  // Gestion des notifications
  function showNotification(message, type = 'info', duration = 3000) {
    if (activeNotifications >= 5) {
      console.warn("Limite des notifications atteinte.");
      return; // Empêche les spams de notifications
    }

    activeNotifications++;
    const notification = $(`
      <div class="custom-notification ${type}">
        ${message}
      </div>
    `).appendTo('body');

    setTimeout(function () {
      notification.addClass('show');
    }, 100);

    setTimeout(function () {
      notification.removeClass('show');
      setTimeout(function () {
        notification.remove();
        activeNotifications--;
      }, 300);
    }, duration);
  }

  // Gestion des erreurs globales
  window.onerror = function (msg, url, lineNo, columnNo, error) {
    const errorKey = `${msg} at ${url}:${lineNo}:${columnNo}`;
    if (recentErrors.has(errorKey)) {
      return false; // Ignore l'erreur déjà capturée
    }

    console.error('Error detected: ', { msg, url, lineNo, columnNo, error });
    recentErrors.add(errorKey);
    setTimeout(() => recentErrors.delete(errorKey), ERROR_TIMEOUT); // Supprime après un délai
    showNotification('Une erreur est survenue', 'error', 5000);
    return false;
  };

  // Initialisation des tooltips
  if (typeof $().tooltip === 'function') {
    $('[data-toggle="tooltip"]').tooltip({
      trigger: 'hover',
      container: 'body',
    });
  }

  // Gestion de la fermeture des menus déroulants au clic à l'extérieur
  $(document).on('click', function (event) {
    if (!$(event.target).closest('.dropdown-menu').length) {
      $('.dropdown-menu').removeClass('show');
    }
  });

  // Support du mode sombre si présent dans le système
  if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
    document.body.classList.add('dark-mode');
  }

  // Gestion du chargement des images
  $('img')
    .on('load', function () {
      $(this).addClass('loaded');
    })
    .on('error', function () {
      $(this).addClass('error');
    });

  // Fonction utilitaire pour debounce
  function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout);
        func(...args);
      };
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  }
});
