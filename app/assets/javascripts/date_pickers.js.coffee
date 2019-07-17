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
  $('#create_at_start_create_at_start').datepicker({
    changeMonth:true,
    changeYear:true
  });
  $('#create_at_end_create_at_end').datepicker({
    changeMonth:true,
    changeYear:true
  });
$(document).ready(ready)
$(document).on('page:load', ready)