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
  user_nickname: $.cookie('user_nickname'),
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
      this.ws = pusher

    this.after () ->
      this.trigger 'subscribeToWS', {id: 'index'}
      blabbr.hideLoadingNotification()
      if _gaq?
        _gaq.push ['_trackPageview']
        _gaq.push ['_trackEvent', this.path, this.verb, 'blabbr']

    # set location proxy-]
    #
    this.setLocationProxy(new Sammy.PushLocationProxy(this)) if history.pushState

    # bindings
    #
    this.bind 'getAndShow', (e, infos) ->
      that = this
      $.ajax {
        type: "GET"
        , url: that.path
        , dataType: "html"
        , success: (data) ->
          if data?
            that.trigger 'showContent', {data: data, target: infos.target}
            if infos.hash
              that.trigger 'moveTo', {hash: infos.hash}

      }

    this.bind 'showContent', (e, data) ->
      $(data.target).show().html data.data
      this.trigger 'updateTitle'


    this.bind 'showPost', (e, data) ->
      that = this
      $.ajax {
        type: "GET"
        , url: data.path
        , dataType: "html"
        , success: (data) ->
          if data?
            $(data).hide().appendTo("#posts").show('slow')
            that.trigger 'notify'

      }

    this.bind 'updateTitle', ->
      title = $('.page-title').attr 'title'
      $("#page-title").html title
      document.title = "Blabbr - #{title}"

    this.bind 'notify', ->
      lostFocus()
      blinkTitle(1)
      if current_user.audio
        this.trigger 'audioNotification'

    this.bind 'audioNotification', ->
      $('body').append '<audio id="player" src="/sound.mp3" autoplay />'
      audio = $('#player')
      $(audio).bind 'ended', ->
        $(this).remove

    this.bind 'moveTo', (e, data) ->
      $.each [window.location.hash, data.hash], (index, value) ->
        if (value)
          $(value).livequery () ->
              $(this).addClass('anchor')
              $('html,body').animate({scrollTop: $(this).offset().top},'slow')
              $(value).livequery().expire()

    this.bind 'subscribeToWS', (e, data) ->
      id = data.id
      that = this
      unless that.ws.channels.channels[id]
        channel = that.ws.subscribe id
        channel.bind 'new-post', (data) ->
          url = "/topics/#{id}/posts/#{data.id}.js"
          console.log data
          console.log current_user
          if data.user_nickname != current_user.user_nickname && id == current_user.topic_id
            that.trigger 'showPost', {path: url, user_id: data.user_id}
        channel.bind 'index', (data) ->
          if $('aside #topics').length
            that.trigger 'getAndShow', {path: '/topics.js', target: "aside"}


    # routes
    #
    this.get blabbr.prefix, ->
      this.trigger 'getAndShow',  {target: '#contents'}

    this.get "#{blabbr.prefix}topics", ->
      this.trigger 'getAndShow',  {target: 'aside'}

    this.get "#{blabbr.prefix}topics/new", ->
      this.trigger 'getAndShow', {target: 'aside'}

    # TODO : post event
    this.post "/topics", ->
      postAndShow this.path, this.params

    this.get "#{blabbr.prefix}topics/page/:page_id", ->
      this.trigger 'getAndShow', {target: '#contents', hash: '#contents'}

    this.get "#{blabbr.prefix}topics/:id", ->
      current_user.topic_id = this.params['id']
      this.trigger 'subscribeToWS',  {id: this.params['id']}
      this.trigger 'getAndShow', {target: '#contents', hash: '#contents'}

    this.get "#{blabbr.prefix}topics/:id/edit", ->
      this.trigger 'getAndShow', {target: 'aside'}

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

    this.get "#{blabbr.prefix}topics/:id/page/:page_id", ->
      current_user.topic_id = this.params['id']
      this.trigger 'subscribeToWS',  {id: this.params['id']}
      this.trigger 'getAndShow', {target: '#contents', hash: window.location.hash || '#contents'}

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
      this.trigger 'getAndShow', {target: 'aside'}

    this.get "#{blabbr.prefix}smilies", ->
      this.trigger 'getAndShow', {target: 'aside'}

    this.get "#{blabbr.prefix}smilies/new", ->
      this.trigger 'getAndShow', {target: 'aside'}

    this.get "#{blabbr.prefix}users/:id", ->
      this.trigger 'getAndShow', {target: 'aside'}

  $(->
    app.run(blabbr.prefix)
  )
)(jQuery)
