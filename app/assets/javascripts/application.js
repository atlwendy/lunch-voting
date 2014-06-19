//= require jquery
//= require jquery_ujs
//= require jquery.datetimepicker
//= require bootstrap
//= require turbolinks
//= require_tree .

$(function(){
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()
})