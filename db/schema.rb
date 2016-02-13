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

ActiveRecord::Schema.define(version: 20160213230530) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adverts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "property_id"
    t.boolean  "seed"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "adverts", ["property_id"], name: "index_adverts_on_property_id", using: :btree
  add_index "adverts", ["user_id"], name: "index_adverts_on_user_id", using: :btree

  create_table "favorites", force: :cascade do |t|
    t.integer  "property_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "favorites", ["property_id"], name: "index_favorites_on_property_id", using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "favourites", force: :cascade do |t|
    t.integer  "property_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "favourites", ["property_id"], name: "index_favourites_on_property_id", using: :btree
  add_index "favourites", ["user_id"], name: "index_favourites_on_user_id", using: :btree

  create_table "mybkp", id: false, force: :cascade do |t|
    t.integer  "id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "listing_id"
    t.integer  "price"
    t.string   "address"
    t.string   "city"
    t.string   "zip"
    t.string   "state"
    t.integer  "area"
    t.datetime "date"
    t.integer  "beds"
    t.integer  "baths"
    t.integer  "garage"
    t.string   "sysid"
    t.string   "county"
    t.integer  "images_tot"
    t.string   "built"
    t.string   "floor"
    t.string   "ptype"
    t.text     "remarks"
    t.integer  "area_lot"
    t.datetime "last_trans_date"
    t.datetime "last_img_trans_date"
  end

  create_table "offers", force: :cascade do |t|
    t.string   "amount"
    t.string   "funding_source"
    t.string   "pre_approved"
    t.string   "down_payment"
    t.string   "standard_terms"
    t.string   "downpayment_days"
    t.string   "planning_inspections"
    t.string   "request_pest_report"
    t.string   "initial_deposit"
    t.string   "offer_expires"
    t.string   "special_instructions"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "address"
    t.integer  "user_id"
    t.integer  "property_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "request_one_year_home_warranty"
  end

  add_index "offers", ["property_id"], name: "index_offers_on_property_id", using: :btree
  add_index "offers", ["user_id"], name: "index_offers_on_user_id", using: :btree

  create_table "properties", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "listing_id"
    t.integer  "price"
    t.string   "address"
    t.string   "city"
    t.string   "zip"
    t.string   "state"
    t.integer  "area"
    t.datetime "date"
    t.integer  "beds"
    t.integer  "baths"
    t.integer  "garage"
    t.string   "sysid"
    t.string   "county"
    t.integer  "images_tot"
    t.string   "built"
    t.string   "floor"
    t.string   "ptype"
    t.text     "remarks"
    t.integer  "area_lot"
    t.datetime "last_trans_date"
    t.datetime "last_img_trans_date"
    t.boolean  "seed"
    t.boolean  "non_rets"
    t.string   "open_house_beg"
    t.string   "open_house_end"
  end

  create_table "properties_users", id: false, force: :cascade do |t|
    t.integer "property_id", null: false
    t.integer "user_id",     null: false
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
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "seed"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "adverts", "properties"
  add_foreign_key "adverts", "users"
  add_foreign_key "favorites", "properties"
  add_foreign_key "favorites", "users"
  add_foreign_key "favourites", "properties"
  add_foreign_key "favourites", "users"
  add_foreign_key "offers", "properties"
  add_foreign_key "offers", "users"
end
