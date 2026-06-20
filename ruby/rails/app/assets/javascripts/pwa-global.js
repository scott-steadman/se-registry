// Minimal PWA registration + install prompt handler for non-v2 pages
(function() {
  if (!('serviceWorker' in navigator)) return;

  // Register service worker if available
  window.addEventListener('load', function() {
    navigator.serviceWorker.register('/service-worker.js').catch(function(e){
      console.warn('SW registration failed:', e);
    });
  });

  var deferredPrompt;
  var btnId = 'pwa-install-button';

  function showButton() {
    var btn = document.getElementById(btnId);
    if (btn) btn.style.display = 'inline-block';
  }

  function hideButton() {
    var btn = document.getElementById(btnId);
    if (btn) btn.style.display = 'none';
  }

  window.addEventListener('beforeinstallprompt', function(e) {
    e.preventDefault();
    deferredPrompt = e;
    showButton();
  });

  window.addEventListener('appinstalled', function() {
    deferredPrompt = null;
    hideButton();
  });

  // Attach a direct click handler to the install button for reliability
  document.addEventListener('DOMContentLoaded', function() {
    var btn = document.getElementById(btnId);
    if (!btn) return;
    btn.addEventListener('click', function(e) {
      e.preventDefault();
      console.log('PWA install button clicked');
      if (!deferredPrompt) {
        console.warn('No install prompt available');
        return;
      }
      deferredPrompt.prompt();
      deferredPrompt.userChoice.then(function(choiceResult) {
        deferredPrompt = null;
        hideButton();
      });
    });
  });
})();
