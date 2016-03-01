class Site < ActiveRecord::Base
  validates :name, presence: true

  has_many :listings

  scope :website, -> { where(kind: :website) }
  scope :business, -> { where(kind: :business) }

  def adapter
    @adapter ||= "Searchbot::Sources::#{name}".constantize
  end

  def inspect
    "<Site:#{object_id} @id=#{id} @name=#{name}>"
  end

end