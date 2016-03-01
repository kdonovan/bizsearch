class SearchGroup < ActiveRecord::Base
  belongs_to :user
  has_many :saved_searches

  def name
    self['name'] || (user ? "#{user.email}'s " : '') + 'Saved Searches'
  end
end
