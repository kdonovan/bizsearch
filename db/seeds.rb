# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Searchbot.sources.each do |src|
  Source.create(name: src.name.split('::').last)
end

Search.create name: 'Seattle',         min_cashflow: 150_000, priority: 1000, state: 'Washington',    city: 'Seattle'
Search.create name: 'Bellingham',      min_cashflow: 200_000, priority: 100,  state: 'Washington',    city: 'Bellingham'
Search.create name: 'Pt. Townsend',    min_cashflow: 200_000, priority: 100,  state: 'Washington',    city: 'Townsend'
Search.create name: 'Washington',      min_cashflow: 200_000, priority: 80,   state: 'Washington'
Search.create name: 'Oregon',          min_cashflow: 250_000, priority: 70,   state: 'Oregon'

Search.create name: 'San Diego',       min_cashflow: 200_000, priority: 80,  state: 'California',     city: 'San Diego'
Search.create name: 'Austin',          min_cashflow: 250_000, priority: 80,  state: 'Texas',          city: 'Austin'
Search.create name: 'Key West',        min_cashflow: 250_000, priority: 80,  state: 'Florida',        city: 'Key West'

Search.create name: 'New Orleans',     min_cashflow: 350_000, priority: 70,  state: 'Louisiana',      city: 'New Orleans'
Search.create name: 'Charleston',      min_cashflow: 350_000, priority: 70,  state: 'South Carolina', city: 'Charleston'
Search.create name: 'Miami',           min_cashflow: 350_000, priority: 70,  state: 'Florida',        city: 'Miami'

Search.create name: 'Absentee - OR',   min_cashflow: 350_000, priority: 60, state: 'Oregon',          keyword: 'absentee'
Search.create name: 'Absentee - CA',   min_cashflow: 350_000, priority: 60, state: 'California',      keyword: 'absentee'
Search.create name: 'Absentee - AK',   min_cashflow: 350_000, priority: 60, state: 'Alaska',          keyword: 'absentee'
Search.create name: 'Absentee - HI',   min_cashflow: 350_000, priority: 60, state: 'Hawaii',          keyword: 'absentee'

Search.update_all max_price: 2_000_000
