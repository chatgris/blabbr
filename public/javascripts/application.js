/* DO NOT MODIFY. This file was compiled Sun, 27 Mar 2011 19:12:53 GMT from
 * /home/chatgris/dev/blabbr/app/coffeescripts/application.coffee
 */

(function() {
  var titleHolder;
  titleHolder = document.title;
  $(document).ready(function() {
    var addContent, blinkTitle, deletePost, gainedFocus, insertQuote, lostFocus, postAndAdd, postAndReplace, postAndShow, replaceContent, showEdit;
    $('input.autocomplete').livequery(function() {
      return $(this).each(function() {
        var input;
        input = $(this);
        return input.autocomplete(input.attr('data-autocomplete-url'));
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
      return gainedFocus();
    });
    $('.bubble p, .bubble ul').live('click', function(e) {
      var user;
      if ($(e.target).is('p, ul')) {
        user = $(this).parent().get(0).getAttribute("data_user");
        return insertQuote($(this).text(), user);
      }
    });
    $('#flash_notice').livequery(function() {
      $.blabbrNotify('success', $(this).text());
      return $(this).remove();
    });
    insertQuote = function(content, user) {
      return $('#post_body').val($('#post_body').val() + "bq..:" + user + " " + content + " \n\np. ");
    };
    postAndAdd = function(path, params, id) {
      return $.ajax({
        type: "POST",
        url: path,
        dataType: "html",
        data: $.param(params.toHash()),
        success: function(msg) {
          return addContent(msg, id);
        }
      });
    };
    showEdit = function(data, id) {
      $("#" + id).find('.bubble').html(data);
      return hideLoadingNotification();
    };
    deletePost = function(path, params) {
      return $.ajax({
        type: "DELETE",
        url: path,
        data: $.param(params.toHash()),
        dataType: "html",
        success: function(msg) {
          replaceContent(msg, params['post_id']);
          return $('#edit_post_' + params['post_id']).remove();
        }
      });
    };
    postAndShow = function(path, params) {
      return $.ajax({
        type: "POST",
        url: path,
        dataType: "html",
        data: $.param(params.toHash()),
        success: function(msg) {
          return showContent(msg, "#contents");
        }
      });
    };
    postAndReplace = function(path, params) {
      return $.ajax({
        type: "POST",
        url: path,
        dataType: "html",
        data: $.param(params.toHash()),
        success: function(msg) {
          return replaceContent(msg, params['post_id']);
        }
      });
    };
    replaceContent = function(data, id) {
      $("#" + id + " .bubble").html(data);
      return hideLoadingNotification();
    };
    addContent = function(data, id) {
      id = id || "#contents";
      return $(id).append(data);
    };
    blinkTitle = function(state) {
      if (windowIsActive !== true) {
        if (state === 1) {
          document.title = "[new!] - " + titleHolder;
          state = 0;
        } else {
          document.title = titleHolder;
          state = 1;
        }
        return setTimeout("blinkTitle(" + state + ")", 1600);
      } else {
        return document.title = titleHolder;
      }
    };
    lostFocus = function() {
      var windowIsActive;
      return windowIsActive = false;
    };
    return gainedFocus = function() {
      var windowIsActive;
      return windowIsActive = true;
    };
  });
}).call(this);
