/* DO NOT MODIFY. This file was compiled Sun, 17 Apr 2011 15:56:53 GMT from
 * /home/chatgris/dev/blabbr/app/coffeescripts/blabbr.coffee
 */

(function() {
  var current_user, root;
  current_user = {
    audio: $.cookie('audio'),
    user_nickname: $.cookie('user_nickname'),
    topic_id: null
  };
  root = history.pushState ? "/" : "#/";
  (function($) {
    var app;
    app = $.sammy(function() {
      var context;
      context = this;
      this.before(function() {
        this.trigger('loadingNotification');
        context.path = history.pushState ? "/" + (this.path.substr(1)) + ".js" : "" + (this.path.substr(1)) + ".js";
        return context.params = this.params;
      });
      this.after(function() {
        this.trigger('subscribeToWS', {
          id: 'index'
        });
        if (typeof _gaq != "undefined" && _gaq !== null) {
          _gaq.push(['_trackPageview']);
          return _gaq.push(['_trackEvent', this.path, this.verb, 'blabbr']);
        }
      });
      if (history.pushState) {
        this.setLocationProxy(new Sammy.PushLocationProxy(this));
      }
      this.bind('loadingNotification', function() {
        return $("#contents").append('<p class="loading"></p>');
      });
      this.bind('hideLoadingNotification', function() {
        return $('.loading').hide();
      });
      this.bind('getAndShow', function(e, infos) {
        var path;
        path = infos.path || context.path;
        return $.ajax({
          type: "GET",
          url: path,
          dataType: "html",
          success: function(data) {
            if (data != null) {
              context.trigger('showContent', {
                data: data,
                target: infos.target
              });
              if (infos.hash != null) {
                context.trigger('moveTo', {
                  hash: infos.hash
                });
              }
            }
            return context.trigger('hideLoadingNotification');
          }
        });
      });
      this.bind('postAndShow', function() {
        return $.ajax({
          type: "POST",
          url: context.path,
          dataType: "html",
          data: $.param(context.params.toHash()),
          success: function(msg) {
            return context.trigger('showContent', {
              data: msg,
              target: "#contents"
            });
          }
        });
      });
      this.bind('postAndReplace', function() {
        var target;
        target = "#" + context.params['post_id'] + " .bubble";
        return $.ajax({
          type: "POST",
          url: context.path,
          dataType: "html",
          data: $.param(context.params.toHash()),
          success: function(msg) {
            context.trigger('replaceContent', {
              data: msg,
              target: target
            });
            return context.trigger('hideLoadingNotification');
          }
        });
      });
      this.bind('postAndAdd', function(e, infos) {
        return $.ajax({
          type: "POST",
          url: context.path,
          dataType: "html",
          data: $.param(context.params.toHash()),
          success: function(msg) {
            context.trigger('addContent', {
              data: msg,
              target: infos.target
            });
            context.trigger('moveTo', {
              hash: infos.hash || infos.target
            });
            return context.trigger('hideLoadingNotification');
          }
        });
      });
      this.bind('getAndReplace', function(e, infos) {
        var target;
        target = "#" + context.params['post_id'] + " .bubble";
        return $.ajax({
          type: "GET",
          url: context.path,
          dataType: "html",
          success: function(data) {
            if (data != null) {
              context.trigger('replaceContent', {
                data: data,
                target: target
              });
              return context.trigger('hideLoadingNotification');
            }
          }
        });
      });
      this.bind('showPost', function(e, data) {
        return $.ajax({
          type: "GET",
          url: data.path,
          dataType: "html",
          success: function(data) {
            if (data != null) {
              $(data).hide().appendTo("#posts").show('slow');
              return context.trigger('notify');
            }
          }
        });
      });
      this.bind('deletePost', function() {
        var target;
        target = "#" + context.params['post_id'] + " .bubble";
        return $.ajax({
          type: "DELETE",
          url: context.path,
          data: $.param(context.params.toHash()),
          dataType: "html",
          success: function(data) {
            context.trigger('replaceContent', {
              data: data,
              target: target
            });
            $("#edit_post_" + context.params['post_id']).remove();
            return context.trigger('hideLoadingNotification');
          }
        });
      });
      this.bind('showContent', function(e, data) {
        $(data.target).show().html(data.data);
        return this.trigger('updateTitle');
      });
      this.bind('addContent', function(e, data) {
        var id;
        id = data.target || "#contents";
        return $(id).append(data.data);
      });
      this.bind('replaceContent', function(e, data) {
        return $(data.target).html(data.data);
      });
      this.bind('updateTitle', function() {
        var title;
        title = $('.page-title').attr('title');
        $("#page-title").html(title);
        return document.title = "Blabbr - " + title;
      });
      this.bind('notify', function() {
        if (current_user.audio != null) {
          return this.trigger('audioNotification');
        }
      });
      this.bind('audioNotification', function() {
        var audio;
        console.log('pouet');
        $('body').append('<audio id="player" src="/sound.mp3" autoplay />');
        audio = $('#player');
        return $(audio).bind('ended', function() {
          return $(this).remove;
        });
      });
      this.bind('moveTo', function(e, data) {
        return $.each([window.location.hash, data.hash], function(index, value) {
          if (value != null) {
            return $(value).livequery(function() {
              $(this).addClass('anchor');
              $('html,body').animate({
                scrollTop: $(this).offset().top
              }, 'slow');
              return $(value).livequery().expire();
            });
          }
        });
      });
      this.bind('subscribeToWS', function(e, data) {
        var channel, id;
        id = data.id;
        if (!pusher.channels.channels[id]) {
          channel = pusher.subscribe(id);
          channel.bind('new-post', function(data) {
            var url;
            url = "/topics/" + id + "/posts/" + data.id + ".js";
            if (data.user_nickname !== current_user.user_nickname && id === current_user.topic_id) {
              return context.trigger('showPost', {
                path: url,
                user_id: data.user_id
              });
            }
          });
          return channel.bind('index', function(data) {
            if ($('aside #topics').length != null) {
              return context.trigger('getAndShow', {
                path: '/topics.js',
                target: "aside"
              });
            }
          });
        }
      });
      this.bind('topicId', function() {
        return current_user.topic_id = this.params['id'];
      });
      this.get(root, function() {
        return this.trigger('getAndShow', {
          target: '#contents'
        });
      });
      this.get("" + root + "topics", function() {
        return this.trigger('getAndShow', {
          target: 'aside'
        });
      });
      this.get("" + root + "topics/new", function() {
        return this.trigger('getAndShow', {
          target: 'aside'
        });
      });
      this.get("" + root + "topics/page/:page_id", function() {
        return this.trigger('getAndShow', {
          target: '#contents',
          hash: '#contents'
        });
      });
      this.get("" + root + "topics/:id", function() {
        this.trigger('getAndShow', {
          target: '#contents',
          hash: '#contents'
        });
        this.trigger('topicId');
        return this.trigger('subscribeToWS', {
          id: this.params['id']
        });
      });
      this.get("" + root + "topics/:id/edit", function() {
        return this.trigger('getAndShow', {
          target: 'aside'
        });
      });
      this.get("" + root + "topics/:id/page/:page_id", function() {
        this.trigger('getAndShow', {
          target: '#contents',
          hash: window.location.hash || '#contents'
        });
        this.trigger('topicId');
        return this.trigger('subscribeToWS', {
          id: this.params['id']
        });
      });
      this.get("" + root + "topics/:id/posts/:post_id/edit", function() {
        return this.trigger('getAndReplace', {
          target: this.params['post_id']
        });
      });
      this.get("" + root + "dashboard", function() {
        return this.trigger('getAndShow', {
          target: 'aside'
        });
      });
      this.get("" + root + "smilies", function() {
        return this.trigger('getAndShow', {
          target: 'aside'
        });
      });
      this.get("" + root + "smilies/new", function() {
        return this.trigger('getAndShow', {
          target: 'aside'
        });
      });
      this.get("" + root + "users/:id", function() {
        return this.trigger('getAndShow', {
          target: 'aside'
        });
      });
      this.post("/topics", function() {
        this.trigger('postAndShow');
      });
      this.post('/topics/:id/posts', function() {
        this.trigger('postAndAdd', {
          target: '#posts',
          hash: '#new_post'
        });
      });
      this.post('/topics/:id/members', function() {
        this.trigger('postAndAdd');
      });
      this.put("" + root + "topics/:id", function(context) {
        this.trigger('postAndAdd', {
          target: '#contents'
        });
      });
      this.put("" + root + "topics/:id/posts/:post_id", function() {
        this.trigger('postAndReplace');
      });
      return this.del("" + root + "topics/:id/posts/:post_id", function() {
        this.trigger('deletePost');
      });
    });
    return $(function() {
      return app.run(root);
    });
  })(jQuery);
}).call(this);
