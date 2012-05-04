# Global functions referenced from HTML
@applicantAssuranceCheck = () ->
  if !$('#applicant_assurance').is(':checked')
    alert 'Please read and check the Application Assurance and Sign Off before submitting your application.'
    return false
  if !confirm('Submit application for review? No more edits will be possible.')
    return false
  true

@togglePostdocFields = () ->
  if $('#applicant_applicant_type')?
    postdoc_only = ['#applicant_residency', ]
    postdoc_fields = $("[data-toggle='postdoc_only']")
    predoc_summer_fields = $("[data-toggle='predoc_summer_only']")
    if $('#applicant_applicant_type').val() == 'postdoc'
      for field in postdoc_fields
        $(field).removeAttr('disabled')
      for field in predoc_summer_fields
        $(field).attr('disabled', 'disabled')
    else
      for field in postdoc_fields
        $(field).attr('disabled', 'disabled')
      for field in predoc_summer_fields
        $(field).removeAttr('disabled')

  # if window.choices[$(element).val()]?
  #   window.show_fields = window.choices[$(element).val()]
  #   diff = window.toggle_fields.filter( (x) -> return window.show_fields.indexOf(x) < 0 )
  #   for field in window.toggle_fields
  #     $(field).removeAttr('disabled')
  #     $(field).parent().show()
  #   for field in diff
  #     $(field).attr('disabled', 'disabled')
  #     $(field).parent().hide()
  # else
  #   for field in window.toggle_fields
  #     $(field).attr('disabled', 'disabled')
  #     $(field).parent().hide()


jQuery ->
  $(".datepicker").datepicker
    showOtherMonths: true
    selectOtherMonths: true
    changeMonth: true
    changeYear: true

  $("#ui-datepicker-div").hide()

  $(document).on('click', ".pagination a, .page a, .next a, .prev a", () ->
    $.get(this.href, null, null, "script")
    false
  )

  $(document).on("click", ".per_page a", () ->
    object_class = $(this).data('object')
    $.get($("#"+object_class+"_search").attr("action"), $("#"+object_class+"_search").serialize() + "&"+object_class+"_per_page="+ $(this).data('count'), null, "script")
    false
  )

  togglePostdocFields()

  $("#applicant_applicant_type").on('change', () ->
    togglePostdocFields()
  )
