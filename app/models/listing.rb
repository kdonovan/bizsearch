# Ideally each business for sale has a single listing, delegating to separate SiteListings
# as needed when the same business is listed on multiple sites.
class Listing < ActiveRecord::Base
  has_many :site_listings, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_and_belongs_to_many :saved_searches

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

  def primary_site_listing
    site_listings.first
  end

  def self.delegate_first_not_nil(*fields)
    fields.each do |field|
      define_method field do
        site_listings.detect {|l| l.send(field) }.try(field)
      end
    end
  end


  def self.delegate_lowest(*fields)
    fields.each do |field|
      define_method field do
        site_listings.map {|l| l.send(field) }.compact.min
      end
    end
  end

  delegate :title, :description, :city, :state, to: :primary_site_listing

  delegate_first_not_nil :reason_selling, :seller_financing, :employees, :established

  delegate_lowest :price, :cashflow, :revenue, :ffe, :inventory, :real_estate


  def self.import(result, source:, saved_search:)
    return unless sl = SiteListing.handle_new(result, source: source)
    dups    = sl.duplicates_on_other_networks(saved_search)
    listing = sl.listing || dups.detect(&:listing).try(:listing) || Listing.new
    listing.saved_searches << saved_search unless listing.saved_searches.include?(saved_search)

    dups.each do |dup|
      dup.update_attributes(listing: listing)
    end

    sl.update_attributes!(listing: listing)

    return listing
  end

end