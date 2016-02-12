require 'rails_helper'

describe Searcher do

  before(:each) do
    Searchbot.sources.each do |src|
      Source.create(name: src.name.split('::').last)
    end

    SavedSearch.create name: 'Seattle Test', min_price: 200_000, state: 'Washington', city: 'Seattle'
  end

  it "combines duplicates across networks", vcr: {match_requests_on: [:method, :uri, :body]} do
    results = Searcher.new.search
    binding.pry
    expect( results.length ).not_to eq 0
  end

end
