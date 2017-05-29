$(document).ready(function () {
    //card list accordion
    $("#accordion").accordion({
        heightStyle: "content"
    });

    //card confirm
    var card_confirm_form = $("#card-confirm-form");
    $("#confirm-card-form").on('click', function () {
        var data_ajax_card = card_confirm_form.serialize();
        if (data_ajax_card) {
            $.ajax({
                type: "POST",
                url: 'path/to',
                data: data_ajax_card,
                success: function (response) {
                    //ajax successful response(callback) code
                    console.log(response);
                }
            });
        } else {
            alert('ERROR!!');
        }
        return false;
    });

    //personal confirm
    var personal_confirm_form = $("#personal-confirm-form");
    $("#confirm-personal-form").on('click', function () {
        var data_ajax_personal = personal_confirm_form.serialize();
        $.ajax({
            type: "POST",
            url: 'path/to',
            data: data_ajax_personal,
            success: function (response) {
                //ajax successful response(callback) code
                console.log(response);
            }
        });
        return false;
    });
});