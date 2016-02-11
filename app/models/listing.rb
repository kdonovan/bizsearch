class Listing < ActiveRecord::Base
  validates :title, presence: true

  belongs_to :source
  belongs_to :search # TODO: eventually this should be a has-and-belongs-to-many relationship so each search can list ALL it's results
  has_many :notes

  UNWANTED_SEARCHBOT_FIELDS = %i(cashflow_from location source_klass teaser)

  scope :undecided, -> { where(status: ['unseen', 'maybe']) }
  scope :yep, -> { where(status: 'yep') }
  scope :nope, -> { where(status: 'nope') }

  state_machine :status, initial: :unseen do
    state :unseen
    state :nope
    state :maybe
    state :yep

    event :nope do
      transition all => :nope
    end

    event :maybe do
      transition all => :maybe
    end

    event :yep do
      transition all => :yep
    end

  end

  def self.handle_new(result, source)
    result = result.detail # Ensure we're working with the full page record
    keys   = result.keys - UNWANTED_SEARCHBOT_FIELDS
    params = keys.each_with_object({}) do |key, hash|
      # Explicitly send, not just to_hash, because we have custom formatting logic in getter methods
      hash[key] = result.send(key)
    end
    params[:source] = source
    params[:identifier] = params.delete(:id)


    # TODO: eventually, link/deduplicate matching listings across sources

    return if skip_listing?(params)

    Listing.where(params).first_or_create!
  end

  private

  # Allow custom filters (eventually will be user-by-user or search-by-search basis)
  STOPWORDS = [] # %w(plumber plumbing contractor)

  def self.skip_listing?(params)
    STOPWORDS.present? && params[:title] =~ /#{STOPWORDS.join('|')}/i
  end


end