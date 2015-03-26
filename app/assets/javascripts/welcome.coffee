$(document)
  .on('click', '[data-object~="show-administrator-login"]', () ->
    $("#choose-role").hide()
    $("#administrator-login").show()
    false
  )
