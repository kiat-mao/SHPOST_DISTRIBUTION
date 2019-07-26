# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "page:change", ->
  $ "a[name='order_detail_check_decline'], a[name='order_detail_recheck_decline'], a[name='order_order_detail_recheck_decline'], a[name='order_order_detail_check_decline']"
  .click (e) ->
    if confirm "确定驳回吗？"
      why_decline = prompt('驳回理由')
      if why_decline?
        this.href = "#{ this.href }?why_decline=#{why_decline}"
      else false
    else false

  $ "a[name='order_detail_to_recheck'], a[name='order_order_detail_to_recheck']"
  .click (e) ->
    if not confirm "确定通过吗？" 
    then false

  $ "a[name='order_detail_place'], a[name='order_order_detail_place']"
  .click (e) ->
    if not confirm "确定下单吗？" 
    then false

  $ "a[name='order_detail_confirm'], a[name='order_order_detail_confirm']"
  .click (e) ->
    if not confirm "确定收货吗？" 
    then false

  $ "a[name='order_detail_cancel'], a[name='order_order_detail_cancel']"
  .click (e) ->
    if not confirm "确定取消吗？" 
    then false

  $ "a[name='order_detail_to_check'], a[name='order_order_detail_to_check']"
  .click (e) ->
    if not confirm "确定送审吗？" 
    then false

