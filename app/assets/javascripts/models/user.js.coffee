(($) ->
  window.User = Model 'user',
    @persistence Model.REST, '/users'

    @extend {
      fetch = @persistence().query
    }

)(jQuery)
