$(document).ready(function () {
    $("#accordion").accordion({
    	heightStyle: "content"
    });
    $("#accordion a").on('click', function () {
        var modal_content = $(this).attr('data-modal');
        var modal_title = $(this).text();
        $('.content-modal-load').html(modal_content);
        $('.title-modal-load').html(modal_title);
    });
});