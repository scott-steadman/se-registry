
window.nextPageLoader = {
  scrollerSelector:   '#infinite-scroll',
  nextPageSelector:   'a.next_page',
  paginationSelector: '.pagination',

  isLoading: false,

  loadMoreIfNecessary: function() {
    if(window.nextPageLoader.isLoading) return;
    window.nextPageLoader.isLoading = true;

    window.requestAnimationFrame(function() {
      if(window.nextPageLoader.isPaginatorVisible()) window.nextPageLoader.loadNextPage();
      window.nextPageLoader.isLoading = false;

      // The browser window may be large and we still haven't
      // filled the page. So we'll check again.
      window.nextPageLoader.loadMoreIfNecessary();
    });

  }, // loadMoreIfNecessary

  isPaginatorVisible: function() {
    var documentTop     = window.scrollY;
                          // handle chrome bug where outerHeight < innerHeight
    var windowHeight    = Math.max(window.innerHeight, window.outerHeight);
    var documentBottom  = documentTop + windowHeight;
    var elementTop      = $(window.nextPageLoader.scrollerSelector).offset().top
    var isVisible       = elementTop <= documentBottom;

    return isVisible;
  }, // isPaginatorVisible

  loadNextPage: function() {
    var more_posts_url = $(window.nextPageLoader.nextPageSelector).attr('href');
    if(!more_posts_url) return;

    $(window.nextPageLoader.paginationSelector).html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..."/>');
    $.getScript(more_posts_url);
  }, // loadNextPage

} //  window.nextPageLoader

$(document).on('turbolinks:load', function() {
  if( $('#infinite-scroll').size() > 0 ) {
    $(window).on('scroll', window.nextPageLoader.loadMoreIfNecessary);
  }

  // paginator may already be visible
  window.nextPageLoader.loadMoreIfNecessary();
});
