class Source < ActiveRecord::Base
  validates :name, presence: true

  has_many :listings

  def source_class
    @source_class ||= "Searchbot::Sources::#{name}".constantize
  end

  def inspect
    "<Source:#{object_id} @id=#{id} @name=#{name}>"
  end

end