$(document).ready(function() {
  // collapse all directories
  $('.tree-view > .entry.directory').addClass('collapsed');

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
