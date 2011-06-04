(($) ->
 class window.UserView
    constructor: (@user) ->
      @selector = $('.aside aside')
      do @yield

    template: ->
      ich.user @user

    yield: ->
      @selector.html @template()

  class window.TopicView
    constructor: (@topic)->
      @selector = $('#contents')
      do @yield

    template: (topic)->
      ich.topic topic

    clear: ->
      @selector.html('')

    yield: ->
      # TODO: use promises or defer
      @selector.append @template(@topic)
      new PostView(topic) for topic in @topic.posts
      new PostNewView @topic.topic

    insertQuote: (e)->
      if $(e.target).is('p, ul')
        console.log e

    events: ->
      @selector.find('.bubble p, .bubble ul').bind 'click', @insertQuote

  class window.PostNewView
    constructor: (@topic)->
      console.log @topic
      @selector = $('#new_post')
      do @yield

    clear: ->
      @selector.html('')

    template: (topic)->
      ich.post_new topic

    yield: ->
      @selector.append @template(@topic)

  class window.PostView
    constructor: (@post) ->
      @selector = $('#posts')
      do @yield

    template: (post)->
      ich.post post

    yield: ->
      @selector.append @template(@post)


  class window.TopicNewView
    constructor: ->
      @selector = $('.aside aside')
      do @clear
      do @yield

    clear: ->
      @selector.html('')

    template: ->
      ich.topic_new

    yield: ->
      @selector.append @template

  class window.TopicsView
    constructor: (@topics) ->
      @selector = $('#contents')
      do @clear
      do @yield

    member: (members)->
      member = (member for member in members when member.nickname == Blabbr.current_user.nickname)
      member[0].hash = 'new_post' if member[0].unread == 0
      member[0]

    template: (topic)->
      topic.member = @member(topic.members)
      ich.topic_item topic

    clear: ->
      @selector.html('')

    yield: ->
      @selector.append '<section id="topics"></section>'
      @selector.find('section').append @template(topic) for topic in @topics


)(jQuery)
