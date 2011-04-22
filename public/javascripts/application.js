/* DO NOT MODIFY. This file was compiled Fri, 22 Apr 2011 18:03:11 GMT from
 * /home/chatgris/dev/blabbr/app/coffeescripts/application.coffee
 */

(function() {
  var insertQuote, titleHolder;
  titleHolder = document.title;
  $(document).ready(function() {
    $('input.autocomplete').livequery(function() {
      return $(this).each(function() {
        var action, input;
        input = $(this);
        action = input.attr('data-autocomplete-url');
        return input.autocomplete("" + action + ".json", {
          json: true,
          minChars: 3
        });
      });
    });
    $("#new_smiley").livequery(function() {
      return $(this).sexyPost({
        onprogress: function(event, completed, loaded, total) {
          return $("#status").text("Uploading: " + ((completed * 100).toFixed(2)) + "% complete...");
        },
        oncomplete: function(event, responseText) {
          return $("#status").text("Upload complete.");
        }
      });
    });
    if (!history.pushState) {
      $("a[href^=/][class!='no-ajax']").livequery(function() {
        var href;
        href = $(this).attr('href');
        return $(this).attr('href', "#" + (href.replace('#', '/')));
      });
    }
    $(".simple_form.user").livequery(function() {
      return $(this).sexyPost({
        onprogress: function(event, completed, loaded, total) {
          return $("#status").text("Uploading: " + ((completed * 100).toFixed(2)) + "% complete...");
        },
        oncomplete: function(event, responseText) {
          return $("#status").text("Upload complete.");
        }
      });
    });
    $('html').mouseover(function() {
      return window.isActive = true;
    });
    $('.bubble p, .bubble ul').live('click', function(e) {
      var user;
      if ($(e.target).is('p, ul')) {
        user = $(this).parent().get(0).getAttribute("data_user");
        return insertQuote($(this).text(), user);
      }
    });
    return $('#flash_notice').livequery(function() {
      $.blabbrNotify('success', $(this).text());
      return $(this).remove();
    });
  });
  insertQuote = function(content, user) {
    return $('#post_body').val($('#post_body').val() + "bq..:" + user + " " + content + " \n\np. ");
  };
}).call(this);
