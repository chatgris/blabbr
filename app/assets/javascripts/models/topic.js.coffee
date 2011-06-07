class Model
  @xhr: (method = 'GET', path, callback, data = '')->
    $.ajax {
      type: method,
      url: path,
      contentType: "application/json",
      dataType: "json",
      data: data,
      complete: (xhr, textStatus) ->
        callback $.parseJSON(xhr.responseText)
    }
    return

  @find: (id, callback)->
    path = "#{@persistence}/#{id}"
    @xhr 'GET', path, callback

  @all: (callback)->
    @xhr 'GET', @persistence, callback

  @get: (path, callback)->
    @xhr 'GET', path, callback

  @create: (data) ->
    if @params
      path = @persistence.replace(param, data[param]) for param in @params when param in @params
    else
      path = @persistence
    @xhr 'POST', path, @after_create, JSON.stringify data

(($) ->
  class window.User extends Model
    @persistence: '/users'

  class window.Post extends Model
    @persistence: '/topics/id/posts'
    @params: ['id']

    @after_create: (post) ->
      new PostView post
      $('#new_post textarea').text('')

  class window.Topic extends Model
    @persistence: '/topics'

    @after_create: (topic)->
      new TopicView topic
      $('aside form')[0].reset()

)(jQuery)
