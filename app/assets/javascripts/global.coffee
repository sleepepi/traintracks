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

@flashMessage = (message, alert_type = 'success', overwrite = true) ->
  div_block = "<div class='navbar-alert alert alert-#{alert_type}'><button type='button' class='close' data-dismiss='alert'>&times;</button>#{message}</div>"
  flash_container = $('[data-object~="flash-container"]')
  if overwrite
    flash_container.html(div_block)
  else
    flash_container.append(div_block)

@setFocusToField = (element_id) ->
  val = $(element_id).val()
  $(element_id).focus().val('').val(val)

@extensionsReady = ->
  datepickerReady()
  tooltipsReady()
  typeaheadReady()

# These functions get called on initial page visit and on turbolink page changes
@turbolinksReady = ->
  togglePostdocFields()
  setFocusToField("#search")
  # $('[data-object~="form-load"]').submit()
  extensionsReady()

# These functions only get called on the initial page visit (no turbolinks).
# Browsers that don't support turbolinks will initialize all functions in
# turbolinks on page load. Those that do support Turbolinks won't call these
# methods here, but instead will wait for `turbolinks:load` event to prevent
# running the functions twice.
@initialLoadReady = ->
  turbolinksReady() unless Turbolinks.supported

$(document).ready(initialLoadReady)
$(document)
  .on('turbolinks:load', turbolinksReady)
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
