$(document).on("turbolinks:load", function() {
  $('iframe.address').each(function(i, el) {
    var frame = $(el);
    frame.attr('src', frame.attr('data-src'));
  });

  $(document).on("click", ".card-call-to-actions button", function(event) {
    var $button = $(this);
    Turbolinks.visit($button.find('a').attr('href'));
  });

  $(document).on("change", ".dropdown select", function(event) {
    var newSearch, queryParamRegExp;
    var search = location.search;
    var queryParam = this.name + "=" + this.value;

    if (!search) {
      Turbolinks.visit(location.pathname + "?" + queryParam);
    } else {
      queryParamRegExp = new RegExp("(" + this.name + "=[^\&]+)");

      if (search.match(queryParamRegExp)) {
        newSearch = search.replace(queryParamRegExp, queryParam);
      } else {
        newSearch = search + "&" + queryParam;
      }
      Turbolinks.visit(location.pathname + newSearch);
    }
  });
});
