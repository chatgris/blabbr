current_user =
  audio: $.cookie('audio')
  user_nickname: $.cookie('user_nickname'),
  topic_id: null,

root = if history.pushState then "/" else "#/"

(($) ->
  app = $.sammy ->

    # before and after filter
    #
    this.before () ->
      this.trigger 'loadingNotification'
      this.path = if history.pushState then "/#{this.path.substr(1)}.js" else "#{this.path.substr(1)}.js"

    this.after () ->
      this.trigger 'subscribeToWS', {id: 'index'}
      if _gaq?
        _gaq.push ['_trackPageview']
        _gaq.push ['_trackEvent', this.path, this.verb, 'blabbr']

    # set location proxy-]
    #
    this.setLocationProxy(new Sammy.PushLocationProxy(this)) if history.pushState

    # bindings
    #
    this.bind 'loadingNotification', ->
      $("#contents").append '<p class="loading"></p>'

    this.bind 'hideLoadingNotification', ->
      $('.loading').hide()

    this.bind 'getAndShow', (e, infos) ->
      that = this
      path = infos.path || that.path
      $.ajax {
        type: "GET"
        , url: path
        , dataType: "html"
        , success: (data) ->
          if data?
            that.trigger 'showContent', {data: data, target: infos.target}
            if infos.hash?
              that.trigger 'moveTo', {hash: infos.hash}
          that.trigger 'hideLoadingNotification'

      }

    # TODO : return html rather than js
    this.bind 'postAndShow', ->
      that = this
      $.ajax {
        type: "POST",
        url: that.path,
        dataType: "html",
        data: $.param(that.params.toHash()),
        success: (msg) ->
          that.trigger 'showContent', {data: msg, target: "#contents"}
      }

    this.bind 'postAndAdd', (e, infos) ->
      that = this
      $.ajax {
        type: "POST",
        url: that.path,
        dataType: "html",
        data: $.param(that.params.toHash()),
        success: (msg) ->
          that.trigger 'addContent', {data: msg, target: infos.target}
      }

    this.bind 'showContent', (e, data) ->
      $(data.target).show().html data.data
      this.trigger 'updateTitle'

    this.bind 'addContent', (e, data) ->
      id = data.target || "#contents"
      $(id).append(data.data)

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
      if current_user.audio?
        this.trigger 'audioNotification'

    this.bind 'audioNotification', ->
      $('body').append '<audio id="player" src="/sound.mp3" autoplay />'
      audio = $('#player')
      $(audio).bind 'ended', ->
        $(this).remove

    this.bind 'moveTo', (e, data) ->
      $.each [window.location.hash, data.hash], (index, value) ->
        if value?
          $(value).livequery () ->
              $(this).addClass('anchor')
              $('html,body').animate({scrollTop: $(this).offset().top},'slow')
              $(value).livequery().expire()

    this.bind 'subscribeToWS', (e, data) ->
      id = data.id
      that = this
      unless pusher.channels.channels[id]
        channel = pusher.subscribe id
        channel.bind 'new-post', (data) ->
          url = "/topics/#{id}/posts/#{data.id}.js"
          if data.user_nickname != current_user.user_nickname && id == current_user.topic_id
            that.trigger 'showPost', {path: url, user_id: data.user_id}
        channel.bind 'index', (data) ->
          if $('aside #topics').length?
            that.trigger 'getAndShow', {path: '/topics.js', target: "aside"}

    this.bind 'topicId', ->
      current_user.topic_id = this.params['id']

    # routes
    #

    # GET
    this.get root, ->
      this.trigger 'getAndShow',  {target: '#contents'}

    this.get "#{root}topics", ->
      this.trigger 'getAndShow',  {target: 'aside'}

    this.get "#{root}topics/new", ->
      this.trigger 'getAndShow', {target: 'aside'}

    this.get "#{root}topics/page/:page_id", ->
      this.trigger 'getAndShow', {target: '#contents', hash: '#contents'}

    this.get "#{root}topics/:id", ->
      this.trigger 'getAndShow', {target: '#contents', hash: '#contents'}
      this.trigger 'topicId'
      this.trigger 'subscribeToWS',  {id: this.params['id']}

    this.get "#{root}topics/:id/edit", ->
      this.trigger 'getAndShow', {target: 'aside'}

    this.get "#{root}topics/:id/page/:page_id", ->
      this.trigger 'getAndShow', {target: '#contents', hash: window.location.hash || '#contents'}
      this.trigger 'topicId'
      this.trigger 'subscribeToWS',  {id: this.params['id']}

    # TODO : event
    this.get "#{root}topics/:id/posts/:post_id/edit", ->
      post_id = this.params['post_id']
      $.ajax {
        type: "GET"
        , url: this.path
        , dataType: "html"
        , success: (data) ->
          if data?
            showEdit(data, post_id)
      }

    this.get "#{root}dashboard", ->
      this.trigger 'getAndShow', {target: 'aside'}

    this.get "#{root}smilies", ->
      this.trigger 'getAndShow', {target: 'aside'}

    this.get "#{root}smilies/new", ->
      this.trigger 'getAndShow', {target: 'aside'}

    this.get "#{root}users/:id", ->
      this.trigger 'getAndShow', {target: 'aside'}


    # POST
    # weird return bug here
    this.post "/topics", ->
      this.trigger 'postAndShow'
      return

    this.post '/topics/:id/posts',->
      this.trigger 'postAndAdd', { target: '#posts'}
      return

    this.post '/topics/:id/members',->
      this.trigger 'postAndAdd'
      return


    # PUT
    # TODO make only one call
    # TODO : event
    this.put "#{root}topics/:id", ->
      postAndAdd this.path, this.params
      getAndShow this.path, "#contents", "#contents"

    this.put "#{root}topics/:id/posts/:post_id", ->
      postAndReplace this.path, this.params

    this.put "#{root}users/:id", ->
      postAndShow this.path, this.params


    # DEL
    # TODO : event
    this.del "#{root}topics/:id/posts/:post_id", ->
      deletePost this.path, this.params

  $(->
    app.run(root)
  )
)(jQuery)
