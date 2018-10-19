$(document)
  .on("click", "[data-object~=annual-save]", ->
    $("#applicant_publish_annual").val($(this).data("publish"))
    $("#annual_publish").val($(this).data("publish"))
    $($(this).data("target")).submit()
    false
  )
