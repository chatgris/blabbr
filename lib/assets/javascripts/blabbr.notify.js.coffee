(($) ->
  $.blabbrNotify = (type, message)->
    setTimeout ->
      $('#notify').children().hide('slow').remove()
    , 5000
    $('#notify').append('<p class="'+type+'">'+message+'</p>')
)(jQuery)
