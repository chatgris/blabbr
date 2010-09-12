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

});

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

function showPost(url){
  $.get(url,function(data){
      if (data) {
        $(data).hide().appendTo("#posts").show('slow');
        lostFocus();
        blinkTitle(1);
        document.getElementById('player').play();
      }
  },'js');
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

