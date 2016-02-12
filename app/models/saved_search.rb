class SavedSearch < ActiveRecord::Base
  default_scope -> { order('priority DESC') }

  has_and_belongs_to_many :listings
  has_many :site_listings, through: :listings

  def as_filter
    attributes.symbolize_keys.except(:id, :name, :priority, :created_at, :updated_at)
  end

end
