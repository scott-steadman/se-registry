
App.nextPageLoader = {
  scrollerSelector:   '#infinite-scroll',
  nextPageSelector:   'a.next_page',
  paginationSelector: '.pagination',

  isLoading: false,

  loadMoreIfNecessary: function() {
    if(App.nextPageLoader.isLoading) return;
    App.nextPageLoader.isLoading = true;

    requestAnimationFrame(function() {
      if(App.nextPageLoader.isPaginatorVisible()) App.nextPageLoader.loadNextPage();
      App.nextPageLoader.isLoading = false;

      // The browser window may be large and we still haven't
      // filled the page. So we'll check again.
      App.nextPageLoader.loadMoreIfNecessary();
    });

  }, // loadMoreIfNecessary

  isPaginatorVisible: function() {
    var documentTop     = window.scrollY;
                          // handle chrome bug where outerHeight < innerHeight
    var windowHeight    = Math.max(window.innerHeight, window.outerHeight);
    var documentBottom  = documentTop + windowHeight;
    var elementTop      = $(App.nextPageLoader.scrollerSelector).offset().top
    var isVisible       = elementTop <= documentBottom;

    return isVisible;
  }, // isPaginatorVisible

  loadNextPage: function() {
    var more_posts_url = $(App.nextPageLoader.nextPageSelector).attr('href');
    if(!more_posts_url) return;

    $(App.nextPageLoader.paginationSelector).html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..."/>');
    $.getScript(more_posts_url);
  }, // loadNextPage

} //  App.nextPageLoader

$(document).on('turbo:load', function() {
  if( $('#infinite-scroll').size() > 0 ) {
    $(window).on('scroll', App.nextPageLoader.loadMoreIfNecessary);
  }

  // paginator may already be visible
  App.nextPageLoader.loadMoreIfNecessary();
});
