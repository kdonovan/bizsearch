class NotesController < ApplicationController
  before_action :get_listing, only: [:create, :destroy]

  def create
    @note = @listing.notes.create!(note_params)
    render partial: 'shared/panel', locals: { body: @note.body, title: 'Newly created', type: :info }
  end

  def destroy
    @note = @listing.notes.find( params[:id] )
    @note.destroy
    render nothing: true
  end

  private

  def get_listing
    @listing = Listing.find(params[:listing_id])
  end

  def note_params
    params.require(:note).permit(:body)
  end

end
