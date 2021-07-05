App.users = {

  onBefriendClicked: function(elementId, befriendPath) {
    jQuery.ajax(befriendPath, {
      method: 'post',

    }).done(function(data, textStatus, jqXHR) {
      $(elementId).replaceWith(data);

    }).fail(function(jqXHR, txtStatus, errorThrown) {
      App.showErrorDialog('Error', 'Unable to befriend user');
    });

  }, // onBefriendClicked

  onUnfriendClicked: function(elementId, unfriend_path) {
    jQuery.ajax(unfriend_path, {
      method: 'delete',

    }).done(function(data, textStatus, jqXHR) {
      $(elementId).replaceWith(data);

    }).fail(function(jqXHR, txtStatus, errorThrown) {
      App.showErrorDialog('Error', 'Unable to befriend user');
    });

  }, // onUnfriendClicked

  onEditClicked: function(user_id, edit_user_path) {
    jQuery.ajax(edit_user_path, {

    }).done(function(data, textStatus, jqXHR) {
      $(`#user-${user_id}`).replaceWith(data);

    }).fail(function(jqXHR, txtStatus, errorThrown) {
      App.showErrorDialog('Error', 'Unable to create a user');
    });

  }, // onEditClicked

  onCancelEditClicked: function(id, user_user_path) {
    jQuery.ajax(user_user_path, {

    }).done(function(data, textStatus, jqXHR) {
      $(`#${id}`).replaceWith(data);

    }).fail(function(jqXHR, txtStatus, errorThrown) {
      // user was probably deleted
      $(`#${id}`).remove();
    });

  }, // onCancelEditClicked

} // App.users

$(document).on('turbolinks:load', function() {
  $('#friend__autocomplete').autocomplete({source: '/users/autocomplete'});
});
