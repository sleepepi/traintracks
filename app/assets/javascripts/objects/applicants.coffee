$(document)
  .on('click', '[data-object~="applicant-save"]', () ->
    if $(this).data('assurance') and not applicantAssuranceCheck()
      false
    else
      $('#applicant_publish').val($(this).data('publish'))
      $($(this).data('target')).submit()
      false
  )
  .on('click', '[data-object~="remove-parent"]', () ->
    $(this).closest("[data-object~='#{$(this).data('target')}']").remove()
    false
  )
  .on('click', '#send_annual_email', () ->
    $('#send_email_modal').modal('hide')
    $('#saving_modal').modal(backdrop: 'static', keyboard: false)
    $('#annual_reminder_email_form').submit()
    false
  )
  .on('change', '#applicant_applicant_type', () ->
    togglePostdocFields()
  )
