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

if ($("#ex1").length > 0) {
    var slider = new Slider('#ex1', {
        formatter: function (value) {
            $(".wewill .amount").text('$' + numberWithCommas(value * 0.005));
            return 'Purchase Price $' + numberWithCommas(value);
        }, tooltip: 'always',
    });
}


$(document).ready(function () {

    $('.more-filters-page#myModal').on('hidden.bs.modal', function () {
        window.location.href = '/pages/browse'
    })


    $(".more-filters-page .btn.view_results").click(function () {
        var query_string = '';
        query_string = query_string + 'min_price=' + $(".more-filters-page input.min_price").val() + '&';
        query_string = query_string + 'max_price=' + $(".more-filters-page input.max_price").val() + '&';
        query_string = query_string + 'search=' + $(".more-filters-page input.search").val() + '&';
        query_string = query_string + 'beds=' + $(".more-filters-page input.beds").val() + '&';
        query_string = query_string + 'baths=' + $(".more-filters-page input.baths").val() + '&';
        query_string = query_string + 'area=' + $(".more-filters-page input#area").val() + '&';
        query_string = query_string + 'area_lot=' + $(".more-filters-page input#area_lot").val() + '&';
        window.location.href = '/pages/browse?' + query_string;

    });


    if ($("body").hasClass('map-view')) {
        var vh = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
        var vh2 = $('.browse-page .right-panel')[0].getBoundingClientRect().y;
        $(".browse-page .right-panel").css('height', vh - vh2 - 3);
        $(".browse-page #map_canvas").css('height', vh - vh2 - 10);
    }


    $('.twitter.popup').click(function (event) {
        var width = 575,
            height = 400,
            left = ($(window).width() - width) / 2,
            top = ($(window).height() - height) / 2,
            url = this.href,
            opts = 'status=1' +
                ',width=' + width +
                ',height=' + height +
                ',top=' + top +
                ',left=' + left;

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
    $("section.signup form#new_user").submit(function (event) {
        if ($("form#new_user input.tos").is(':checked') == false) {
            alert('Please agree to the Terms of Service');
            event.preventDefault();
        }
    });


    // functions related to users pressing favorite button
    // in the browse page
    $('.browse-page .links a.favorite, .listing_details .links a.favorite').click(function () {
        var this_elem = $(this);
        var url = "/api/favorite_on";
        var user_id = $(this).data('userid');
        var property_id = $(this).data('propertyid');
        if ($(this).hasClass('fav-on') == true) {
            url = "/api/favorite_off";
        }
        $.post(url, {user_id: user_id, property_id: property_id}, function (data) {
            if (data.status == 'ok') {
                this_elem.toggleClass('fav-on');
            } else {
                console.log('Error b1832d');
            }
        });


    });


    var typingTimer;                //timer identifier
    var typingTimer_2;              //timer identifier
    var typingTimer_3;              //timer identifier
    var doneTypingInterval = 750;  //time in ms, 5 second for example

    //on keyup, start the countdown
    $('.browse-page input.search').keydown(function () {
        clearTimeout(typingTimer);
        if ($('.browse-page .search-bar input.search').val()) {
            typingTimer = setTimeout(function () {
                $('.browse-page input.search').addClass('loading-gif');
                setTimeout(function () {
                    window.location.href = '?search='
                        + $('.browse-page input.search').val();
                }, 500);

            }, doneTypingInterval);
        }
    });

    //on keyup, start the countdown
    $('.browse-page input.min_price').keydown(function () {
        clearTimeout(typingTimer_2);
        if ($('.browse-page .search-bar input.min_price').val()) {
            typingTimer_2 = setTimeout(function () {
                $('.browse-page input.min_price').addClass('loading-gif');
                setTimeout(function () {
                    window.location.href = '?min_price='
                        + $('.browse-page input.min_price').val();
                }, 500);

            }, doneTypingInterval);
        }
    });

    //on keyup, start the countdown
    $('.browse-page input.max_price').keydown(function () {
        clearTimeout(typingTimer_3);
        if ($('.browse-page .search-bar input.max_price').val()) {
            typingTimer_3 = setTimeout(function () {
                $('.browse-page input.max_price').addClass('loading-gif');
                setTimeout(function () {
                    window.location.href = '?max_price='
                        + $('.browse-page input.max_price').val();
                }, 500);

            }, doneTypingInterval);
        }
    });


});

/* --- Magnific Popup Init --------------- */
/*  carousel gallery popup- - - */
$('.gallery-image').magnificPopup({
    delegate: 'a',
    type: 'image',
    gallery: {
        enabled: true
    }
    // other options
});


function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
