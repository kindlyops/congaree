function initZipcodeSearch() {
  var input = $('#zipcode-search input:not([loaded])');

  if(input.length && typeof google !== "undefined") {

    var options = {
      componentRestrictions: { country: 'us' },
      types: ['(regions)']
    };

    var zipcodeSearch = new google.maps.places.Autocomplete(input[0], options);
    zipcodeSearch.addListener('place_changed', function() {
      var place = zipcodeSearch.getPlace();

      if (place.types) {
        var parser = document.createElement('a');
        $form = $('form.zipcode-search-form');
        parser.href = $form.attr('action');

        var placeType = place.types[0];
        var isZipcode = placeType === "postal_code";
        var isState = placeType === "administrative_area_level_1";
        var isCounty = placeType === "administrative_area_level_2";
        var isCity = placeType === "locality";
        var stateComponent = R.find(R.where({types: R.contains('administrative_area_level_1')}), place.address_components);

        if (isZipcode) {
          var location = 'zipcode=' + place.name;
        } else if (isState) {
          var location = 'state=' + stateComponent.short_name;
        } else if (isCounty) {
          var county = 'county=' + place.name.replace(/ County/, "");
          var state = '&state=' + stateComponent.short_name;
          var location = county + state;
        } else if (isCity) {
          var city = 'city=' + place.name;
          var state = '&state=' + stateComponent.short_name;
          var location = city + state;
        }

        if (parser.search) {
          var url = $form.attr('action') + '&' + location;
        } else {
          var url = $form.attr('action') + '?' + location;
        }

        Turbolinks.visit(url);
      }
    });

    google.maps.event.addDomListener(input[0], 'keydown', function(e){
      var keyCode = e.keyCode || e.which;
      var noneSelected = $('.pac-item-selected').length === 0;
      var isTabOrEnter = keyCode === 13 || keyCode === 9;
      var isSearching = isTabOrEnter && noneSelected && !e.triggered;

      if(isSearching) {
        google.maps.event.trigger(input[0], 'keydown', { keyCode: 40 });
        google.maps.event.trigger(input[0], 'keydown', { keyCode: 13, triggered: true });
      }
    });

    $(document).on('submit', 'form.zipcode-search-form', function(e) {
      e.preventDefault();
    });

    input.attr('loaded', true);
  }
}

function initLocationSearch() {
  var input = $('#location-search input:not([loaded])');

  if(input.length && typeof google !== "undefined") {

    var options = {
      componentRestrictions: { country: 'us' },
      types: ['address']
    };

    var autocomplete = new google.maps.places.Autocomplete(input[0], options);

    autocomplete.addListener('place_changed', function() {
      var place = autocomplete.getPlace();
      var $form = $('form#new_account');
      var $latitude = $form.find('#account_organization_attributes_location_attributes_latitude');
      var $longitude = $form.find('#account_organization_attributes_location_attributes_longitude');
      var $full_street_address = $form.find('#account_organization_attributes_location_attributes_full_street_address');
      var $city = $form.find('#account_organization_attributes_location_attributes_city');
      var $state = $form.find('#account_organization_attributes_location_attributes_state');
      var $state_code = $form.find('#account_organization_attributes_location_attributes_state_code');
      var $postal_code = $form.find('#account_organization_attributes_location_attributes_postal_code');
      var $country = $form.find('#account_organization_attributes_location_attributes_country');
      var $country_code = $form.find('#account_organization_attributes_location_attributes_country_code');
      var $address = $form.find('#address');

      $latitude.val(place.geometry.location.lat());
      $longitude.val(place.geometry.location.lng());
      $full_street_address.val(place.formatted_address);
      var city = R.find(R.where({types: R.contains('locality')}), place.address_components);
      $city.val(city.long_name);
      var state = R.find(R.where({types: R.contains('administrative_area_level_1')}), place.address_components);
      $state.val(state.long_name);
      $state_code.val(state.short_name);
      var postal_code = R.find(R.where({types: R.contains('postal_code')}), place.address_components);
      $postal_code.val(postal_code.short_name);
      var country = R.find(R.where({types: R.contains('country')}), place.address_components);
      $country.val(country.long_name);
      $country_code.val(country.short_name);
      var address = R.reject(R.isEmpty, [place.name, city.long_name, state.short_name, postal_code.short_name]).join(', ');
      $address.val(address);
      input.data('address', address);
      var $locationSearch = $('#location-search');
      $locationSearch.removeClass('has-warning');
      $locationSearch.find('.form-control-feedback').remove();
    });

    function missingLocation(input) {
      return R.or(input.data('address') !== input.val(), R.any(function(field) {
        return $(field).val() === "";
      }, $("#new_account input[name*='account'][name*='location']")));
    }

    function validateLocation(e) {
      var $locationSearch = $('#location-search');
      var input = $locationSearch.find('input');
      if (input.val() && missingLocation(input)) {
        e.preventDefault();
        $locationSearch.addClass('has-warning');
        $locationSearch.find('.form-control-feedback').remove();
        $locationSearch.append('<div class="form-control-feedback">Please enter your address and select from the dropdown.</div>');
      }
    }

    $(document).on('focusout', input, validateLocation);
    $(document).on('click', '#new_account button[type="submit"]', validateLocation);

    google.maps.event.addDomListener(input[0], 'keydown', function(e){
      var keyCode = e.keyCode || e.which;
      var noneSelected = $('.pac-item-selected').length === 0;
      var isTabOrEnter = keyCode === 13 || keyCode === 9;
      var isSearching = isTabOrEnter && noneSelected && !e.triggered;

      if(isSearching) {
        e.preventDefault();
        google.maps.event.trigger(input[0], 'keydown', { keyCode: 40 });
        google.maps.event.trigger(input[0], 'keydown', { keyCode: 13, triggered: true });
      }
    });

    input.attr('loaded', true);
  }
}

function initAutocompletes() {
  initZipcodeSearch();
  initLocationSearch();
}

$(document).on('turbolinks:load', function() {
  initLocationSearch();

  var zipcodeSearch = $('#zipcode-search:not([loaded])');
  if(zipcodeSearch.length) {
    var target = $('body')[0];
    var observer = new MutationObserver(function(mutations) {
      mutations.forEach(function(mutation) {
        var nodes = mutation.addedNodes;
        var firstNode = nodes[0];
        var className = firstNode && firstNode.className;

        if (!!className && className.match(/pac-container/)) {
          $(mutation.addedNodes).addClass('zipcode-search');
          observer.disconnect();
        }
      });
    });
    observer.observe(target, { childList: true });
    $(document).on('focusin', '#zipcode-search', function() {
      $(this).addClass('expanded');
      $(this).find('input').attr('placeholder', 'Search zipcode, city, county, or state');
    });

    $(document).on('focusout', '#zipcode-search', function() {
      $(this).removeClass('expanded');
      $(this).find('input').attr('placeholder', 'Anywhere');
    });

    var input = $('#zipcode-search input');
    $(input).on('focusout', function(e) {
      var searchRegex = /zipcode|city|state|county/;
      var isFiltered = window.location.search.match(searchRegex);

      if($(e.target).val() === "" && isFiltered) {
        e.preventDefault();
        $form = $('form.zipcode-search-form');

        Turbolinks.visit($form.attr('action'));
      }
    });

    initZipcodeSearch();
    zipcodeSearch.attr('loaded', true);
  }
});
