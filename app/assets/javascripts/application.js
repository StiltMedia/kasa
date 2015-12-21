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

var map; //the google map used in browse page ->  maps view

function fbShare(url, title, descr, image, winWidth, winHeight) {
    var winTop = (screen.height / 2) - (winHeight / 2);
    var winLeft = (screen.width / 2) - (winWidth / 2);
    window.open('http://www.facebook.com/sharer.php?s=100&p[title]=' + title + '&p[summary]=' + descr + '&p[url]=' + url + '&p[images][0]=' + image, 'sharer', 'top=' + winTop + ',left=' + winLeft + ',toolbar=0,status=0,width=' + winWidth + ',height=' + winHeight);
}

if ( $("#ex1").length > 0 ) {
  // Without JQuery
  var slider = new Slider('#ex1', {
  	formatter: function(value) {
                  $(".wewill .amount").text('$'+numberWithCommas(value*0.005));
  		return 'Purchase Price $' + numberWithCommas(value);
  	}, tooltip: 'always',
  });
}


$(document).ready(function() {
  

  $('.twitter.popup').click(function(event) {
    var width  = 575,
        height = 400,
        left   = ($(window).width()  - width)  / 2,
        top    = ($(window).height() - height) / 2,
        url    = this.href,
        opts   = 'status=1' +
                 ',width='  + width  +
                 ',height=' + height +
                 ',top='    + top    +
                 ',left='   + left;
    
    window.open(url, 'twitter', opts);
    return false;
  });

  // Google Maps initializations
  function gm_initialize() {
    var mapOptions = {
      center: new google.maps.LatLng(25.7753, -80.2089),
      zoom: 10
    };
    map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
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
