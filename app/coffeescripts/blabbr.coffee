current_user =
  audio: $.cookie('audio')
  user_nickname: $.cookie('user_nickname'),
  topic_id: null,

root = if history.pushState then "/" else "#/"

(($) ->
  app = $.sammy ->

    context = this

    # before and after filter
    #
    this.before () ->
      this.trigger 'loadingNotification'
      context.path = if history.pushState then "/#{this.path.substr(1)}.js" else "#{this.path.substr(1)}.js"
      context.params = this.params

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
      path = infos.path || context.path
      $.ajax {
        type: "GET"
        , url: path
        , dataType: "html"
        , success: (data) ->
          if data?
            context.trigger 'showContent', {data: data, target: infos.target}
            if infos.hash?
              context.trigger 'moveTo', {hash: infos.hash}
          context.trigger 'hideLoadingNotification'

      }

    # TODO : return html rather than js
    this.bind 'postAndShow', ->
      $.ajax {
        type: "POST",
        url: context.path,
        dataType: "html",
        data: $.param(context.params.toHash()),
        success: (msg) ->
          context.trigger 'showContent', {data: msg, target: "#contents"}
      }

    this.bind 'postAndReplace', ->
      target = "##{context.params['post_id']} .bubble"
      $.ajax {
        type: "POST",
        url: context.path,
        dataType: "html",
        data: $.param(context.params.toHash()),
        success: (msg) ->
          context.trigger 'replaceContent', {data: msg, target: target}
          context.trigger 'hideLoadingNotification'
      }

    this.bind 'postAndAdd', (e, infos) ->
      $.ajax {
        type: "POST",
        url: context.path,
        dataType: "html",
        data: $.param(context.params.toHash()),
        success: (msg) ->
          context.trigger 'addContent', {data: msg, target: infos.target}
          context.trigger 'moveTo', {hash: infos.hash || infos.target}
          context.trigger 'hideLoadingNotification'
      }

    this.bind 'getAndReplace', (e, infos) ->
      target = "##{context.params['post_id']} .bubble"
      $.ajax {
        type: "GET"
        , url: this.path
        , dataType: "html"
        , success: (data) ->
          if data?
            context.trigger 'replaceContent', {data: data, target: target}
            context.trigger 'hideLoadingNotification'
      }


    this.bind 'showPost', (e, data) ->
      $.ajax {
        type: "GET"
        , url: data.path
        , dataType: "html"
        , success: (data) ->
          if data?
            $(data).hide().appendTo("#posts").show('slow')
            context.trigger 'notify'

      }

    this.bind 'deletePost', ->
      target = "##{context.params['post_id']} .bubble"
      $.ajax {
        type: "DELETE",
        url: context.path,
        data: $.param(context.params.toHash()),
        dataType: "html",
        success: (data) ->
          context.trigger 'replaceContent', {data: data, target: target}
          $("#edit_post_#{context.params['post_id']}").remove()
          context.trigger 'hideLoadingNotification'
      }

    this.bind 'showContent', (e, data) ->
      $(data.target).show().html data.data
      this.trigger 'updateTitle'

    this.bind 'addContent', (e, data) ->
      id = data.target || "#contents"
      $(id).append(data.data)

    this.bind 'replaceContent', (e, data) ->
      $(data.target).html(data.data)

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
      unless pusher.channels.channels[id]
        channel = pusher.subscribe id
        channel.bind 'new-post', (data) ->
          url = "/topics/#{id}/posts/#{data.id}.js"
          if data.user_nickname != current_user.user_nickname && id == current_user.topic_id
            context.trigger 'showPost', {path: url, user_id: data.user_id}
        channel.bind 'index', (data) ->
          if $('aside #topics').length?
            context.trigger 'getAndShow', {path: '/topics.js', target: "aside"}

    this.bind 'topicId', ->
      current_user.topic_id = this.params['id']

    # routes
    #
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

    this.get "#{root}topics/:id/posts/:post_id/edit", ->
      this.trigger 'getAndReplace', {target: this.params['post_id']}

    this.get "#{root}dashboard", ->
      this.trigger 'getAndShow', {target: 'aside'}

    this.get "#{root}smilies", ->
      this.trigger 'getAndShow', {target: 'aside'}

    this.get "#{root}smilies/new", ->
      this.trigger 'getAndShow', {target: 'aside'}

    this.get "#{root}users/:id", ->
      this.trigger 'getAndShow', {target: 'aside'}

    this.post "/topics", ->
      this.trigger 'postAndShow'
      return

    this.post '/topics/:id/posts',->
      this.trigger 'postAndAdd', { target: '#posts', hash:'#new_post'}
      return

    this.post '/topics/:id/members',->
      this.trigger 'postAndAdd'
      return

    this.put "#{root}topics/:id", (context) ->
      this.trigger 'postAndAdd', {target: '#contents'}
      return

    this.put "#{root}topics/:id/posts/:post_id", ->
      this.trigger 'postAndReplace'
      return

    this.del "#{root}topics/:id/posts/:post_id", ->
      this.trigger 'deletePost'
      return

  $(->
    app.run(root)
  )
)(jQuery)
