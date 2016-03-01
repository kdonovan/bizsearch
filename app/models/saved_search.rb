class SavedSearch < ActiveRecord::Base
  default_scope -> { order('priority DESC') }

  belongs_to :search_group
  has_and_belongs_to_many :listings
  has_many :site_listings, through: :listings

  def as_filter
    attributes.symbolize_keys.except(:id, :name, :priority, :created_at, :updated_at, :site_names)
  end

  def sites
    Site.where(name: site_names)
  end

  def update
    sites.each do |site|
      SearcherJob.perform_later(saved_search: self, site: site)
    end
  end

  def site_names
    raw = self['site_names']
    raw.flat_map do |site_name|
      case site_name
      when 'all'
        Searchbot.source_names
      when 'business'
        Searchbot.business_source_names
      when 'website'
        Searchbot.website_source_names
      else
        site_name if Searchbot.source_names.include?(site_name)
      end
    end.compact
  end

  private


end
