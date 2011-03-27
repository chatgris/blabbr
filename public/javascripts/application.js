var titleHolder = document.title;

jQuery(function($){


    $('input.autocomplete').livequery(function()
    {
        $(this).each(function()
        {
            var $input = $(this);
            $input.autocomplete($input.attr('data-autocomplete-url'));
        });
    });

    $("#new_smiley").livequery(function()
    {
        $(this).sexyPost({
            onprogress: function(event, completed, loaded, total) {
              $("#status").text("Uploading: " + (completed * 100).toFixed(2) + "% complete...");
            },
            oncomplete: function(event, responseText) {
              $("#status").text("Upload complete.");
            }
        });
    });

    if (!history.pushState)
    {
        $("a[href^=/][class!='no-ajax']").livequery(function()
        {
            var href= $(this).attr('href');
            $(this).attr('href', '#'+href.replace('#', '/'));
        });
    }

    $(".simple_form.user").livequery(function()
    {
        $(this).sexyPost({
            onprogress: function(event, completed, loaded, total) {
              $("#status").text("Uploading: " + (completed * 100).toFixed(2) + "% complete...");
            },
            oncomplete: function(event, responseText) {
              $("#status").text("Upload complete.");
            }
        });
    });

    $('html').mouseover(function()
    {
        gainedFocus();
    });

    $('.bubble p, .bubble ul')
    .live('click', function(e) {
        if ($(e.target).is('p, ul'))
        {
          var user = $(this).parent().get(0).getAttribute("data_user");
          insertQuote($(this).text(), user)
        }
    });

    $('#flash_notice').livequery(function()
    {
        $.blabbrNotify('success', $(this).text());
        $(this).remove();
    });

});

function insertQuote(content, user) {
    $('#post_body').val($('#post_body').val() + "bq..:" + user + " " + content + " \n\np. ");
}

function ajaxPath(path) {
    return (history.pushState) ? '/'+path.substr(1)+'.js' :  path.substr(1)+'.js';
}

function postAndAdd(path, params, id) {
    $.ajax({
        type: "POST",
        url: path,
        dataType: "html",
        data: $.param(params.toHash()),
        success: function(msg){
            addContent(msg, id)
        }
    });
}

function showEdit(data, id){
    $("#" + id).find('.bubble').html(data);
    hideLoadingNotification()
}

function deletePost(path, params) {
    $.ajax({
        type: "DELETE",
        url: path,
        data: $.param(params.toHash()),
        dataType: "html",
        success: function(msg){
            replaceContent(msg, params['post_id']);
            $('#edit_post_'+params['post_id']).remove()
        }
    });
}

function postAndShow(path, params) {
    $.ajax({
        type: "POST",
        url: path,
        dataType: "html",
        data: $.param(params.toHash()),
        success: function(msg){
            showContent(msg, "#contents")
        }
    });
}

function postAndReplace(path, params) {
    $.ajax({
        type: "POST",
        url: path,
        dataType: "html",
        data: $.param(params.toHash()),
        success: function(msg){
            replaceContent(msg, params['post_id'])
        }
    });
}

function replaceContent(data, id){
    $("#"+id+" .bubble").html(data);
    hideLoadingNotification()
}

function addContent(data, id){
    var id = id || "#contents";
    $(id).append(data);
}

function blinkTitle(state) {
    if (windowIsActive != true) {
      if (state == 1) {
        document.title = "[new!] - " + titleHolder;
        state = 0;
      } else {
        document.title = "" + titleHolder;
        state = 1;
      }

      setTimeout("blinkTitle(" + state + ")", 1600);
    } else {
      document.title = titleHolder;
    }
}

function lostFocus() {
    windowIsActive = false;
}

function gainedFocus() {
    windowIsActive = true;
}
