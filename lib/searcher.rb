class Searcher

  def import_search_results
    saved_searches.map(&:update)
  end

  private

  def saved_searches
    SavedSearch.all
  end

end