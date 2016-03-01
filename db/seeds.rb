# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Searchbot.business_sources.each do |src|
  Site.create(name: src.name.split('::').last, kind: :business)
end

Searchbot.website_sources.each do |src|
  Site.create(name: src.name.split('::').last, kind: :website)
end

user = User.create email: "#{`whoami`.strip}@deviantech.com", password: 'password', password_confirmation: 'password'

group = user.search_groups.create name: 'Seattle Businesses'

group.saved_searches.create name: 'Seattle Test',      min_price: 200_000, state: 'Washington', city: 'Seattle'

# group.saved_searches name: 'Seattle',         min_cashflow: 150_000, priority: 1000, state: 'Washington',    city: 'Seattle'
# group.saved_searches name: 'Bellingham',      min_cashflow: 200_000, priority: 100,  state: 'Washington',    city: 'Bellingham'
# group.saved_searches name: 'Pt. Townsend',    min_cashflow: 200_000, priority: 100,  state: 'Washington',    city: 'Townsend'
# group.saved_searches name: 'Washington',      min_cashflow: 200_000, priority: 80,   state: 'Washington'
# group.saved_searches name: 'Oregon',          min_cashflow: 250_000, priority: 70,   state: 'Oregon'

# group.saved_searches name: 'San Diego',       min_cashflow: 200_000, priority: 80,  state: 'California',     city: 'San Diego'
# group.saved_searches name: 'Austin',          min_cashflow: 250_000, priority: 80,  state: 'Texas',          city: 'Austin'
# group.saved_searches name: 'Key West',        min_cashflow: 250_000, priority: 80,  state: 'Florida',        city: 'Key West'

# group.saved_searches name: 'New Orleans',     min_cashflow: 350_000, priority: 70,  state: 'Louisiana',      city: 'New Orleans'
# group.saved_searches name: 'Charleston',      min_cashflow: 350_000, priority: 70,  state: 'South Carolina', city: 'Charleston'
# group.saved_searches name: 'Miami',           min_cashflow: 350_000, priority: 70,  state: 'Florida',        city: 'Miami'

# group.saved_searches name: 'Absentee - OR',   min_cashflow: 350_000, priority: 60, state: 'Oregon',          keyword: 'absentee'
# group.saved_searches name: 'Absentee - CA',   min_cashflow: 350_000, priority: 60, state: 'California',      keyword: 'absentee'
# group.saved_searches name: 'Absentee - AK',   min_cashflow: 350_000, priority: 60, state: 'Alaska',          keyword: 'absentee'
# group.saved_searches name: 'Absentee - HI',   min_cashflow: 350_000, priority: 60, state: 'Hawaii',          keyword: 'absentee'

SavedSearch.update_all max_price: 2_000_000, site_names: ['business']

# TODO: allow saved search to specify which sources to use