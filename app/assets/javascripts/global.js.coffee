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

@initializeTypeahead = () ->
  $('[data-object~="typeahead"]').each( () ->
    $this = $(this)
    $this.typeahead(
      local: $this.data('local')
    )
  )

@setFocusToField = (element_id) ->
  val = $(element_id).val()
  $(element_id).focus().val('').val(val)

@ready = () ->
  contourReady()
  initializeTypeahead()
  $("[rel~=tooltip]").tooltip( trigger: 'hover' )
  $("input[rel=tooltip], textarea[rel=tooltip]").tooltip( trigger: 'focus' )
  togglePostdocFields()
  setFocusToField("#search")


$(document).ready(ready)
$(document)
  .on('page:load', ready)
  .on('click', '[data-object~="value-set"]', () ->
    $(this).find('input').prop('checked', true)
    $('#applicants_search').submit()
  )
  .on('click', '[data-object~="export"]', () ->
    window.location = $($(this).data('target')).attr('action') + '.' + $(this).data('format') + '?' + $($(this).data('target')).serialize()
    false
  )
  .on('click', '[data-object~="modal-show"]', () ->
    $($(this).data('target')).modal('show')
    false
  )
  .on('click', '[data-object~="modal-hide"]', () ->
    $($(this).data('target')).modal('hide')
    false
  )
  .on('click', '[data-object~="submit"]', () ->
    $($(this).data('target')).submit()
    false
  )
