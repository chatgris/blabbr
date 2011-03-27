/* DO NOT MODIFY. This file was compiled Sun, 27 Mar 2011 16:01:50 GMT from
 * /home/chatgris/dev/blabbr/app/coffeescripts/blabbr.coffee
 */

(function() {
  var blabbr, grab, topics;
  grab = {
    getData: function(path, callback) {
      return $.get("" + path + ".json", '', callback, "json");
    }
  };
  topics = {
    index: function(path) {
      var callback;
      callback = function(response) {
        var topic, _i, _len, _results;
        $('#contents').html('');
        _results = [];
        for (_i = 0, _len = response.length; _i < _len; _i++) {
          topic = response[_i];
          _results.push(addContent(ich.topic(topic), "#contents"));
        }
        return _results;
      };
      return grab.getData(path, callback);
    }
  };
  window.current_user = {
    audio: $.cookie('audio'),
    user_nickname: $.cookie('user_nickname'),
    topic_id: null
  };
  blabbr = {
    prefix: history.pushState ? "/" : "#/",
    loadingNotification: function() {
      return $("#contents").append('<p class="loading"></p>');
    },
    hideLoadingNotification: function() {
      return $('.loading').hide();
    }
  };
  (function($) {
    var app;
    app = $.sammy(function() {
      this.before(function() {
        blabbr.loadingNotification();
        this.path = ajaxPath(this.path);
        return this.ws = pusher;
      });
      this.after(function() {
        this.trigger('subscribeToWS', {
          id: 'index'
        });
        blabbr.hideLoadingNotification();
        if (typeof _gaq != "undefined" && _gaq !== null) {
          _gaq.push(['_trackPageview']);
          return _gaq.push(['_trackEvent', this.path, this.verb, 'blabbr']);
        }
      });
      if (history.pushState) {
        this.setLocationProxy(new Sammy.PushLocationProxy(this));
      }
      this.bind('getAndShow', function(e, infos) {
        var that;
        that = this;
        return $.ajax({
          type: "GET",
          url: infos.path,
          dataType: "html",
          success: function(data) {
            if (data != null) {
              that.trigger('showContent', {
                data: data,
                target: infos.target
              });
              if (infos.hash) {
                return that.trigger('moveTo', {
                  hash: infos.hash
                });
              }
            }
          }
        });
      });
      this.bind('showContent', function(e, data) {
        $(data.target).show().html(data.data);
        return this.trigger('updateTitle');
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
        if (current_user.audio) {
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
          if (value) {
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
        if (!that.ws.channels.channels[id]) {
          channel = that.ws.subscribe(id);
          channel.bind('new-post', function(data) {
            var url;
            url = "/topics/" + id + "/posts/" + data.id + ".js";
            console.log(data);
            console.log(current_user);
            if (data.user_nickname !== current_user.user_nickname && id === current_user.topic_id) {
              return that.trigger('showPost', {
                path: url,
                user_id: data.user_id
              });
            }
          });
          return channel.bind('index', function(data) {
            if ($('aside #topics').length) {
              return that.trigger('getAndShow', {
                path: '/topics.js',
                target: "aside"
              });
            }
          });
        }
      });
      this.get(blabbr.prefix, function() {
        return this.trigger('getAndShow', {
          path: this.path,
          target: '#contents'
        });
      });
      this.get("" + blabbr.prefix + "topics", function() {
        return this.trigger('getAndShow', {
          path: this.path,
          target: 'aside'
        });
      });
      this.get("" + blabbr.prefix + "topics/new", function() {
        return this.trigger('getAndShow', {
          path: this.path,
          target: 'aside'
        });
      });
      this.post("/topics", function() {
        return postAndShow(this.path, this.params);
      });
      this.get("" + blabbr.prefix + "topics/page/:page_id", function() {
        return this.trigger('getAndShow', {
          path: this.path,
          target: '#contents',
          hash: '#contents'
        });
      });
      this.get("" + blabbr.prefix + "topics/:id", function() {
        current_user.topic_id = this.params['id'];
        this.trigger('subscribeToWS', {
          id: this.params['id']
        });
        return this.trigger('getAndShow', {
          path: this.path,
          target: '#contents',
          hash: '#contents'
        });
      });
      this.get("" + blabbr.prefix + "topics/:id/edit", function() {
        return this.trigger('getAndShow', {
          path: this.path,
          target: 'aside'
        });
      });
      this.put("" + blabbr.prefix + "topics/:id", function() {
        postAndAdd(this.path, this.params);
        return getAndShow(this.path, "#contents", "#contents");
      });
      this.post('/topics/:id/posts', function() {
        return postAndAdd(this.path, this.params, '#posts');
      });
      this.post('/topics/:id/members', function() {
        return postAndAdd(this.path, this.params);
      });
      this.get("" + blabbr.prefix + "topics/:id/page/:page_id", function() {
        current_user.topic_id = this.params['id'];
        this.trigger('subscribeToWS', {
          id: this.params['id']
        });
        return this.trigger('getAndShow', {
          path: this.path,
          target: '#contents',
          hash: window.location.hash || '#contents'
        });
      });
      this.get("" + blabbr.prefix + "topics/:id/posts/:post_id/edit", function() {
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
      this.put("" + blabbr.prefix + "topics/:id/posts/:post_id", function() {
        return postAndReplace(this.path, this.params);
      });
      this.del("" + blabbr.prefix + "topics/:id/posts/:post_id", function() {
        return deletePost(this.path, this.params);
      });
      this.put("" + blabbr.prefix + "users/:id", function() {
        return postAndShow(this.path, this.params);
      });
      this.get("" + blabbr.prefix + "dashboard", function() {
        return this.trigger('getAndShow', {
          path: this.path,
          target: 'aside'
        });
      });
      this.get("" + blabbr.prefix + "smilies", function() {
        return this.trigger('getAndShow', {
          path: this.path,
          target: 'aside'
        });
      });
      this.get("" + blabbr.prefix + "smilies/new", function() {
        return this.trigger('getAndShow', {
          path: this.path,
          target: 'aside'
        });
      });
      return this.get("" + blabbr.prefix + "users/:id", function() {
        return this.trigger('getAndShow', {
          path: this.path,
          target: 'aside'
        });
      });
    });
    return $(function() {
      return app.run(blabbr.prefix);
    });
  })(jQuery);
}).call(this);
