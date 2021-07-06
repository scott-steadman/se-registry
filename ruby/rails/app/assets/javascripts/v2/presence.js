App.presence = App.presence || {
  // called when a friend visits the site
  received(data) {
    var func = 'on' + this.capitalize(data['event']);
    App.presence[func](data['friend_id']);
  },

  onAppear(friend_id) {
  },

  onDisappear(friend_id) {
  },

} // App.presence

// we're just going to the subscription to indicate the user's presence.
App.consumer = App.consumer || ActionCable.createConsumer();
App.consumer.subscriptions.create('PresenceChannel', App.presence);

//ActionCable.logger.enabled = true;
