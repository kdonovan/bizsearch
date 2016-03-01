class ListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_listing, only: [:decide, :compare]

  def index
    scope = %w(yep nope).include?(params[:status]) ? params[:status] : 'undecided'
    @listings = current_user.listings.send(scope).includes(:site_listings)
  end

  def refresh
    # TODO: this should be scoped to the specific search group
    current_user.saved_searches.each {|s| s.update! }

    flash[:info] = "Started job search agent (refresh in a few minutes to see any updates)"

    redirect_to action: :index
  end

  def decide
    render(nothing: true, status: 500) and return unless %w(yep nope maybe).include?(params[:decision])

    @listing.send( params[:decision] )
    render(nothing: true, status: 200)
  end

  def compare
    @site_listings = @listing.site_listings
    render layout: 'modal'
  end

  private

  def get_listing
    @listing = current_user.listings.find(params[:id])
  end

end
