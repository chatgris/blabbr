(($) ->
 class window.UserView
    constructor: (@user) ->
      @selector = $('.aside aside')
      do @yield
      do @events

    template: ->
      ich.user @user

    yield: ->
      @selector.html @template()

    show_link: (e)->
      console.log e

    events: ->
      @selector.find('a').bind 'click', @show_link

  class window.PostsView
    constructor: (@posts) ->
      @selector = $('#contents')
      do @yield
      do @events

    template: (post)->
      ich.post post

    yield: ->
      do @clear
      @selector.append @template(post) for post in @posts

    clear: ->
      @selector.html('')

    insertQuote: (e)->
      if $(e.target).is('p, ul')
        console.log e

    events: ->
      @selector.find('.bubble p, .bubble ul').bind 'click', @insertQuote

)(jQuery)
