class Searcher

  def search
    sources.each do |src|
      search_filters.each do |search|
        search_source(src, search)
      end
    end
  end

  private

  def sources
    # TODO: Source.all
    [Source.last]
  end

  def search_filters
    [Search.first]
    # Search.all
  end

  def search_source(source, search)
    # TODO: better logic would be to limit to seen for a specific filter, too
    seen_ids = source.listings.pluck(:identifier)

    adapter = source.source_class.new( search.as_filter, seen: seen_ids )
    adapter.results.map do |result|
      Listing.handle_new( result, source )
    end
  end

end