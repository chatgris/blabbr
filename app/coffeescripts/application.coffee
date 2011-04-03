titleHolder = document.title;

$(document).ready ->

  # TODO : find a better autocomplete
  $('input.autocomplete').livequery ->
    $(this).each ->
      input = $(this)
      input.autocomplete(input.attr('data-autocomplete-url'))

  $("#new_smiley").livequery ->
    $(this).sexyPost {
      onprogress: (event, completed, loaded, total) ->
        $("#status").text("Uploading: #{(completed * 100).toFixed(2)}% complete...");
      , oncomplete: (event, responseText) ->
        $("#status").text("Upload complete.")
      }

  if !history.pushState
    $("a[href^=/][class!='no-ajax']").livequery ->
      href = $(this).attr('href')
      $(this).attr 'href', "##{href.replace('#', '/')}"

  $(".simple_form.user").livequery ->
    $(this).sexyPost {
        onprogress: (event, completed, loaded, total) ->
          $("#status").text("Uploading: #{(completed * 100).toFixed(2)}% complete...")
      , oncomplete: (event, responseText) ->
        $("#status").text("Upload complete.")
      }

  $('html').mouseover ->
    gainedFocus()

  $('#contents').livequery ->
    left = $('#contents').position().left
    $('aside').css('left', left + 680)
    $('#notify').css('left', left + 680)

  $('.bubble p, .bubble ul').live 'click', (e) ->
    if $(e.target).is('p, ul')
      user = $(this).parent().get(0).getAttribute("data_user")
      insertQuote($(this).text(), user)

  $('#flash_notice').livequery ->
    $.blabbrNotify('success', $(this).text())
    $(this).remove()

insertQuote = (content, user) ->
  $('#post_body').val($('#post_body').val() + "bq..:" + user + " " + content + " \n\np. ");


blinkTitle = (state) ->
  if  windowIsActive != true
    if state == 1
      document.title = "[new!] - " + titleHolder
      state = 0
    else
      document.title = titleHolder
      state = 1

    setTimeout("blinkTitle(#{state})", 1600)
  else
    document.title = titleHolder

lostFocus = ->
  windowIsActive = false

gainedFocus = ->
    windowIsActive = true
