class Site < ActiveRecord::Base
  validates :name, presence: true

  has_many :listings

  def adapter
    @adapter ||= "Searchbot::Sources::#{name}".constantize
  end

  def inspect
    "<Site:#{object_id} @id=#{id} @name=#{name}>"
  end

end