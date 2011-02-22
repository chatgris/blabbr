var root = (history.pushState) ? "/" : "#/";
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

(function($) {

    var app = $.sammy(function() {

        this.notFound = function(verb, path) {
            document.location.href = path;
        }

        if (history.pushState) {
            this.setLocationProxy(new Sammy.PushLocationProxy(this));
        }

        this.before(function(){
            path = ajaxPath(this.path);
            loadingNotification();
        });

        this.after(function(){
            subscribeToPusher('index');
            if(typeof(_gaq) !== 'undefined'){
                _gaq.push(['_trackPageview']);
                _gaq.push(['_trackEvent', this.path, this.verb, 'blabbr']);
            }
        });

        this.get(root, function() {
            getAndShow(path, "#contents");
        });

        this.get(root + 'topics', function() {
            getAndShow(path, "aside");
        });

        this.get(root +'topics/new', function() {
            getAndShow(path, "aside");
        });

        this.post('/topics', function() {
            postAndShow(path, this.params);
        });

        this.get(root +'topics/page/:page_id', function() {
            getAndShow(path, "#contents", '#contents');
        });

        this.get(root +'topics/:id', function() {
            subscribeToPusher(this.params['id']);
            getAndShow(path, "#contents", '#contents');
        });

        this.get(root +'topics/:id/edit', function() {
            getAndShow(path, "aside");
        });

        this.put('/topics/:id', function() {
            postAndAdd(path, this.params);
            getAndShow(path, "#contents", '#contents');
        });

        this.post('/topics/:id/posts', function() {
            postAndAdd(path, this.params);
        });

        this.post('/topics/:id/members', function() {
            postAndAdd(path, this.params);
        });

        this.get(root +'topics/:id/page/:page_id', function() {
            subscribeToPusher(this.params['id']);
            getAndShow(path, "#contents", '#contents');
        });

        this.get(root +'topics/:id/page/:page_id/:anchor', function() {
            subscribeToPusher(this.params['id']);
            params = this.params;
            getAndShow("/topics/"+params['id']+"/page/"+params['page_id']+".js", "#contents", params['anchor']);
        });

        this.get(root +'topics/:id/posts/:post_id/edit', function() {
            var post_id = this.params['post_id'];
            $.ajax({
                type: "GET",
                url: path,
                dataType: "html",
                success: function(data){
                if (data) {
                    showEdit(data, post_id);
                }}
            });
        });

        this.put('/topics/:id/posts/:post_id', function() {
            postAndReplace(path, this.params);
        });

        this.del('/topics/:id/posts/:post_id', function() {
            deletePost(path, this.params);
        });

        this.get(root +'users/:id', function() {
            getAndShow(path, 'aside');
        });

        this.put('/users/:id', function() {
            postAndShow(path, this.params);
        });

        this.get(root +'dashboard', function() {
            getAndShow(path, 'aside');
        });

        this.get(root +'smilies', function() {
            getAndShow(path);
        });

        this.get(root +'smilies/new', function() {
            getAndShow(path, 'aside');
        });

    });

    $(function() {
         app.run(root);
    });

})(jQuery);
