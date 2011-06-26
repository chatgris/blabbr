(($) ->
  class window.CommonView
    constructor: ->
      do @yield
      do @events
      do @hide_loading_notification

    update_title: (title) ->
      $("#page-title").html title
      document.title = "Blabbr - #{title}"

    move_to: (hash) ->
      hash = window.location.hash || hash
      selector = $(hash)
      selector.addClass('anchor')
      $('html,body').animate({scrollTop: selector.offset().top},'slow')

    expand_text_area: (e)->
      $(e.currentTarget).css('height', '100px')

    show_errors: (selector, errors)->
      selector.html('')
      selector.append "<dt>#{key} :</dt><dd>#{error[0]}</dd>" for key, error of errors

    hide_loading_notification: ->
      $('.loading').hide()

    get_token: ->
      $('meta[name="csrf-token"]').attr('content')

    member: (members)->
      member = (member for member in members when member.nickname == Blabbr.current_user.nickname)
      member[0].hash = if member[0].unread == 0 then 'new_post' else "p#{member[0].hash}"
      member[0]

    events: ->
      # do nothing, placeholder method

  class window.SmileyView extends CommonView
    constructor: ->
      @selector = $('.aside aside')
      super

    template: ->
      ich.smiley_new {token: @get_token()}

    yield: ->
      context = @
      @selector.html @template()
      @selector.find('form').sexyPost {
        accept: 'application/json',
        autoclear: true,
        progress: (event, completed, loaded, total) ->
          $(this).find('progress:first').attr('value',(completed *100).toFixed(2))
        , complete: (event, responseText, status) ->
          if status is 201
            $.blabbrNotify 'success', 'Smiley added !'
            context.selector.find('.errors').html ''
            $(this).find('progress:first').attr('value',0)
          else if status is 422
            context.show_errors context.selector.find('.errors'), $.parseJSON(responseText)
      }

  class window.UserView extends CommonView
    constructor: (@user) ->
      @selector = $('.aside aside')
      super

    template: ->
      ich.user @user

    yield: ->
      @selector.html @template()

  class window.UserEditView extends CommonView
    constructor: ->
      @user = Blabbr.current_user
      @selector = $('.aside aside')
      super

    template: ->
      @user.token = @get_token
      ich.user_edit @user

    yield: ->
      @selector.html @template()
      @selector.find("option[value=#{@user.time_zone}]").attr('selected', 'selected')
      @selector.find(":radio[value=#{@user.audio}]").attr('checked', 'checked')
      context = @
      @selector.find('form').sexyPost {
        accept: 'application/json',
        autoclear: true,
        progress: (event, completed, loaded, total) ->
          $(this).find('meter:first').attr('value',(completed *100).toFixed(2))
        , complete: (event, responseText, status) ->
          if status is 200
            $.blabbrNotify 'success', 'Account updated !'
            context.selector.html ''
            Blabbr.current_user = $.parseJSON(responseText)
          else if status is 422
            context.show_errors context.selector.find('.errors'), $.parseJSON(responseText)
      }

  class window.TopicInfoView extends CommonView
    constructor: (@topic)->
      @selector = $('.topic-info')
      super

    template: ->
      @topic.member_posts_count = @member(@topic.members).posts_count
      @topic.is_creator = @topic.creator == Blabbr.current_user.nickname
      ich.topic_info @topic

    yield: ->
      @selector.html @template()
      @update_title @topic.title

  class window.TopicView extends CommonView
    constructor: (@topic)->
      @selector = $('#contents')
      super

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
      @selector.html @template(@topic.topic)
      new TopicInfoView @topic.topic
      new PostView(post) for post in @topic.posts
      @paginate @selector.find('.pagination')
      new PostNewView @topic.topic
      @move_to @selector.get(0)


  class window.TextileView extends CommonView
    constructor: ->
      @selector = $('.aside aside')
      super

    template: ->
      ich.textile

    yield: ->
      @selector.html @template

  class window.PostNewView extends CommonView
    constructor: (@topic)->
      @selector = $('#new_post')
      super

    template: (topic)->
      ich.post_new topic

    events: ->
      @selector.find('textarea').bind 'focus', @expand_text_area

    yield: ->
      @selector.append @template(@topic)

  class window.PostView extends CommonView
    constructor: (@post, @topic) ->
      @selector = $('#posts')
      @post_id = "'#p#{@post.pid}'"
      @post.current = @post.creator_n == Blabbr.current_user.nickname
      @post.published = @post.state == 'published'
      @post.deleted = @post.state == 'deleted'
      super

    template: (post)->
      ich.post post

    quoter: (e)->
      $(e.currentTarget).append('<span id="quote"></span>')

    unquoter: (e)->
      $(e.currentTarget).find("#quote").remove()

    insert_quote: (e)->
      if $(e.target).is('#quote')
        content = $(e.currentTarget).text()
        user = $(e.currentTarget).parents('article:first').find('.user').text()
        $('#post_body').val($('#post_body').val() + "bq..:" + user + " " + content + " \n\np. ")

    events: ->
      @selector.find("#{@post_id} .bubble p, #{@post_id} .bubble ul").bind 'mouseenter', @quoter
      @selector.find("#{@post_id} .bubble p, #{@post_id} .bubble ul").bind 'mouseleave', @unquoter
      @selector.find("#{@post_id} .bubble p, #{@post_id} .bubble ul").bind 'click', @insert_quote

    yield: ->
      @selector.append @template(@post)

  class window.PostEditedView extends CommonView
    constructor: (@post)->
      @selector = $("#p#{@post.pid}")
      @post.current = @post.creator_n == Blabbr.current_user.nickname
      @post.published = @post.state == 'published'
      @post.deleted = @post.state == 'deleted'
      super

    template: (post)->
      ich.post post

    yield: ->
      @selector.replaceWith @template(@post)

  class window.PostEditView extends CommonView
    constructor: (@post) ->
      @selector = $("#p#{@post.pid}")
      super

    template: ->
      ich.post_edit @post

    events: ->
      @selector.find('textarea').bind 'focus', @expand_text_area

    yield: ->
      @selector.find('.bubble').html @template()

  class window.TopicNewView extends CommonView
    constructor: ->
      @selector = $('.aside aside')
      super

    template: ->
      ich.topic_new

    events: ->
      @selector.find('textarea').bind 'focus', @expand_text_area

    yield: ->
      @selector.html @template

  class window.TopicEditView extends CommonView
    constructor: (@topic)->
      @selector = $('.aside aside')
      super

    template: ->
      @topic.members_list = ("#{member.nickname}," for member in @topic.members)
      ich.topic_edit @topic

    yield: ->
      @selector.html @template()
      @selector.find('#members_list').tagsInput {
          defaultText: 'add a member',
          unique: true,
          autocomplete_url:'/users/autocomplete.json',
          autocomplete: {json: true}
      }

  class window.TopicsView extends CommonView
    constructor: (@topics, @selector = $('#contents')) ->
      super

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
      @selector.html @template
      @selector.find('.topics').append @template_item(topic) for topic in @topics.topics
      @paginate @selector
      @update_title 'Topics'

  class window.TopicsSideView extends TopicsView
    constructor: ->
      super

    yield: ->
      @selector.html '<section class="topics"><h2>Topics</h2></section>'
      @selector.find('section').append @template_item(topic) for topic in @topics.topics

  class window.SmiliesView extends CommonView
    constructor: (@smilies) ->
      @selector = $('.aside aside')
      super

    template_item: (smiley)->
      ich.smiley_item smiley

    insert_smiley: (e)->
      code = $(e.currentTarget).attr('alt')
      $('#post_body').val($('#post_body').val() + code)

    yield: ->
      @selector.html '<h2>Smilies</h2>'
      content = (@template_item(smiley).get(0) for smiley in @smilies)
      @selector.append content

    events: ->
      @selector.find('img').bind 'click', @insert_smiley


)(jQuery)
