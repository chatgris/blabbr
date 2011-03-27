titleHolder = document.title;

$(document).ready ->

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

  $('.bubble p, .bubble ul').live 'click', (e) ->
    if $(e.target).is('p, ul')
      user = $(this).parent().get(0).getAttribute("data_user")
      insertQuote($(this).text(), user)

  $('#flash_notice').livequery ->
    $.blabbrNotify('success', $(this).text())
    $(this).remove()

insertQuote = (content, user) ->
  $('#post_body').val($('#post_body').val() + "bq..:" + user + " " + content + " \n\np. ");


showEdit = (data, id) ->
  $("#" + id).find('.bubble').html(data)
  hideLoadingNotification()

deletePost = (path, params) ->
  $.ajax {
      type: "DELETE",
      url: path,
      data: $.param(params.toHash()),
      dataType: "html",
      success: (msg) ->
          replaceContent(msg, params['post_id']);
          $('#edit_post_'+params['post_id']).remove()
  }

postAndReplace = (path, params) ->
  $.ajax {
      type: "POST",
      url: path,
      dataType: "html",
      data: $.param(params.toHash()),
      success: (msg) ->
          replaceContent(msg, params['post_id'])
  }

replaceContent = (data, id) ->
  $("#"+id+" .bubble").html(data)
  hideLoadingNotification()


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
