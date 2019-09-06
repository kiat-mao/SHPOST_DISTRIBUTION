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
  $('#close_at_start_close_at_start').datepicker({
    changeMonth:true,
    changeYear:true
  });
  $('#close_at_end_close_at_end').datepicker({
    changeMonth:true,
    changeYear:true
  });
  $('#check_at_start_check_at_start').datepicker({
    changeMonth:true,
    changeYear:true
  });
  $('#check_at_end_check_at_end').datepicker({
    changeMonth:true,
    changeYear:true
  });
  $('#recheck_at_start_recheck_at_start').datepicker({
    changeMonth:true,
    changeYear:true
  });
  $('#recheck_at_end_recheck_at_end').datepicker({
    changeMonth:true,
    changeYear:true
  });
$(document).ready(ready)
$(document).on('page:load', ready)