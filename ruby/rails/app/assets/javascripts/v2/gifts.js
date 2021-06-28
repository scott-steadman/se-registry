window.gifts = {
  hideMenu: function() {
    document.getElementById('gift__menu').classList.add('is-hidden');
  }, // hideMenu

  onEditClicked: function(gift_id, edit_gift_path) {
    window.gifts.hideMenu();

    jQuery.ajax(edit_gift_path, {

    }).done(function(data, textStatus, jqXHR) {
      $(`#gift-${gift_id}`).replaceWith(data);

    }).fail(function(jqXHR, txtStatus, errorThrown) {
      window.showErrorDialog('Error', 'Unable to create a gift');
      window.gifts.showMenu();
    });

  }, // onEditClicked

  onCancelCreateClicked: function() {
    window.gifts.showMenu();
    $('#gift-new').remove();
  }, // onCancelEditClicked

  onCancelEditClicked: function(id, user_gift_path) {
    window.gifts.showMenu();

    jQuery.ajax(user_gift_path, {

    }).done(function(data, textStatus, jqXHR) {
      $(`#${id}`).replaceWith(data);

    }).fail(function(jqXHR, txtStatus, errorThrown) {
      // gift was probably deleted
      $(`#${id}`).remove();
    });

  }, // onCancelEditClicked

  onNewClicked: function(new_gift_path) {
    window.gifts.hideMenu();

    jQuery.ajax(new_gift_path, {

    }).done(function(data, textStatus, jqXHR) {
      document.getElementById('gift__list').insertAdjacentHTML('afterbegin', data);

    }).fail(function(jqXHR, txtStatus, errorThrown) {
      window.showErrorDialog('Error', 'Unable to create a new gift');
      window.events.showMenu();
    });

  }, // onNewClicked

  replaceOrder: function (value) {
    var key       = 'order';
    var uri       = window.location.search;
    var regex     = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
    var separator = uri.indexOf('?') !== -1 ? "&" : "?";
    var result    = '';

    if (uri.match(regex)) {
      result = uri.replace(regex, '$1' + key + "=" + value + '$2');
    } else {
      result = uri + separator + key + "=" + value;
    }

    return result;
  }, // replaceOrder

  showMenu: function() {
    document.getElementById('gift__menu').classList.remove('is-hidden');
  }, // showMenu

} // window.gifts
