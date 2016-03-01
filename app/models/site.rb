class Site < ActiveRecord::Base
  validates :name, presence: true, inclusion: Searchbot.sources.map {|s| s.name.split('::').last }

  has_many :listings

  scope :website,  -> { where(kind: :website) }
  scope :business, -> { where(kind: :business) }

  def adapter(search)
    api.new( search.as_filter )
  end

  def inspect
    "<Site:#{object_id} @id=#{id} @name=#{name}>"
  end

  private

  def api
    @api ||= "Searchbot::Sources::#{name}::Searcher".constantize
  end

end