$(function () {

    History = window.History // Note: We are using a capital H instead of a lower h
    $('#film-details').delegate('.season .details, .season .arrow', 'click', function () {
        $(this).parent().children('.episodes').toggle('slow')
        $(this).parent().children('.arrow').toggleClass('arrow-down arrow-right')

    });
    //$('.ca-container').contentcarousel({
    //    sliderSpeed: 500,
    //    sliderEasing: 'easeOutExpo',
    //    itemSpeed: 500,
    //    itemEasing: 'easeOutExpo',
    //    scroll: 5
    //});

    $("body").delegate("#c-members #pagination a", "click", function () {
        html_item = $(this).parent();
        content = html_item.html();
        html_item.html("<div style='height:24px; margin:10px 0 0 0'><img src='/assets/ajax-loader.gif'/></div>");
        set_page(this.href)
        $.ajax({
            url: this.href,
            dataType: 'html',
            type: 'GET',
            data: {},
            success: function (data) {
                $('#c-members').html(data);
            },
            error: function () {
                html_item.html(content);
            }
        });
        return false;
    });

    $("body").delegate("#c-members #sort", "change", function () {
        loader = 'ajax-loader.gif';
        $(this).parent().ajaxSubmit({success: show_review, dataType: 'html'});
        html_item = $("#c-members");
        content = html_item.html();
        $(this).parent().html("<div style='height:22px'><img src='/assets/" + loader + "'/></div>");
        return false; // prevent default behaviour
    });

    function show_review(responseText, statusText) {
        if (jQuery.trim(statusText) == "success") {
            $("#c-members").html(responseText);
        }
        else {
            $("#c-members").html(content);
        }
    };
    /* to do */
    if (($('#image_5').attr('src') != undefined)) {
        var img = new Image();
        img.onload = function () {
            height_im = this.height
            if (height_im <= 3) {
                $('#thumbs-wrap').hide()
            }
        }
        img.src = $('#image_1').attr('src');
    }

    $('#uninterested a').click(function () {

    });

    $('.normal .preview_box img').click(function () {
        url = $(this).attr('src')
        url = url.replace('screenshots/small/', 'screenshots/big/')
        open_image(url)
    });

    $(window).keydown(function (e) {
        if ($('#big_image').is(":visible")) {
            switch (e.keyCode) {
                case 37: // flèche gauche
                    next_prev('minder')
                    break;
                case 39: // flèche droite
                    next_prev('plus')
                    break;
            }
        }
    });

    $('body').delegate('.next_button, .prev_button', "click", function () {
        if ($(this).hasClass('next_button')) {
            next_prev('plus')
        }
        else {
            next_prev('minder')
        }
    });

    function next_prev(operation) {
        url = $('#big_image').attr('src')
        l = url.length
        ext = url.substr((l - 5), 5)
        n = url.substr((l - 5), 1)
        if (operation == 'plus') {
            n = parseInt(n) + 1
        }
        else {
            n = parseInt(n) - 1
        }
        if (n > 6) {
            n = 1
        }
        if (n < 1) {
            n = 6
        }
        url = url.replace(ext, n + '.jpg')
        open_image(url)
    }

    function open_image(url) {
        var img = new Image();
        img.onload = function () {
            height_im = this.height
            width_im = this.width
            if (height_im > 3) {
                img = "<div style='width:" + width_im + "px; height:" + height_im + "px; text-align:center;position:relative;margin: 0 0 15px;'><div class='prev_button' style='height:" + height_im + "px'><div class='image_prev'></div></div><div class='next_button' style='height:" + height_im + "px'><div class='image_next'></div>     </div>    <img src='" + url + "' id='big_image'/></div>"
                jQuery.facebox(img);

            }
        }
        img.src = url;
        set_page(url)
    }

    /***trailer ***/
    //$('body').delegate("#content_trailer .linkallversions a", "click", function () {
    //    html_item = $(this);
    //    content = html_item.html();
    //    html_item.html("Loading...");
    //    root_item = $('#content_trailer');
    //
    //    set_page(html_item.attr('href'))
    //    $.ajax({
    //        dataType: 'html',
    //        url: html_item.attr('href'),
    //        type: 'GET',
    //        data: {},
    //        success: function (data) {
    //            root_item.html(data);
    //        },
    //        error: function () {
    //            html_item.html(content);
    //        }
    //    });
    //    return false;
    //});

    $('body').delegate('.streaming_add_list, .streaming_remove_list', "click", function () {
        $(this).parent().ajaxSubmit({dataType: 'script'});
        $(this).parent().html("<div class='load2'><img src='/assets/ajax-loader.gif' /></div>")
        return false; // prevent default behaviour
    });

    endscroll();

    $('.menu').on('click', function () {
        if (!$(this).next('.nav').is(':visible')) {
            $('.nav').hide('fast')
            $(this).next('.nav').show('fast')
        }
    });

    if ($('#online #filters').html()) {
        $('#products_index').delegate('.cover', 'mouseenter', function () {
            if ($("#ca-container").length > 0) {
                $(this).parent().find('.tooltips').css('margin-top', -193 - $(window).scrollTop());
            }
            $(this).parent().find('.tooltips').delay(400).fadeIn('fast');
            content = $(this).parent().find('.tooltips_other')
            if (content.html() == 'loading') {
                $.ajax({
                    url: $(this).attr('data-url'),
                    dataType: 'html',
                    type: 'GET',
                    data: {},
                    success: function (data) {
                        res = data.split('|||')

                        $(res[0]).html(res[1]);
                    },
                    error: function () {
                        content.html('error');
                    }
                });
            }
        });

        $('#products_index').delegate('.cover', 'mouseleave', function () {
            $(this).parent().find('.tooltips').stop(true, true)
            $(this).parent().find('.tooltips').delay(200).fadeOut(200);

        });

        $('#products_index').delegate('.tooltips', 'mouseenter', function () {
            if ($('#ca-container').length > 0) {
                $(this).css('margin-top', -193 - $(window).scrollTop());
            }
            $(this).stop(true, true)
            $(this).fadeIn('fast');
        });
        $('#products_index').delegate('.tooltips', 'mouseleave', function () {
            $(this).fadeOut(200);
        });


        load_form();

        // MAIN TOP BUTTONS START !!!

        $('#products_index, #film-details, #categories, #studios').delegate('#online #date_filters_year_min, #online  #date_filters_year_max', "change", function () {
            submit_online()
        });

        $('#products_index, #film-details, #categories, #studios').delegate('.packages.svod, .packages.tvod', 'click', function () {
            $('#filter_online_form').attr('action', $(this).attr('href'));
            $('.packages').removeClass('current');
            $(this).addClass('current');
            submit_online();
            return false;
        });

        // MAIN TOP BUTTONS END !!!

        //$('#products_index, #film-details, #categories, #studios').delegate(".links", "change", function () {
        //    submit_online()
        //});

        // CATEGORIES START !!!

        $(".icheckbox,.iradio").iCheck({
            checkboxClass: 'icheckbox_minimal-grey',
            radioClass: 'iradio_minimal-grey'
        });

        $('.iradio').on('ifChecked', function (e) {
            submit_online();
        });

        $(document).on('click', '.filter-close', function (e) {
            var form_element = $(this).closest('.applied-filter-tag').attr('data-input-element');
            //$('#' + form_element + ' .iradio').iCheck('uncheck');
            //$('#' + form_element + ' input.tags').tagit('removeAll');
            //$('#' + form_element + ' .dropdown-select').val("").selectmenu("refresh");
            //$('div[data-input-element=' + form_element + ']').fadeOut(200, function () {
            //    $(this).remove();
            //});

            if (form_element === "Plush à la Carte") {

                $(".reset-applied-filters").trigger("click");

            } else if (form_element === "Plush Unlimited") {

                $(".reset-applied-filters").trigger("click");

            } else if (form_element === "Derniers ajouts" || form_element === "Laatste aanwinsten" || form_element === "Newly added") {

                $('.iradio').iCheck('uncheck');
                submit_online();

            } else if (form_element === "Les plus populaires" || form_element === "Meest bekeken" || form_element === "Most viewed") {

                $('.iradio').iCheck('uncheck');
                submit_online();

            } else if (form_element === "Dernière chance" || form_element === "Laatste kans" || form_element === "Last chance") {

                $('.iradio').iCheck('uncheck');
                submit_online();

            } else if (form_element === "Les mieux côtés" || form_element === "Beste beoordeeld" || form_element === "Best rated") {

                $('.iradio').iCheck('uncheck');
                submit_online();

            } else if (form_element === "Bientôt disponible" || form_element === "Binnenkort beschikbaar" || form_element === "Coming soon") {

                $('.iradio').iCheck('uncheck');
                submit_online();

            } else if (form_element === "Nouveautés" || form_element === "Nieuwe films" || form_element === "New movies") {

                $('.iradio').iCheck('uncheck');
                submit_online();

            } else if (form_element === "Haute Définition" || form_element === "High Definition") {

                $('.iradio').iCheck('uncheck');
                submit_online();

            }

            console.log(form_element);
        });

        $('#products_index, #film-details, #categories, #studios').delegate("#close_audience", "click", function () {
            $("#online #audience-slider-range").slider("values", [0, 4])
        });

        $('#products_index, #film-details').delegate("#close_country", "click", function () {
            $('#online #filters_country_id').val('').trigger('chosen:updated');
            submit_online()
        });

        $('#products_index, #film-details, #categories, #studios').delegate("#close_year", "click", function () {
            $("#online #date_filters_year_min").val($("#online #date_filters_year_min option:first").val());
            $("#online #date_filters_year_max").val($("#online #date_filters_year_min option:last").val());
            submit_online()
        });
        /*$('#products_index').delegate(".links", "click", function() {
         $('#filters_view_mode').val($(this).attr('data'))
         submit_online()
         })*/

        $('#products_index').delegate("#close_ratings", "click", function () {
            $("#online #ratings-slider-range").slider("values", [0, 18])
        });

        $('#products_index').delegate("#close_audios", "click", function () {
            $('#online #filters_audio').val('audio...').trigger('chosen:updated');
            submit_online()
        });

        $('#products_index').delegate("#close_subtitles", "click", function () {
            $('#online #filters_subtitles').val('sub...').trigger('chosen:updated');
            submit_online()
        });

        $('#products_index').delegate("#close_category", "click", function () {
            $('#online #filters_category_id').val('').trigger('chosen:updated');
            submit_online()
        });

        $('#products_index').delegate("#close_actor", "click", function () {
            $('#filter_online_form').attr('action', $(this).attr('url'))
            submit_online()
        })
        $('#products_index').delegate("#close_director", "click", function () {
            $('#filter_online_form').attr('action', $(this).attr('url'))
            submit_online()
        });

        $('#products_index').delegate("#close_view_mode", "click", function () {
            $('.links').prop('checked', false);
            submit_online()
        });

        $('#products_index').delegate("#close_belgium", "click", function () {
            $('#filter_online_form #belgium').val('')

            submit_online()
        });

        $('#products_index').delegate("#pagination.deactive a", "click", function () {
            ajax_pagination($(this).attr('href'))
            return false
        });


    }

    if ($('.edit_search_filter #filters').html()) {
        $("#filters ul li a").on("click", function () {
            $(this).parent().toggleClass('open');
            $(this).parent().children("div").toggle();
            return false;
        });
        audience_slider_values = {'0': 0, '10': 1, '12': 2, '16': 3, '18': 4};
        $("#audience-slider-range").slider({
            range: true,
            min: 0,
            max: 4,
            values: [audience_slider_values[$("#search_filter_audience_min").val()], audience_slider_values[$("#search_filter_audience_max").val()]],
            step: 1,
            slide: function (event, ui) {
                actual_audience_values = {'0': 0, '1': 10, '2': 12, '3': 16, '4': 18};
                $("#search_filter_audience_min").val(actual_audience_values[ui.values[0]]);
                $("#search_filter_audience_max").val(actual_audience_values[ui.values[1]]);
            }
        });
        $("#ratings-slider-range").slider({
            range: true,
            min: 1,
            max: 5,
            values: [$("#online #search_filter_rating_min").val(), $("#online #search_filter_rating_max").val()],
            step: 1,
            slide: function (event, ui) {
                $("#online #search_filter_rating_min").val(ui.values[0]);
                $("#online #search_filter_rating_max").val(ui.values[1]);
            }
        });
        $('#products_index').delegate(".categorie_online", "click", function () {

            return false
        })
    }
    History.Adapter.bind(window, 'statechange', function () { // Note: We are using statechange instead of popstate
        // Log the State
        var State = History.getState(); // Note: We are using History.getState() instead of event.state
        $('.loading_bar').show()
        $.ajax({
            url: State.url,
            dataType: 'script',
            type: 'GET',
            data: {},
            success: function (data) {
            },
            error: function () {
            }
        });
    })
});

function ajax_pagination(path) {
    /*$('#products').html("<div style='height:22px'><img src='/assets/ajax-loader.gif'/></div>");*/
    $('.loading_bar').show()
    $.ajax({url: path, dataType: 'script'});
    History.pushState(null, null, path);
}


function goToByScroll(id) {
    $('html,body').animate({scrollTop: $("#" + id).offset().top}, 'slow');
}
function endscroll() {
    $('#toTop').on('click', function () {
        goToByScroll('top')
    });
    if ($('#products_index #pagination.active').length) {
        $(window).scroll(function () {
            var path;
            path = $('#products_index #pagination .next_page').attr('href');

            if ($(window).scrollTop() < 500) {
                $('#toTop').fadeOut('slow')
            }
            else {
                $('#toTop').fadeIn('slow')
            }
            if (path && $(window).scrollTop() > $(document).height() - $(window).height() - 1200) {
                set_page(path)
                $('#pagination').html("<img src='/assets/loading.gif' />");
                return $.ajax({url: path, dataType: 'script'});
            }
        });
    }
}

function submit_online() {
    if ($('.not_reload').length > 0) {
        //$('.loading_bar').show();
        /*$('#filter_online_form').ajaxSubmit({dataType: 'script'});*/
        if ($('#filter_online_form').attr('action').indexOf('?') > 0) {
            history_url = $('#filter_online_form').attr('action') + "&" + $('#filter_online_form').serialize()
        }
        else {
            history_url = $('#filter_online_form').attr('action') + "?" + $('#filter_online_form').serialize()
        }

        History.pushState(null, null, history_url);
    }
    else {
        $('#filter_online_form').submit();
    }
}

function load_form() {

    $('.chosen-select').chosen({allow_single_deselect: true}).change(function () {
        submit_online();
    });

    //$("#online #ratings-slider-range").slider({
    //    range: true,
    //    min: 1,
    //    max: 5,
    //    values: [$("#filters_rating_min").val(), $("#filters_rating_max").val()],
    //    step: 1,
    //    change: function (event, ui) {
    //        $("#online #filters_rating_min").val(ui.values[0]);
    //        $("#online #filters_rating_max").val(ui.values[1]);
    //        submit_online()
    //    }
    //});
    //audience_slider_values = {'0': 0, '10': 1, '12': 2, '16': 3, '18': 4};
    //$("#online #audience-slider-range").slider({
    //    range: true,
    //    min: 0,
    //    max: 4,
    //    values: [audience_slider_values[$("#online #filters_audience_min").val()], audience_slider_values[$("#online #filters_audience_max").val()]],
    //    step: 1,
    //    change: function (event, ui) {
    //        actual_audience_values = {'0': 0, '1': 10, '2': 12, '3': 16, '4': 18};
    //        $("#online #filters_audience_min").val(actual_audience_values[ui.values[0]]);
    //        $("#online #filters_audience_max").val(actual_audience_values[ui.values[1]]);
    //        submit_online()
    //    }
    //});
}

$(window).scroll(function () {
    var $this = $(this);
    $('.ca-wrapper .tooltips:visible').css('margin-top', -193 - $this.scrollTop());
    /*$('#box2').css('left', 20 - $this.scrollLeft());*/
});