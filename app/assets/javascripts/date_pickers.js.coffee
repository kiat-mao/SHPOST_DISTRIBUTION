ready = ->
  $('#start_date_start_date').datepicker({
    changeMonth:true,
    changeYear:true
  });
  $('#end_date_end_date').datepicker({
    changeMonth:true,
    changeYear:true
  });
  $('#supplier_valid_before').datepicker({
    showAnim:"blind",
    changeMonth:true,
    changeYear:true
  });
$(document).ready(ready)
$(document).on('page:load', ready)