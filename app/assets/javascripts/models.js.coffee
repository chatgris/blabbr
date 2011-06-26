(($) ->
  class Model
    @xhr: (method = 'GET', path, callback, data = '')->
      $.ajax {
        type: method,
        url: path,
        contentType: "application/json",
        dataType: "json",
        data: data,
        complete: (xhr, textStatus) ->
          $.blabbrNotify 'success', xhr.getResponseHeader('X-Message-Notice') if xhr.getResponseHeader('X-Message-Notice')
          $.blabbrNotify 'fail', xhr.getResponseHeader('X-Message-Error') if xhr.getResponseHeader('X-Message-Error')
          callback $.parseJSON(xhr.responseText)
      }
      return

    @filter_path: (params)->
      if @params
        path = @persistence.replace(param, params[param]) for param in @params when param in @params
      else
        path = @persistence

    @find: (params, callback)->
      path = "#{@filter_path(params)}/#{params.id}"
      @xhr 'GET', path, callback

    @all: (callback)->
      @xhr 'GET', @persistence, callback

    @get: (path, callback)->
      @xhr 'GET', path, callback

    @put: (path, data) ->
      @xhr 'PUT', path, @after_update, JSON.stringify data

    @create: (data) ->
      @xhr 'POST', @filter_path(data), @after_create, JSON.stringify data

    @update: (data) ->
      path = "#{@filter_path(data)}/#{data.id}"
      @xhr 'PUT', path, @after_update, JSON.stringify data

    @destroy: (data) ->
      path = "#{@filter_path(data)}/#{data.id}"
      @xhr 'DELETE', path, @after_destroy, JSON.stringify data

  class window.User extends Model
    @persistence: '/users'

  class window.Post extends Model
    @persistence: '/topics/topic_id/posts'
    @params: ['topic_id']

    @after_create: (post) ->
      new PostView post
      $('#new_post form')[0].reset()
      $('#new_post textarea')[0].focus()

    @after_update: (post)->
      new PostEditedView post

    @after_destroy: (post) ->
      new PostEditedView post

  class window.Smiley extends Model
    @persistence: '/smilies'

  class window.Topic extends Model
    @persistence: '/topics'

    @after_create: (topic)->
      new TopicView topic
      $('.aside aside').html('')

    @after_update: (topic) ->
      new TopicInfoView topic
      $('.aside aside').html('')

)(jQuery)
