# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
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
    if listName == ""
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
          $('<option value="' + data.list_id + '">' + listName + '</option>').insertBefore($('#card_trello_list_id option[value="new_list"]'));
          $('#new_list_modal_loader').addClass('hidden')
          $('#new_list_modal').modal('hide')
          $('#card_trello_list_id').val(data.list_id)

