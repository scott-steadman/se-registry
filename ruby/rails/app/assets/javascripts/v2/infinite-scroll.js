
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

    const scroller = $(App.nextPageLoader.scrollerSelector);
    if(scroller.length == 0) return false;
    const scrollerTop = scroller.offset().top

    const documentTop     = window.scrollY;
                          // handle chrome bug where outerHeight < innerHeight
    const windowHeight    = Math.max(window.innerHeight, window.outerHeight);
    const documentBottom  = documentTop + windowHeight;
    const isVisible       = scrollerTop <= documentBottom;

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
