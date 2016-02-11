class AddListings < ActiveRecord::Migration
  def change

    create_table :sources do |t|
      t.string :name
    end

    create_table :listings do |t|
      t.belongs_to :source, :search
      t.string :identifier, :title, :link, required: true
      t.integer :price, :cashflow, :revenue

      t.text :description
      t.string :city, :state

      t.integer :ffe, :inventory, :real_estate, :employees, :established
      t.string :reason_selling
      t.boolean :seller_financing, :inventory_included, :real_estate_included

      t.string :status, default: 'unseen'
      t.timestamps
    end

  end
end