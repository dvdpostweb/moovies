/// toggle text
jQuery.fn.extend({
    toggleText: function (a, b) {
        var isClicked = false;
        var that = this;
        this.click(function () {
            if (isClicked) {
                that.html(a);
                isClicked = false;
            }
            else {
                that.html(b);
                isClicked = true;
            }
        });
        return this;
    }
});

/// common handlers

$(document).ready(function () {
    "use strict"; // Start of use strict

    function mainSidemenuState(state) {
        switch (state) {
            case 'on':
                $(".canavas").addClass('on');
                $("#overlay").addClass('on');
                break;
            case 'off':
                $(".canavas").removeClass('on');
                $("#overlay").removeClass('on');
                break;
        }
    }

    function filtersPanelState(state) {
        $('.content-left #filters-open-adaptive .fa').toggleClass("fa-arrow-up fa-arrow-down");
        switch (state) {
            case 'on':
                $('#filters-open-adaptive').addClass('on');
                $('.content-left').addClass('on');
                $("#overlay").addClass('on');
                break;
            case 'off':
                $('#filters-open-adaptive').removeClass('on');
                $('.content-left').removeClass('on');
                $("#overlay").removeClass('on');
                break;
        }
    }

    // preload canavas content
    $('.canavas').waitForImages(function () {
        $('.canavas').fadeIn('1000');
    })

    // toggle sidemenu (main menu)
    $(".side-menu-close").on('click', function () {
        mainSidemenuState('off');
    });

    $(".navbar-toggle").on('click', function () {
        mainSidemenuState('on');
    });

    //on resize window event
    $(window).resize(function () {
        //checkMq();
        //mainSidemenuState('off');
        //filtersPanelState('off');
    });

    // bootsrap affix navbar offset
    $('.navbar-default').affix({
        offset: {
            top: 80
        }
    })
    // bootsrap affix on top offset
    $('#on-top').affix({
        offset: {
            top: 380
        }
    })

    // scroll top -> on top
    $('#on-top').on('click', function (event) {
        $(this).removeClass('affix');
        $('html, body').animate({scrollTop: 0}, '500');
    });

    // clone main to side menu
    $(".top-header > div").clone().appendTo(".side-menu-login");
    $(".navbar-collapse").clone().appendTo(".side-menu-nav");
    $(".top-search-holder").clone().appendTo(".side-menu-search");


    // promo code top panel
    $('#user-status-switch').on('click', function () {
        $('.panel-enter-code, .top-green-status').toggleClass('on');
        return false;
    }).toggleText('<i class="fa fa-copy marr5"></i><a href="#" id="promo-code-open" class="no-decoration">(voir tout)</a>', '<i class="fa fa-minus marr5"></i><a href="#" id="promo-code-open" class="no-decoration"> (minimiser)</a>');

    //promo code left/filter panel
    $('#left-promo-code-trigger').on('click', function (e) {
        $('.left-promo-code').toggleClass("on");
        $('#left-promo-code-trigger .fa-caret-down').toggleClass("white");
        e.preventDefault();
    });

    // filters content left states
    $('#filters-open-adaptive').on('click', function () {
        $(this).toggleClass("green");
        if ($('.content-left').is(".on")) {
            filtersPanelState('off');
        } else {
            filtersPanelState('on');
            $(".canavas").removeClass('on');
        }
    });

    // ajax settings
    //var ajaxTriggDelayTime = 800;
    //var hostname = $(location).attr('hostname');

    //function ajaxFilters() {
    //    var view_movies = $('input[name=view_movies]').val();
    //
    //    setTimeout(function () {
    //        if (view_movies === '') {
    //            $('input[name=view_movies]').val('list');
    //            $('.content-right').attr('id', 'list');
    //        }
    //        var form_filters = $('#filters-form');
    //        var data_form = form_filters.serialize();
    //        $.ajax({
    //            type: "POST",
    //            url: '/',
    //            data: data_form,
    //            success: function (response) {
    //                console.log(data_form);
                    //location.href = 'http://' + hostname + '/index.php?page=home&' + data_form;
                    // $('.movies').empty().html(data_form + '<br><br>GUruuu, ovde ti ide ajax respond..:)');
                    //$('.movies').prepend("<strong class='block100 red-bck white padlr20 padtb5 radius4 mart10'>AJAX Filter is triggered</strong>");
    //            }
    //        });
    //    }, ajaxTriggDelayTime);
    //}

    // checkbox
    //$(".icheckbox,.iradio").iCheck({
    //    checkboxClass: 'icheckbox_minimal-grey',
    //    radioClass: 'iradio_minimal-grey'
    //});

    //$('#filters .iradio').on('ifChecked', function (e) {
    //    ajaxFilters();
    //});


    // cotations range slider
    var listing_handle = $("#custom-listing-handle");
    var listing_sizes = [1,2,3,4,5];
    var initialValueListing = 2;
    listing_handle.text(listing_sizes[initialValueListing]);

    $("#listing-slider").slider({
        value: initialValueListing,
        min: 0,
        max: listing_sizes.length - 1,
        create: function (event, ui) {
            listing_handle.text(listing_sizes[ui.value]);
        },
        slide: function (event, ui) {
            listing_handle.text(listing_sizes[ui.value]);
        }
    });


    // public range slider
    var range_handle = $("#custom-range-handle");
    var range_sizes = ["ALL", "-10", "-12", "-16", "-18"];
    var initialValue = 2;
    range_handle.text(range_sizes[initialValue]);

    $("#range-slider").slider({
        value: initialValue,
        min: 0,
        max: range_sizes.length - 1,
        create: function (event, ui) {
            range_handle.text(range_sizes[ui.value]);
        },
        slide: function (event, ui) {
            range_handle.text(range_sizes[ui.value]);
        }
    });

    // listing slider instance
    // if ($("#listing-range-slider").length) {
    //     var listingSlider = $("#listing-range-slider").find('#listing-range').data("ionRangeSlider");
    // }
    // range slider instance
    // if ($("#public-range-slider").length) {
    //     var rangeSlider = $("#public-range-slider").find('#public-range').data("ionRangeSlider");
    // }
    // dropdown select
    if ($("#from-dropdown").length) {
        $("#from-dropdown").selectmenu({
            appendTo: $("#from-dropdown").next('.tags-autocomplete-holder')
        });
        $("#to-dropdown").selectmenu({
            appendTo: $("#to-dropdown").next('.tags-autocomplete-holder')
        });
    }
    if ($("#genres-dropdown").length) {
        $("#genres-dropdown").selectmenu({
            appendTo: $("#genres-dropdown").next('.tags-autocomplete-holder')
        });
    }
    if ($("#sort-dropdown").length) {
        $("#sort-dropdown").selectmenu();
    }
    $('.dropdown-select').on('selectmenuchange', function () {
        ajaxFilters();
    });

    // applied filters
    $('[data-input-element=listing-range-slider] a.filter-close').on('click', function () {
        var form_element = $(this).closest('.applied-filter-tag').attr('data-input-element');
        $('#' + form_element).find('#listing-range').data("ionRangeSlider").reset();
    })
    // $('[data-input-element=public-range-slider] a.filter-close').on('click', function () {
    //     var form_element = $(this).closest('.applied-filter-tag').attr('data-input-element');
    //     $('#' + form_element).find('#public-range').data("ionRangeSlider").reset();
    // })
    $(document).on('click', '.filter-close', function (e) {
        var form_element = $(this).closest('.applied-filter-tag').attr('data-input-element');
        $('#' + form_element + ' .iradio').iCheck('uncheck');
        $('#' + form_element + ' input.tags').tagit('removeAll');
        $('#' + form_element + ' .dropdown-select').val("").selectmenu("refresh");
        $('div[data-input-element=' + form_element + ']').fadeOut(200, function () {
            $(this).remove();
        });
    })
    $(document).on('click', '.reset-applied-filters', function (e) {
        $('.applied-filter-panel').fadeOut(200, function () {
            $(this).remove();
            resetFiltersForm();
        })
        e.preventDefault();
    });

    // switch movies view
    $(document).on('click', '#grid-view-switch', function (e) {
        $('input[name=view_movies]').val('grid');
        $('.content-right').attr('id', 'grid');
        ajaxFilters();
        return false;
    })
    $(document).on('click', '#list-view-switch', function (e) {
        $('input[name=view_movies]').val('list');
        $('.content-right').attr('id', 'list');
        ajaxFilters();
        return false;
    })

    // reset all filters form elements on page-load
    function resetFiltersForm() {
        if ($(".tags").length) {
            $('input.tags').tagit('removeAll');
        }
        $('#filters .iradio').iCheck('uncheck');
        if ($('#listing-range-slider').length) {
            // listingSlider.reset();
        }
        // if ($('#public-range-slider').length) {
        //     rangeSlider.reset();
        // }
        if ($(".dropdown-select").length) {
            $('.dropdown-select').val("");
            $('.dropdown-select').selectmenu("refresh");
        }
    }

    resetFiltersForm();

    // chosen dropdown
    $('.chosen-select').chosen({allow_single_deselect: false});


}); // End of use strict
