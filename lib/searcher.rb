class Searcher

  def import_search_results
    sites.flat_map do |site|
      saved_searches.flat_map do |search|
        search_site(site, search)
      end
    end.uniq
  end

  private

  def sites
    # TODO: once fix the BizBuySell IP-based restriction, re-enable that site
    Site.where.not(name: 'BizBuySell')
  end

  def saved_searches
    SavedSearch.all
  end

  def search_site(site, saved_search)
    adapter(site, saved_search).results.map do |result|
      Listing.import( result, saved_search: saved_search, site: site )
    end
  end

  def adapter(site, saved_search)
    seen_ids = saved_search.site_listings.where(:site_id.eq site.id).pluck('DISTINCT(identifier)')

    site.adapter.new( saved_search.as_filter, seen: seen_ids )
  end

end