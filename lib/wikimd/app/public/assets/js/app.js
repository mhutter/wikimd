$(document).ready(function() {
  // activate expands this dir and lets the event buble up
  $('.directory').bind('expand-tree', function () {
    $(this).removeClass('collapsed').addClass('expanded');
  });

  // collapse all directories
  $('.tree-view > .entry.directory').addClass('collapsed');
  // expand current tree
  var path = document.location.pathname.replace(/^\/([ch]\/)?/, '');
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

  // Quicksearch handler
  $('#search').on('keyup', function(event) {
    var query = $(this).val(),
        results = $('#results');

    if (query.length > 2) {
      $.getJSON('/search.json', {query: query}, function(data) {
        console.log(data);
        var items = [];
        $.each(data, function(_, el) {
          items.push('<li><a href="/'+el+'">' + el + '</a></li>');
        });
        results.html(items.join(""));
      });
    } else {
      results.html('');
    }
  });
});
