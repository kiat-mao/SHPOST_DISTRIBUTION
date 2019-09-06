

# apply non-idempotent transformations to the body
#$ ->
#  switch_user_status()

#$(document).on "page:change", ->
  #$ "a[name='switch_user_status']"
  #.unbind("ajax:success")
  #switch_user_status()

$(document).on "ajax:success", "a[name='switch_user_status']", (e, data, status, xhr)->
  if this.text is "用户停用"
    this.href = this.href.replace "lock" , "unlock"
    this.text = "用户启用"
    alert "该用户已停用"
  else
    this.href = this.href.replace "unlock" , "lock"
    this.text = "用户停用"
    alert "该用户已启用"


