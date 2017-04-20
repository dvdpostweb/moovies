(function ($) {
    $.facebox = function (data, klass) {
        $.facebox.loading(data.settings || [])

        if (data.ajax) fillFaceboxFromLink(data.ajax, klass)
        else if (data.image) fillFaceboxFromImage(data.image, klass)
        else if (data.div) fillFaceboxFromHref(data.div, klass)
        else if ($.isFunction(data)) data.call($)
        else $.facebox.reveal(data, klass)
    }

    /*
     * Public, $.facebox methods
     */

    $.extend($.facebox, {
        settings: {
            modalSize: null,      // null, 'large', or 'small'
            compatibility: 'normal',  // straight or normal
            imageTypes: ['png', 'jpg', 'jpeg', 'gif'],
            faceboxMinimalHtml: '\
    <div class="modal fade" id="facebox" tabindex="-1" role="dialog" aria-labelledby="fbModalLabel" ar ia-hidden="true"> \
      <div class="modal-dialog modal-lg"> \
        <div class="modal-content"> \
        </div> \
      </div> \
    </div> \
    ',
            faceboxHtml: '\
    <div id="mon-compte-modal" class="modal compte-modal fade" role="dialog" tabindex="-1"> \
      <button type="button" class="close" data-dismiss="modal">&nbsp;</button> \
      <div class="modal-dialog thinrgray-bck"> \
        <div class="modal-content padtb10 padlr5 block100"> \
        </div> \
        <div class="modal-footer dark-gray"> \
          <div class="text-right"> \
            <a href="index.php%3Fpage=mon-compte.html#" class="dark-blue close normal f14 mart10" data-dismiss="modal">' + gon.modal_close_button_text +' X</a> \
          </div> \
        </div> \
      </div> \
    </div> \
    '
        },

        loading: function () {
            init()
            if ($.facebox.current_modal) return true;

            if ($.facebox.settings.compatibility == 'straight') {
                $.facebox.current_modal = $($.facebox.settings.faceboxMinimalHtml);
            } else {
                $.facebox.current_modal = $($.facebox.settings.faceboxHtml);
            }

            if ($.facebox.settings.modalSize == 'small') {
                $.facebox.current_modal.find('.modal-dialog').addClass('modal-sm');
            } else if ($.facebox.settings.modalSize == 'large') {
                $.facebox.current_modal.find('.modal-dialog').addClass('modal-lg');
            }
        },

        // In this case, show a remote link
        revealRemote: function (link, klass) {
            if (klass) $.facebox.current_modal.addClass(klass)
            $.facebox.current_modal.modal({remote: link});
        },

        // data is literal data to stick in the modal
        reveal: function (data, klass) {
            if (klass) $.facebox.current_modal.addClass(klass)
            $.facebox.current_modal.find('.modal-content').append(data);
            $.facebox.current_modal.modal();
        },

        // Takes literal data and examines it.  If the literal data has a
        // "modal-body" div, then the data will replace the entire
        // "modal-content" div of the modal.  Otherwise, the data will be
        // stuck into "modal-body".  Additionally, the first header (h1-h6)
        // will be removed and its contents put into an h4 in the modal
        // header.
        revealNormal: function (data, klass) {
            if (klass) $.facebox.current_modal.addClass(klass)
            if (data.match(/class\s*=\s*["']modal-body/)) {
                $.facebox.current_modal.find('.modal-content').empty().append(data);
            } else {
                var header_match_data = data.match(/<(h[123456]).*?>(.*?)(<\/\1>)/);
                if (header_match_data) {
                    $.facebox.current_modal.find('.modal-header h4').empty().append(header_match_data[2]);
                    data = data.replace(new RegExp(header_match_data[0]), '');
                } else {
                    $.facebox.current_modal.find('.modal-header h4').remove();
                }
                $.facebox.current_modal.find('.modal-content').append(data);
            }
            $.facebox.current_modal.modal();
        },

        close: function () {
            $(document).trigger('close.facebox')
            return false
        }
    })

    /*
     * Public, $.fn methods
     */

    $.fn.facebox = function (settings) {
        if ($(this).length == 0) return

        init(settings)

        function clickHandler() {
            $.facebox.loading(true)

            // support for rel="facebox.inline_popup" syntax, to add a class
            // also supports deprecated "facebox[.inline_popup]" syntax
            var klass = this.rel.match(/facebox\[?\.(\w+)\]?/)
            if (klass) klass = klass[1]

            fillFaceboxFromHref(this.href, klass)
            return false
        }

        return this.bind('click.facebox', clickHandler)
    }

    /*
     * Private methods
     */

    // called one time to setup facebox on this page
    function init(settings) {
        if ($.facebox.settings.inited) return true
        else $.facebox.settings.inited = true

        $(document).trigger('init.facebox')
        makeCompatible()

        var imageTypes = $.facebox.settings.imageTypes.join('|')
        $.facebox.settings.imageTypesRegexp = new RegExp('\\.(' + imageTypes + ')(\\?.*)?$', 'i')

        // This will hold the current modal
        $.facebox.current_modal = null;

        if (settings) $.extend($.facebox.settings, settings)

        $(document).on('show.bs.modal', function () {
            $(document).trigger('loading.facebox').trigger('beforeReveal.facebox');
        });

        $(document).on('shown.bs.modal', function () {
            $(document).trigger('reveal.facebox').trigger('afterReveal.facebox')
        });

        $(document).on('hidden.bs.modal', function () {
            $(document).trigger('afterClose.facebox');
            $.facebox.current_modal.remove();
            $.facebox.current_modal = null;
        });
    }

    // Backwards compatibility
    function makeCompatible() {
        var $s = $.facebox.settings

        $s.loadingImage = $s.loading_image || $s.loadingImage
        $s.closeImage = $s.close_image || $s.closeImage
        $s.imageTypes = $s.image_types || $s.imageTypes
        $s.faceboxHtml = $s.facebox_html || $s.faceboxHtml
    }

    // Figures out what you want to display and displays it
    // formats are:
    //     div: #id
    //   image: blah.extension
    //    ajax: anything else
    function fillFaceboxFromHref(href, klass) {
        // div
        if (href.match(/#/)) {
            var url = window.location.href.split('#')[0]
            var target = href.replace(url, '')
            if (target == '#') return
            $.facebox.reveal($(target).html(), klass)

            // image
        } else if (href.match($.facebox.settings.imageTypesRegexp)) {
            fillFaceboxFromImage(href, klass)
            // ajax
        } else {
            fillFaceboxFromLink(href, klass)
        }
    }

    function fillFaceboxFromImage(href, klass) {
        var image = new Image()
        image.onload = function () {
            $.facebox.reveal('<div class="image"><img src="' + image.src + '" /></div>', klass)
        }
        image.src = href
    }

    function fillFaceboxFromLink(href, klass) {
        if ($.facebox.settings.compatibility == 'normal') {
            $.facebox.jqxhr = $.get(href, function (data) {
                $.facebox.revealNormal(data, klass)
            }, 'text');
        } else {
            $.facebox.revealRemote(href, klass);
        }
    }

    /*
     * Bindings
     */

    $(document).bind('close.facebox', function () {
        $.facebox.current_modal.modal('hide');
    });

})(jQuery);
