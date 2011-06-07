class window.Domino
  constructor: (@opts)->
    @opts.inner ||= 5
    @opts.current_page = parseInt(@opts.current_page)

  paginate: ->
    return if @opts.per_page > @opts.total_entries
    @pagination = '<ul>'
    do @set_num_pages
    do @build_pagination
    @pagination += '</ul>'

  add_page:(page)->
    @pagination += "<li><a href='#{@opts.path}#{page}\'>#{page}</li>"

  add_current_page: ->
    @pagination += "<li><a href='#{@opts.path}#{@opts.current_page}\' class='current-page'>#{@opts.current_page}</li>"

  pre_current: ->
    start = @opts.current_page - @opts.inner
    end = @opts.current_page - 1
    @add_page(page) for page in [start..end] when page > 0

  post_current: ->
    start = @opts.current_page + 1
    end = @opts.current_page + @opts.inner
    @add_page(page) for page in [start..end] when page <= @num_page

  build_pagination: ->
    do @pre_current
    do @add_current_page
    do @post_current

  set_num_pages: ->
    @num_page = Math.ceil(@opts.total_entries / @opts.per_page)
