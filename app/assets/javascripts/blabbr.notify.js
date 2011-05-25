(function ($) {
    $.blabbrNotify = function(type, message) {
        setTimeout(function () {
            $('#notify').children().hide('slow').remove();
        }, 5000);
        $('#notify').append('<p class="'+type+'">'+message+'</p>');
    };

    $.redirectTo = function(path) {
        if (history.pushState) {
            getAndShow(ajaxPath(path), "#contents");
            history.pushState({ path: path }, '', path)
        }
        else
        {
            window.location = '/#' + path;
        }
        $('aside').hide('slow');
    }
})(jQuery);
