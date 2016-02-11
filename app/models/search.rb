class Search < ActiveRecord::Base
  default_scope -> { order('priority DESC') }

  def as_filter
    attributes.symbolize_keys.except(:id, :name, :priority, :created_at, :updated_at)
  end

end
