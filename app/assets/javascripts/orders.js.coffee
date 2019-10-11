$ ->
  show_order_details_js()
   
$(document).on "page:load", ->
  show_order_details_js()

show_order_details_js = ->
  $("[name='detail']").click (e) -> 
  	order_no = $(this).parents('tr').find("td:first").text();
  	$("[name="+order_no+"]").slideToggle("fast");
  	return false;
    