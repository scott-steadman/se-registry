"use strict";

App.site_nav ||= {

  bodyClassList: function() { return document.querySelector('body').classList; },


  openClass: 'is-open',

  onToggleClicked: function(element) {
    element.closest('#site-nav').classList.toggle(this.openClass);
  },


  rightHandedClass: 'is-right-handed',

  onMoveClicked: function(element) {
    this.bodyClassList().toggle(this.rightHandedClass);
    this.saveState();
  },

  rightHandedKey: 'isRightHanded',

  saveState: function() {
    var isRightHanded = this.bodyClassList().contains(this.rightHandedClass);
    window.localStorage.setItem(this.rightHandedKey, isRightHanded);
  },

  loadState: function() {
    var isRightHanded = window.localStorage.getItem(this.rightHandedKey);

    if(isRightHanded === null) {
      this.saveState();
      return;
    }

    if(isRightHanded == 'true') {
      this.bodyClassList().add(this.rightHandedClass);
    } else {
      this.bodyClassList().remove(this.rightHandedClass);
    }
  }
}

App.site_nav.loadState();
