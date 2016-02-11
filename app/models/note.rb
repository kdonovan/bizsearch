class Note < ActiveRecord::Base
  belongs_to :listing

  validates :listing, presence: true
  validates :body, presence: true
end
