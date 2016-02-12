class ListingsController < ApplicationController
  before_action :get_listing, only: [:decide, :compare]


  def index
    scope = %w(yep nope).include?(params[:status]) ? params[:status] : 'undecided'
    @listings = Listing.send(scope).includes(:site_listings)
  end

  def refresh
    SearcherJob.perform_later
    flash[:info] = "Started job search agent"

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
    @listing = Listing.find(params[:id])
  end

end
