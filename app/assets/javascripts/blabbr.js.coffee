window.Blabbr = {}

(($) ->

  app = $.sammy ->
    @use Sammy.NestedParams
    context = @

    # before and after filter
    #
    @before () ->
      @trigger 'loadingNotification'

    @after () ->
      # google analytic
      if _gaq?
        _gaq.push ['_trackPageview']
        _gaq.push ['_trackEvent', @path, @verb, 'blabbr']

    # bindings
    #
    @bind 'loadingNotification', ->
      $("#contents").append '<p class="loading"></p>'

    @bind 'notify', ->
      context.trigger 'lostFocus'
      context.trigger 'blinkTitle', 1
      if Blabbr.current_user.audio is true
        @trigger 'audioNotification'

    @bind 'lostFocus', ->
      Blabbr.is_active = false

    @bind 'blinkTitle', (e, state) ->
      unless Blabbr.is_active
        if state is 1
          document.title = "[new!] - #{Blabbr.title}"
          state = 0
        else
          document.title = Blabbr.title
          state = 1
        setTimeout ->
          context.trigger 'blinkTitle', state
        , 1600
      else
        document.title = Blabbr.title

    @bind 'audioNotification', ->
      $('body').append '<audio id="player" src="/sound.mp3" autoplay />'
      audio = $('#player')
      $(audio).bind 'ended', ->
        $(@).remove

    @bind 'subscribeToWS', (e, data) ->
      context = @
      id = data.id
      Blabbr.topic_id = id
      unless pusher.channels.channels[id]
        channel = pusher.subscribe id
        channel.bind 'new-post', (post) ->
          if post.creator_n isnt Blabbr.current_user.nickname && post.tid is Blabbr.topic_id
            new PostView post
            context.trigger 'notify'
        channel.bind 'index', (post) ->
          if $('aside .topics').length > 0
            context.redirect 'topics'
          else
            $.blabbrNotify 'success', 'New message !!!'

    # routes
    #
    @get '/', ->
      Topic.all (topics)->
        new TopicsView topics
        context.trigger 'hideLoadingNotification'

    @get 'topics', ->
      Topic.all (topics)->
        new TopicsSideView topics, $('.aside aside')

    @get 'topics/new', ->
      new TopicNewView

    @get 'topics/:id', ->
      Topic.find @params, (topic)->
        new TopicView topic
        context.trigger 'subscribeToWS',  {id: topic.topic.tid}

    @get 'topics/:id/edit', ->
      Topic.find @params, (topic)->
        new TopicEditView topic.topic

    @get 'topics/page/:page_id', ->
      Topic.get @path, (topics) ->
        new TopicsView topics

    @get 'topics/:topic_id/page/:page_id', ->
      Topic.get @path, (topic) ->
        new TopicView topic
        context.trigger 'subscribeToWS',  {id: topic.topic.tid}

    @get 'topics/:topic_id/posts/:id/edit', (e)->
      Post.get @path, (post) ->
        new PostEditView post, e

    @get 'topics/:topic_id/posts/textile', (e)->
      new TextileView

    @get 'smilies', ->
      Smiley.all (smilies)->
        new SmiliesView smilies

    @get 'smilies/new', ->
      new SmileyView

    @get 'users/:id', ->
      User.find @params, (user) ->
        new UserView user

    @get 'dashboard', ->
      new UserEditView

    @post 'topics', (e)->
      Topic.create @params
      return

    @post '/topics/:topic_id/posts', ->
      Post.create @params
      return

    @put 'topics/:id', ->
      Topic.update @params
      return

    @put 'topics/:topic_id/posts/:id', ->
      Post.update @params
      return

    @put 'topics/:topic_id/posts/:id/publish', ->
      Post.put @path, @params
      return

    @del 'topics/:topic_id/posts/:id', ->
      Post.destroy @params
      return

  Blabbr.run = () ->
    $.getJSON '/users/current.json', (user) ->
      Blabbr.current_user = user
      app.run()

  $(->
    notice = $('#flash_notice')
    $.blabbrNotify 'success', notice.text() if notice.text()
    notice.remove()

    $('html').mouseenter ->
      Blabbr.is_active = true

    # global error callback
    $("#notify").ajaxError ->
      $.blabbrNotify 'fail', 'Oups, something went wrong'
      $('.loading').hide()

    # add csrf protection on ajax request
    $.ajaxPrefilter (options, originalOptions, xhr)->
      token = $('meta[name="csrf-token"]').attr('content')
      xhr.setRequestHeader('X-CSRF-Token', token)

    Blabbr.run()
  )
)(jQuery)
