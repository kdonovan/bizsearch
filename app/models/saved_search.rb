class SavedSearch < ActiveRecord::Base
  default_scope -> { order('priority DESC') }

  belongs_to :search_group
  has_and_belongs_to_many :listings
  has_many :site_listings, through: :listings
  delegate :user, to: :search_group

  FILTER_KEYS = %i(city state keyword min_price max_price min_cashflow max_cashflow min_ratio max_ratio min_revenue max_revenue min_hours_required max_hours_required)

  def as_filter
    attributes.symbolize_keys.slice( *FILTER_KEYS )
  end

  def sites
    Site.where(name: site_names)
  end

  def update!
    sites.each do |site|
      SearcherJob.perform_later(saved_search: self, site: site)
    end
  end

  def site_names
    raw = self['site_names']
    raw.flat_map do |site_name|
      case site_name
      when 'all'
        basenames Searchbot.sources
      when 'business'
        basenames Searchbot.business_sources
      when 'website'
        basenames Searchbot.website_sources
      else
        site_name if basenames(Searchbot.sources).include?(site_name)
      end
    end.compact
  end

  private

  def basenames(modules)
    modules.map do |module_name|
      module_name.name.split('::').last
    end
  end

end
