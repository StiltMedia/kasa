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

  if ( ! ($('.dd').nestable == undefined) )
    $('.dd').nestable();
  if ( ! ($('.jstree_demo_div').jstree == undefined) )
    $('.jstree_demo_div').jstree();
  offers_bindings();


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



function offers_bindings() {

  $(".btn.accept-offer, .btn.accept-counter, .btn.counter,.btn.decline-counter,.btn.decline-offer").on("click", function() {
   if ($(this).closest(".portlet").find("input:checked").length == 0) {
     $(this).notify("None selected",{arrowShow: false,autoHideDelay: 2000});
     return false;
   }
   if ($(this).closest(".portlet").find("input:checked").length >1) {
     $(this).notify("Select 1",{arrowShow: false,autoHideDelay: 2000});
     return false;
   }    
  });

  $(".page-container.user-dashboard .btn.accept-offer").on('click', function() {
    if ($(this).closest(".portlet").find("input:checked").first().closest('tr').data("ntype") != "offer" ) {
      $(this).notify("Select an offer to accept it",{arrowShow: false,autoHideDelay: 2000});
      return false;
    }
    var src = $(this).closest(".portlet").find("input:checked").first().closest('tr').data("src");
    var dst=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("dst");
    var property_id=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("property-id");
    $.ajax({
      type: 'POST',
      dataType: "json",
      url: '/negotiations',
        data: { negotiation: { src: dst, dst: src, details: null, ndate: null, ntype: "accept-offer", property_id: property_id } },
      beforeSend:function(){
        //$(".page-container.tickets-show .timeline-body-content:last").css('background', "rgba(255,255,255,0.5)");
      },
      success:function(data){
        $(".page-container.user-dashboard .offers.refreshable").html(data.content);
        offers_bindings();
      },
      error:function(){
        //alert('Ajax error');
      }
    });
  });

  $(".page-container.user-dashboard .btn.decline-offer").on('click', function() {
    if ($(this).closest(".portlet").find("input:checked").first().closest('tr').data("ntype") != "offer" ) {
        $(this).notify("Select an offer to decline it",{arrowShow: false,autoHideDelay: 2000});
      return false;
    }
    var src = $(this).closest(".portlet").find("input:checked").first().closest('tr').data("src");
    var dst=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("dst");
    var property_id=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("property-id");
    $.ajax({
      type: 'POST',
      dataType: "json",
      url: '/negotiations',
        data: { negotiation: { src: dst, dst: src, details: null, ndate: null, ntype: "decline-offer", property_id: property_id } },
      beforeSend:function(){
        //$(".page-container.tickets-show .timeline-body-content:last").css('background', "rgba(255,255,255,0.5)");
      },
      success:function(data){
        $(".page-container.user-dashboard .offers.refreshable").html(data.content);
        offers_bindings();
      },
      error:function(){
        //alert('Ajax error');
      }
    });
  });



  $(".page-container.user-dashboard .btn.counter").on('click', function() {
    if ($(this).closest(".portlet").find("input:checked").first().closest('tr').data("ntype") != "offer" ) {
        $(this).notify("Select an offer to counter it",{arrowShow: false,autoHideDelay: 2000});
      return false;
    }
    var src = $(this).closest(".portlet").find("input:checked").first().closest('tr').data("src");
    var dst=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("dst");
    var property_id=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("property-id");
    $.ajax({
      type: 'POST',
      dataType: "json",
      url: '/negotiations',
        data: { negotiation: { src: dst, dst: src, details: null, ndate: null, ntype: "counter", property_id: property_id } },
      beforeSend:function(){
      },
      success:function(data){
        $(".page-container.user-dashboard .offers.refreshable").html(data.content);
        offers_bindings();
      },
      error:function(){
      }
    });
  });

  $(".page-container.user-dashboard .btn.accept-counter").on('click', function() {
    if ($(this).closest(".portlet").find("input:checked").first().closest('tr').data("ntype") != "counter" ) {
        $(this).notify("Select a counter to accept it",{arrowShow: false,autoHideDelay: 2000});
      return false;
    }
    var src = $(this).closest(".portlet").find("input:checked").first().closest('tr').data("src");
    var dst=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("dst");
    var property_id=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("property-id");
    $.ajax({
      type: 'POST',
      dataType: "json",
      url: '/negotiations',
        data: { negotiation: { src: dst, dst: src, details: null, ndate: null, ntype: "accept-counter", property_id: property_id } },
      beforeSend:function(){
      },
      success:function(data){
        $(".page-container.user-dashboard .offers.refreshable").html(data.content);
        offers_bindings();
      },
      error:function(){
      }
    });
  });


  $(".page-container.user-dashboard .btn.decline-counter").on('click', function() {
    if ($(this).closest(".portlet").find("input:checked").first().closest('tr').data("ntype") != "counter" ) {
        $(this).notify("Select a counter to decline it",{arrowShow: false,autoHideDelay: 2000});
      return false;
    }
    var src = $(this).closest(".portlet").find("input:checked").first().closest('tr').data("src");
    var dst=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("dst");
    var property_id=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("property-id");
    $.ajax({
      type: 'POST',
      dataType: "json",
      url: '/negotiations',
        data: { negotiation: { src: dst, dst: src, details: null, ndate: null, ntype: "decline-counter", property_id: property_id } },
      beforeSend:function(){
      },
      success:function(data){
        $(".page-container.user-dashboard .offers.refreshable").html(data.content);
        offers_bindings();
      },
      error:function(){
      }
    });
  });



}
