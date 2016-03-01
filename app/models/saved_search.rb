class SavedSearch < ActiveRecord::Base
  default_scope -> { order('priority DESC') }

  belongs_to :search_group
  has_and_belongs_to_many :listings
  has_many :site_listings, through: :listings

  def as_filter
    attributes.symbolize_keys.except(:id, :name, :priority, :created_at, :updated_at, :site_names, :search_group_id)
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
        basenames Searchbot.sources
      when 'business'
        basenames Searchbot.business_sources
      when 'website'
        basenames Searchbot.website_sources
      else
        site_name if Searchbot.source_names.include?(site_name)
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
