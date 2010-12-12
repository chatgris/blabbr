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

    $('html').mouseover(function()
    {
        gainedFocus();
    });

    $("a[href^=/][class!='no-ajax']").livequery(function()
    {
        var href= $(this).attr('href');
        if (href.substr(- 3 ) == '.js')
        {
            href= href.substring(0, href.length-3);
        }
        $(this).attr('href', '#'+href.replace('#', '/'));
    });

    $('.bubble p, .bubble ul')
    .live('click', function(e) {
        if ($(e.target).is('p, ul'))
        {
          var user = $(this).parent().get(0).getAttribute("data_user");
          insertQuote($(this).text(), user)
        }
    });

});


function insertQuote(content, user) {
    $('#post_body').val($('#post_body').val() + "bq..:" + user + " " + content + " \n\np. ");
}

function updatePosts(url){
    $.get(url,function(data){
        if (data) {
          $(data).hide().appendTo("#posts").show('slow');
          lostFocus();
          blinkTitle(1);
          document.getElementById('player').play();
        }
    },'js');
}

function ajaxPath(path) {
    return path.substr(1)+'.js';
}

function showPost(url, userID){
    $.get(url,function(data){
        if (data) {
          $(data).hide().appendTo("#posts").show('slow');
          if (userID != user_id)
          {
            notify();
          }
          hideLoadingNotification();
        }
    },'js');
}

function showEdit(data, id){
    $("#" + id).find('div').html(data);
    hideLoadingNotification()
}

function showContent(data, place){
    $(place).html(data);
    hideLoadingNotification()
}

function setTitle(title) {
    $("#page-title").html(title);
    document.title = "Blabbr - " + title;
}

function replaceContent(data, id){
    $("#"+id+" .bubble").html(data);
    hideLoadingNotification()
}

function addContent(data){
    $("#contents").append(data);
    hideLoadingNotification();
}

function notify() {
    lostFocus();
    blinkTitle(1);
    audioNotification();
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

function audioNotification() {
    document.getElementById('player').play();
}

function lostFocus() {
    windowIsActive = false;
}

function gainedFocus() {
    windowIsActive = true;
}

function loadingNotification() {
    $("#contents").append('<p class="loading"></p>');
}

function hideLoadingNotification() {
    $('.loading').hide();
}

function goToByScroll(id){
    $("#"+id).livequery(function()
    {
        $(this).addClass('anchor');
        $('html,body').animate({scrollTop: $(this).offset().top},'slow');
        $("#"+id).livequery().expire();
    });
}

