jQuery(function($){//on document ready
  //autocomplete
  $('input.autocomplete').each(function(){
    var $input = $(this);
    $input.autocomplete($input.attr('data-autocomplete-url'));
  });
});
function updatePosts(url){
  $.get(url,function(data){
      if (data) {
        $(data).hide().appendTo("#posts").show('slow');
        document.getElementById('player').play();
      }
  },'js');
}
