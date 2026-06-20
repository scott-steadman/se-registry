(function() {
  if (!('serviceWorker' in navigator)) return;

  window.addEventListener('load', function() {
    navigator.serviceWorker.register('/service-worker.js')
      .then(function(registration) {
        console.log('Service worker registered with scope:', registration.scope);
      })
      .catch(function(error) {
        console.warn('Service worker registration failed:', error);
      });
  });
})();
