/* DO NOT MODIFY. This file was compiled Sun, 27 Mar 2011 20:13:53 GMT from
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
      this.before(function() {
        this.trigger('loadingNotification');
        return this.path = history.pushState ? "/" + (this.path.substr(1)) + ".js" : "" + (this.path.substr(1)) + ".js";
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
        var path, that;
        that = this;
        path = infos.path || that.path;
        return $.ajax({
          type: "GET",
          url: path,
          dataType: "html",
          success: function(data) {
            if (data != null) {
              that.trigger('showContent', {
                data: data,
                target: infos.target
              });
              if (infos.hash != null) {
                that.trigger('moveTo', {
                  hash: infos.hash
                });
              }
            }
            return that.trigger('hideLoadingNotification');
          }
        });
      });
      this.bind('postAndShow', function() {
        var that;
        that = this;
        return $.ajax({
          type: "POST",
          url: that.path,
          dataType: "html",
          data: $.param(that.params.toHash()),
          success: function(msg) {
            return that.trigger('showContent', {
              data: msg,
              target: "#contents"
            });
          }
        });
      });
      this.bind('postAndAdd', function(e, infos) {
        var that;
        that = this;
        return $.ajax({
          type: "POST",
          url: that.path,
          dataType: "html",
          data: $.param(that.params.toHash()),
          success: function(msg) {
            return that.trigger('addContent', {
              data: msg,
              target: infos.target
            });
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
      this.bind('showPost', function(e, data) {
        var that;
        that = this;
        return $.ajax({
          type: "GET",
          url: data.path,
          dataType: "html",
          success: function(data) {
            if (data != null) {
              $(data).hide().appendTo("#posts").show('slow');
              return that.trigger('notify');
            }
          }
        });
      });
      this.bind('updateTitle', function() {
        var title;
        title = $('.page-title').attr('title');
        $("#page-title").html(title);
        return document.title = "Blabbr - " + title;
      });
      this.bind('notify', function() {
        lostFocus();
        blinkTitle(1);
        if (current_user.audio != null) {
          return this.trigger('audioNotification');
        }
      });
      this.bind('audioNotification', function() {
        var audio;
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
        var channel, id, that;
        id = data.id;
        that = this;
        if (!pusher.channels.channels[id]) {
          channel = pusher.subscribe(id);
          channel.bind('new-post', function(data) {
            var url;
            url = "/topics/" + id + "/posts/" + data.id + ".js";
            if (data.user_nickname !== current_user.user_nickname && id === current_user.topic_id) {
              return that.trigger('showPost', {
                path: url,
                user_id: data.user_id
              });
            }
          });
          return channel.bind('index', function(data) {
            if ($('aside #topics').length != null) {
              return that.trigger('getAndShow', {
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
        var post_id;
        post_id = this.params['post_id'];
        return $.ajax({
          type: "GET",
          url: this.path,
          dataType: "html",
          success: function(data) {
            if (data != null) {
              return showEdit(data, post_id);
            }
          }
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
        return console.log('weird return bug here');
      });
      this.post('/topics/:id/posts', function() {
        this.trigger('postAndAdd', {
          target: '#posts'
        });
        return console.log('weird return bug here');
      });
      this.post('/topics/:id/members', function() {
        this.trigger('postAndAdd');
        return console.log('weird return bug here');
      });
      this.put("" + root + "topics/:id", function() {
        postAndAdd(this.path, this.params);
        return getAndShow(this.path, "#contents", "#contents");
      });
      this.put("" + root + "topics/:id/posts/:post_id", function() {
        return postAndReplace(this.path, this.params);
      });
      this.put("" + root + "users/:id", function() {
        return postAndShow(this.path, this.params);
      });
      return this.del("" + root + "topics/:id/posts/:post_id", function() {
        return deletePost(this.path, this.params);
      });
    });
    return $(function() {
      return app.run(root);
    });
  })(jQuery);
}).call(this);
