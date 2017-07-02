module Searcher

  def self.import_search_results!
    saved_searches.map(&:update!)
  end

  private

  def self.saved_searches
    SavedSearch.all
  end

end