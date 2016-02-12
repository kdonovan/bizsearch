# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160210231753) do

  create_table "listings", force: :cascade do |t|
    t.string   "status",     limit: 255, default: "unseen"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "listings", ["status"], name: "index_listings_on_status", using: :btree

  create_table "listings_saved_searches", id: false, force: :cascade do |t|
    t.integer "listing_id",      limit: 4
    t.integer "saved_search_id", limit: 4
  end

  add_index "listings_saved_searches", ["listing_id"], name: "index_listings_saved_searches_on_listing_id", using: :btree
  add_index "listings_saved_searches", ["saved_search_id"], name: "index_listings_saved_searches_on_saved_search_id", using: :btree

  create_table "notes", force: :cascade do |t|
    t.integer  "listing_id", limit: 4
    t.text     "body",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "saved_searches", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "state",        limit: 255
    t.string   "city",         limit: 255
    t.string   "keyword",      limit: 255
    t.integer  "min_price",    limit: 4
    t.integer  "max_price",    limit: 4
    t.integer  "min_cashflow", limit: 4
    t.integer  "max_cashflow", limit: 4
    t.integer  "priority",     limit: 4,   default: 10
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "saved_searches", ["priority"], name: "index_saved_searches_on_priority", using: :btree

  create_table "site_listings", force: :cascade do |t|
    t.integer  "source_id",            limit: 4
    t.integer  "listing_id",           limit: 4
    t.string   "identifier",           limit: 255
    t.string   "title",                limit: 255
    t.string   "link",                 limit: 255
    t.integer  "price",                limit: 4
    t.integer  "cashflow",             limit: 4
    t.integer  "revenue",              limit: 4
    t.text     "description",          limit: 65535
    t.string   "city",                 limit: 255
    t.string   "state",                limit: 255
    t.integer  "ffe",                  limit: 4
    t.integer  "inventory",            limit: 4
    t.integer  "real_estate",          limit: 4
    t.integer  "employees",            limit: 4
    t.integer  "established",          limit: 4
    t.string   "reason_selling",       limit: 255
    t.boolean  "seller_financing"
    t.boolean  "inventory_included"
    t.boolean  "real_estate_included"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "sources", force: :cascade do |t|
    t.string "name", limit: 255
  end

end
