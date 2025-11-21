// Homepage Carousel Scroll Functionality
(function() {
  'use strict';

  let gamesLoaded = false;
  let retryCount = 0;
  const MAX_RETRIES = 10;

  // Initialize carousels when DOM is ready
  function initCarousels() {
    if (typeof games === 'undefined' || !games || games.length === 0) {
      if (retryCount < MAX_RETRIES) {
        retryCount++;
        console.log(`Waiting for games data... Retry ${retryCount}/${MAX_RETRIES}`);
        setTimeout(initCarousels, 500);
        return;
      } else {
        console.error('Games data not available after maximum retries');
        loadPlaceholderGames();
        return;
      }
    }

    console.log('Loading games into carousels...');
    loadTopCarousel();
    loadBottomCarousel();
    gamesLoaded = true;
  }

  // Load games into top carousel (left to right)
  function loadTopCarousel() {
    const trackTop = document.getElementById('carousel-track-top');
    if (!trackTop) {
      console.error('Top carousel track not found');
      return;
    }

    // Shuffle games for variety
    const shuffledGames = [...games].sort(() => Math.random() - 0.5);
    
    // Take first 15 games and duplicate them for seamless loop
    const gamesToShow = shuffledGames.slice(0, 15);
    const duplicatedGames = [...gamesToShow, ...gamesToShow];

    trackTop.innerHTML = duplicatedGames.map(game => createGameCard(game)).join('');
    addClickHandlers(trackTop);
  }

  // Load games into bottom carousel (right to left)
  function loadBottomCarousel() {
    const trackBottom = document.getElementById('carousel-track-bottom');
    if (!trackBottom) {
      console.error('Bottom carousel track not found');
      return;
    }

    // Shuffle games differently from top carousel
    const shuffledGames = [...games].sort(() => Math.random() - 0.5);
    
    // Take different set of games
    const gamesToShow = shuffledGames.slice(15, 30);
    
    // If not enough games, use from the start
    if (gamesToShow.length < 15) {
      const remaining = 15 - gamesToShow.length;
      gamesToShow.push(...shuffledGames.slice(0, remaining));
    }
    
    const duplicatedGames = [...gamesToShow, ...gamesToShow];

    trackBottom.innerHTML = duplicatedGames.map(game => createGameCard(game)).join('');
    addClickHandlers(trackBottom);
  }

  // Create a game card HTML
  function createGameCard(game) {
    const gameImage = game.image || 'others/assets/images/placeholder.png';
    const gameName = game.name || 'Unknown Game';
    const gameId = game.id || '';

    return `
      <div class="carousel-game-card" data-game-id="${gameId}">
        <img src="${gameImage}" alt="${gameName}" draggable="false" loading="lazy">
        <h3>${gameName}</h3>
      </div>
    `;
  }

  // Add click handlers to game cards
  function addClickHandlers(track) {
    const cards = track.querySelectorAll('.carousel-game-card');
    cards.forEach(card => {
      card.addEventListener('click', function(e) {
        e.preventDefault();
        const gameId = this.getAttribute('data-game-id');
        
        if (gameId && typeof loadGame === 'function') {
          console.log(`Loading game: ${gameId}`);
          loadGame(gameId);
        } else {
          console.warn('Game ID not found or loadGame function not available');
        }
      });
    });
  }

  // Load placeholder games if real data isn't available
  function loadPlaceholderGames() {
    console.warn('Loading placeholder games');
    
    const placeholders = Array(15).fill(null).map((_, i) => ({
      id: `placeholder-${i}`,
      name: `Game ${i + 1}`,
      image: 'others/assets/images/placeholder.png'
    }));

    const trackTop = document.getElementById('carousel-track-top');
    const trackBottom = document.getElementById('carousel-track-bottom');

    if (trackTop) {
      const duplicated = [...placeholders, ...placeholders];
      trackTop.innerHTML = duplicated.map(game => createGameCard(game)).join('');
    }

    if (trackBottom) {
      const duplicated = [...placeholders, ...placeholders];
      trackBottom.innerHTML = duplicated.map(game => createGameCard(game)).join('');
    }
  }

  // Adjust animation speed based on number of games
  function adjustAnimationSpeed() {
    const trackTop = document.getElementById('carousel-track-top');
    const trackBottom = document.getElementById('carousel-track-bottom');

    if (trackTop && trackTop.children.length > 0) {
      const cardCount = trackTop.children.length / 2; // Divided by 2 because duplicated
      const duration = Math.max(20, cardCount * 2.5); // At least 20s
      trackTop.style.animationDuration = `${duration}s`;
    }

    if (trackBottom && trackBottom.children.length > 0) {
      const cardCount = trackBottom.children.length / 2;
      const duration = Math.max(20, cardCount * 2.5);
      trackBottom.style.animationDuration = `${duration}s`;
    }
  }

  // Pause/resume animations on visibility change
  function handleVisibilityChange() {
    const tracks = document.querySelectorAll('.carousel-track');
    
    if (document.hidden) {
      tracks.forEach(track => {
        track.style.animationPlayState = 'paused';
      });
    } else {
      tracks.forEach(track => {
        track.style.animationPlayState = 'running';
      });
    }
  }

  // Initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
      setTimeout(initCarousels, 100);
    });
  } else {
    setTimeout(initCarousels, 100);
  }

  // Handle page visibility changes
  document.addEventListener('visibilitychange', handleVisibilityChange);

  // Expose reload function for external use
  window.reloadHomeCarousels = function() {
    if (gamesLoaded) {
      console.log('Reloading carousels...');
      loadTopCarousel();
      loadBottomCarousel();
      adjustAnimationSpeed();
    } else {
      initCarousels();
    }
  };

  // Adjust animation speed after initial load
  setTimeout(adjustAnimationSpeed, 1000);

})();
