class SearcherJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Searcher.new.search
  end

end
