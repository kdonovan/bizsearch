# SiteListing represents listing from a specific site (as opposed to generic Listing)
class SiteListing < ActiveRecord::Base
  belongs_to :site
  belongs_to :listing

  validates :listing, presence: true
  validates :title, presence: true

  def self.handle_new(result, site:)
    sl = SiteListing.where(site: site, identifier: result[:id]).first_or_initialize
    sl.attributes = params_from_result(result)
    sl.skip_listing? ? nil : sl
  end

  # Listings from other sites that may duplicate this one
  def duplicates_on_other_networks(saved_search)
    scope = saved_search.site_listings.where.not(site_id: site.id)

    %i(city state established).each do |attr|
      scope = narrow_by(scope, attr)
    end

    # Explicitly NOT searching price, as that can easily differ between listings
    %i(cashflow revenue).each do |attr|
      scope = narrow_by(scope, attr, allow_range: true)
    end

    select_similar_titles(scope.to_a)
  end

  def skip_listing?
    STOPWORDS.present? && title && title =~ /#{STOPWORDS.join('|')}/i
  end

  private



  def self.params_from_result(result)
    result = result.detail # Ensure we're working with the full page record
    keys   = result.keys - UNWANTED_SEARCHBOT_FIELDS

    keys.each_with_object({}) do |key, hash|
      # Explicitly send, not just to_hash, because we have custom formatting logic in getter methods
      hash[key] = result.send(key)
    end
  end

  UNWANTED_SEARCHBOT_FIELDS = %i(cashflow_from location source_klass teaser id)

  # Allow custom filters (eventually will be user-by-user or search-by-search basis)
  STOPWORDS = [] # %w(plumber plumbing contractor)

  def narrow_by(scope, attr, opts = {})
    val = send(attr)
    return scope unless val.to_i > 0

    if opts[:allow_range]
      allowable = [val * 0.1, 10_000].max
      range = (val - allowable) .. (val + allowable)
      scope.where( attr.eq(nil).or( attr.in(range) ) )
    else
      scope.where( attr.eq(nil).or( attr.eq(val) ) )
    end
  end

  def select_similar_titles(others)
    others.select do |other|
      similar_title?(other)
    end
  end

  def similar_title?(other)
    return true if title == other.title

    # Is one a subset of the other?
    titles = [title, other.title].map {|t| t.downcase.gsub(/[^\w ]/, '').gsub(/\s{2,}/, ' ').strip }.sort_by {|t| t.length}
    return true if titles[1] =~ /#{titles[0]}/

    # Maybe they share some key words?
    a, b = titles.map(&:split)
    a.select {|word| b.include?(word) }.length > 2
  end
end
