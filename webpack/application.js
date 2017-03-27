require("pricing/alacarte.js");

$(document).ready(function () {

    var originalLeave = $.fn.popover.Constructor.prototype.leave;
    $.fn.popover.Constructor.prototype.leave = function (obj) {
        var self = obj instanceof this.constructor ? obj : $(obj.currentTarget)[this.type](this.getDelegateOptions()).data('bs.' + this.type);
        originalLeave.call(this, obj);

        if (obj.currentTarget) {
            self.$tip.one('mouseenter', function () {
                clearTimeout(self.timeout);
                self.$tip.one('mouseleave', function () {
                    $.fn.popover.Constructor.prototype.leave.call(self, self);
                });
            })
        }
    };

    function popoverTrig() {
        $('.popper').popover({
            placement: "left",
            trigger: "hover",
            container: 'body',
            html: true,
            delay: {
                show: 300,
                hide: 100
            },
            content: function () {
                return $(this).next('.synopsys-content').html();
            }
        })
    };

    // full-movie slider
    $('.responsive-carousel').slick({
        dots: false,
        infinite: false,
        speed: 200,
        slidesToShow: 5,
        slidesToScroll: 2,
        responsive: [
            {
                breakpoint: 980,
                settings: {
                    slidesToShow: 3,
                    slidesToScroll: 2,
                }
            },
            {
                breakpoint: 600,
                settings: {
                    slidesToShow: 2,
                    slidesToScroll: 1
                }
            }
        ]
    });

    //raty stars
    $('.slide-score').raty({
        readOnly: true,
        score: function () {
            return $(this).attr('data-score');
        }
    });

    // synopsis adaptive trigg open
    $('.synopsys-adaptive-open').on('click', function () {
        $('.synopsys-adaptive-open').removeClass('hidden');
        $(this).addClass('hidden');
        $('.synopsys-content').removeClass('on');
        $(this).prev('.synopsys-content').addClass('on');
        return false;
    })

    // synopsis adaptive trigg close
    $('.synopsys-adaptive-close').on('click', function () {
        $(this).closest('.slick-slide').children('.synopsys-adaptive-open').removeClass('hidden');
        $(this).closest('.grid-slide').children('.synopsys-adaptive-open').removeClass('hidden');
        $(this).closest('.synopsys-content').removeClass('on');

        return false;
    })

    // modernizr
    function checkModernizr() {
        if (Modernizr.mq('(min-width: 981px)')) {
            popoverTrig();
            fancyboxBinder();
        }
        if (Modernizr.mq('(max-width: 980px)')) {
            $('.popper').popover('destroy');
            fancyboxUnBinder();
        }
    }

    // the call to checkMq here will execute after the document has loaded
    checkModernizr();

    $(window).resize(function () {
        checkModernizr();
    });

    $('.tags-autocomplete-holder li.ui-menu-item').on('click', function (e) {
        e.preventDefault();
    })

    //youtube api trigg
    var player;

    function onYouTubeIframeAPIReady(videoID) {
        player = new YT.Player('modal-trailer-video', {
            videoId: videoID,
        });
    }

    function youtubeVideoID(url) {
        var regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/;
        var match = url.match(regExp);
        return (match && match[7].length == 11) ? match[7] : false;
    }

    //load youtube url
    $(document).on('click', '.btn-trailer', function (e) {
        var youTubeLink = $(this).attr('data-src');
        var videoID = youtubeVideoID(youTubeLink);
        onYouTubeIframeAPIReady(videoID);

    })

    //trailer modal close event
    $('#trailer-modal').on('hidden.bs.modal', function () {
        //stops trailer video on modal close
        $('iframe').attr('src', $('iframe').attr('src'));
        $('iframe#modal-trailer-video').remove();
        $('.embed-responsive-16by9').append('<div id="modal-trailer-video" class="modal-trailer-video"></div>');
    });

    // fancybox
    function fancyboxBinder() {
        $(".fancybox").unbind('click')
        $("a.fancybox").fancybox({
            padding: 5,
            helpers: {
                overlay: {
                    locked: false,
                    overlayShow: true
                }
            },
        })
    }

    function fancyboxUnBinder() {
        $.fancybox.close();
        $(".fancybox").bind('click', function (e) {
            e.preventDefault();
        })
        $(document).unbind('click.fb-start');
    }

});


var coreJS = require('core-js');
var zoneJS = require('zone.js');
var reflectMetadata = require('reflect-metadata');
var ng = {
    core: require("@angular/core"),
    common: require("@angular/common"),
    compiler: require("@angular/compiler"),
    forms: require("@angular/forms"),
    platformBrowser: require("@angular/platform-browser"),
    platformBrowserDynamic: require("@angular/platform-browser-dynamic"),
    router: require("@angular/router")
};

var AngularTestComponent = ng.core.Component({
    selector: "shine-angular-test",
    template: '\
<h2 *ngIf="salutation">Hello {{salutation}}!</h2> \
<form> \
<div class="form-group"> \
<label for="name">Name</label> \
<input type="text" id="name" class="form-control" \
name="name" bindon-ngModel="salutation"> \
</div> \
</form> \
'
}).Class({
    constructor: function () {
        this.salutation = null;
    }
});

var AngularTestAppModule = ng.core.NgModule({
    imports: [ng.platformBrowser.BrowserModule, ng.forms.FormsModule],
    declarations: [AngularTestComponent],
    bootstrap: [AngularTestComponent]
})
    .Class({
        constructor: function () {
        }
    });


document.addEventListener('DOMContentLoaded', function() {
    var shouldBootstrap = document.getElementById("angular-test");
    if (shouldBootstrap) {
        ng.platformBrowserDynamic.
        platformBrowserDynamic().
        bootstrapModule(AngularTestAppModule);
    }
});







