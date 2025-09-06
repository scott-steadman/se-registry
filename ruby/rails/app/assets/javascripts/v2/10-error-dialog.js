MicroModal.init();

App.showErrorDialog = function(title, message) {
  var titleElement = document.getElementById('site-modal__title');
  titleElement.innerText = title;

  var contentElement = document.getElementById('site-modal__content');
  contentElement.classList.add('is-error');
  contentElement.innerText = message;

  MicroModal.show('site-modal', {
    // prevent click from passing through to button/link beneath dialog
    onClose: function(modal, element, event) {event.preventDefault()},
  });
}

App.onAjaxSuccess = function(event, payload, result, request) {
  var target = this.getAttribute('data-replace-target');
  if(target) {
    $('#'+target).replaceWith(payload);
  }
}

$(document).on('ajax:success', 'form[data-replace-target]', App.onAjaxSuccess)
