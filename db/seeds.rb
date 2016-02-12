# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Searchbot.sources.each do |src|
  Site.create(name: src.name.split('::').last)
end

SavedSearch.create name: 'Seattle Test',      min_price: 200_000, state: 'Washington', city: 'Seattle'

# SavedSearch.create name: 'Seattle',         min_cashflow: 150_000, priority: 1000, state: 'Washington',    city: 'Seattle'
# SavedSearch.create name: 'Bellingham',      min_cashflow: 200_000, priority: 100,  state: 'Washington',    city: 'Bellingham'
# SavedSearch.create name: 'Pt. Townsend',    min_cashflow: 200_000, priority: 100,  state: 'Washington',    city: 'Townsend'
# SavedSearch.create name: 'Washington',      min_cashflow: 200_000, priority: 80,   state: 'Washington'
# SavedSearch.create name: 'Oregon',          min_cashflow: 250_000, priority: 70,   state: 'Oregon'

# SavedSearch.create name: 'San Diego',       min_cashflow: 200_000, priority: 80,  state: 'California',     city: 'San Diego'
# SavedSearch.create name: 'Austin',          min_cashflow: 250_000, priority: 80,  state: 'Texas',          city: 'Austin'
# SavedSearch.create name: 'Key West',        min_cashflow: 250_000, priority: 80,  state: 'Florida',        city: 'Key West'

# SavedSearch.create name: 'New Orleans',     min_cashflow: 350_000, priority: 70,  state: 'Louisiana',      city: 'New Orleans'
# SavedSearch.create name: 'Charleston',      min_cashflow: 350_000, priority: 70,  state: 'South Carolina', city: 'Charleston'
# SavedSearch.create name: 'Miami',           min_cashflow: 350_000, priority: 70,  state: 'Florida',        city: 'Miami'

# SavedSearch.create name: 'Absentee - OR',   min_cashflow: 350_000, priority: 60, state: 'Oregon',          keyword: 'absentee'
# SavedSearch.create name: 'Absentee - CA',   min_cashflow: 350_000, priority: 60, state: 'California',      keyword: 'absentee'
# SavedSearch.create name: 'Absentee - AK',   min_cashflow: 350_000, priority: 60, state: 'Alaska',          keyword: 'absentee'
# SavedSearch.create name: 'Absentee - HI',   min_cashflow: 350_000, priority: 60, state: 'Hawaii',          keyword: 'absentee'

SavedSearch.update_all max_price: 2_000_000
