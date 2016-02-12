// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('ready page:load', function () {
  $(".best_in_place").best_in_place();

  $(".edit_block").on('click', function() {
    $(this).closest('.editable-block').find(".best_in_place").css("outline","1px solid gray");
  });
});

