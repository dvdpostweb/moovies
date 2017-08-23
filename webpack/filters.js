History = window.History;

$(document).ready(function () {

    $("#filters_view_mode_last_added").on('ifChecked', function (e) {

        submit_online();

        ahoy.track("newly_added_choose_click", {

            event: "click",
            locale: gon.locale,
            movie_type: gon.movie_type

        });

    });

    $("#filters_view_mode_most_viewed").on('ifChecked', function (e) {

        submit_online();

        ahoy.track("most_viewed_choose_click", {

            event: "click",
            locale: gon.locale,
            movie_type: gon.movie_type

        });

    });

    $("#filters_view_mode_last_chance").on('ifChecked', function (e) {

        submit_online();

        ahoy.track("last-chance_choose_click", {

            event: "click",
            locale: gon.locale,
            movie_type: gon.movie_type

        });

    });

    $("#filters_view_mode_best_rated").on('ifChecked', function (e) {

        submit_online();

        ahoy.track("best_rated_choose_click", {

            event: "click",
            locale: gon.locale,
            movie_type: gon.movie_type

        });

    });

    $("#filters_view_mode_soon").on('ifChecked', function (e) {

        submit_online();

        ahoy.track("coming_soon_choose_click", {

            event: "click",
            locale: gon.locale,
            movie_type: gon.movie_type

        });

    });

    $("#filters_view_mode_new").on('ifChecked', function (e) {

        submit_online();

        ahoy.track("new_movies_choose_click", {

            event: "click",
            locale: gon.locale,
            movie_type: gon.movie_type

        });

    });

    $("#filters_view_mode_hd").on('ifChecked', function (e) {

        submit_online();

        ahoy.track("high_definition_choose_click", {

            event: "click",
            locale: gon.locale,
            movie_type: gon.movie_type

        });

    });

    $("#filters_category_id_chosen").on("click",".active-result",function(){

        var genre = $(this).text();

        ahoy.track("genres_choose_click", {

            event: "click",
            genre: genre,
            locale: gon.locale,
            movie_type: gon.movie_type

        });

    });

    //$("#filters_category_id_chosen").on("click",".chosen-single-with-deselect",function(){
    //    ahoy.track("genres_close_click", {
    //        event: "click",
    //        locale: gon.locale,
    //        movie_type: gon.movie_type
    //    });
    //});

    $("#filters_audio").change(function(){
        var audiosMultiple =  $(this).find("option:selected").text();

        ahoy.track("audios_choose_click", {

            event: "click",
            audio: audiosMultiple,
            locale: gon.locale,
            movie_type: gon.movie_type

        });

    });

    $("#filters_subtitles").change(function(){
        var subtitlesMultiple =  $(this).find("option:selected").text();

        ahoy.track("subtitles_choose_click", {

            event: "click",
            subtitles: subtitlesMultiple,
            locale: gon.locale,
            movie_type: gon.movie_type

        });

    });

    $("#date_filters_year_min").change(function(){
        var yearFrom =  $(this).find("option:selected").text();

        ahoy.track("year_from_choose_click", {

            event: "click",
            year_from: yearFrom,
            locale: gon.locale,
            movie_type: gon.movie_type

        });

    });

    $("#date_filters_year_max").change(function(){
        var yearMax =  $(this).find("option:selected").text();

        ahoy.track("year_max_choose_click", {

            event: "click",
            year_max: yearMax,
            locale: gon.locale,
            movie_type: gon.movie_type

        });

    });

    $("#filters_country_id").change(function(){
        var countriesMultiple =  $(this).find("option:selected").text();

        ahoy.track("countries_choose_click", {

            event: "click",
            countries: countriesMultiple,
            locale: gon.locale,
            movie_type: gon.movie_type

        });

    });




});

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

    //$('.iradio').on('ifChecked', function (e) {
        //submit_online();
    //    console.log("?????");
    //});

    $(document).on('click', '.filter-close', function (e) {

        var form_element = $(this).closest('.applied-filter-tag').attr('data-input-element');

        if (form_element === "Plush à la Carte") {

            $(".reset-applied-filters").trigger("click");

        } else if (form_element === "Plush Unlimited") {

            $(".reset-applied-filters").trigger("click");

        } else if (form_element === "Derniers ajouts" || form_element === "Laatste aanwinsten" || form_element === "Newly added") {

            $('.iradio').iCheck('uncheck');

            submit_online();

            //ahoy.track("Newly Added Tracking Destroy Event", {
            //    event: "Newly Added Destroy Clicked",
            //    locale: gon.locale,
            //    movie_type: gon.movie_type
            //
            //});

        } else if (form_element === "Les plus populaires" || form_element === "Meest bekeken" || form_element === "Most viewed") {

            $('.iradio').iCheck('uncheck');

            submit_online();

            //ahoy.track("Most viewed Tracking Destroy Event", {
            //    event: "Most viewed Destroy Clicked",
            //    locale: gon.locale,
            //    movie_type: gon.movie_type
            //});

        } else if (form_element === "Dernière chance" || form_element === "Laatste kans" || form_element === "Last chance") {

            $('.iradio').iCheck('uncheck');

            submit_online();

            //ahoy.track("Last chance Tracking Destroy Event", {
            //    event: "Last chance Destroy Clicked",
            //    locale: gon.locale,
            //    movie_type: gon.movie_type
            //});

        } else if (form_element === "Les mieux côtés" || form_element === "Beste beoordeeld" || form_element === "Best rated") {

            $('.iradio').iCheck('uncheck');

            submit_online();

            //ahoy.track("Best rated Tracking Destroy Event", {
            //    event: "Best rated Destroy Clicked",
            //    locale: gon.locale,
            //    movie_type: gon.movie_type
            //
            //});

        } else if (form_element === "Bientôt disponible" || form_element === "Binnenkort beschikbaar" || form_element === "Coming soon") {

            $('.iradio').iCheck('uncheck');

            submit_online();

            //ahoy.track("Coming soon Tracking Destroy Event", {
            //
            //    event: "Coming soon Destroy Clicked",
            //    locale: gon.locale,
            //    movie_type: gon.movie_type
            //
            //});

        } else if (form_element === "Nouveautés" || form_element === "Nieuwe films" || form_element === "New movies") {

            $('.iradio').iCheck('uncheck');

            submit_online();

            //ahoy.track("New movies Tracking Destroy Event", {
            //
            //    event: "New movies Destroy Clicked",
            //    locale: gon.locale,
            //    movie_type: gon.movie_type
            //
            //});

        } else if (form_element === "Haute Définition" || form_element === "High Definition") {

            $('.iradio').iCheck('uncheck');

            submit_online();

            //ahoy.track("High Definition Tracking Destroy Event", {
            //
            //    event: "High Definition Destroy Clicked",
            //    locale: gon.locale,
            //    movie_type: gon.movie_type
            //
            //});

        }

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

        //ahoy.track("Genres Tracking Destroy Event", {
        //    event: "destroy click",
        //    locale: gon.locale,
        //    movie_type: gon.movie_type
        //});

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