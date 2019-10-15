$ ->
  show_order_details_js()
   
$(document).on "page:load", ->
  show_order_details_js()

show_order_details_js = ->
  $("tr[name='order_row'] td:not(td:has(a))").click (e) -> 
  	order_no = $(this).parent().find("td:first").text();
  	$("[name="+order_no+"]").slideToggle("fast");
  	return false;
    