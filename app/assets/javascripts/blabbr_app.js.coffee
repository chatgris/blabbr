window.Blabbr = {}

(($) ->
  Blabbr.app = $.sammy ->

    @.get '/', ->
      topics = Topic.fetch '', (topics)->
        console.log topics

    @.get 'topics/:id', ->
      topics = Topic.fetch @params.id, (data)->
        new PostsView data[0].attributes.posts
        console.log topics

    @.get 'topics/page/:page_id', ->
      topics = Topic.fetch @params.page_id, (topics)->
        console.log topics

    @.get 'users/:id', ->
      user = User.fetch @params.id, (user)->
        new UserView user[0].attributes

  $(->
    Blabbr.app.run()
  )
)(jQuery)
