// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function() {
// Without JQuery
var slider = new Slider('#ex1', {
	formatter: function(value) {
                $(".wewill .amount").text('$'+numberWithCommas(value*0.005));
		return 'Purchase Price $' + numberWithCommas(value);
	}, tooltip: 'always',
});



  // Google Maps initializations
  function initialize() {
    var mapOptions = {
      center: new google.maps.LatLng(-34.397, 150.644),
      zoom: 8
    };
    var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
  }

  if ( window.location.href.indexOf("/pages/browse") > -1 ) {
    google.maps.event.addDomListener(window, 'load', initialize());
  }
  // end Google Maps initializations

  // ensure user agreed to tos
  $("section.signup form#new_user").submit(function(event) {
    if ( $("form#new_user input.tos").is(':checked') == false ) {
      alert('Please agree to the Terms of Service');
      event.preventDefault();
    }
  });


  // functions related to users pressing favorite button
  // in the browse page
  $('.browse-page .links a.favorite').click(function(){
    var this_elem = $(this);
    var url = "/api/favorite_on";
    var user_id = $(this).data('userid');
    var property_id = $(this).data('propertyid');
    if ($(this).hasClass('fav-on') == true) {
      url = "/api/favorite_off";
    }
    $.post( url, { user_id: user_id, property_id: property_id }, function( data ) {
      if (data.status == 'ok') {
        this_elem.toggleClass('fav-on');
      } else {
        console.log('Error b1832d');
      }
    });
    

  });




  var typingTimer;                //timer identifier
  var doneTypingInterval = 750;  //time in ms, 5 second for example

  //on keyup, start the countdown
  $('.browse-page input.search').keyup(function(){
      clearTimeout(typingTimer);
      if ($('.browse-page .search-bar input.search').val) {
          typingTimer = setTimeout(function(){
              //do stuff here e.g ajax call etc....
               //var v = $("#in").val();
               //$("#out").html(v);
               console.log("a");
               $('.browse-page input.search').addClass('loading-gif');
               setTimeout(function() {window.location.href = '?search=' 
+ $('.browse-page input.search').val(); },500);
               
          }, doneTypingInterval);
      }
  });
  
});


function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
