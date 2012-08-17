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

jQuery ->
  togglePostdocFields()

  $("#applicant_applicant_type").on('change', () ->
    togglePostdocFields()
  )

  $(document)
    .on('click', '[data-object~="value-set"]', () ->
      $($(this).data('target')).val($(this).data('value'))
      $($(this).data('target')).closest('form').submit()
    )
    .on('click', '[data-object~="export"]', () ->
      window.location = $($(this).data('target')).attr('action') + '.' + $(this).data('format') + '?' + $($(this).data('target')).serialize()
      false
    )
    .on('click', '[data-object~="reset-filters"]', () ->
      $('[data-object~="filter"]').val('')
      $($(this).data('target')).submit()
      false
    )
    .on('click', '[data-object~="reset-applicant-filters"]', () ->
      $('[data-object~="filter"]').val('')
      $('#enrolled-all').click()
      false
    )
    .on('click', '[data-object~="modal-show"]', () ->
      $($(this).data('target')).modal({ dynamic: true })
      false
    )
    .on('click', '[data-object~="modal-hide"]', () ->
      $($(this).data('target')).modal('hide');
      false
    )
