# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
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
      $(this).parent().remove()
      false
    )

  $('#send_annual_email').on('click', () ->
    if $('#enrolled').val() == 'all' and !confirm('Warning! Are you sure you want to send an annual email to ALL applicants?')
      return false
    $('#send_email_modal').modal('hide')
    $('#annual_subject').val($('#subject').val())
    $('#annual_body').val($('#body').val())
    $('#annual_year').val($('#year').val())
    $('#saving_modal').modal(backdrop: 'static', keyboard: false)
    $.get($('#applicants_search').attr('action'), $('#applicants_search').serialize() + '&annual_email=1', null, 'script')
    false
  )


