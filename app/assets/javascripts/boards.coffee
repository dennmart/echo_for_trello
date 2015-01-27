# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  weeklyOptions = { 'weekly': [
    { 'value': 0, 'name': 'Sunday' },
    { 'value': 1, 'name': 'Monday' },
    { 'value': 2, 'name': 'Tuesday' },
    { 'value': 3, 'name': 'Wednesday' },
    { 'value': 4, 'name': 'Thursday' },
    { 'value': 5, 'name': 'Friday' },
    { 'value': 6, 'name': 'Saturday' } ]
  }

  # TODO: Do this in a better and cleaner way.
  monthlyOptions = { 'monthly': [
    { 'day': 1 },
    { 'day': 2 },
    { 'day': 3 },
    { 'day': 4 },
    { 'day': 5 },
    { 'day': 6 },
    { 'day': 7 },
    { 'day': 8 },
    { 'day': 9 },
    { 'day': 10 },
    { 'day': 11 },
    { 'day': 12 },
    { 'day': 13 },
    { 'day': 14 },
    { 'day': 15 },
    { 'day': 16 },
    { 'day': 17 },
    { 'day': 18 },
    { 'day': 19 },
    { 'day': 20 },
    { 'day': 21 },
    { 'day': 22 },
    { 'day': 23 },
    { 'day': 24 },
    { 'day': 25 },
    { 'day': 26 },
    { 'day': 27 },
    { 'day': 28 },
    { 'day': 29 },
    { 'day': 30 },
    { 'day': 31 }
  ] }

  clearModalInfo = ->
    $('#new_list_modal_messages').removeClass()
    $('#new_list_modal_messages').text('')

  $('#card_trello_list_id').on 'change', ->
    if this.value == 'new_list'
      $('#new_list_modal').modal('show')

  $('#new_list_modal').on 'hide.bs.modal', (e)->
    $('#card_trello_list_id').val('')
    clearModalInfo()
    $('#new_list_modal_title').val('')

  $('#new_list_modal_save').on 'click',(e)->
    clearModalInfo()

    boardId = $('#card_trello_board_id').val()
    listName = $('#new_list_modal_title').val()
    if listName == ''
      $('#new_list_modal_messages').addClass('bg-danger')
      $('#new_list_modal_messages').text('The field is blank!')
    else
      $('#new_list_modal_loader').removeClass('hidden')
      $.ajax
        url: '/boards/' + boardId + '/new_list'
        type: 'POST'
        dataType: 'json'
        data: { 'id': boardId, 'list_name': listName }
        error: (jqXHR, textStatus, errorThrown) ->
          $('#new_list_modal_loader').addClass('hidden')
          $('#new_list_modal_messages').addClass('bg-danger')
          $('#new_list_modal_messages').text(jqXHR.responseJSON.message)
        success: (data, textStatus, jqXHR) ->
          $('<option value="' + data.list_id + '">' + listName + '</option>').insertBefore($('#card_trello_list_id option[value="new_list"]'))
          $('#new_list_modal_loader').addClass('hidden')
          $('#new_list_modal').modal('hide')
          $('#card_trello_list_id').val(data.list_id)

  $('#card_frequency').on 'change', ->
    if this.value == ''
      $('#frequency_period_group').html('')
    else
      $('#frequency_period_group').removeClass('hidden')
      if this.value == '1'
        template = HoganTemplates['frequency_daily_options']
        templateData = {}
      else if this.value == '2'
        template = HoganTemplates['frequency_weekly_options']
        templateData = weeklyOptions
      else if this.value == '3'
        template = HoganTemplates['frequency_monthly_options']
        templateData = monthlyOptions
      $('#frequency_period_group').html(template.render(templateData))

  $('.card-form').validate
    rules:
      'card[trello_list_id]':
        required: true
      'card[title]':
        required: true
      'card[frequency]':
        required: true
    messages:
      'card[trello_list_id]': 'Please select a list from the menu, or create a new list'
      'card[title]': 'Please enter the card title'
      'card[frequency]': 'Please select the frequency you want the card to be created'
    highlight: (elem) ->
      $(elem).parent('div').addClass('has-error')
    unhighlight: (elem) ->
      $(elem).parent('div').removeClass('has-error')

  frequencyPeriodOptions = ->
    if $('#card_frequency').val() == '1'
      $('#frequency_period_group').html(HoganTemplates['frequency_daily_options'].render())
    else if $('#card_frequency').val() == '2'
      $('#frequency_period_group').html(HoganTemplates['frequency_weekly_options'].render(weeklyOptions))
    else if $('#card_frequency').val() == '3'
      $('#frequency_period_group').html(HoganTemplates['frequency_monthly_options'].render(monthlyOptions))
      if $('#frequency_period_value').val() > 28
        $('#frequency_period_warning').html(HoganTemplates['frequency_period_warning'].render({ 'card_day': $('#frequency_period_value').val() }))

  $(document).ready(frequencyPeriodOptions)

  $(document).ready ->
    $('#card_frequency_period').on 'change', ->
      if this.value > 28
        $('#frequency_period_warning').html(HoganTemplates['frequency_period_warning'].render({ 'card_day': this.value }))
      else
        $('#frequency_period_warning').html('')

