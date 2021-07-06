App.presence = App.presence || {

  friendCountSelector: '#site-nav__friend-count',

  myUserId: null, // set in application.html.erb

  initialized() {
    App.presence.friendsOnline = new Set();
    $(App.presence.friendCountSelector).tooltip({delay: 0});
  },

  // called when a friend visits the site
  received(data) {
    var func = 'on' + this.capitalize(data['event']);
    App.presence[func](data['friend_id']);
  },

  onAppear(friend_id) {
    // don't count self as a friend
    if(friend_id == App.presence.myUserId) return;

    App.presence.friendsOnline.add(friend_id);
    App.presence.updateOnlineCount();
  },

  onDisappear(friend_id) {
    // don't count self as a friend
    if(friend_id == App.presence.myUserId) return;

    App.presence.friendsOnline.delete(friend_id);
    App.presence.updateOnlineCount();
  },

  isFriendOnline(friend_id) {
    if(friend_id) {
      return App.presence.friendsOnline.has(friend_id);
    }

    return App.presence.friendsOnline.size > 0;
  },

  updateOnlineCount() {
    var count = App.presence.friendsOnline.size;
    var element = $(App.presence.friendCountSelector);

    if(count == 1) {
      element.attr('title', "1 friend is online");

    } else if(count > 1) {
      element.attr('title', count + " friends are online");

    } else {
      count = '';
      element.tooltip('disable');
    }

    element.text(count);

    if(count > 0) {
      element.show('bounce', {distance: 10, times: 3}, 'slow');
    } else {
      element.hide();
    }
  },

  capitalize(string) {
    return string.charAt(0).toUpperCase()  + string.slice(1);
  },

} // App.presence

// we're just going to the subscription to indicate the user's presence.
App.consumer = App.consumer || ActionCable.createConsumer();
App.consumer.subscriptions.create('PresenceChannel', App.presence);

//ActionCable.logger.enabled = true;
