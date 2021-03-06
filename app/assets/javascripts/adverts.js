// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


//$(".image-adder #fileupload").on("changed", function(e) {
//    console.log("here0 "+ $(".image-adder .btn.indiv-upload").length);
//
//    //e.stopPropagation(); 
//    //alert();
//    //return false;
//});
//

$("#fileupload").on("change.bs.fileinput", function(e) {
  setTimeout( function() {
    $(".image-adder .btn.indiv-upload:first").click();
  }, 500);
});


$(document).on('ready page:load', function () {

  $(document).on('click', '.add-another-day', function() {
    var review_mode;
    if ( $(".review-block").length > 1 ) {
      review_mode = true;
    }
    $.ajax({
      type: "POST",
      url: '/adverts/'+$(this).data('advertid')+'/add_another_day',
      data: {
              review_mode: review_mode
            },
      success: function(data) {
        console.log("here");
        $(".open-house-times-edit-widget").html(data.html);
        $(".best_in_place").best_in_place();
        if (review_mode == true)
          $(".adverts-new-page").closest('body').find('.review-block').eq(3).find('.look-like-input, .look-like-textarea').css('border','2px solid #939393');
      },
      dataType: 'json'
    });


  });

  $(".adverts-new-page").closest('body').find('.review-block .look-like-input').css("border","0px");
  $(".adverts-new-page").closest('body').find('.review-block .look-like-textarea').css("border","0px");
  $(".adverts-new-page").closest('body').find('.review-block .best_in_place').css("pointer-events","none");
  $(".adverts-new-page").closest('body').find('.review-block .longblue').css('visibility', 'hidden');

  $(".best_in_place").best_in_place();

  $(".edit_block").on('click', function() {
    $(this).closest('.editable-block').find(".best_in_place").css("outline","1px solid gray");
  });

  $(document).on('click', '.my-close', function() {
    $.ajax({
      type: "POST",
      url: '/properties/img_rm',
      data: { propertyid: $(this).data("propertyid"),
              index: $(this).data("index")
            },
      success: function() {  location.reload();   },
      dataType: 'json'
    });

  });

  //$(".my-close").css('visibility','hidden');
  //$(".my-close").eq(-1).css('visibility','visible');



  
  



  $(function () {
      'use strict';
      // Change this to the location of your server-side upload handler:
      var url = window.location.hostname === 'blueimp.github.io' ?
                  '//jquery-file-upload.appspot.com/' : 'server/php/',
          uploadButton = $('<button class="indiv-upload" />')
              .addClass('btn btn-primary')
              .prop('disabled', true)
              .text('Processing...')
              .on('click', function () {
                  var $this = $(this),
                      data = $this.data();
                  $this
                      .off('click')
                      .text('Abort')
                      .on('click', function () {
                          $this.remove();
                          data.abort();
                      });
                  data.submit().always(function () {
                      $this.remove();
                  });
              });
      $('#fileupload').fileupload({
          url: url,
          dataType: 'json',
          formData: {propertyid: $("#fileupload").data('propertyid') },
          autoUpload: false,
          acceptFileTypes: /(\.|\/)(jpe?g)$/i,
          maxFileSize: 999000,
          // Enable image resizing, except for Android and Opera,
          // which actually support image resizing, but fail to
          // send Blob objects via XHR requests:
          disableImageResize: /Android(?!.*Chrome)|Opera/
              .test(window.navigator.userAgent),
          previewMaxWidth: 100,
          previewMaxHeight: 100,
          previewCrop: true
      }).on('fileuploadadd', function (e, data) {
          data.context = $('<div/>').appendTo('#files');
          $.each(data.files, function (index, file) {
              var node = $('<p/>');

              if (!index) {
                  node

                      .append(uploadButton.clone(true).data(data));
              }
              node.appendTo(data.context);
              //node.attr('data-property-id', 'aaa' );
          });
      }).on('fileuploadprocessalways', function (e, data) {
          //$(".my-close").css('visibility', 'hidden');
          var index = data.index,
              file = data.files[index],
              node = $(data.context.children()[index]);
          if (file.preview) {
              node
                  .prepend('<br>')
                  .prepend(file.preview);
          }
          if (file.error) {
              node
                  .append('<br>')
                  .append($('<span class="text-danger"/>').text(file.error));
          }
          if (index + 1 === data.files.length) {
              data.context.find('button')
                  .text('Upload')
                  .prop('disabled', !!data.files.error);
          }
      }).on('fileuploadprogressall', function (e, data) {
          var progress = parseInt(data.loaded / data.total * 100, 10);
          $('#progress .progress-bar').css(
              'width',
              progress + '%'
          );
      }).on('fileuploaddone', function (e, data) {
          $(".adverts-new-page canvas:last-of-type").wrap("<div class='img-wrap'></div>");
          $("<span class='my-close'>&times;</span>").appendTo( $(".img-wrap:last-of-type") );
          //$(".my-close").css('visibility', 'hidden');
          //$(".my-close").eq(-1).css('visibility', 'visible');
          $(".my-close").eq(-1).data('propertyid',$(this).data('propertyid'));
            $.getJSON("/properties/"+$(this).data('propertyid')+"/images_tot", null, function(data) {
            console.log("wrap length was "+ ($(".img-wrap").length) + " setting last myclose index to "+ (data.images_tot-1) );
            $(".my-close").eq(-1).data('index', (data.images_tot-1) );
          });
          $.each(data.result.files, function (index, file) {
              if (file.url) {
                  var link = $('<a>')
                      .attr('target', '_blank')
                      .prop('href', file.url);
                  $(data.context.children()[index])
                      .wrap(link);
              } else if (file.error) {
                  var error = $('<span class="text-danger"/>').text(file.error);
                  $(data.context.children()[index])
                      .append('<br>')
                      .append(error);
              }
              location.reload();
          });
      }).on('fileuploadfail', function (e, data) {
          $.each(data.files, function (index) {
              var error = $('<span class="text-danger"/>').text('File upload failed.');
              $(data.context.children()[index])
                  .append('<br>')
                  .append(error);
          });
      }).prop('disabled', !$.support.fileInput)
          .parent().addClass($.support.fileInput ? undefined : 'disabled');
  });
  

});


function validate_step_4() {
  if ( $(".adverts-new-page .agree").is(":checked") == true ) {
    return true;
  } else {
    $("input.agree").notify("In agreement with our Terms of Use?");
    return false;
  }
}


function validate_step_5() {
  var errors = "";
  var success_url = '/users/'+$(".adverts-new-page").data('user-id')+'/adverts';
  var property_id = $(".adverts-new-page").data('property-id');
  var advert_id = $(".adverts-new-page").data('advert-id');
  var val = $('*[data-bip-attribute="address"]').text();
  // address validations - cannot be empty
  if ( val.indexOf('Address of Property for Sale') > -1 ) {
    errors = errors + "  Invalid: Address<br>\n";
  }
  val = $('*[data-bip-attribute="city"]').text();
  // city validations - cannot be empty
  if ( val == 'City' ) {
    errors = errors + "  Invalid: City<br>\n";
  }
  val = $('*[data-bip-attribute="state"]').text();
  // state validations - cannot be empty
  if ( val == 'State eg. FL' ) {
    errors = errors + "  Invalid: State<br>\n";
  }
  val = $('*[data-bip-attribute="price"]').text();
  // price validations - cannot be empty
  if ( val == 'Set your price' ) {
    errors = errors + "  Invalid: Price<br>\n";
  }
  val = $('*[data-bip-attribute="ptype"]').text();
  // price validations - cannot be empty
  if ( val == 'Property Type' ) {
    errors = errors + "  Invalid: Property Type<br>\n";
  }
  val = $('*[data-bip-attribute="beds"]').text();
  // beds validations - cannot be empty
  if ( val == '# of bedrooms' ) {
    errors = errors + "  Invalid: # of bedrooms<br>\n";
  }
  val = $('*[data-bip-attribute="baths"]').text();
  // baths validations - cannot be empty
  if ( val == '# of bathrooms' ) {
    errors = errors + "  Invalid: # of bathrooms<br>\n";
  }
  val = $('*[data-bip-attribute="area"]').text();
  // area validations - cannot be empty
  if ( val == 'Property size in Square Feet' ) {
    errors = errors + "  Invalid: Property size in Square Feet<br>\n";
  }
  val = $('*[data-bip-attribute="garage"]').text();
  // garage validations - cannot be empty
  if ( val == '# of garage spaces' ) {
    errors = errors + "  Invalid: Property size in Square Feet<br>\n";
  }
  if (errors.length > 0) {
    $("#myModal .modal-body p").html(errors);
    $('#myModal').modal('show');
    //alert('Please correct the following issues:\n' + errors);
    return false;
  } else {
    $.ajax({
      type: 'POST',
      url: '/properties/' + property_id + '?mf=TGlzdGluZyBzYXZlZA==',
      data: { _method: 'PUT', property: { date: new Date().toISOString() } },
      success: function() { /*alert('Listing saved.');*/ return true; },
      dataType: 'json',
      async: false
    });
    $.ajax({
      type: 'POST',
      url: '/adverts/' + advert_id,
      data: { _method: 'PUT', advert: { completed: 't' } },
      success: function() {  },
      dataType: 'json',
      async: false
    });
    
    //$.post('/properties/' + property_id, { _method: 'PUT', property: { date: new Date().toISOString() } }, function (data) {
    //  alert('Listing saved.');
    //  return true;
    //});
  }

}


function toggle_review_block(elem,ndx) {
  if ($(".adverts-new-page").closest('body').find('.review-block').eq(ndx).find('.best_in_place').eq(0).css('pointer-events') == 'none' ) {
    $(".adverts-new-page").closest('body').find('.review-block').eq(ndx).find('.best_in_place').css('pointer-events','inherit');
    $(".adverts-new-page").closest('body').find('.review-block').eq(ndx).find('.look-like-input, .look-like-textarea').css('border','2px solid #939393');
    //$(".adverts-new-page").closest('body').find('.review-block').eq(ndx).find('.look-like-input').eq(0).click();
  } else {
    $(".adverts-new-page").closest('body').find('.review-block').eq(ndx).find('.best_in_place').css('pointer-events','none');
    $(".adverts-new-page").closest('body').find('.review-block').eq(ndx).find('.look-like-input, .look-like-textarea').css('border','0px');
  }

  if (ndx == 1) {
    if ( $(".longblue").css('visibility') == "visible") {
      //$(".longblue").css('visibility', 'hidden');
      //$("button.indiv-upload").css('visibility','hidden');
    } else {
      $(".longblue").css('visibility', 'visible');
      $("button.indiv-upload").css('visibility','visible');
    }
    window.location.replace('/adverts/new?step=2&propertyid=' + $(".adverts-new-page").data('property-id') );
  }

  if (ndx == 3) {
    $("a.add-another-day").removeClass("hide");
  }

}


