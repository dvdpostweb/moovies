$(document).ready(function () {

    History = window.History;

    if ($('#online #filters').html()) {


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

        $(".icheckbox,.iradio").iCheck({
            checkboxClass: 'icheckbox_minimal-grey',
            radioClass: 'iradio_minimal-grey'
        });

        $('.iradio').on('ifChecked', function (e) {
            submit_online();
        });

        $(document).on('click', '.filter-close', function (e) {
            var form_element = $(this).closest('.applied-filter-tag').attr('data-input-element');

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

        $('#products_index').delegate("#close_ratings", "click", function () {
            $("#ratings-slider-range").slider("values", [0, 18])
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


function submit_online() {
    if ($('.not_reload').length > 0) {
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

    $("#online #ratings-slider-range").slider({
        range: true,
        min: 1,
        max: 5,
        values: [$("#filters_rating_min").val(), $("#filters_rating_max").val()],
        step: 1,
        change: function (event, ui) {
            $("#online #filters_rating_min").val(ui.values[0]);
            $("#online #filters_rating_max").val(ui.values[1]);
            submit_online()
        }
    });
    audience_slider_values = {'0': 0, '10': 1, '12': 2, '16': 3, '18': 4};
    $("#online #audience-slider-range").slider({
        range: true,
        min: 0,
        max: 4,
        values: [audience_slider_values[$("#online #filters_audience_min").val()], audience_slider_values[$("#online #filters_audience_max").val()]],
        step: 1,
        change: function (event, ui) {
            actual_audience_values = {'0': 0, '1': 10, '2': 12, '3': 16, '4': 18};
            $("#online #filters_audience_min").val(actual_audience_values[ui.values[0]]);
            $("#online #filters_audience_max").val(actual_audience_values[ui.values[1]]);
            submit_online()
        }
    });
}