titleHolder = document.title;

$(document).ready ->
  load_current_user = () ->
    $.getJSON '/users/current.json', (data) ->
      window.current_user = data
      window.app.run()

  load_current_user()

  $('input.autocomplete').livequery ->
    $(this).each ->
      input = $(this)
      action = input.attr('data-autocomplete-url')
      input.autocomplete("#{action}.json", {
        json: true,
        minChars: 3
      })

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
    window.isActive = true

  $('.bubble p, .bubble ul').live 'click', (e) ->
    if $(e.target).is('p, ul')
      user = $(this).parent().get(0).getAttribute("data_user")
      insertQuote($(this).text(), user)

  $('#flash_notice').livequery ->
    $.blabbrNotify('success', $(this).text())
    $(this).remove()

insertQuote = (content, user) ->
  $('#post_body').val($('#post_body').val() + "bq..:" + user + " " + content + " \n\np. ");
