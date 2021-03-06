module ListingHelper

  def listing_status(l)
    label, text = case l.status
    when 'unseen' then ['warning', 'New']
    when 'maybe'  then ['primary', 'Maybe']
    when 'nope'   then ['danger',  'Nope']
    when 'yep'    then ['success', 'Yep']
    else               ['default', "? #{l.status} ?"]
    end

    content_tag :span, text, class: "label label-#{label}"
  end

  def format_description(desc)
    return unless desc
    desc
      .gsub(/\[([\w\s\/-]+)\]:/, '<h6>\1</h6>')
      .gsub(/\n\n\n/, '<br>')
      .gsub(/\r\n/, '<br>')
  end

  def listing_note(listing, note)
    title = note.created_at.strftime("Noted at %k:%M on %b %e (%Z)")
    close = link_to "&times;".html_safe, listing_note_path(listing, note), class: 'close note-destroy',
      remote: true,
      method: :delete,
      data: {confirm: "Are you sure?", disable_with: 'Confirming...'}

    render 'shared/panel', body: note.body, type: :info, title: title, close: close
  end

  def compare_site_listings(fields)
    rows = fields.map do |field|
      {
        title: field.titleize,
        values: @site_listings.map do |sl|
          val = sl.send(field)
          block_given? ? yield(val) : val
        end
      }
    end

    render partial: 'comparison_rows', locals: {rows: rows}
  end

  def filter_label
    case params[:status]
    when 'yep'  then 'accepted'
    when 'nope' then 'rejected'
    else 'all'
    end
  end

end
