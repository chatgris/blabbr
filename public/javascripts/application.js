var titleHolder = document.title;

jQuery(function($){//on document ready
  //autocomplete
  $('input.autocomplete').each(function(){
    var $input = $(this);
    $input.autocomplete($input.attr('data-autocomplete-url'));
  });

  $('html').mouseover(function() {
    gainedFocus();
  });

  $('a[data-remote=true]')
  .live("ajax:success", function(data, status, xhr) {
    showEdit(status, this.getAttribute("message"));
  });

  $('.edit_post')
  .live("ajax:success", function(data, status, xhr) {
    var id = $(this).attr('id');
    $("#" + id).hide().html(status).show('slow');
  });

  $('.bubble p, .bubble ul')
  .live('click', function(e) {
      if (!$(e.target).is('a'))
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

function showPost(url, userID){
  $.get(url,function(data){
      if (data) {
        $(data).hide().appendTo("#posts").show('slow');
        if (userID != user_id)
        {
          notify();
        }
      }
  },'js');
}

function showEdit(status, id){
  $("#" + id).find('div').hide().html(status).show('slow');
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

