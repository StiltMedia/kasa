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
//= require jquery_ujs
//= require best_in_place
//= require notifyjs_rails
//= require_self


$("document").ready( function() {

  if ( $(".page-container.user-dashboard").length > 0 ) {
    //$("#sparkline_bar").sparkline([8,9,10,11,10,10,12,10,10,11,8,9,10,11,10,10,12,10,10,11,8,9,10,11,10,10,12,10,10,11],{type:"bar",width:"400",barWidth:10,height:"220",barColor:"#35aa47",negBarColor:"#e02222"})
    $("#sparkline_bar").sparkline($(".page-container").data("stats"),{type:"bar",width:"400",barWidth:10,height:"220",barColor:"#35aa47",negBarColor:"#e02222"})
  }

  $(".best_in_place").best_in_place();

  $(".page-container.tickets-show .btn.reply").on('click', function() {
    
      var ticket_id = $(".page-container").data("ticket-id");
      var url = '/tickets/'+ticket_id+'/add_memo';
      var body = $(".page-container.tickets-show .timeline-body-content:last").text().trim();
      if (body.length == 0) {
        $.notify("Empty");
        return false;
      }

      $.ajax({
        type: 'POST',
        dataType: "json",
        url: url,
        data: { body: body },
        beforeSend:function(){
          $(".page-container.tickets-show .timeline-body-content:last").css('background', "rgba(255,255,255,0.5)");
        },
        success:function(data){
          $(".page-container.tickets-show .timeline .refreshable").html(data.content);
        },
        error:function(){
          alert('Ajax error');
        }
      });
      





  });
});

