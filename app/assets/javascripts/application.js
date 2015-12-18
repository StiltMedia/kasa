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
