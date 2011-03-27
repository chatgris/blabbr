grab =
  getData: (path, callback) ->
    $.get("#{path}.json", '', callback, "json")

topics =
  index: (path) ->
    callback = (response) ->
      $('#contents').html('')
      addContent(ich.topic(topic), "#contents") for topic in response
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

    # before and after filter
    #
    this.before () ->
      blabbr.loadingNotification()
      this.path = ajaxPath this.path

    this.after () ->
      subscribeToPusher 'index'
      blabbr.hideLoadingNotification()
      if _gaq?
        _gaq.push ['_trackPageview']
        _gaq.push ['_trackEvent', this.path, this.verb, 'blabbr']


    # set location proxy
    #
    this.setLocationProxy(new Sammy.PushLocationProxy(this)) if history.pushState


    # bindings
    #
    this.bind 'getAndShow', (e, infos) ->
      that = this
      $.ajax {
        type: "GET"
        , url: infos.path
        , dataType: "html"
        , success: (data) ->
          if data?
            that.trigger 'showContent', {data: data, target: infos.target}
            if infos.hash
              that.trigger 'moveTo', {hash: infos.hash}

      }

    this.bind 'showContent', (e, data) ->
      $(data.target).show().html(data.data)

    this.bind 'moveTo', (e, data) ->
      $.each [window.location.hash, data.hash], (index, value) ->
        if (value)
          $(value).livequery () ->
              $(this).addClass('anchor');
              $('html,body').animate({scrollTop: $(this).offset().top},'slow');
              $(value).livequery().expire();


    # routes
    #
    this.get blabbr.prefix, ->
      this.trigger 'getAndShow',  {path :this.path, target: '#contents'}

    this.get "#{blabbr.prefix}topics", ->
      this.trigger 'getAndShow',  {path: this.path, target: 'aside'}

    this.get "#{blabbr.prefix}topics/new", ->
      this.trigger 'getAndShow', {path: this.path, target: 'aside'}

    # TODO : post event
    this.post "/topics", ->
      postAndShow this.path, this.params

    this.get "#{blabbr.prefix}topics/page/:page_id", ->
      this.trigger 'getAndShow', {path: this.path, target: '#contents', hash: '#contents'}

    # TODO : pusher as event
    this.get "#{blabbr.prefix}topics/:id", ->
      current_user.topic_id = this.params['id']
      subscribeToPusher this.params['id']
      this.trigger 'getAndShow', {path: this.path, target: '#contents', hash: '#contents'}

    this.get "#{blabbr.prefix}topics/:id/edit", ->
      this.trigger 'getAndShow', {path: this.path, target: 'aside'}

    # TODO : post event
    # TODO make only one call
    this.put "#{blabbr.prefix}topics/:id", ->
      postAndAdd this.path, this.params
      getAndShow this.path, "#contents", "#contents"

    # TODO : post event
    this.post '/topics/:id/posts',->
      postAndAdd this.path, this.params, '#posts'

    # TODO : post event
    this.post '/topics/:id/members',->
     postAndAdd this.path, this.params

    # TODO : pusher as event
    this.get "#{blabbr.prefix}topics/:id/page/:page_id", ->
      current_user.topic_id = this.params['id']
      subscribeToPusher this.params['id']
      this.trigger 'getAndShow', {path: this.path, target: '#contents', hash: window.location.hash || '#contents'}

    # TODO : event
    this.get "#{blabbr.prefix}topics/:id/posts/:post_id/edit", ->
      post_id = this.params['post_id']
      $.ajax {
        type: "GET"
        , url: this.path
        , dataType: "html"
        , success: (data) ->
          if data?
            showEdit(data, post_id)
      }

    # TODO : post event
    this.put "#{blabbr.prefix}topics/:id/posts/:post_id", ->
      postAndReplace this.path, this.params

    # TODO : delete event
    this.del "#{blabbr.prefix}topics/:id/posts/:post_id", ->
      deletePost this.path, this.params

    # TODO : post event
    this.put "#{blabbr.prefix}users/:id", ->
      postAndShow this.path, this.params

    this.get "#{blabbr.prefix}dashboard", ->
      this.trigger 'getAndShow', {path: this.path, target: 'aside'}

    this.get "#{blabbr.prefix}smilies", ->
      this.trigger 'getAndShow', {path: this.path, target: 'aside'}

    this.get "#{blabbr.prefix}smilies/new", ->
      this.trigger 'getAndShow', {path: this.path, target: 'aside'}

    this.get "#{blabbr.prefix}users/:id", ->
      this.trigger 'getAndShow', {path: this.path, target: 'aside'}

  $(->
    app.run(blabbr.prefix)
  )
)(jQuery)
