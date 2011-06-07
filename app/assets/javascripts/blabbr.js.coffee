(($) ->
  window.app = $.sammy ->

    context = this

    # before and after filter
    #
    @before () ->
      @trigger 'loadingNotification'
      context.path = "#{@path.split('#')[0]}.js"
      context.path_json = "#{@path.split('#')[0]}.json"
      context.params = @params
      context.title = $('title').text()

    @after () ->
      @trigger 'subscribeToWS', {id: 'index'}
      if _gaq?
        _gaq.push ['_trackPageview']
        _gaq.push ['_trackEvent', @path, @verb, 'blabbr']

    # bindings
    #
    @bind 'loadingNotification', ->
      $("#contents").append '<p class="loading"></p>'

    @bind 'hideLoadingNotification', ->
      $('.loading').hide()

    @bind 'getAndShow', (e, infos) ->
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

    @bind 'posts', (e, data) ->
      $('.page-title').html('')
      context.trigger 'addContent', {data: ich.post(post), target: '.page-title'} for post in data.posts

    @bind 'user', (e, data) ->
      context.trigger 'showContent', {data: ich.user(data), target: 'aside'}

    @bind 'getAndShowJson', (e, infos) ->
      path = infos.path || context.path
      $.ajax {
        type: "GET"
        , url: context.path_json
        , dataType: "json"
        , success: (data) ->
          if data?
            context.trigger infos.type, data
            if infos.hash?
              context.trigger 'moveTo', {hash: infos.hash}
          context.trigger 'hideLoadingNotification'

      }

    @bind 'postAndShow', ->
      $.ajax {
        type: "POST",
        url: context.path,
        dataType: "html",
        data: $.param(context.params.toHash()),
        success: (msg) ->
          context.trigger 'showContent', {data: msg, target: "#contents"}
      }

    @bind 'postAndReplace', ->
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

    @bind 'emptyAside', ->
      $('aside').html('')

    @bind 'postAndAdd', (e, infos) ->
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

    @bind 'getAndReplace', (e, infos) ->
      target = "##{context.params['post_id']} .bubble"
      $.ajax {
        type: "GET"
        , url: context.path
        , dataType: "html"
        , success: (data) ->
          if data?
            context.trigger 'replaceContent', {data: data, target: target}
            context.trigger 'hideLoadingNotification'
      }


    @bind 'showPost', (e, data) ->
      $.ajax {
        type: "GET"
        , url: data.path
        , dataType: "html"
        , success: (data) ->
          if data?
            $(data).hide().appendTo("#posts").show('slow')
            context.trigger 'notify'

      }

    @bind 'deletePost', ->
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

    @bind 'deleteMember', (e, infos) ->
      $.ajax {
        type: "DELETE",
        url: context.path,
        data: $.param(context.params.toHash()),
        dataType: "html",
        success: (data) ->
          context.trigger 'addContent', {data: data, target: infos.target}
          context.trigger 'hideLoadingNotification'
      }

    @bind 'showContent', (e, data) ->
      $(data.target).show().html data.data
      @trigger 'updateTitle'

    @bind 'addContent', (e, data) ->
      id = data.target || "#contents"
      $(id).append(data.data)

    @bind 'replaceContent', (e, data) ->
      $(data.target).html(data.data)

    @bind 'updateTitle', ->
      title = $('.page-title').attr 'title'
      $("#page-title").html title
      document.title = "Blabbr - #{title}"

    @bind 'notify', ->
      context.trigger 'lostFocus'
      context.trigger 'blinkTitle', 1
      if current_user.audio?
        @trigger 'audioNotification'

    @bind 'lostFocus', ->
      window.isActive = false

    @bind 'blinkTitle', (e, state) ->
      unless window.isActive
        if state == 1
          document.title = "[new!] - #{context.title}";
          state = 0
        else
          document.title = context.title
          state = 1
        setTimeout ->
          context.trigger 'blinkTitle', state
        , 1600
      else
        document.title = context.title

    @bind 'audioNotification', ->
      $('body').append '<audio id="player" src="/sound.mp3" autoplay />'
      audio = $('#player')
      $(audio).bind 'ended', ->
        $(@.remove

    @bind 'moveTo', (e, data) ->
      $.each [window.location.hash, data.hash], (index, value) ->
        if value?
          $(value).livequery () ->
            $(@.addClass('anchor')
            $('html,body').animate({scrollTop: $(@.offset().top},'slow')
            $(value).livequery().expire()

    @bind 'subscribeToWS', (e, data) ->
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

    @bind 'topicId', ->
      current_user.topic_id = @params['id']

    # routes
    #
    @get '/', ->
      @trigger 'getAndShow',  {target: '#contents'}

    @get 'topics', ->
      @trigger 'getAndShow',  {target: 'aside'}

    @get 'topics/new', ->
      @trigger 'getAndShow', {target: 'aside'}

    @get 'topics/page/:page_id', ->
      @trigger 'getAndShow', {target: '#contents', hash: '#contents'}

    @get 'topics/:id', ->
      @trigger 'getAndShowJson', {target: '#contents', hash: '#contents', type: 'posts'}
      @trigger 'topicId'
      @trigger 'subscribeToWS',  {id: @params['id']}

    @get 'topics/:id/edit', ->
      @trigger 'getAndShow', {target: 'aside'}

    @get 'topics/:id/page/:page_id', ->
      @trigger 'getAndShow', {target: '#contents', hash: window.location.hash || '#contents'}
      @trigger 'topicId'
      @trigger 'subscribeToWS',  {id: @params['id']}

    @get 'topics/:id/posts/:post_id/edit', ->
      @trigger 'getAndReplace', {target: @params['post_id']}

    @get 'dashboard', ->
      @trigger 'getAndShow', {target: 'aside'}

    @get 'smilies', ->
      @trigger 'getAndShow', {target: 'aside'}

    @get 'smilies/new', ->
      @trigger 'getAndShow', {target: 'aside'}

    @get 'users/:id', ->
      @trigger 'getAndShowJson', {target: 'aside', type: 'user'}

    @post '/topics', ->
      @trigger 'postAndShow'
      @trigger 'emptyAside'
      return

    @post '/topics/:id/posts',->
      @trigger 'postAndAdd', { target: '#posts', hash:'#new_post'}
      return

    @put '/topics/:id/add_member',->
      @trigger 'postAndAdd'
      return

    @put '/topics/:id/rm_member',->
      @trigger 'postAndAdd'
      return

    @put 'topics/:id', ->
      @trigger 'postAndAdd', {target: '#contents'}
      return

    @put 'topics/:id/posts/:post_id', ->
      @trigger 'postAndReplace'
      return

    @del 'topics/:id/posts/:post_id', ->
      @trigger 'deletePost'
      return

    @get 'logout', (e) ->
      window.location = e.path

  $(->
    #app.run()
  )
)(jQuery)
