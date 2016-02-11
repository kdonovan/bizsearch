class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :listing_id
      t.text :body

      t.timestamps null: false
    end
  end
end
