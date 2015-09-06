$(document).ready(function() {
  // activate expands this dir and lets the event buble up
  $('.directory').bind('expand-tree', function () {
    $(this).removeClass('collapsed').addClass('expanded');
  });

  // collapse all directories
  $('.tree-view > .entry.directory').addClass('collapsed');
  // expand current tree
  var path = document.location.pathname.substr(1);
  $('[data-path="'+path+'"]').trigger('expand-tree');

  // click handler for directory entries
  $('.directory').click(function(event) {
    // prevent event from bubbling up to parent directories
    event.stopPropagation();
    $(this).toggleClass('expanded');
    $(this).toggleClass('collapsed');
  });

  // don't toggle when clicking a link
  $('.directory a').click(function(event) {
    event.stopPropagation();
  });

});
