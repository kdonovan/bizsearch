class Site < ActiveRecord::Base
  validates :name, presence: true, inclusion: Searchbot.sources.map {|s| s.name.split('::').last }

  has_many :listings

  scope :website,  -> { where(kind: :website) }
  scope :business, -> { where(kind: :business) }

  def adapter(search, options = {})
    filter = search.respond_to?(:as_filter) ? search.as_filter : search

    api.new( filter, options )
  end

  def inspect
    "<Site:#{object_id} @id=#{id} @name=#{name}>"
  end

  private

  def api
    @api ||= "Searchbot::Sources::#{name}::Searcher".constantize
  end

end