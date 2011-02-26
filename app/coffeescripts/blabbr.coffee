grab =
  getData: (path, callback) ->
    $.get("#{path}.json", '', callback, "json")

topics =
  index: (path) ->
    callback = (response) ->
      $('#contents').html('')
      addContent(ich.topic(topic), "#contents") for topic in response
    grab.getData(path, callback)

users =
  show: (path) ->
    callback = (response) -> showContent ich.user(response), "#contents"
    grab.getData(path, callback)

blabbr =
  user:
    current:
      audio: $.cookie('audio')
      user_id: $.cookie('user_id'),
      nick: $.cookie('nick'),
      topic_id: null,
  prefix: if history.pushState then "/" else "#/"

(($) ->
  app = $.sammy ->

    this.setLocationProxy(new Sammy.PushLocationProxy(this)) if history.pushState

    this.get blabbr.prefix, ->
      topics.index this.path

    this.get "#{blabbr.prefix}users/:id", ->
      users.show this.path

  $(->
    app.run(blabbr.prefix)
  )
)(jQuery);

