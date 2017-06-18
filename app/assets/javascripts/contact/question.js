$(document).ready(function () {
    //datepicker
    $("#date").datepicker();

    //select dropdown
    $("#select-drop").selectmenu({
        appendTo: ".drop-holder"
    });

    //form trigger
    var service_form = $("#service");
    $("#service-submit-form").on('click', function () {
        var data_service = service_form.serialize();
        console.log(data_service);
        return false;
    });

    //modal form trigger
    var modal_form = $("#send-mail-modal-form");
    $("#send-mail-submit-form").on('click', function () {
        var data_modal_form = modal_form.serialize();
        console.log(data_modal_form);
        return false;
    });
});