/* DO NOT MODIFY. This file was compiled Sat, 26 Feb 2011 18:22:04 GMT from
 * /home/chatgris/dev/blabbr/app/coffeescripts/blabbr.coffee
 */

(function() {
  var blabbr, grab, topics, users;
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
  users = {
    show: function(path) {
      var callback;
      callback = function(response) {
        return showContent(ich.user(response), "#contents");
      };
      return grab.getData(path, callback);
    }
  };
  blabbr = {
    user: {
      current: {
        audio: $.cookie('audio'),
        user_id: $.cookie('user_id'),
        nick: $.cookie('nick'),
        topic_id: null
      }
    },
    prefix: history.pushState ? "/" : "#/"
  };
  (function($) {
    var app;
    app = $.sammy(function() {
      if (history.pushState) {
        this.setLocationProxy(new Sammy.PushLocationProxy(this));
      }
      this.get(blabbr.prefix, function() {
        return topics.index(this.path);
      });
      return this.get("" + blabbr.prefix + "users/:id", function() {
        return users.show(this.path);
      });
    });
    return $(function() {
      return app.run(blabbr.prefix);
    });
  })(jQuery);
}).call(this);
