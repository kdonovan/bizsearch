class AddInitialStructure < ActiveRecord::Migration
  def change
    create_table :search_groups do |t|
      t.string :name
      t.belongs_to :user, index: true
      t.timestamps null: false
    end

    create_table :notes do |t|
      t.belongs_to :user, index: true
      t.belongs_to :listing, index: true
      t.text :body

      t.timestamps null: false
    end

    create_table :saved_searches do |t|
      t.belongs_to :search_group, index: true
      t.string :name

      t.string :city, :state, :keyword
      t.integer :min_price, :max_price
      t.integer :min_cashflow, :max_cashflow
      t.integer :min_revenue, :max_revenue
      t.decimal :min_ratio, precision: 3, scale: 1
      t.decimal :max_ratio, precision: 3, scale: 1

      # Web attributes
      t.integer :min_hours_required
      t.integer :max_hours_required

      t.integer :priority, default: 10, index: true
      t.string :site_names, array: true
      t.timestamps null: false
    end

    create_table :sites do |t|
      t.string :name
      t.string :kind
    end

    create_table :listings do |t|
      t.belongs_to :user, index: true
      t.string :status, default: 'unseen', index: true
      t.timestamps null: false
    end

    create_table :listings_saved_searches, id: false do |t|
      t.belongs_to :listing, index: true
      t.belongs_to :saved_search, index: true
    end

    create_table :site_listings do |t|
      t.belongs_to :site, :listing
      t.string :identifier, :title, :link, required: true
      t.integer :price, :cashflow, :revenue

      t.text :description
      t.string :city, :state, :business_url

      t.integer :ffe, :inventory, :real_estate, :hours_required
      t.string :reason_selling, :established, :employees
      t.boolean :seller_financing, :inventory_included, :real_estate_included

      t.timestamps null: false
    end
  end
end