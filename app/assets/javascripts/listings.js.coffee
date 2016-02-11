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
      tr.addClass('shown')

  # Handle clicks via ajax
  $(".buttons").on "ajax:success", ->
    $(this).closest('tr').hide()

  $('#listings-table .note-form').on 'ajax:success', (e, data, status, xhr) ->
    f = $(this)
    f.find('input[name="note[body]"]').val('')
    f.find('.note_count').html( parseInt( f.find('.note_count').html() ) + 1)
    f.parents('tr').first().next().find('.notes').prepend( $(data).hide().fadeIn() )

  $('#listings-table').on 'ajax:success', '.note-destroy', ->
    counter = $(this).parents('tr').first().prev().find('.note_count')
    counter.html( parseInt(counter.html()) - 1 )
    $(this).parents('.panel').first().fadeOut()

$(document).ready(initListingTable)
$(document).on('page:load', initListingTable)
