$(document).ready(function () {


    $(window).resize(function () {
        stickyHeaderChart();
    });


    function stickyHeaderChart() {
        var stickyCharterHeader = $('#header-chart');
        var charterHeaderFixPoint = $('.charts-top').outerHeight() + 70;
        var submitFixPoint = $('.planTableOptions').outerHeight() + charterHeaderFixPoint - 70;

        $(window).scroll(function () {
            if ($(window).scrollTop() >= charterHeaderFixPoint) {
                stickyCharterHeader.addClass('affix');
                $('.planTableOptions').addClass('affix');

            }
            if ($(window).scrollTop() < charterHeaderFixPoint) {
                stickyCharterHeader.removeClass('affix');
                $('.planTableOptions').removeClass('affix');
            }
            if ($(window).scrollTop() >= submitFixPoint) {
                stickyCharterHeader.removeClass('affix');
                $('.planTableOptions').removeClass('affix');
            }

        });
    }

    stickyHeaderChart();

    $('.cellContent').on('click', function () {
        var column = parseInt($(this).attr('data-box-order')) + 1;
        $('.cell').removeClass('selected');
        $('.row > .cell:nth-child(' + column + '), .headerRow > .cell:nth-child(' + column + ')').addClass('selected');
    });


});