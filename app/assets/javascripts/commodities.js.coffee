# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  ready()

$(document).on "page:load",->
  ready()

ready = ->
  $("#dms_no").keypress(enterpress)
  $("#name").keypress(enterpress)
  $("#supplier_name").keypress(enterpress)
  $("#cost_price").keypress(enterpress)
  $("#sell_price").keypress(enterpress)
  $("#desc").keypress(enterpress)

enterpress = (e) ->
  e = e || window.event;   
  if e.keyCode == 13    
  	return false;