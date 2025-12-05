// Homepage Carousel Scroll Functionality
(function() {
  'use strict';

  console.log('🎮 Carousel script loaded');

  let gamesLoaded = false;
  let retryCount = 0;
  const MAX_RETRIES = 30;

  // Initialize carousel when DOM is ready
  function initCarousels() {
    console.log(`🔄 InitCarousels called, retry: ${retryCount}/${MAX_RETRIES}`);
    
    // Check if carousel track exists
    const track = document.getElementById('carousel-track-top');
    
    if (!track) {
      console.warn('⚠️ Carousel track not found in DOM yet');
      if (retryCount < MAX_RETRIES) {
        retryCount++;
        setTimeout(initCarousels, 200);
        return;
      }
      console.error('❌ Carousel track never appeared');
      return;
    }

    console.log('✅ Carousel track found');

    // Check for games data
    let gamesToUse = [];
    
    if (typeof games !== 'undefined' && games && games.length > 0) {
      console.log(`✅ Found ${games.length} games from games array`);
      // Filter out Feedback
      gamesToUse = games.filter(game => game.name !== "Feedback");
      console.log(`✅ Using ${gamesToUse.length} playable games`);
    } else if (typeof window.games !== 'undefined' && window.games && window.games.length > 0) {
      console.log(`✅ Found ${window.games.length} games from window.games`);
      gamesToUse = window.games.filter(game => game.name !== "Feedback");
    } else {
      console.warn('⚠️ No games data found, retrying...');
      if (retryCount < MAX_RETRIES) {
        retryCount++;
        setTimeout(initCarousels, 200);
        return;
      }
      console.error('❌ Games data never loaded');
      return;
    }

    if (gamesToUse.length === 0) {
      console.error('❌ No playable games found');
      return;
    }

    console.log('🎯 Loading carousel with', gamesToUse.length, 'games');
    loadCarousel(gamesToUse);
    gamesLoaded = true;
    console.log('✅ Carousel loaded successfully');
  }

  // Load games into carousel (right to left)
  function loadCarousel(gamesToUse) {
    const track = document.getElementById('carousel-track-top');
    if (!track) return;

    // Shuffle and take first 20 games for a fuller carousel
    const shuffled = [...gamesToUse].sort(() => Math.random() - 0.5);
    const selected = shuffled.slice(0, Math.min(20, gamesToUse.length));
    
    // Duplicate for seamless loop
    const duplicated = [...selected, ...selected];

    track.innerHTML = duplicated.map(game => createGameCard(game)).join('');
    addClickHandlers(track);
    
    console.log(`✅ Carousel loaded with ${duplicated.length} cards`);
  }

  // Create a game card HTML
  function createGameCard(game) {
    // Handle your data structure: image and url properties
    const gameImage = game.image || 'others/assets/images/placeholder.png';
    const gameName = game.name || 'Unknown Game';
    const gameUrl = game.url || '';

    return `
      <div class="carousel-game-card" data-game-url="${gameUrl}" data-game-name="${gameName}" title="${gameName}">
        <img src="${gameImage}" alt="${gameName}" draggable="false" loading="lazy" onerror="this.src='others/assets/images/placeholder.png'">
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
        const gameUrl = this.getAttribute('data-game-url');
        const gameName = this.getAttribute('data-game-name');
        
        console.log(`🎮 Clicked game: ${gameName}`);
        
        if (gameUrl) {
          // Try to use your existing loadGame function if it exists
          if (typeof loadGame === 'function') {
            // Find the game object from the games array
            const gameObj = games.find(g => g.url === gameUrl);
            if (gameObj) {
              loadGame(gameObj);
            } else {
              // Fallback: load directly
              loadGameByUrl(gameUrl, gameName);
            }
          } else {
            // Fallback: load directly
            loadGameByUrl(gameUrl, gameName);
          }
        } else {
          console.warn('⚠️ No URL found for game:', gameName);
        }
      });
    });
  }

  // Fallback function to load game by URL
  function loadGameByUrl(url, name) {
    console.log(`Loading game: ${name} from ${url}`);
    
    // Check if it's a Google Form (Feedback)
    if (url.includes('forms.gle') || url.includes('google.com/forms')) {
      window.open(url, '_blank');
      return;
    }
    
    // Try to use existing game display system
    const gameDisplay = document.getElementById('game-display');
    const gameIframe = document.getElementById('game-iframe');
    
    if (gameDisplay && gameIframe) {
      // Hide all content sections
      document.querySelectorAll('.content').forEach(content => {
        content.style.display = 'none';
      });
      
      // Show game display
      gameDisplay.style.display = 'block';
      gameIframe.src = url;
      
      console.log('✅ Game loaded in iframe');
    } else {
      // Fallback: open in new tab
      console.warn('⚠️ Game display not found, opening in new tab');
      window.open(url, '_blank');
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
      console.log('📄 DOM Content Loaded');
      setTimeout(initCarousels, 100);
    });
  } else {
    console.log('📄 DOM already loaded');
    setTimeout(initCarousels, 100);
  }

  // Handle page visibility changes
  document.addEventListener('visibilitychange', handleVisibilityChange);

  // Expose reload function for external use
  window.reloadHomeCarousels = function() {
    console.log('🔄 Reloading carousel...');
    if (typeof games !== 'undefined' && games && games.length > 0) {
      const gamesToUse = games.filter(game => game.name !== "Feedback");
      loadCarousel(gamesToUse);
    } else {
      initCarousels();
    }
  };

  console.log('🎮 Carousel script initialization complete');

})();
