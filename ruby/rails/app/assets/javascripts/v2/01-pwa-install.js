// Handle PWA install prompt UI
(function() {
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
    console.log('PWA installed');
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
        if (choiceResult.outcome === 'accepted') {
          console.log('User accepted the install prompt');
        } else {
          console.log('User dismissed the install prompt');
        }
        deferredPrompt = null;
        hideButton();
      });
    });
  });
})();
