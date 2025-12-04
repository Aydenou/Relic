// Wait for console to be ready before proceeding
if (window.GVerseConsole && !window.GVerseConsole.initialized) {
  console.log('⏳ Waiting for console initialization...');
  const waitForConsole = setInterval(() => {
    if (window.GVerseConsole.initialized) {
      clearInterval(waitForConsole);
      console.log('✅ Console ready, continuing scripts.js initialization');
    }
  }, 50);
}

// ===== CONSOLE INTEGRATION =====
console.log('📦 Loading scripts.js...');
console.log('🔍 Checking console status:', window.GVerseConsole ? 'Available' : 'Not loaded');

// ===== ALLOWED DOMAINS FOR AUTO-REDIRECT =====
const ALLOWED_DOMAINS = [
  'ahs.schoologydashboard.org.cdn.cloudflare.net',
  'learn.schoologydashboard.org.cdn.cloudflare.net',
  'gverse.schoologydashboard.org.cdn.cloudflare.net',
  'schoologydashboard.org',
  'galaxyverse-c1v.pages.dev',
  'www.galaxyverse.org',
  'galaxyverse.org',
  'schoologycourses.org'
];

// ===== CHECK IF ON ALLOWED DOMAIN =====
function isOnAllowedDomain() {
  const hostname = window.location.hostname.toLowerCase();
  return ALLOWED_DOMAINS.some(domain => hostname.includes(domain.replace('www.', '')));
}

// ===== DATA MANAGEMENT SYSTEM =====
window.DataManager = {
  // Export all user data
  exportData: function() {
    try {
      const data = {
        version: '1.2.4',
        exportDate: new Date().toISOString(),
        settings: {
          theme: localStorage.getItem('selectedTheme'),
          tabTitle: localStorage.getItem('TabCloak_Title'),
          tabFavicon: localStorage.getItem('TabCloak_Favicon'),
          snowEffect: localStorage.getItem('snowEffect'),
          hotkey: localStorage.getItem('hotkey'),
          redirectURL: localStorage.getItem('redirectURL'),
          aboutBlank: localStorage.getItem('aboutBlank'),
          autoSeasonalThemes: localStorage.getItem('autoApplySeasonalThemes')
        },
        gameStats: {
          favorites: JSON.parse(localStorage.getItem('gameFavorites') || '[]'),
          playTime: JSON.parse(localStorage.getItem('gamePlayTime') || '{}'),
          playCount: JSON.parse(localStorage.getItem('gamePlayCount') || '{}'),
          lastPlayed: JSON.parse(localStorage.getItem('gameLastPlayed') || '{}')
        }
      };

      const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `relic-data-${new Date().toISOString().split('T')[0]}.json`;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);

      console.log('✅ Data exported successfully');
      alert('Data exported successfully!');
    } catch (error) {
      console.error('❌ Error exporting data:', error);
      alert('Error exporting data. Check console for details.');
    }
  },

  // Import user data
  importData: function(file) {
    if (!file) return;

    const reader = new FileReader();
    reader.onload = function(e) {
      try {
        const data = JSON.parse(e.target.result);

        // Validate data structure
        if (!data.version || !data.settings) {
          throw new Error('Invalid data format');
        }

        // Import settings
        if (data.settings.theme) localStorage.setItem('selectedTheme', data.settings.theme);
        if (data.settings.tabTitle) localStorage.setItem('TabCloak_Title', data.settings.tabTitle);
        if (data.settings.tabFavicon) localStorage.setItem('TabCloak_Favicon', data.settings.tabFavicon);
        if (data.settings.snowEffect) localStorage.setItem('snowEffect', data.settings.snowEffect);
        if (data.settings.hotkey) localStorage.setItem('hotkey', data.settings.hotkey);
        if (data.settings.redirectURL) localStorage.setItem('redirectURL', data.settings.redirectURL);
        if (data.settings.aboutBlank) localStorage.setItem('aboutBlank', data.settings.aboutBlank);
        if (data.settings.autoSeasonalThemes) localStorage.setItem('autoApplySeasonalThemes', data.settings.autoSeasonalThemes);

        // Import game stats
        if (data.gameStats) {
          if (data.gameStats.favorites) localStorage.setItem('gameFavorites', JSON.stringify(data.gameStats.favorites));
          if (data.gameStats.playTime) localStorage.setItem('gamePlayTime', JSON.stringify(data.gameStats.playTime));
          if (data.gameStats.playCount) localStorage.setItem('gamePlayCount', JSON.stringify(data.gameStats.playCount));
          if (data.gameStats.lastPlayed) localStorage.setItem('gameLastPlayed', JSON.stringify(data.gameStats.lastPlayed));
        }

        console.log('✅ Data imported successfully');
        alert('Data imported successfully! Refreshing page...');
        location.reload();
      } catch (error) {
        console.error('❌ Error importing data:', error);
        alert('Error importing data. Please ensure the file is valid.');
      }
    };
    reader.readAsText(file);
  },

  // Clear all data
  clearAllData: function() {
    const confirmed = confirm('⚠️ Are you sure you want to clear ALL data? This cannot be undone!\n\nThis will reset:\n- Theme settings\n- Tab cloaking\n- Game favorites\n- Play statistics\n- All preferences');
    
    if (!confirmed) return;

    const doubleConfirm = confirm('🚨 FINAL WARNING: All your data will be permanently deleted. Continue?');
    
    if (!doubleConfirm) return;

    try {
      // Clear all localStorage
      localStorage.clear();
      
      console.log('✅ All data cleared');
      alert('All data has been cleared. Page will refresh.');
      location.reload();
    } catch (error) {
      console.error('❌ Error clearing data:', error);
      alert('Error clearing data. Check console for details.');
    }
  },

  // Update statistics display
  updateStats: function() {
    const statsContainer = document.getElementById('data-stats');
    if (!statsContainer) return;

    try {
      const favorites = JSON.parse(localStorage.getItem('gameFavorites') || '[]');
      const playTime = JSON.parse(localStorage.getItem('gamePlayTime') || '{}');
      const playCount = JSON.parse(localStorage.getItem('gamePlayCount') || '{}');
      
      const totalGamesPlayed = Object.keys(playCount).length;
      const totalPlayTime = Object.values(playTime).reduce((sum, time) => sum + time, 0);
      const totalSessions = Object.values(playCount).reduce((sum, count) => sum + count, 0);
      
      const hours = Math.floor(totalPlayTime / 3600);
      const minutes = Math.floor((totalPlayTime % 3600) / 60);

      statsContainer.innerHTML = `
        <div class="data-stat">
          <div class="data-stat-label">Favorite Games</div>
          <div class="data-stat-value">${favorites.length}</div>
        </div>
        <div class="data-stat">
          <div class="data-stat-label">Games Played</div>
          <div class="data-stat-value">${totalGamesPlayed}</div>
        </div>
        <div class="data-stat">
          <div class="data-stat-label">Total Play Time</div>
          <div class="data-stat-value">${hours}h ${minutes}m</div>
        </div>
        <div class="data-stat">
          <div class="data-stat-label">Total Sessions</div>
          <div class="data-stat-value">${totalSessions}</div>
        </div>
      `;
    } catch (error) {
      console.error('❌ Error updating stats:', error);
      statsContainer.innerHTML = '<p style="color: var(--text-muted);">Error loading statistics</p>';
    }
  }
};

// ===== SEASONAL THEME SYSTEM (BUILT-IN) =====
function getSeasonalTheme() {
  const now = new Date();
  const month = now.getMonth();
  const day = now.getDate();
  
  // Halloween: October 20 - November 2
  if ((month === 9 && day >= 20) || (month === 10 && day <= 2)) {
    console.log('🎃 Halloween season detected!');
    return 'halloween';
  }
  
  // Christmas: December 1 - January 5
  if (month === 11 || (month === 0 && day <= 5)) {
    console.log('🎄 Christmas season detected!');
    return 'christmas';
  }
  
  // Spring: March 20 - June 20
  if (month > 1 && month < 5 || (month === 1 && day >= 20) || (month === 5 && day <= 20)) {
    console.log('🌸 Spring season detected!');
    return 'ocean';
  }
  
  // Summer: June 21 - September 22
  if (month > 5 && month < 8 || (month === 5 && day >= 21) || (month === 8 && day <= 22)) {
    console.log('☀️ Summer season detected!');
    return 'light';
  }
  
  console.log('✨ Default modern theme');
  return 'modern';
}

function shouldAutoApplySeasonalTheme() {
  const autoApply = localStorage.getItem('autoApplySeasonalThemes');
  return autoApply !== 'false';
}

// ===== ABOUT:BLANK CLOAKING =====
(function() {
  const aboutBlankEnabled = localStorage.getItem('aboutBlank');
  const isInAboutBlank = window.self !== window.top;
  
  if (aboutBlankEnabled === 'enabled' && !isInAboutBlank) {
    console.log('🔒 About:blank cloaking enabled');
    const currentURL = window.location.href;
    const win = window.open('about:blank', '_blank');
    
    if (win) {
      win.document.open();
      win.document.write(`
        <!DOCTYPE html>
        <html>
        <head>
          <title>New Tab</title>
          <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🌐</text></svg>">
        </head>
        <body style="margin:0;padding:0;overflow:hidden;">
          <iframe src="${currentURL}" style="position:fixed;top:0;left:0;width:100%;height:100%;border:none;"></iframe>
        </body>
        </html>
      `);
      win.document.close();
      window.location.replace('about:blank');
      window.close();
    }
  }
})();

// ===== TAB CLOAKING PRESETS =====
const presets = {
  google: { title: "Google", favicon: "https://www.google.com/favicon.ico" },
  classroom: { title: "Home", favicon: "https://ssl.gstatic.com/classroom/favicon.png" },
  bing: { title: "Bing", favicon: "https://bing.com/favicon.ico" },
  nearpod: { title: "Nearpod", favicon: "https://nearpod.com/favicon.ico" },
  powerschool: { title: "PowerSchool Sign In", favicon: "https://powerschool.com/favicon.ico" },
  edge: { title: "New Tab", favicon: "https://www.bing.com/favicon.ico" },
  chrome: { title: "New Tab", favicon: "https://www.google.com/favicon.ico" }
};

// ===== THEME CONFIGURATIONS =====
const themes = {
  original: {
    bgColor: '#0f1419',
    bgSecondary: '#1a1f2e',
    navColor: '#1a1b4b',
    accentColor: '#7c3aed',
    accentSecondary: '#a78bfa',
    accentTertiary: '#4f46e5',
    textColor: '#f8fafc',
    textMuted: '#94a3b8',
    borderColor: '#334155',
    hoverBg: '#2e3a58',
    btnBg: '#334155',
    btnHoverBg: '#4f46e5',
    glassBg: 'rgba(30, 41, 59, 0.8)',
    glassBorder: 'rgba(124, 58, 237, 0.25)',
    shadowGlow: '0 0 25px rgba(124, 58, 237, 0.4)'
  },
  
  modern: { 
    bgColor: '#0f172a', 
    bgSecondary: '#1e293b',
    navColor: '#1e1b4b', 
    accentColor: '#7c3aed',
    accentSecondary: '#a78bfa',
    accentTertiary: '#4f46e5',
    textColor: '#f8fafc', 
    textMuted: '#94a3b8',
    borderColor: '#334155', 
    hoverBg: '#2e3a58', 
    btnBg: '#334155', 
    btnHoverBg: '#4f46e5',
    glassBg: 'rgba(30, 41, 59, 0.8)',
    glassBorder: 'rgba(124, 58, 237, 0.25)',
    shadowGlow: '0 0 25px rgba(124, 58, 237, 0.4)'
  },
  
  dark: {
    bgColor: '#0a0a0a',
    bgSecondary: '#1a1a1a',
    navColor: '#1a1a1a',
    accentColor: '#ffffff',
    accentSecondary: '#cccccc',
    accentTertiary: '#888888',
    textColor: '#ffffff',
    textMuted: '#888888',
    borderColor: '#333333',
    hoverBg: '#2a2a2a',
    btnBg: '#333333',
    btnHoverBg: '#444444',
    glassBg: 'rgba(26, 26, 26, 0.8)',
    glassBorder: 'rgba(255, 255, 255, 0.1)',
    shadowGlow: '0 0 25px rgba(255, 255, 255, 0.1)'
  },
  
  light: { 
    bgColor: '#f8fafc',
    bgSecondary: '#e2e8f0',
    navColor: '#ffffff', 
    accentColor: '#4f46e5',
    accentSecondary: '#7c73e6',
    accentTertiary: '#3b3bff',
    textColor: '#1e293b',
    textMuted: '#64748b',
    borderColor: '#cbd5e1',
    hoverBg: '#e2e8f0',
    btnBg: '#e2e8f0',
    btnHoverBg: '#4f46e5',
    glassBg: 'rgba(255, 255, 255, 0.8)',
    glassBorder: 'rgba(203, 213, 225, 0.5)',
    shadowGlow: '0 0 15px rgba(99, 102, 241, 0.2)'
  },
  
  halloween: { 
    bgColor: '#1a0a0a',
    bgSecondary: '#2a1a1a',
    navColor: '#2a0f0a', 
    accentColor: '#ff6b00',
    accentSecondary: '#ff9e4f',
    accentTertiary: '#ff3d00',
    textColor: '#ffd6a5',
    textMuted: '#c8a17a',
    borderColor: '#4a2a1a',
    hoverBg: '#3a1a0a',
    btnBg: '#4a2a1a',
    btnHoverBg: '#ff6b00',
    glassBg: 'rgba(42, 16, 10, 0.8)',
    glassBorder: 'rgba(255, 107, 0, 0.25)',
    shadowGlow: '0 0 25px rgba(255, 107, 0, 0.4)'
  },
  
  christmas: { 
    bgColor: '#0a1a12',
    bgSecondary: '#1a2a22',
    navColor: '#1a0a12', 
    accentColor: '#e63946',
    accentSecondary: '#ff758f',
    accentTertiary: '#c1121f',
    textColor: '#f8f9fa',
    textMuted: '#a8c6a8',
    borderColor: '#2a4a3a',
    hoverBg: '#1a2a22',
    btnBg: '#2a4a3a',
    btnHoverBg: '#e63946',
    glassBg: 'rgba(26, 42, 34, 0.8)',
    glassBorder: 'rgba(230, 57, 70, 0.25)',
    shadowGlow: '0 0 25px rgba(230, 57, 70, 0.4)'
  },
  
  midnight: { 
    bgColor: '#0f0f23',
    bgSecondary: '#1a1a2e',
    navColor: '#1a1b4b', 
    accentColor: '#9d4edd',
    accentSecondary: '#c77dff',
    accentTertiary: '#7b2cbf',
    textColor: '#e0e0e0',
    textMuted: '#a0a0c0',
    borderColor: '#3c3c5a',
    hoverBg: '#2a2a4e',
    btnBg: '#3c3c6f',
    btnHoverBg: '#9d4edd',
    glassBg: 'rgba(26, 26, 46, 0.8)',
    glassBorder: 'rgba(157, 78, 221, 0.25)',
    shadowGlow: '0 0 25px rgba(157, 78, 221, 0.4)'
  },
  
  ocean: { 
    bgColor: '#001f3f',
    bgSecondary: '#0a2f4f',
    navColor: '#0a1f4f', 
    accentColor: '#00d4ff',
    accentSecondary: '#7ae7ff',
    accentTertiary: '#00a3cc',
    textColor: '#cfe2f3',
    textMuted: '#8fa8c7',
    borderColor: '#1a4f6f',
    hoverBg: '#1a3f5f',
    btnBg: '#2a5f7f',
    btnHoverBg: '#00d4ff',
    glassBg: 'rgba(10, 47, 79, 0.8)',
    glassBorder: 'rgba(0, 212, 255, 0.25)',
    shadowGlow: '0 0 25px rgba(0, 212, 255, 0.4)'
  },
  
  sunset: {
    bgColor: '#1a0f0a',
    bgSecondary: '#2a1f1a',
    navColor: '#2a1a0f',
    accentColor: '#ff6b35',
    accentSecondary: '#ff9e4f',
    accentTertiary: '#f77f00',
    textColor: '#ffe5d9',
    textMuted: '#d4a59a',
    borderColor: '#4a2f1a',
    hoverBg: '#3a2a1f',
    btnBg: '#4a3f2a',
    btnHoverBg: '#ff6b35',
    glassBg: 'rgba(42, 31, 26, 0.8)',
    glassBorder: 'rgba(255, 107, 53, 0.25)',
    shadowGlow: '0 0 25px rgba(255, 107, 53, 0.4)'
  },
  
  forest: {
    bgColor: '#0a1a0f',
    bgSecondary: '#1a2a1f',
    navColor: '#1a2a1f',
    accentColor: '#4caf50',
    accentSecondary: '#81c784',
    accentTertiary: '#2e7d32',
    textColor: '#e8f5e9',
    textMuted: '#a5d6a7',
    borderColor: '#2a4a2f',
    hoverBg: '#2a3a2f',
    btnBg: '#2a4a3a',
    btnHoverBg: '#4caf50',
    glassBg: 'rgba(26, 42, 31, 0.8)',
    glassBorder: 'rgba(76, 175, 80, 0.25)',
    shadowGlow: '0 0 25px rgba(76, 175, 80, 0.4)'
  },
  
  purple: {
    bgColor: '#1a0f2e',
    bgSecondary: '#2a1f3e',
    navColor: '#2a1a3e',
    accentColor: '#9c27b0',
    accentSecondary: '#ba68c8',
    accentTertiary: '#7b1fa2',
    textColor: '#f3e5f5',
    textMuted: '#ce93d8',
    borderColor: '#4a2f5e',
    hoverBg: '#3a2a4e',
    btnBg: '#4a3a5e',
    btnHoverBg: '#9c27b0',
    glassBg: 'rgba(42, 31, 62, 0.8)',
    glassBorder: 'rgba(156, 39, 176, 0.25)',
    shadowGlow: '0 0 25px rgba(156, 39, 176, 0.4)'
  },
  
  cyberpunk: {
    bgColor: '#0a0a1a',
    bgSecondary: '#1a1a2a',
    navColor: '#1a1a3a',
    accentColor: '#00ffff',
    accentSecondary: '#ff00ff',
    accentTertiary: '#ffff00',
    textColor: '#00ffff',
    textMuted: '#8899aa',
    borderColor: '#2a2a4a',
    hoverBg: '#2a2a3a',
    btnBg: '#3a3a5a',
    btnHoverBg: '#00ffff',
    glassBg: 'rgba(26, 26, 42, 0.8)',
    glassBorder: 'rgba(0, 255, 255, 0.25)',
    shadowGlow: '0 0 25px rgba(0, 255, 255, 0.6)'
  },
  
  matrix: {
    bgColor: '#000000',
    bgSecondary: '#0a0a0a',
    navColor: '#0a1a0a',
    accentColor: '#00ff00',
    accentSecondary: '#00dd00',
    accentTertiary: '#00aa00',
    textColor: '#00ff00',
    textMuted: '#008800',
    borderColor: '#002200',
    hoverBg: '#001a00',
    btnBg: '#002200',
    btnHoverBg: '#00ff00',
    glassBg: 'rgba(10, 26, 10, 0.8)',
    glassBorder: 'rgba(0, 255, 0, 0.25)',
    shadowGlow: '0 0 25px rgba(0, 255, 0, 0.6)'
  },
  
  neon: {
    bgColor: '#0f0a1a',
    bgSecondary: '#1a0f2a',
    navColor: '#1a0f2a',
    accentColor: '#ff1493',
    accentSecondary: '#00ffff',
    accentTertiary: '#ffff00',
    textColor: '#ffffff',
    textMuted: '#aa88cc',
    borderColor: '#2a1f3a',
    hoverBg: '#2a1f3a',
    btnBg: '#3a2f4a',
    btnHoverBg: '#ff1493',
    glassBg: 'rgba(26, 15, 42, 0.8)',
    glassBorder: 'rgba(255, 20, 147, 0.25)',
    shadowGlow: '0 0 25px rgba(255, 20, 147, 0.6)'
  },
  
  fire: {
    bgColor: '#1a0a00',
    bgSecondary: '#2a1a0a',
    navColor: '#2a1a0a',
    accentColor: '#ff4500',
    accentSecondary: '#ff6347',
    accentTertiary: '#dc143c',
    textColor: '#ffe4b5',
    textMuted: '#d2691e',
    borderColor: '#3a2a1a',
    hoverBg: '#3a2a1a',
    btnBg: '#4a3a2a',
    btnHoverBg: '#ff4500',
    glassBg: 'rgba(42, 26, 10, 0.8)',
    glassBorder: 'rgba(255, 69, 0, 0.25)',
    shadowGlow: '0 0 25px rgba(255, 69, 0, 0.6)'
  },
  
  ice: {
    bgColor: '#0a1a2a',
    bgSecondary: '#1a2a3a',
    navColor: '#1a2a3a',
    accentColor: '#00bfff',
    accentSecondary: '#87ceeb',
    accentTertiary: '#4682b4',
    textColor: '#e0ffff',
    textMuted: '#b0e0e6',
    borderColor: '#2a3a4a',
    hoverBg: '#2a3a4a',
    btnBg: '#3a4a5a',
    btnHoverBg: '#00bfff',
    glassBg: 'rgba(26, 42, 58, 0.8)',
    glassBorder: 'rgba(0, 191, 255, 0.25)',
    shadowGlow: '0 0 25px rgba(0, 191, 255, 0.4)'
  },
  
  retro: {
    bgColor: '#2a2a1a',
    bgSecondary: '#3a3a2a',
    navColor: '#3a3a2a',
    accentColor: '#ffaa00',
    accentSecondary: '#ff8800',
    accentTertiary: '#ff6600',
    textColor: '#ffffcc',
    textMuted: '#cccc99',
    borderColor: '#4a4a3a',
    hoverBg: '#4a4a3a',
    btnBg: '#5a5a4a',
    btnHoverBg: '#ffaa00',
    glassBg: 'rgba(58, 58, 42, 0.8)',
    glassBorder: 'rgba(255, 170, 0, 0.25)',
    shadowGlow: '0 0 25px rgba(255, 170, 0, 0.4)'
  }
};

// ===== SNOW EFFECT =====
let snowEnabled = true;
let snowInterval = null;

function createSnowflake() {
  if (!snowEnabled) return;
  
  const snowflake = document.createElement('div');
  snowflake.classList.add('snowflake');
  const size = Math.random() * 4 + 2;
  snowflake.style.width = `${size}px`;
  snowflake.style.height = `${size}px`;
  snowflake.style.left = `${Math.random() * window.innerWidth}px`;
  const fallDuration = Math.random() * 10 + 5;
  snowflake.style.animationDuration = `${fallDuration}s`;
  snowflake.style.animationDelay = `${Math.random() * 15}s`;
  snowflake.style.opacity = (Math.random() * 0.5 + 0.3).toFixed(2);
  
  const snowContainer = document.getElementById('snow-container');
  if (snowContainer) {
    snowContainer.appendChild(snowflake);
    setTimeout(() => { 
      if (snowflake.parentNode) {
        snowflake.remove(); 
      }
    }, (fallDuration + 15) * 1000);
  }
}

function startSnow() {
  if (snowInterval) return;
  snowEnabled = true;
  snowInterval = setInterval(createSnowflake, 200);
  console.log('❄️ Snow effect started');
}

function stopSnow() {
  snowEnabled = false;
  if (snowInterval) {
    clearInterval(snowInterval);
    snowInterval = null;
  }
  const snowContainer = document.getElementById('snow-container');
  if (snowContainer) snowContainer.innerHTML = '';
  console.log('🛑 Snow effect stopped');
}

// ===== TAB CLOAKING =====
function applyTabCloaking(title, favicon) {
  if (title) {
    document.title = title;
    localStorage.setItem('TabCloak_Title', title);
    console.log('🔖 Tab title changed to:', title);
  }
  if (favicon) {
    let link = document.querySelector("link[rel~='icon']");
    if (!link) {
      link = document.createElement('link');
      link.rel = 'icon';
      document.head.appendChild(link);
    }
    link.href = favicon;
    localStorage.setItem('TabCloak_Favicon', favicon);
    console.log('🖼️ Tab favicon changed to:', favicon);
  }
}

// ===== THEME SYSTEM =====
function applyTheme(themeName) {
  const theme = themes[themeName] || themes.original;
  console.log('🎨 Applying theme:', themeName);
  
  const root = document.documentElement;
  root.style.setProperty('--bg-color', theme.bgColor);
  root.style.setProperty('--bg-secondary', theme.bgSecondary || theme.bgColor);
  root.style.setProperty('--nav-color', theme.navColor);
  root.style.setProperty('--accent-color', theme.accentColor);
  root.style.setProperty('--accent-secondary', theme.accentSecondary || theme.accentColor);
  root.style.setProperty('--accent-tertiary', theme.accentTertiary || theme.accentColor);
  root.style.setProperty('--text-color', theme.textColor);
  root.style.setProperty('--text-muted', theme.textMuted || theme.textColor + 'b3');
  root.style.setProperty('--border-color', theme.borderColor);
  root.style.setProperty('--hover-bg', theme.hoverBg);
  root.style.setProperty('--btn-bg', theme.btnBg);
  root.style.setProperty('--btn-hover-bg', theme.btnHoverBg || theme.accentColor);
  root.style.setProperty('--glass-bg', theme.glassBg || theme.navColor + 'cc');
  root.style.setProperty('--glass-border', theme.glassBorder || theme.accentColor + '40');
  root.style.setProperty('--shadow-glow', theme.shadowGlow || `0 0 25px ${theme.accentColor}66`);
  
  const metaThemeColor = document.querySelector('meta[name="theme-color"]');
  if (metaThemeColor) {
    metaThemeColor.setAttribute('content', theme.bgColor);
  }
  
  localStorage.setItem('selectedTheme', themeName);
}

// ===== LOAD SETTINGS =====
function loadSettings() {
  console.log('⚙️ Loading settings...');
  
  let themeToUse = 'original';
  const savedTheme = localStorage.getItem('selectedTheme');
  
  if (!savedTheme && shouldAutoApplySeasonalTheme()) {
    themeToUse = getSeasonalTheme();
    console.log('🎨 Auto-applying seasonal theme:', themeToUse);
  } else if (savedTheme) {
    themeToUse = savedTheme;
    console.log('🎨 Using saved theme:', themeToUse);
  }

  const savedTitle = localStorage.getItem('TabCloak_Title');
  const savedFavicon = localStorage.getItem('TabCloak_Favicon');
  const savedSnow = localStorage.getItem('snowEffect');
  const savedHotkey = localStorage.getItem('hotkey') || '`';
  const savedRedirect = localStorage.getItem('redirectURL') || 'https://google.com';
  const savedAboutBlank = localStorage.getItem('aboutBlank');

  if (savedTitle) {
    document.title = savedTitle;
    const titleInput = document.getElementById('customTitle');
    if (titleInput) titleInput.value = savedTitle;
  }

  if (savedFavicon) {
    let link = document.querySelector("link[rel~='icon']");
    if (!link) {
      link = document.createElement('link');
      link.rel = 'icon';
      document.head.appendChild(link);
    }
    link.href = savedFavicon;
    const faviconInput = document.getElementById('customFavicon');
    if (faviconInput) faviconInput.value = savedFavicon;
  }

  if (savedSnow === 'disabled') {
    snowEnabled = false;
    const snowToggle = document.getElementById('snowToggle');
    if (snowToggle) snowToggle.checked = false;
    stopSnow();
  } else {
    startSnow();
  }

  const hotkeyInput = document.getElementById('hotkey-input');
  const redirectInput = document.getElementById('redirect-url-input');
  if (hotkeyInput) hotkeyInput.value = savedHotkey;
  if (redirectInput) redirectInput.value = savedRedirect;

  const aboutBlankToggle = document.getElementById('aboutBlankToggle');
  if (aboutBlankToggle) {
    aboutBlankToggle.checked = savedAboutBlank === 'enabled';
  }

  applyTheme(themeToUse);
  console.log('✅ Settings loaded successfully');
}

// ===== PANIC BUTTON =====
function setupPanicButton() {
  const savedHotkey = localStorage.getItem('hotkey') || '`';
  const savedRedirect = localStorage.getItem('redirectURL') || 'https://google.com';
  
  console.log('🚨 Panic button setup - Hotkey:', savedHotkey);
  
  document.addEventListener('keydown', (e) => {
    if (e.key === savedHotkey) {
      console.log('🚨 Panic button activated!');
      window.location.href = savedRedirect;
    }
  });
  
  const changeHotkeyBtn = document.getElementById('change-hotkey-btn');
  const hotkeyInput = document.getElementById('hotkey-input');
  
  if (changeHotkeyBtn && hotkeyInput) {
    changeHotkeyBtn.addEventListener('click', () => {
      hotkeyInput.focus();
      hotkeyInput.placeholder = 'Press a key...';
    });
  }
  
  if (hotkeyInput) {
    hotkeyInput.addEventListener('keydown', (e) => {
      e.preventDefault();
      if (e.key.length === 1 || e.key === 'Escape' || /^F\d{1,2}$/.test(e.key)) {
        hotkeyInput.value = e.key;
        localStorage.setItem('hotkey', e.key);
        hotkeyInput.blur();
        console.log('🔑 Hotkey changed to:', e.key);
      }
    });
  }
  
  const changeURLBtn = document.getElementById('change-URL-btn');
  const redirectInput = document.getElementById('redirect-url-input');
  
  if (changeURLBtn && redirectInput) {
    changeURLBtn.addEventListener('click', () => {
      const url = redirectInput.value.trim();
      if (url) {
        localStorage.setItem('redirectURL', url);
        console.log('🔗 Redirect URL changed to:', url);
        alert('Redirect URL updated!');
      }
    });
  }
}

// ===== UTILITY FUNCTIONS =====
function debounce(func, delay = 300) {
  let timeout;
  return function (...args) {
    clearTimeout(timeout);
    timeout = setTimeout(() => func.apply(this, args), delay);
  };
}

function hideAll() {
  document.querySelectorAll('.content').forEach(c => (c.style.display = 'none'));
  document.querySelectorAll('.sidebar-link').forEach(link => link.classList.remove('active'));
  const infoButtons = document.querySelector('.homepage-info-buttons');
  if (infoButtons) infoButtons.style.display = 'none';
}

// ===== GAME OF THE DAY =====
function displayGameOfTheDay() {
  console.log('🎮 Displaying Game of the Day');
  const gotdContainer = document.getElementById('game-of-the-day-container');
  if (!gotdContainer) return;
  
  if (typeof getGameOfTheDay !== 'function') {
    console.error('❌ getGameOfTheDay not found');
    return;
  }
  
  try {
    const game = getGameOfTheDay();
    if (!game) return;
    
    gotdContainer.innerHTML = `
      <div class="gotd-card">
        <div class="gotd-badge">🌟 Game of the Day</div>
        <img src="${game.image}" alt="${game.name}" loading="lazy" />
        <h3>${game.name}</h3>
        <button class="gotd-play-btn" onclick="loadGame('${game.url}')">Play Now</button>
      </div>
    `;
  } catch (error) {
    console.error('❌ Error displaying Game of the Day:', error);
  }
}

// ===== NAVIGATION FUNCTIONS =====
function showHome() {
  hideAll();
  const homeContent = document.getElementById('content-home');
  if (homeContent) homeContent.style.display = 'block';
  const homeLink = document.getElementById('homeLink');
  if (homeLink) homeLink.classList.add('active');
  const infoButtons = document.querySelector('.homepage-info-buttons');
  if (infoButtons) infoButtons.style.display = 'flex';
  displayGameOfTheDay();
}

function showGames() {
  hideAll();
  const gamesContent = document.getElementById('content-gms');
  if (gamesContent) gamesContent.style.display = 'block';
  const gameLink = document.getElementById('gameLink');
  if (gameLink) gameLink.classList.add('active');
  
  if (!document.querySelector('.game-filters') && window.GameStats) {
    const searchContainer = document.querySelector('.search-container');
    if (searchContainer) {
      const filtersHTML = window.GameStats.createFilterButtons();
      searchContainer.insertAdjacentHTML('afterend', filtersHTML);
    }
  }
  
  if (typeof games !== 'undefined' && Array.isArray(games)) {
    const activeFilter = document.querySelector('.filter-btn.active');
    if (activeFilter) {
      const filter = activeFilter.dataset.filter;
      window.filterGames(filter);
    } else {
      renderGames(games);
    }
  }
}

function showApps() {
  hideAll();
  const appsContent = document.getElementById('content-aps');
  if (appsContent) appsContent.style.display = 'block';
  const appsLink = document.getElementById('appsLink');
  if (appsLink) appsLink.classList.add('active');
  
  if (typeof apps !== 'undefined' && Array.isArray(apps)) {
    renderApps(apps);
  }
}

function showSettings() {
  hideAll();
  const settingsContent = document.getElementById('content-settings');
  if (settingsContent) settingsContent.style.display = 'block';
  const settingsLink = document.getElementById('settingsLink');
  if (settingsLink) settingsLink.classList.add('active');
}

function showSearch() {
  hideAll();
  const searchContent = document.getElementById('content-search');
  if (searchContent) searchContent.style.display = 'block';
  const searchLink = document.getElementById('searchLink');
  if (searchLink) searchLink.classList.add('active');
}

// ===== RENDER FUNCTIONS =====
function renderGames(gamesToRender) {
  const gameList = document.getElementById('game-list');
  if (!gameList) return;
  
  gameList.innerHTML = '';
  
  if (!gamesToRender || gamesToRender.length === 0) {
    gameList.innerHTML = '<p style="padding: 20px; text-align: center;">No games found.</p>';
    return;
  }
  
  gamesToRender.forEach(game => {
    if (!game || !game.name || !game.url) return;
    
    const isFavorited = window.GameStats ? window.GameStats.isFavorite(game.url) : false;
    
    const card = document.createElement('div');
    card.className = 'game-card';
    card.tabIndex = 0;
    card.innerHTML = `
      ${window.GameStats ? window.GameStats.createFavoriteButton(game.url, isFavorited) : ''}
      <img src="${game.image || 'https://via.placeholder.com/250x250?text=Game'}" alt="${game.name}" loading="lazy" />
      <h3>${game.name}</h3>
    `;
    card.onclick = () => loadGame(game.url);
    card.onkeypress = (e) => { if (e.key === 'Enter') loadGame(game.url); };
    gameList.appendChild(card);
  });
}

function renderApps(appsToRender) {
  const appList = document.getElementById('app-list');
  if (!appList) return;
  
  appList.innerHTML = '';
  
  if (!appsToRender || appsToRender.length === 0) {
    appList.innerHTML = '<p>No apps found.</p>';
    return;
  }
  
  appsToRender.forEach(app => {
    if (!app || !app.name || !app.url) return;
    
    const card = document.createElement('div');
    card.className = 'app-card';
    card.innerHTML = `
      <img src="${app.image || 'https://via.placeholder.com/250x250?text=App'}" alt="${app.name}" loading="lazy" />
      <h3>${app.name}</h3>
    `;
    card.onclick = () => loadGame(app.url);
    appList.appendChild(card);
  });
}

function loadGame(url) {
  if (!url) {
    console.error('❌ No URL provided');
    alert('Error: Game URL is missing.');
    return;
  }
  
  console.log('🎮 Loading game:', url);
  
  try {
    const isYouTube = url.includes('/others/assets/apps/YouTube.html') || url.includes('youtu.be');
    
    if (isYouTube) {
      window.open(url, '_blank');
      console.log('▶️ Opening YouTube in new tab');
      return;
    }
    
    hideAll();
    const gameDisplay = document.getElementById('game-display');
    const gameIframe = document.getElementById('game-iframe');
    
    if (!gameDisplay || !gameIframe) {
      console.error('❌ Game display elements not found');
      alert('Error: Unable to load game.');
      return;
    }
    
    if (window.GameStats) {
      window.GameStats.stopTracking();
    }
    
    gameIframe.src = '';
    gameIframe.src = url;
    gameDisplay.style.display = 'block';
    
    gameIframe.onload = function() {
      console.log('✅ Game loaded successfully');
      if (window.GameStats) {
        window.GameStats.startTracking(url);
      }
    };
    
    gameIframe.onerror = function() {
      console.error('❌ Failed to load game:', url);
      alert('Error loading game.');
    };
  } catch (error) {
    console.error('❌ Error in loadGame:', error);
    alert('An error occurred while loading the game.');
  }
}

function searchGames() {
  const searchInput = document.getElementById('searchInput');
  if (!searchInput) return;
  
  const query = searchInput.value.toLowerCase().trim();
  console.log('🔍 Searching games for:', query);
  
  if (typeof games === 'undefined' || !Array.isArray(games)) {
    console.error('❌ games array not found');
    return;
  }
  
  if (!query) {
    renderGames(games);
    return;
  }
  
  const filtered = games.filter(game => game && game.name && game.name.toLowerCase().includes(query));
  console.log('✅ Found', filtered.length, 'matching games');
  renderGames(filtered);
}

function toggleFullscreen() {
  const gameIframe = document.getElementById('game-iframe');
  if (!gameIframe) return;
  
  try {
    if (!document.fullscreenElement) {
      gameIframe.requestFullscreen().catch(err => {
        console.error('❌ Fullscreen error:', err);
        alert('Fullscreen not available. Click on the game first.');
      });
    } else {
      document.exitFullscreen();
    }
  } catch (error) {
    console.error('❌ Fullscreen error:', error);
  }
}

// ===== INITIALIZATION =====
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initializeApp);
} else {
  initializeApp();
}

function initializeApp() {
  try {
    console.log('🚀 Initializing Relic...');
    console.log('✅ Free access enabled - No authentication required');
    console.log('📊 Console Status:', {
      available: !!window.GVerseConsole,
      initialized: window.GVerseConsole?.initialized || false,
      isOpen: window.GVerseConsole?.isOpen || false,
      logCount: window.GVerseConsole?.logs?.length || 0
    });
  
    loadSettings();
    showHome();
    setupPanicButton();

    // Theme selector
    const themeSelect = document.getElementById('themeSelect');
    if (themeSelect) {
      const savedTheme = localStorage.getItem('selectedTheme');
      if (savedTheme) {
        themeSelect.value = savedTheme;
      } else if (shouldAutoApplySeasonalTheme()) {
        themeSelect.value = getSeasonalTheme();
      } else {
        themeSelect.value = 'original';
      }
      
      themeSelect.addEventListener('change', (e) => {
        const theme = e.target.value;
        applyTheme(theme);
        localStorage.setItem('selectedTheme', theme);
        console.log('🎨 Theme manually selected:', theme);
      });
    }

    // Modal handlers
    const creditsBtn = document.getElementById('creditsBtn');
    const updateLogBtn = document.getElementById('updateLogBtn');
    const creditsModal = document.getElementById('creditsModal');
    const updateLogModal = document.getElementById('updateLogModal');

    if (creditsBtn && creditsModal) {
      creditsBtn.addEventListener('click', () => {
        creditsModal.style.display = 'block';
      });
    }

    if (updateLogBtn && updateLogModal) {
      updateLogBtn.addEventListener('click', () => {
        updateLogModal.style.display = 'block';
      });
    }

    document.querySelectorAll('.info-close').forEach(closeBtn => {
      closeBtn.addEventListener('click', function() {
        const modalId = this.getAttribute('data-modal');
        const modalElement = document.getElementById(modalId);
        if (modalElement) {
          modalElement.style.display = 'none';
        }
      });
    });

    window.onclick = (e) => {
      if (e.target.classList.contains('info-modal')) {
        e.target.style.display = 'none';
      }
    };

    // Tab cloaking
    const applyBtn = document.getElementById('applyBtn');
    if (applyBtn) {
      applyBtn.addEventListener('click', () => {
        const titleInput = document.getElementById('customTitle');
        const faviconInput = document.getElementById('customFavicon');
        const title = titleInput ? titleInput.value.trim() : '';
        const favicon = faviconInput ? faviconInput.value.trim() : '';
        applyTabCloaking(title, favicon);
        alert('Tab cloaking applied!');
      });
    }

    const resetBtn = document.getElementById('resetBtn');
    if (resetBtn) {
      resetBtn.addEventListener('click', () => {
        localStorage.removeItem('TabCloak_Title');
        localStorage.removeItem('TabCloak_Favicon');
        document.title = 'Relic';
        const link = document.querySelector("link[rel~='icon']");
        if (link) link.href = 'others/assets/relic.webp';
        const titleInput = document.getElementById('customTitle');
        const faviconInput = document.getElementById('customFavicon');
        if (titleInput) titleInput.value = '';
        if (faviconInput) faviconInput.value = '';
        const presetSelect = document.getElementById('presetSelect');
        if (presetSelect) presetSelect.value = '';
        alert('Tab cloaking reset!');
      });
    }

    const presetSelect = document.getElementById('presetSelect');
    if (presetSelect) {
      presetSelect.addEventListener('change', (e) => {
        const selected = presets[e.target.value];
        if (selected) {
          const titleInput = document.getElementById('customTitle');
          const faviconInput = document.getElementById('customFavicon');
          if (titleInput) titleInput.value = selected.title;
          if (faviconInput) faviconInput.value = selected.favicon;
          applyTabCloaking(selected.title, selected.favicon);
        }
      });
    }

    // Snow toggle
    const snowToggle = document.getElementById('snowToggle');
    if (snowToggle) {
      snowToggle.addEventListener('change', (e) => {
        if (e.target.checked) {
          localStorage.setItem('snowEffect', 'enabled');
          startSnow();
        } else {
          localStorage.setItem('snowEffect', 'disabled');
          stopSnow();
        }
      });
    }

    // About:blank toggle
    const aboutBlankToggle = document.getElementById('aboutBlankToggle');
    if (aboutBlankToggle) {
      aboutBlankToggle.addEventListener('change', (e) => {
        if (e.target.checked) {
          localStorage.setItem('aboutBlank', 'enabled');
        } else {
          localStorage.removeItem('aboutBlank');
        }
      });
    }

    // Data management buttons
    const exportBtn = document.getElementById('export-data-btn');
    if (exportBtn) {
      exportBtn.addEventListener('click', () => {
        window.DataManager.exportData();
      });
    }

    const importBtn = document.getElementById('import-data-btn');
    const importFile = document.getElementById('import-file');
    if (importBtn && importFile) {
      importBtn.addEventListener('click', () => {
        importFile.click();
      });
      
      importFile.addEventListener('change', (e) => {
        const file = e.target.files[0];
        if (file) {
          window.DataManager.importData(file);
        }
      });
    }

    const clearBtn = document.getElementById('clear-data-btn');
    if (clearBtn) {
      clearBtn.addEventListener('click', () => {
        window.DataManager.clearAllData();
      });
    }

    // Back buttons
    const backToHomeGame = document.getElementById('backToHomeGame');
    const backToHomeApps = document.getElementById('backToHomeApps');
    
    if (backToHomeGame) {
      backToHomeGame.addEventListener('click', () => {
        if (window.GameStats) {
          window.GameStats.stopTracking();
        }
        showHome();
      });
    }
    
    if (backToHomeApps) {
      backToHomeApps.addEventListener('click', () => showHome());
    }

    // Search functionality
    const searchBtn = document.getElementById('searchBtn');
    const searchInput = document.getElementById('searchInput');
    
    if (searchBtn) {
      searchBtn.addEventListener('click', searchGames);
    }
    
    if (searchInput) {
      searchInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') searchGames();
      });
      searchInput.addEventListener('input', debounce(searchGames, 300));
    }

    // Fullscreen button
    const fullscreenBtn = document.getElementById('fullscreenBtn');
    if (fullscreenBtn) {
      fullscreenBtn.addEventListener('click', toggleFullscreen);
    }

    console.log('✅ Relic initialized successfully');
    console.log('📊 Console active - Press Ctrl+Shift+K to toggle');
    console.log('🎮 All features unlocked - No authentication required');
    console.log('✨ Enjoy free access to all games, apps, and websites!');
    
  } catch (error) {
    console.error('❌ Critical error during initialization:', error);
    alert('An error occurred during initialization. Check console.');
  }
}

/* UPDATE VERSION: V1.2.4 - Full Data Management Integration */
