class SearchGroup < ActiveRecord::Base
  belongs_to :user
  has_many :saved_searches
  has_many :listings, through: :saved_searches
  has_many :site_listings, through: :listings

  def name
    self['name'] || (user ? "#{user.email}'s " : '') + 'Saved Searches'
  end
end
