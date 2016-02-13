require 'rails_helper'

describe Searcher do
  let(:results) { Searcher.new.import_search_results }

  before(:each) do
    Searchbot.sources.each do |src|
      Site.create(name: src.name.split('::').last)
    end

    SavedSearch.create name: 'Seattle Test', min_price: 200_000, state: 'Washington', city: 'Seattle'
  end

  it "combines duplicates across networks", vcr: {match_requests_on: [:method, :uri, :body]} do
    expect( results.length ).to be > 0
    expect( Listing.count ).to be > 0
    expect( Listing.count ).to be < SiteListing.count
  end

end
