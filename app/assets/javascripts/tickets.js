// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$( document ).ready(function() {

  $("#new_memo").on("ajax:success", function(e, data, status, xhr) {
    //$("#new_article").append(xhr.responseText);
    location.reload();
  }).on("ajax:error", function(e, xhr, status, error) {
    alert('Unspecified error');
  });

  $(".tasks-widget a.new-ticket").on('click', function() {
    
  });
});


