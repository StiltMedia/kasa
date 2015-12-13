jQuery(document).ready(function ($) {
    "use strict";

    if ($("#content").length > 0) {
        $(window).on('load', function () {
            setTimeout(function () {
                $('html,body').scrollTop(0)
            }, 0);
        });
    }

    /* One page scroll - - - - */
    $("#menu").localScroll({
        target: '#content', // could be a selector or a jQuery object too.
        queue: true,
        duration: 1000,
        hash: false,
    });
    $('#menu nav li').click(function () {
        $(this).addClass('active');
        $(this).parent().children('li').not(this).removeClass('active');
    });

    if ($("#content").length > 0) {
        var $element = $("#svg #MyGradient stop");
        var lastScrollTop = 0;
        $(window).on('scroll', function () {
            var st = $(this).scrollTop();
            if (st < lastScrollTop) {
                var percentage = percentageSeen();
                drawSVG(percentage);
            }
            else if (st > lastScrollTop) {
                var percentage = percentageSeen();
                drawSVG(percentage);
            }
            lastScrollTop = st;
        });
    }

    var oldOffset = 0;

    function drawSVG(offset) {
        $element.stop().attr("offset", oldOffset);
        $element.animate(
            {
                top: offset
            },
            {
                duration: 1000,
                step: function (now) {
                    $(this).attr("offset", now);
                }
            }
        );
        oldOffset = offset;
    }

    function percentageSeen() {

        var viewportHeight = $(window).height(),
            scrollTop = $(window).scrollTop(),
            elementOffsetTop = $('.visual-container').offset().top,
            elementHeight = $('.visual-container').height();

        var bottom = scrollTop + viewportHeight;

        if (elementOffsetTop > bottom) {
            return 0;
        } else if (elementOffsetTop + elementHeight <= bottom) {
            return 1;
        } else {
            var bottomElement = elementOffsetTop + elementHeight - bottom
            return 1.05 - bottomElement / elementHeight;
        }
    }

    /* price slider */
    $("#slider").slider({
        animate: false,
        value: 102000,
        min: 2000,
        max: 200000,
        step: 10000,
        slide: function (event, ui) {
            update(ui.value); //changed
        }
    });

    update();


//changed. now with parameter
    function update(val) {
        //changed. Now, directly take value from ui.value. if not set (initial, will use current value.)
        var $amount = val ? val : 102000;
        $('#slider a').html('<div class="amount"> ' + $amount + '</div>');
    }

    // checkbox
    $(".checkbox-huge input:checkbox").click(function () {
        $(".checkbox-huge input:checkbox").not($(this)).removeAttr("checked");
        $(this).attr("checked", $(this).attr("checked"));
    });

    // search properties adding class
    var $sv = $('.search-properties .property-fields ul li');
    $sv.on('click', function () {
        $sv.not($(this)).removeClass('checked');
        $(this).addClass('checked', $(this).addClass('checked'));
    });

    // mobile step add color blue
    if ($('.breadcrumb li:last-child').hasClass('active')) {
        $('.breadcrumb li:last-child').parent().css('background-color', '#154067');
    }

    if ($(window).width() < 1030) {
        $('.more-filter').on('click', function () {
            $('.mobile-search-filter').slideDown();
        });
    } else {
        $('.more-filter.modal-filter').click(function () {
            $('#myModal').modal();
        });
    }
    $('.close-filter').on('click', function () {
        $('.mobile-search-filter').slideUp();
    });

    // Inside filter dropdowns
    $('.dropdown-filter > li').on('click', function () {
        $(this).find($('.d-filter-inside')).slideDown();
    });
    $('.mobile-options .done').on('click', function (e) {
        e.preventDefault();
        $(this).closest($('.d-filter-inside')).slideUp();
        $(this).closest('options').closest('.option').focus().find('.result').html($(event.target).text());
        e.stopPropagation();
    });

    var $first = $('li:first', '.options'),
        $last = $('li:last', '.options');
// Have the first and last li's set to a variable
    $(".m-arrows .next").click(function () {

        var $next,
            $selected = $(this).parents('.d-filter-inside').find(".selected");
        // get the selected item
        // If next li is empty , get the first
        $next = $selected.next('li').length ? $selected.next('li') : $first;
        $selected.removeClass("selected");
        $next.addClass('selected');
        if ($selected) {
            $selected.find('a').focus();
        }
    });

    $(".prev").click(function () {
        var $prev,
            $selected = $(".selected");
        // get the selected item
        // If prev li is empty , get the last
        $prev = $selected.prev('li').length ? $selected.prev('li') : $last;
        $selected.removeClass("selected");
        $prev.addClass('selected');
        if ($selected) {
            $selected.find('a').focus();
        }
    });

    $('.options a').on('click', function (e) {
        e.preventDefault();
        $(this).focus().closest('.option').find('.result').html($(event.target).text());
        $(this).closest('.options').find('li').removeClass('selected')
        $(this).parent().addClass('selected')
    });

    $('.options a').on('focus', function() {
        $(this).closest('.option').find('.result').html($(event.target).text());
    });

});
