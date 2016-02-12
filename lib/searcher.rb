class Searcher

  def search
    sources.flat_map do |src|
      saved_searches.flat_map do |search|
        search_source(src, search)
      end
    end.uniq
  end

  private

  def sources
    # TODO: once fix the BizBuySell IP-based restriction, re-enable that source
    Source.where.not(name: 'BizBuySell')
  end

  def saved_searches
    SavedSearch.all
  end

  def search_source(source, saved_search)
    adapter(source, saved_search).results.map do |result|
      Listing.import( result, saved_search: saved_search, source: source )
    end
  end

  def adapter(source, saved_search)
    seen_ids = saved_search.site_listings.where(:source_id.eq source.id).pluck('DISTINCT(identifier)')

    source.source_class.new( saved_search.as_filter, seen: seen_ids )
  end

end