(function($) {

    Sammy = Sammy || {};

    Sammy.PushLocationProxy = function(app) {
        this.app = app;
    };

    Sammy.PushLocationProxy.prototype = {
        bind: function() {
            var proxy = this;
            $(window).bind('popstate', function(e) {
                 proxy.app.trigger('location-changed');
            });
            $('a').live('click', function(e) {
                // Do not bind external links
                if (location.hostname == this.hostname)
                {
                    e.preventDefault();
                    proxy.setLocation($(this).attr('href'));
                    proxy.app.trigger('location-changed');
                }
            });
        },
        unbind: function() {
            $('a').unbind('click');
            $(window).unbind('popstate');
        },

        getLocation: function() {
            return window.location.pathname;
        },

        setLocation: function(new_location) {
            history.pushState({ path: this.path }, '', new_location)
        }
    };

})(jQuery);
