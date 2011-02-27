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

window.current_user =
  audio: $.cookie('audio')
  user_id: $.cookie('user_id'),
  nick: $.cookie('nick'),
  topic_id: null,

blabbr =
  prefix: if history.pushState then "/" else "#/"
  loadingNotification: () ->
    $("#contents").append '<p class="loading"></p>'
  hideLoadingNotification: () ->
    $('.loading').hide()

(($) ->
  app = $.sammy ->

    this.before () ->
      blabbr.loadingNotification()
      this.path = ajaxPath this.path

    this.after () ->
      subscribeToPusher 'index'
      blabbr.hideLoadingNotification()
      if _gaq?
        _gaq.push(['_trackPageview']);
        _gaq.push(['_trackEvent', this.path, this.verb, 'blabbr']);

    this.setLocationProxy(new Sammy.PushLocationProxy(this)) if history.pushState

    this.get blabbr.prefix, ->
      getAndShow(this.path, "#contents");

    this.get "#{blabbr.prefix}topics", ->
      getAndShow this.path, "aside"

    this.get "#{blabbr.prefix}topics/new", ->
      getAndShow this.path, "aside"

    this.post "/topics", ->
      postAndShow this.path, this.params

    this.get "#{blabbr.prefix}topics/page/:page_id", ->
      getAndShow this.path, "#contents", "#contents"

    this.get "#{blabbr.prefix}topics/:id", ->
      current_user.topic_id = this.params['id']
      subscribeToPusher this.params['id']
      getAndShow this.path, "#contents", "#contents"

    this.get "#{blabbr.prefix}topics/:id/edit", ->
      getAndShow this.path, "aside"

    this.put "#{blabbr.prefix}topics/:id", ->
      postAndAdd this.path, this.params
      # TODO make only one call
      getAndShow this.path, "#contents", "#contents"

    this.post '/topics/:id/posts',->
      postAndAdd this.path, this.params, '#posts'

    this.post '/topics/:id/members',->
     postAndAdd this.path, this.params

    this.get "#{blabbr.prefix}topics/:id/page/:page_id", ->
      current_user.topic_id = this.params['id'];
      subscribeToPusher(this.params['id']);
      getAndShow(path, "#contents", '#contents');

    this.get "#{blabbr.prefix}topics/:id/page/:page_id/:anchor", ->
      current_user.topic_id = this.params['id']
      subscribeToPusher this.params['id']
      params = this.params
      getAndShow "/topics/#{params['id']}/page/#{params['page_id']}.js", "#contents", params['anchor']

    this.get "#{blabbr.prefix}topics/:id/posts/:post_id/edit", ->
      post_id = this.params['post_id']
      $.ajax {
        type: "GET",
        url: this.path,
        dataType: "html",
        success: (data) ->
          if data?
            showEdit(data, post_id)
      }

    this.put "#{blabbr.prefix}topics/:id/posts/:post_id", ->
      postAndReplace this.path, this.params

    this.del "#{blabbr.prefix}topics/:id/posts/:post_id", ->
      deletePost this.path, this.params

    this.get "#{blabbr.prefix}users/:id", ->
      getAndShow this.path, 'aside'

    this.put "#{blabbr.prefix}users/:id", ->
      postAndShow this.path, this.params

    this.get "#{blabbr.prefix}dashboard", ->
      getAndShow this.path, 'aside'

    this.get "#{blabbr.prefix}smilies", ->
      getAndShow this.path

    this.get "#{blabbr.prefix}smilies/new", ->
      getAndShow this.path, 'aside'

    this.get "#{blabbr.prefix}users/:id", ->
      users.show this.path

  $(->
    app.run(blabbr.prefix)
  )
)(jQuery);

