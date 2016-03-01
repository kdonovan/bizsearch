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

ActiveRecord::Schema.define(version: 20160301160000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "listings", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "status",     default: "unseen"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "listings", ["status"], name: "index_listings_on_status", using: :btree
  add_index "listings", ["user_id"], name: "index_listings_on_user_id", using: :btree

  create_table "listings_saved_searches", id: false, force: :cascade do |t|
    t.integer "listing_id"
    t.integer "saved_search_id"
  end

  add_index "listings_saved_searches", ["listing_id"], name: "index_listings_saved_searches_on_listing_id", using: :btree
  add_index "listings_saved_searches", ["saved_search_id"], name: "index_listings_saved_searches_on_saved_search_id", using: :btree

  create_table "notes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "listing_id"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "notes", ["listing_id"], name: "index_notes_on_listing_id", using: :btree
  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "saved_searches", force: :cascade do |t|
    t.integer  "search_group_id"
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.string   "keyword"
    t.integer  "min_price"
    t.integer  "max_price"
    t.integer  "min_cashflow"
    t.integer  "max_cashflow"
    t.integer  "min_revenue"
    t.integer  "max_revenue"
    t.decimal  "min_ratio",          precision: 3, scale: 1
    t.decimal  "max_ratio",          precision: 3, scale: 1
    t.integer  "min_hours_required"
    t.integer  "max_hours_required"
    t.integer  "priority",                                   default: 10
    t.string   "site_names",                                                           array: true
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
  end

  add_index "saved_searches", ["priority"], name: "index_saved_searches_on_priority", using: :btree
  add_index "saved_searches", ["search_group_id"], name: "index_saved_searches_on_search_group_id", using: :btree

  create_table "search_groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "search_groups", ["user_id"], name: "index_search_groups_on_user_id", using: :btree

  create_table "site_listings", force: :cascade do |t|
    t.integer  "site_id"
    t.integer  "listing_id"
    t.string   "identifier"
    t.string   "title"
    t.string   "link"
    t.integer  "price"
    t.integer  "cashflow"
    t.integer  "revenue"
    t.text     "description"
    t.string   "city"
    t.string   "state"
    t.string   "business_url"
    t.integer  "ffe"
    t.integer  "inventory"
    t.integer  "real_estate"
    t.integer  "employees"
    t.integer  "established"
    t.integer  "hours_required"
    t.string   "reason_selling"
    t.boolean  "seller_financing"
    t.boolean  "inventory_included"
    t.boolean  "real_estate_included"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "sites", force: :cascade do |t|
    t.string "name"
    t.string "kind"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
