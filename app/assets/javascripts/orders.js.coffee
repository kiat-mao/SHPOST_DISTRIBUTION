$ ->
  show_order_details_js()
   
$(document).on "page:load", ->
  show_order_details_js()

show_order_details_js = ->
  $("[name='detail']").click (e) -> 
    $(this).parents('tr').next('.extra-row').slideToggle("fast");