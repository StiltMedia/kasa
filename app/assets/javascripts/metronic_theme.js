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


  if ( ! ($('.jstree_demo_div').jstree == undefined) ) {
    $('.jstree_demo_div').jstree({}).on('ready.jstree', function() { 
        console.log("loaded");
        $(this).jstree('open_all');
        offers_bindings();

    });
  }
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

function refresh_offers_portlet() {
    $.ajax({
      type: 'GET',
      dataType: "json",
      url: '/pages/refresh_offers_portlet',
      data: { 
      },
      beforeSend:function(){
      },
      success:function(data){
        $(".page-container.user-dashboard .portlet.offers").html(data.content);
        offers_bindings();
        $('.jstree_demo_div').jstree({}).on('ready.jstree', function() { 
                console.log("loaded");
                $(this).jstree('open_all');
                offers_bindings();
        });
      },
      error:function(){
      }
    });
}

function offers_bindings() {

    $(".portlet .btn.accept, .portlet .btn.decline, .portlet .btn.counter").on("click", function() {
        var data = { 
              negotiation: { 
                  property_id: $(this).data('property-id'),
                  buyer_id: $(this).data('buyer-id'),
                  seller_id: $(this).data('seller-id'),
                  ntype: $(this).data('ntype'),
                  ndate: new Date().toUTCString(),
                  amount: -1
              }
        };

        if ( $(this).hasClass('counter') == true ) {
            bootbox.prompt("Enter amount (digits only)", function(result) {                
              if (result === null) {
                console.log("Prompt dismissed");
              } else if (isNaN(result) ) {
                alert('Amount has to be numeric');
              } else {
                data.negotiation.amount = result;
                $.ajax({
                  type: 'POST',
                  dataType: "json",
                  url: '/negotiations',
                  data: data,
                  beforeSend:function(){
                  },
                  success:function(data){
                    refresh_offers_portlet();
                  },
                  error:function(){
                    alert('Error');
                  }
                });
              }
            });
        } else {
              data.negotiation.amount = null;
              $.ajax({
                type: 'POST',
                dataType: "json",
                url: '/negotiations',
                data: data,
                beforeSend:function(){
                },
                success:function(data){
                  refresh_offers_portlet();
                },
                error:function(){
                  alert('Error');
                }
              });
        } 
    }); 

    $(".portlet .btn.decline").on("click", function() {
       refresh_offers_portlet();
    }); 


    $(".portlet .btn.accept").on("click", function() {
       refresh_offers_portlet();
    }); 

    $(".portlet .btn.counter").on("click", function() {
       refresh_offers_portlet();
    }); 


  //$(".btn.accept-offer, .btn.accept-counter, .btn.counter,.btn.decline-counter,.btn.decline-offer").on("click", function() {
  // if ($(this).closest(".portlet").find("input:checked").length == 0) {
  //   $(this).notify("None selected",{arrowShow: false,autoHideDelay: 2000});
  //   return false;
  // }
  // if ($(this).closest(".portlet").find("input:checked").length >1) {
  //   $(this).notify("Select 1",{arrowShow: false,autoHideDelay: 2000});
  //   return false;
  // }    
  //});

  //$(".page-container.user-dashboard .btn.accept-offer").on('click', function() {
  //  if ($(this).closest(".portlet").find("input:checked").first().closest('tr').data("ntype") != "offer" ) {
  //    $(this).notify("Select an offer to accept it",{arrowShow: false,autoHideDelay: 2000});
  //    return false;
  //  }
  //  var src = $(this).closest(".portlet").find("input:checked").first().closest('tr').data("src");
  //  var dst=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("dst");
  //  var property_id=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("property-id");
  //  $.ajax({
  //    type: 'POST',
  //    dataType: "json",
  //    url: '/negotiations',
  //      data: { negotiation: { src: dst, dst: src, details: null, ndate: null, ntype: "accept-offer", property_id: property_id } },
  //    beforeSend:function(){
  //      //$(".page-container.tickets-show .timeline-body-content:last").css('background', "rgba(255,255,255,0.5)");
  //    },
  //    success:function(data){
  //      $(".page-container.user-dashboard .offers.refreshable").html(data.content);
  //      offers_bindings();
  //    },
  //    error:function(){
  //      //alert('Ajax error');
  //    }
  //  });
  //});

  //$(".page-container.user-dashboard .btn.decline-offer").on('click', function() {
  //  if ($(this).closest(".portlet").find("input:checked").first().closest('tr').data("ntype") != "offer" ) {
  //      $(this).notify("Select an offer to decline it",{arrowShow: false,autoHideDelay: 2000});
  //    return false;
  //  }
  //  var src = $(this).closest(".portlet").find("input:checked").first().closest('tr').data("src");
  //  var dst=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("dst");
  //  var property_id=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("property-id");
  //  $.ajax({
  //    type: 'POST',
  //    dataType: "json",
  //    url: '/negotiations',
  //      data: { negotiation: { src: dst, dst: src, details: null, ndate: null, ntype: "decline-offer", property_id: property_id } },
  //    beforeSend:function(){
  //      //$(".page-container.tickets-show .timeline-body-content:last").css('background', "rgba(255,255,255,0.5)");
  //    },
  //    success:function(data){
  //      $(".page-container.user-dashboard .offers.refreshable").html(data.content);
  //      offers_bindings();
  //    },
  //    error:function(){
  //      //alert('Ajax error');
  //    }
  //  });
  //});
  //
  //
  //
  //$(".page-container.user-dashboard .btn.counter").on('click', function() {
  //  if ($(this).closest(".portlet").find("input:checked").first().closest('tr').data("ntype") != "offer" ) {
  //      $(this).notify("Select an offer to counter it",{arrowShow: false,autoHideDelay: 2000});
  //    return false;
  //  }
  //  var src = $(this).closest(".portlet").find("input:checked").first().closest('tr').data("src");
  //  var dst=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("dst");
  //  var property_id=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("property-id");
  //  $.ajax({
  //    type: 'POST',
  //    dataType: "json",
  //    url: '/negotiations',
  //      data: { negotiation: { src: dst, dst: src, details: null, ndate: null, ntype: "counter", property_id: property_id } },
  //    beforeSend:function(){
  //    },
  //    success:function(data){
  //      $(".page-container.user-dashboard .offers.refreshable").html(data.content);
  //      offers_bindings();
  //    },
  //    error:function(){
  //    }
  //  });
  //});
  //
  //$(".page-container.user-dashboard .btn.accept-counter").on('click', function() {
  //  if ($(this).closest(".portlet").find("input:checked").first().closest('tr').data("ntype") != "counter" ) {
  //      $(this).notify("Select a counter to accept it",{arrowShow: false,autoHideDelay: 2000});
  //    return false;
  //  }
  //  var src = $(this).closest(".portlet").find("input:checked").first().closest('tr').data("src");
  //  var dst=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("dst");
  //  var property_id=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("property-id");
  //  $.ajax({
  //    type: 'POST',
  //    dataType: "json",
  //    url: '/negotiations',
  //      data: { negotiation: { src: dst, dst: src, details: null, ndate: null, ntype: "accept-counter", property_id: property_id } },
  //    beforeSend:function(){
  //    },
  //    success:function(data){
  //      $(".page-container.user-dashboard .offers.refreshable").html(data.content);
  //      offers_bindings();
  //    },
  //    error:function(){
  //    }
  //  });
  //});
  //
  //
  //$(".page-container.user-dashboard .btn.decline-counter").on('click', function() {
  //  if ($(this).closest(".portlet").find("input:checked").first().closest('tr').data("ntype") != "counter" ) {
  //      $(this).notify("Select a counter to decline it",{arrowShow: false,autoHideDelay: 2000});
  //    return false;
  //  }
  //  var src = $(this).closest(".portlet").find("input:checked").first().closest('tr').data("src");
  //  var dst=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("dst");
  //  var property_id=  $(this).closest(".portlet").find("input:checked").first().closest('tr').data("property-id");
  //  $.ajax({
  //    type: 'POST',
  //    dataType: "json",
  //    url: '/negotiations',
  //      data: { negotiation: { src: dst, dst: src, details: null, ndate: null, ntype: "decline-counter", property_id: property_id } },
  //    beforeSend:function(){
  //    },
  //    success:function(data){
  //      $(".page-container.user-dashboard .offers.refreshable").html(data.content);
  //      offers_bindings();
  //    },
  //    error:function(){
  //    }
  //  });
  //});



}
