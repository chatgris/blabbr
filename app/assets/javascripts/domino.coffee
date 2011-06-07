class window.Domino
  constructor: (@opts)->
    @opts.inner ||= 3
    @opts.outer ||= 3
    @opts.separator ||= '...'
    @opts.current_page = parseInt(@opts.current_page)

  paginate: ->
    return if @opts.per_page > @opts.total_entries
    @pagination = '<ul>'
    do @set_num_pages
    do @build_pagination
    @pagination += '</ul>'

  add_page:(page, css)->
    @pagination += "<li><a href='#{@opts.path}#{page}\' class='#{css}'>#{page}</li>"

  add_separator: ->
    @pagination += "<li>#{@opts.separator}</li>"

  add_current_page: ->
    @add_page(@opts.current_page, 'current')

  pre_current: ->
    start = @opts.current_page - @opts.inner
    end = @opts.current_page - 1
    @add_page(page, 'inner') for page in [start..end] when page > 0

  post_current: ->
    start = @opts.current_page + 1
    end = @opts.current_page + @opts.inner
    @add_page(page, 'inner') for page in [start..end] when page <= @num_page

  outer_start: ->
    marker = @opts.current_page - @opts.outer
    if marker > 1
      @add_page(page, 'outer') for page in [1..@opts.outer] when page < marker
      do @add_separator

  outer_end: ->
    marker = @opts.current_page + @opts.outer
    if marker < @num_page
      start = @num_page - @opts.outer
      do @add_separator
      @add_page(page, 'outer') for page in [start..@num_page] when page > marker

  build_pagination: ->
    do @outer_start
    do @pre_current
    do @add_current_page
    do @post_current
    do @outer_end

  set_num_pages: ->
    @num_page = Math.ceil(@opts.total_entries / @opts.per_page)
