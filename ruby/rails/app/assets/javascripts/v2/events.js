App.events = {

  hideMenu: function() {
    document.getElementById('event-menu').classList.add('is-hidden');
  }, // hideMenu

  onEditClicked: function(event_id, edit_event_path) {
    App.events.hideMenu();

    jQuery.ajax(edit_event_path, {

    }).done(function(data, textStatus, jqXHR) {

      var eventElement = $(`#event-${event_id}`);
      eventElement.replaceWith(data);

      // show/hide year if recurring is un/checked
      $('input#occasion_recur').on('change', App.events.updateDateEditor);
      App.events.updateDateEditor();

    }).fail(function(jqXHR, txtStatus, errorThrown) {
      App.showErrorDialog('Error', 'Unable to create a new occasion');
      App.events.showMenu();
    });

  }, // onEditClicked

  onCancelCreateClicked: function() {
    App.events.showMenu();
    document.getElementById('event-new').remove();
  }, // onCancelCreateClicked

  onCancelEditClicked: function(id, user_event_path) {
    App.events.showMenu();

    jQuery.ajax(user_event_path, {

    }).done(function(data, textStatus, jqXHR) {
      $(`#${id}`).replaceWith(data);

    }).fail(function(jqXHR, txtStatus, errorThrown) {
      // event was probably deleted
      $(`#${id}`).remove();
    });

  }, // onCancelEditClicked

  onAddOccasionClicked: function(new_user_occasion_path) {
    App.events.hideMenu();

    jQuery.ajax(new_user_occasion_path, {

    }).done(function(data, textStatus, jqXHR) {

      var eventList = document.getElementById('event__list');
      eventList.insertAdjacentHTML('afterbegin', data);

      // show/hide year if recurring is un/checked
      $('input#occasion_recur').on('change', App.events.updateDateEditor);
      App.events.updateDateEditor();

    }).fail(function(jqXHR, txtStatus, errorThrown) {
      App.showErrorDialog('Error', 'Unable to create a new occasion');
      App.events.showMenu();
    });

  }, // onAddOccasionClicked

  onAddReminderClicked: function(new_user_reminder_path) {
    App.events.hideMenu();

    jQuery.ajax(new_user_reminder_path, {

    }).done(function(data, textStatus, jqXHR) {

      var eventList = document.getElementById('event__list');
      eventList.insertAdjacentHTML('afterbegin', data);

      // show/hide year if recurring is un/checked
      $('input#reminder_recur').on('change', App.events.updateDateEditor);
      App.events.updateDateEditor();

    }).fail(function(jqXHR, txtStatus, errorThrown) {
      App.showErrorDialog('Error', 'Unable to create a new reminder');
      App.events.showMenu();
    });

  }, // onAddReminderClicked

  showMenu: function() {
    document.getElementById('event-menu').classList.remove('is-hidden');
  }, // showMenu

  updateDateEditor: function() {
    var checkBox  = $('input[id$="_recur"]');
    var yearField = $('select[id$="_date_1i"]');
    var label     = $('label#event__date-label');

    if(checkBox.prop('checked')) {
      yearField.hide();
      label.text('Every');
    } else {
      yearField.show();
      label.text('On');
    }
  }, // updateDateEditor

} // App.events

