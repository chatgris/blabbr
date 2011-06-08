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
          document.title = "[new!] - #{context.title}"
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

  $(->
    #app.run()
  )
)(jQuery)
