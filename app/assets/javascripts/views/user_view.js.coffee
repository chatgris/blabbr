(($) ->
  class window.CommonView

    update_title: (title) ->
      $("#page-title").html title
      document.title = "Blabbr - #{title}"

    move_to: (hash) ->
      hash = window.location.hash || hash
      selector = $(hash)
      selector.addClass('anchor')
      $('html,body').animate({scrollTop: selector.offset().top},'slow')

    show_errors: (selector, errors)->
      selector.html('')
      selector.append "<dt>#{key} :</dt><dd>#{error[0]}</dd>" for key, error of errors

    clear_selector: ->
      @selector.html('')

    get_token: ->
      $('meta[name="csrf-token"]').attr('content')

  class window.SmileyView extends CommonView
    constructor: ->
      @selector = $('.aside aside')
      do @yield

    template: ->
      ich.smiley_new {token: @get_token()}

    yield: ->
      context = @
      @selector.html @template()
      @selector.find('form').sexyPost {
        accept: 'application/json',
        autoclear: true,
        progress: (event, completed, loaded, total) ->
          $(this).siblings('meter:first').attr('value',(completed *100).toFixed(2))
        , complete: (event, responseText, status) ->
          if status is 201
            $.blabbrNotify 'success', 'Smiley added !'
            context.selector.find('.errors').html ''
          else if status is 422
            context.show_errors context.selector.find('.errors'), $.parseJSON(responseText)
      }

  class window.UserView extends CommonView
    constructor: (@user) ->
      @selector = $('.aside aside')
      do @yield

    template: ->
      ich.user @user

    yield: ->
      @selector.html @template()

   class window.TopicView extends CommonView
    constructor: (@topic)->
      @selector = $('#contents')
      do @yield

    template: (topic)->
      ich.topic topic

    paginate: (selector)->
      new Domino {
        current_page: @topic.current_page,
        per_page: @topic.per_page,
        total_entries: @topic.total_entries,
        path: "#{@topic.topic.path}/page/"
      }, (pagination)->
        selector.append pagination

    yield: ->
      # TODO: use promises or defer
      @selector.html @template(@topic)
      @update_title @topic.topic.title
      new PostView(topic) for topic in @topic.posts
      @paginate @selector.find('.pagination')
      new PostNewView @topic.topic
      @move_to @selector.get(0)

    insertQuote: (e)->
      if $(e.target).is('p, ul')
        console.log e

    events: ->
      @selector.find('.bubble p, .bubble ul').bind 'click', @insertQuote

  class window.PostNewView
    constructor: (@topic)->
      @selector = $('#new_post')
      do @yield

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
      do @clear_selector
      do @yield

    template: ->
      ich.topic_new

    yield: ->
      @selector.append @template

  class window.TopicsView extends CommonView
    constructor: (@topics, @selector = $('#contents')) ->
      do @clear_selector
      do @yield

    member: (members)->
      member = (member for member in members when member.nickname == Blabbr.current_user.nickname)
      member[0].hash = 'new_post' if member[0].unread == 0
      member[0]

    template: ->
      ich.topics

    template_item: (topic)->
      topic.member = @member(topic.members)
      ich.topic_item topic

    paginate: (selector)->
      new Domino {
        current_page: @topics.current_page,
        per_page: @topics.per_page,
        total_entries: @topics.total_entries,
        path: '/topics/page/'
      }, (pagination)->
        selector.find('.pagination').append pagination

    yield: ->
      @selector.append @template
      @selector.find('.topics').append @template_item(topic) for topic in @topics.topics
      @paginate @selector
      @update_title 'Topics'

  class window.TopicsSideView extends TopicsView
    yield: ->
      @selector.append '<section class="topics"></section>'
      @selector.find('section').append @template_item(topic) for topic in @topics.topics

  class window.SmiliesView extends CommonView
    constructor: (@smilies) ->
      @selector = $('.aside aside')
      do @yield
      do @events

    template_item: (smiley)->
      ich.smiley_item smiley

    insert_smiley: (e)->
      code = $(e.currentTarget).attr('alt')
      $('#post_body').val($('#post_body').val() + code)

    yield: ->
      @selector.html @template_item(smiley) for smiley in @smilies

    events: ->
      console.log @selector.find('li')
      @selector.find('img').bind 'click', @insert_smiley


)(jQuery)
