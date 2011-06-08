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

    @bind 'hideLoadingNotification', ->
      $('.loading').hide()

    # routes
    #
    @get '/', ->
      Topic.all (topics)->
        new TopicsView topics
        context.trigger 'hideLoadingNotification'

    @get 'topics', ->
      Topic.all (topics)->
        new TopicsSideView topics, $('.aside aside')
        context.trigger 'hideLoadingNotification'

    @get 'topics/new', ->
      new TopicNewView
      context.trigger 'hideLoadingNotification'

    @get 'topics/:id', ->
      Topic.find @params.id, (topic)->
        new TopicView topic
        context.trigger 'hideLoadingNotification'

    @get 'topics/:id/edit', ->
      console.log 'TODO'
      context.trigger 'hideLoadingNotification'

    @get 'topics/page/:page_id', ->
      Topic.get @path, (topics) ->
        new TopicsView topics
        context.trigger 'hideLoadingNotification'

    @get 'topics/:id/page/:page_id', ->
      Topic.get @path, (topic) ->
        new TopicView topic
        context.trigger 'hideLoadingNotification'

    @get 'topics/:id/posts/:post_id/edit', ->
      console.log 'TODO'
      context.trigger 'hideLoadingNotification'

    @get 'smilies', ->
      console.log 'TODO'
      context.trigger 'hideLoadingNotification'

    @get 'smilies/new', ->
      new SmileyView
      context.trigger 'hideLoadingNotification'

    @get 'users/:id', ->
      User.find @params.id, (user) ->
        new UserView user
        context.trigger 'hideLoadingNotification'

    @get 'dashboard', ->
      console.log 'TODO'
      context.trigger 'hideLoadingNotification'

    @post 'topics', (e)->
      Topic.create @params
      context.trigger 'hideLoadingNotification'
      return

    @post '/topics/:id/posts', ->
      Post.create @params
      context.trigger 'hideLoadingNotification'
      return

    @put 'topics/:id', ->
      console.log 'TODO'
      context.trigger 'hideLoadingNotification'
      return

    @put 'topics/:id/posts/:post_id', ->
      console.log 'TODO'
      context.trigger 'hideLoadingNotification'
      return

    @del 'topics/:id/posts/:post_id', ->
      console.log 'TODO'
      context.trigger 'hideLoadingNotification'

  Blabbr.run = () ->
    $.getJSON '/users/current.json', (data) ->
      Blabbr.current_user = data
      app.run()

  $(->
    # add csrf protection on ajax request
    $.ajaxPrefilter (options, originalOptions, xhr)->
      token = $('meta[name="csrf-token"]').attr('content')
      xhr.setRequestHeader('X-CSRF-Token', token)

    Blabbr.run()
  )
)(jQuery)
