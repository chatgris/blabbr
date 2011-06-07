/*!
 * jQuery.sexyPost v1.0.1
 * http://github.com/jurisgalang/jquery-sexypost
 *
 * Copyright 2010, Juris Galang
 * Dual licensed under the MIT or GPL Version 2 licenses.
 *
 * Date: Sat June 26 14:20:01 2010 -0800
 */
(function($){$.fn.sexyPost=function(options){var events=["onstart","onprogress","oncomplete","onerror","onabort","onfilestart","onfilecomplete"];var config={async:true,autoclear:false,onstart:function(event){},onprogress:function(event,completed,loaded,total){},oncomplete:function(event,responseText){},onerror:function(event){},onabort:function(event){}};if(options)$.extend(config,options);this.each(function(){for(event in events){if(config[events[event]]){$(this).bind("sexyPost."+events[event],config[events[event]]);}}
var form=$(this);form.submit(function(){var action=$(this).attr("action");var method=$(this).attr("method");send(this,action,method,config.async);return false;});$(".submit-trigger",form).not(":button").bind("change",function(){form.trigger("submit");});$(".submit-trigger",form).not(":input").bind("click",function(){form.trigger("submit");});var xhr=new XMLHttpRequest();xhr.onloadstart=function(event){form.trigger("sexyPost.onstart");}
xhr.onload=function(event){if(config.autoclear&&(xhr.status>=200)&&(xhr.status<=204))clearFields(form);form.trigger("sexyPost.oncomplete",[xhr.responseText]);}
xhr.onerror=function(event){form.trigger("sexyPost.onerror");}
xhr.onabort=function(event){form.trigger("sexyPost.onabort");}
xhr.upload["onprogress"]=function(event){var completed=event.loaded/event.total;form.trigger("sexyPost.onprogress",[completed,event.loaded,event.total]);}
function clearFields(form){$(":input",form).not(":button, :submit, :reset, :hidden").removeAttr("checked").removeAttr("selected").val("");}
function send(form,action,method,async){var data=new FormData();$("input:text, input:hidden, input:password, textarea",form).each(function(){data.append($(this).attr("name"),$(this).val());});$("input:file",form).each(function(){var files=this.files;for(i=0;i<files.length;i++)data.append($(this).attr("name"),files[i]);});$("select option:selected",form).each(function(){data.append($(this).parent().attr("name"),$(this).val());});$("input:checked",form).each(function(){data.append($(this).attr("name"),$(this).val());});xhr.open(method,action,async);xhr.setRequestHeader("Cache-Control","no-cache");xhr.setRequestHeader("X-Requested-With","XMLHttpRequest");xhr.send(data);}});return this;}})(jQuery);
