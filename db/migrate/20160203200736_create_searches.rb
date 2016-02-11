class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :name
      t.string :state
      t.string :city
      t.string :keyword
      t.integer :min_price
      t.integer :max_price
      t.integer :min_cashflow
      t.integer :max_cashflow
      t.integer :priority, default: 10

      t.timestamps null: false
    end
  end
end
