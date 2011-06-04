window.Blabbr = {}

(($) ->

  app = $.sammy ->
    @use Sammy.NestedParams

    @get '/', ->
      do Topic.all (topics)->
        new TopicsView topics

    @get 'topics/new', ->
      new TopicNewView

    @get 'topics/:id', ->
      Topic.find @params.id, (topic)->
        new TopicView topic

    @get 'topics/page/:page_id', ->
      topics = Topic.fetch @params.page_id, (topics)->
        console.log topics

    @get 'users/:id', ->
      User.find @params.id, (user) ->
        new UserView user

    @post 'topics', (e)->
      Topic.create @params

    @post '/topics/:id/posts', ->
      Post.create @params

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
