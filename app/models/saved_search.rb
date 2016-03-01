class SavedSearch < ActiveRecord::Base
  default_scope -> { order('priority DESC') }

  has_and_belongs_to_many :listings
  has_many :site_listings, through: :listings

  def as_filter
    attributes.symbolize_keys.except(:id, :name, :priority, :created_at, :updated_at)
  end

  def sites
    Site.where(name: source_names)
  end

  def update
    sites.each do |site|
      SearcherJob.perform_later(saved_search: self, site: site)
    end
  end

  private

  def source_names
    case self['sources']
    when 'all'
      Searchbot.sources
    when 'business'
      Searchbot.business_sources
    when 'website'
      Searchbot.website_sources
    else
      # TODO - just use straight postgres arrays...
      self['sources'].split(',')
    end
  end

end
