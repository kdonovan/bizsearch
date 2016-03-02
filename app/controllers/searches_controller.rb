class SearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @searches = current_user.search_groups
  end

end
