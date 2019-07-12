# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $ "a[name='order_detail_decline']"
  .click (e) ->
    if confirm "确定驳回吗？" 
    then this.href = "#{ this.href }?why_decline=#{ prompt('驳回理由') }" 
    else false


    #return false

    #"if(!confirm('确定驳回吗？')){return false;}else{var reson=prompt('驳回理由');$('#why_decline').val(reson);alert(reson);alert($('#why_decline').val());}"