format = (raw) ->
  $('<div class="listing-detail"></div>').html(raw.body)

initListingTable = ->
  table = $('#listings-table').DataTable({
    pageLength: 50
    columns: [
      {
          className:      'details-control'
          orderable:      false
          data:           null
          defaultContent: ''
      }
      { data: "location" },
      { data: "price" },
      { data: "cashflow" },
      { data: "multiple" },
      { data: "status" },
      { data: "title" },
      {
        data: "body"
        visible: false
      }
    ],
    order: [[5, 'desc'], [3, 'desc']]
  })

  # Add event listener for opening and closing details
  $('#listings-table tbody').on 'click', 'td.title .detail', (e) -> e.stopPropagation()
  $('#listings-table tbody').on 'click', 'td.clickable', ->
    tr = $(this).closest('tr')
    row = table.row( tr )

    if row.child.isShown()
      # This row is already open - close it
      row.child.hide()
      tr.removeClass('shown')
    else
      # Open this row
      row.child( format(row.data()) ).show()
      row.child().addClass('child-row')
      tr.addClass('shown')
      tr.find('#note_body').focus()

  # Handle clicks via ajax
  $(".buttons").on "ajax:success", ->
    $(this).closest('tr').hide()

  $('#listings-table .note-form').on 'ajax:success', (e, data, status, xhr) ->
    f = $(this)
    f.find('input[name="note[body]"]').val('')
    counter = f.parents('td').first().find('.note_count')
    counter.html( parseInt( counter.html() ) + 1)
    counter.parents('.badge').first().removeClass('hidden')
    f.parents('tr').first().next().find('.notes').prepend( $(data).hide().fadeIn() )

  $('#listings-table').on 'ajax:success', '.note-destroy', ->
    td = $(this).parents('.td').first()
    counter = $(this).parents('tr').first().prev().find('.note_count')
    n = parseInt(counter.html()) - 1
    counter.html(n)
    counter.parents('.badge').first().addClass('hidden') if n < 1
    $(this).parents('.panel').first().fadeOut()
    table.cell( td ).invalidate().draw()

  $('#listings-table').on 'ajax:success', '.remote-modal', (e, data, status, xhr) ->
    $(data).modal().on 'hidden.bs.modal', ->
      $('.modal-backdrop').remove() # Somehow we're getting a double backdrop by loading modal from remote


$(document).ready(initListingTable)
$(document).on('page:load', initListingTable)
