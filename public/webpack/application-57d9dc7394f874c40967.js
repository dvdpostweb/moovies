!function(e){function o(n){if(t[n])return t[n].exports;var s=t[n]={exports:{},id:n,loaded:!1};return e[n].call(s.exports,s,s.exports,o),s.loaded=!0,s.exports}var t={};return o.m=e,o.c=t,o.p="/webpack/",o(0)}([function(e,o,t){t(1),$(document).ready(function(){function e(){$(".popper").popover({placement:"left",trigger:"hover",container:"body",html:!0,delay:{show:300,hide:100},content:function(){return $(this).next(".synopsys-content").html()}})}function o(){Modernizr.mq("(min-width: 981px)")&&e(),Modernizr.mq("(max-width: 980px)")&&$(".popper").popover("destroy")}function t(e){r=new YT.Player("modal-trailer-video",{videoId:e})}function n(e){var o=/^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/,t=e.match(o);return!(!t||11!=t[7].length)&&t[7]}var s=$.fn.popover.Constructor.prototype.leave;$.fn.popover.Constructor.prototype.leave=function(e){var o=e instanceof this.constructor?e:$(e.currentTarget)[this.type](this.getDelegateOptions()).data("bs."+this.type);s.call(this,e),e.currentTarget&&o.$tip.one("mouseenter",function(){clearTimeout(o.timeout),o.$tip.one("mouseleave",function(){$.fn.popover.Constructor.prototype.leave.call(o,o)})})},$(".responsive-carousel").slick({dots:!1,infinite:!1,speed:200,slidesToShow:5,slidesToScroll:2,responsive:[{breakpoint:980,settings:{slidesToShow:3,slidesToScroll:2}},{breakpoint:600,settings:{slidesToShow:2,slidesToScroll:1}}]}),$(".slide-score").raty({readOnly:!0,score:function(){return $(this).attr("data-score")}}),$(".synopsys-adaptive-open").on("click",function(){return $(".synopsys-adaptive-open").removeClass("hidden"),$(this).addClass("hidden"),$(".synopsys-content").removeClass("on"),$(this).prev(".synopsys-content").addClass("on"),!1}),$(".synopsys-adaptive-close").on("click",function(){return $(this).closest(".slick-slide").children(".synopsys-adaptive-open").removeClass("hidden"),$(this).closest(".grid-slide").children(".synopsys-adaptive-open").removeClass("hidden"),$(this).closest(".synopsys-content").removeClass("on"),!1}),o(),$(window).resize(function(){o()}),$(".tags-autocomplete-holder li.ui-menu-item").on("click",function(e){e.preventDefault()});var r;$(document).on("click",".btn-trailer",function(e){var o=$(this).attr("data-src"),s=n(o);t(s)}),$("#trailer-modal").on("hidden.bs.modal",function(){$("iframe").attr("src",$("iframe").attr("src")),$("iframe#modal-trailer-video").remove(),$(".embed-responsive-16by9").append('<div id="modal-trailer-video" class="modal-trailer-video"></div>')})})},function(e,o){$(document).ready(function(){function e(){var e=$("#header-chart"),o=$(".charts-top").outerHeight()+70,t=$(".planTableOptions").outerHeight()+o-70;$(window).scroll(function(){$(window).scrollTop()>=o&&(e.addClass("affix"),$(".planTableOptions").addClass("affix")),$(window).scrollTop()<o&&(e.removeClass("affix"),$(".planTableOptions").removeClass("affix")),$(window).scrollTop()>=t&&(e.removeClass("affix"),$(".planTableOptions").removeClass("affix"))})}$(window).resize(function(){e()}),e(),$(".cellContent").on("click",function(){var e=parseInt($(this).attr("data-box-order"))+1;$(".cell").removeClass("selected"),$(".row > .cell:nth-child("+e+"), .headerRow > .cell:nth-child("+e+")").addClass("selected")})})}]);