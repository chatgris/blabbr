(($) ->
  window.User = Model 'user', ->
    @.persistence Model.REST, '/users'

    @.extend {
      fetch: (id, callback)->
        @persistence().query(id, callback)
    }

  window.Topic = Model 'topic', ->
    @.persistence Model.REST, '/topics'

    @.extend {
      fetch: (id, callback)->
        @persistence().query(id, callback)
    }

)(jQuery)
