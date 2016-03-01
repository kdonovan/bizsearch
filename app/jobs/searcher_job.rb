class SearcherJob < ActiveJob::Base
  queue_as :default

  attr_reader :saved_search, :site

  def perform(saved_search:, site:)
    @saved_search, @site = saved_search, site

    adapter.detailed_listings.map do |listing|
      Listing.import( listing, saved_search: saved_search, site: site )
    end
  end

  private

  def seen_ids
    @seen_ids ||= saved_search.site_listings.where(:site_id.eq site.id).pluck('DISTINCT(identifier)')
  end

  def adapter
    @adapter ||= site.adapter.new( saved_search.as_filter, seen: seen_ids )
  end

end
