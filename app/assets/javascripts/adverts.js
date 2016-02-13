// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('ready page:load', function () {
  $(".best_in_place").best_in_place();

  $(".edit_block").on('click', function() {
    $(this).closest('.editable-block').find(".best_in_place").css("outline","1px solid gray");
  });

  $(document).on('click', '.my-close', function() {
    $.ajax({
      type: "POST",
      url: '/properties/img_rm',
      data: { propertyid: $(this).data("propertyid") },
      success: function() {  locatoin.reload();   },
      dataType: 'json'
    });

  });

  $(".my-close").css('visibility','hidden');
  $(".my-close").eq(-1).css('visibility','visible');




  $(function () {
      'use strict';
      // Change this to the location of your server-side upload handler:
      var url = window.location.hostname === 'blueimp.github.io' ?
                  '//jquery-file-upload.appspot.com/' : 'server/php/',
          uploadButton = $('<button/>')
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
              var node = $('<p/>')
                      .append($('<span/>').text(file.name));
              if (!index) {
                  node
                      .append('<br>')
                      .append(uploadButton.clone(true).data(data));
              }
              node.appendTo(data.context);
          });
      }).on('fileuploadprocessalways', function (e, data) {
          $(".my-close").css('visibility', 'hidden');
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
          //$(".adverts-new-page .img-wrap .my-close").css("display","none");
          //$( "<div class='img-wrap'><span class='my-close'>&times;</span></div>" ).insertAfter( $(".adverts-new-page canvas:last-of-type") );
          $(".adverts-new-page canvas:last-of-type").wrap("<div class='img-wrap'></div>");
          $("<span class='my-close'>&times;</span>").appendTo( $(".img-wrap:last-of-type") );
          $(".my-close").css('visibility', 'hidden');
          $(".my-close").eq(-1).css('visibility', 'visible');
          $(".my-close").eq(-1).data('propertyid',$(this).data('propertyid'));
          //$(a).css('display', 'none');
          //$(a).insertAfter ( $(".my-close:last-of-type") );
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
    alert('In agreement with our Terms of Use?');
    return false;
  }
}



