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
      Topic.find @params.id, (topic)->
        new TopicView topic

    @get 'topics/:id/edit', ->
      console.log 'TODO'

    @get 'topics/page/:page_id', ->
      Topic.get @path, (topics) ->
        new TopicsView topics

    @get 'topics/:id/page/:page_id', ->
      Topic.get @path, (topic) ->
        new TopicView topic

    @get 'topics/:id/posts/:post_id/edit', ->
      console.log 'TODO'

    @get 'smilies', ->
      Smiley.all (smilies)->
        new SmiliesView smilies

    @get 'smilies/new', ->
      new SmileyView

    @get 'users/:id', ->
      User.find @params.id, (user) ->
        new UserView user

    @get 'dashboard', ->
      console.log 'TODO'

    @post 'topics', (e)->
      Topic.create @params
      return

    @post '/topics/:id/posts', ->
      Post.create @params
      return

    @put 'topics/:id', ->
      console.log 'TODO'
      return

    @put 'topics/:id/posts/:post_id', ->
      console.log 'TODO'
      return

    @del 'topics/:id/posts/:post_id', ->
      console.log 'TODO'

  Blabbr.run = () ->
    $.getJSON '/users/current.json', (data) ->
      Blabbr.current_user = data
      app.run()

  $(->
    $('html').mouseover ->
      Blabbr.is_active = true

    # add csrf protection on ajax request
    $.ajaxPrefilter (options, originalOptions, xhr)->
      token = $('meta[name="csrf-token"]').attr('content')
      xhr.setRequestHeader('X-CSRF-Token', token)

    Blabbr.run()
  )
)(jQuery)
