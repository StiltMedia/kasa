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

ActiveRecord::Schema.define(version: 20150721145727) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.integer  "preference_order",         default: 1,    null: false
    t.integer  "address_preference_order", default: 1,    null: false
    t.string   "full_street_address"
    t.integer  "street_number"
    t.string   "street_dir_prefix"
    t.string   "street_name"
    t.string   "street_suffix"
    t.string   "street_dir_suffix"
    t.string   "street_additional_info"
    t.integer  "box_number"
    t.string   "unit_number"
    t.string   "city",                                    null: false
    t.string   "state_or_province"
    t.string   "postal_code"
    t.string   "carrier_route"
    t.string   "country",                  default: "US"
    t.integer  "address_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["city"], name: "index_addresses_on_city", using: :btree
  add_index "addresses", ["country"], name: "index_addresses_on_country", using: :btree
  add_index "addresses", ["postal_code"], name: "index_addresses_on_postal_code", using: :btree
  add_index "addresses", ["state_or_province"], name: "index_addresses_on_state_or_province", using: :btree

  create_table "addresses_businesses", id: false, force: :cascade do |t|
    t.integer "address_id",  null: false
    t.integer "business_id", null: false
  end

  add_index "addresses_businesses", ["address_id", "business_id"], name: "index_addresses_businesses_on_address_id_and_business_id", unique: true, using: :btree

  create_table "addresses_listing_offices", id: false, force: :cascade do |t|
    t.integer "address_id",        null: false
    t.integer "listing_office_id", null: false
  end

  add_index "addresses_listing_offices", ["address_id", "listing_office_id"], name: "index_address_offices_address_id_office_id", unique: true, using: :btree

  create_table "addresses_listings", id: false, force: :cascade do |t|
    t.integer "address_id", null: false
    t.integer "listing_id", null: false
  end

  add_index "addresses_listings", ["address_id", "listing_id"], name: "index_addresses_listings_on_address_id_and_listing_id", unique: true, using: :btree
  add_index "addresses_listings", ["listing_id"], name: "index_addresses_listings_on_listing_id", using: :btree

  create_table "businesses", force: :cascade do |t|
    t.string   "name",                            null: false
    t.string   "type",                            null: false
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.string   "website_url"
    t.string   "logo_url"
    t.string   "business_additional_information"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "businesses", ["name"], name: "index_businesses_on_name", using: :btree
  add_index "businesses", ["type"], name: "index_businesses_on_type", using: :btree

  create_table "businesses_listings", id: false, force: :cascade do |t|
    t.integer "business_id", null: false
    t.integer "listing_id",  null: false
  end

  add_index "businesses_listings", ["business_id", "listing_id"], name: "index_businesses_listings_on_business_id_and_listing_id", unique: true, using: :btree
  add_index "businesses_listings", ["listing_id"], name: "index_businesses_listings_on_listing_id", using: :btree

  create_table "enumerals", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "type",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "enumerals", ["name"], name: "index_enumerals_on_name", using: :btree
  add_index "enumerals", ["type"], name: "index_enumerals_on_type", using: :btree

  create_table "enumerals_listings", id: false, force: :cascade do |t|
    t.integer "enumeral_id", null: false
    t.integer "listing_id",  null: false
  end

  add_index "enumerals_listings", ["enumeral_id", "listing_id"], name: "index_enumerals_listings_on_enumeral_id_and_listing_id", unique: true, using: :btree
  add_index "enumerals_listings", ["listing_id"], name: "index_enumerals_listings_on_listing_id", using: :btree

  create_table "expenses", force: :cascade do |t|
    t.integer  "expense_category_id"
    t.integer  "currency_period_id"
    t.decimal  "expense_value"
    t.integer  "listing_id",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "expenses", ["currency_period_id"], name: "index_expenses_on_currency_period_id", using: :btree
  add_index "expenses", ["expense_category_id"], name: "index_expenses_on_expense_category_id", using: :btree
  add_index "expenses", ["listing_id"], name: "index_expenses_on_listing_id", using: :btree

  create_table "listing_media", force: :cascade do |t|
    t.string   "media_url",                    null: false
    t.string   "media_caption"
    t.text     "media_description"
    t.string   "media_modification_timestamp"
    t.string   "type",                         null: false
    t.integer  "listing_id",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "listing_media", ["listing_id"], name: "index_listing_media_on_listing_id", using: :btree
  add_index "listing_media", ["media_url"], name: "index_listing_media_on_media_url", using: :btree
  add_index "listing_media", ["type"], name: "index_listing_media_on_type", using: :btree

  create_table "listing_offices", force: :cascade do |t|
    t.string   "office_key",             null: false
    t.string   "office_identifier",      null: false
    t.string   "level"
    t.string   "office_code_identifier"
    t.string   "name",                   null: false
    t.string   "corporate_name"
    t.string   "broker_identifier"
    t.string   "main_office_identifier"
    t.string   "phone_number"
    t.string   "fax_number"
    t.string   "office_email"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "listing_offices", ["broker_identifier"], name: "index_listing_offices_on_broker_identifier", using: :btree
  add_index "listing_offices", ["main_office_identifier"], name: "index_listing_offices_on_main_office_identifier", using: :btree
  add_index "listing_offices", ["office_code_identifier"], name: "index_listing_offices_on_office_code_identifier", using: :btree
  add_index "listing_offices", ["office_identifier"], name: "index_listing_offices_on_office_identifier", using: :btree
  add_index "listing_offices", ["office_key"], name: "index_listing_offices_on_office_key", using: :btree

  create_table "listing_offices_listings", id: false, force: :cascade do |t|
    t.integer "listing_office_id", null: false
    t.integer "listing_id",        null: false
  end

  add_index "listing_offices_listings", ["listing_id"], name: "index_listing_offices_listings_on_listing_id", using: :btree
  add_index "listing_offices_listings", ["listing_office_id", "listing_id"], name: "index_listings_offices_listing_id_office_id", unique: true, using: :btree

  create_table "listing_providers", force: :cascade do |t|
    t.string   "name",                        null: false
    t.string   "url"
    t.integer  "source_provider_category_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "listing_providers", ["source_provider_category_id"], name: "index_listing_providers_on_source_provider_category_id", using: :btree

  create_table "listing_services", force: :cascade do |t|
    t.string   "identifier", null: false
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "listings", force: :cascade do |t|
    t.integer  "list_price",                      limit: 8
    t.string   "currency_code",                                                      default: "USD"
    t.integer  "list_price_low",                  limit: 8
    t.string   "listing_url"
    t.integer  "listing_provider_id"
    t.string   "lead_routing_email"
    t.integer  "bedrooms"
    t.integer  "bathrooms"
    t.integer  "property_type_id",                                                                                                                                                      null: false
    t.string   "property_type_description"
    t.integer  "property_sub_type_id",                                                                                                                                                  null: false
    t.string   "property_sub_type_description"
    t.string   "listing_key",                                                                                                                                                           null: false
    t.integer  "listing_category_id",                                                                                                                                                   null: false
    t.integer  "listing_status_id",                                                                                                                                                     null: false
    t.boolean  "permit_address_on_internet"
    t.boolean  "vow_address_display"
    t.boolean  "vow_automated_valuation_display"
    t.boolean  "vow_consumer_comment"
    t.boolean  "disclose_address"
    t.boolean  "short_sale"
    t.text     "listing_description"
    t.integer  "listing_service_id"
    t.string   "listing_service_identifier"
    t.integer  "living_area"
    t.string   "living_area_unit",                                                   default: "SQFT"
    t.float    "lot_size"
    t.string   "lot_size_unit"
    t.date     "listing_date"
    t.string   "tracking_item"
    t.text     "listing_title"
    t.integer  "full_bathrooms"
    t.integer  "three_quarter_bathrooms"
    t.integer  "half_bathrooms"
    t.integer  "one_quarter_bathrooms"
    t.integer  "partial_bathrooms"
    t.decimal  "latitude",                                  precision: 10, scale: 6
    t.decimal  "longitude",                                 precision: 10, scale: 6
    t.integer  "county_id"
    t.integer  "community_id"
    t.text     "directions"
    t.string   "elevation"
    t.string   "geocode_options"
    t.string   "parcel_info"
    t.integer  "zoning_type_id"
    t.integer  "year_built"
    t.integer  "year_updated"
    t.integer  "building_unit_count"
    t.integer  "num_floors"
    t.integer  "condo_floor_num"
    t.integer  "num_parking_spaces"
    t.integer  "room_count"
    t.text     "legal_description"
    t.integer  "foreclosure_status_id"
    t.integer  "architectural_style_id"
    t.string   "modification_timestamp"
    t.string   "disclaimer",                                                         default: "Listing information is believed accurate but may contain errors, omissions or changes."
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "listings", ["architectural_style_id"], name: "index_listings_on_architectural_style_id", using: :btree
  add_index "listings", ["bathrooms"], name: "index_listings_on_bathrooms", using: :btree
  add_index "listings", ["bedrooms"], name: "index_listings_on_bedrooms", using: :btree
  add_index "listings", ["community_id"], name: "index_listings_on_community_id", using: :btree
  add_index "listings", ["county_id"], name: "index_listings_on_county_id", using: :btree
  add_index "listings", ["foreclosure_status_id"], name: "index_listings_on_foreclosure_status_id", using: :btree
  add_index "listings", ["latitude"], name: "index_listings_on_latitude", using: :btree
  add_index "listings", ["list_price"], name: "index_listings_on_list_price", using: :btree
  add_index "listings", ["listing_category_id"], name: "index_listings_on_listing_category_id", using: :btree
  add_index "listings", ["listing_date"], name: "index_listings_on_listing_date", using: :btree
  add_index "listings", ["listing_key"], name: "index_listings_on_listing_key", using: :btree
  add_index "listings", ["listing_provider_id"], name: "index_listings_on_listing_provider_id", using: :btree
  add_index "listings", ["listing_service_id"], name: "index_listings_on_listing_service_id", using: :btree
  add_index "listings", ["listing_service_identifier"], name: "index_listings_on_listing_service_identifier", using: :btree
  add_index "listings", ["listing_status_id"], name: "index_listings_on_listing_status_id", using: :btree
  add_index "listings", ["living_area"], name: "index_listings_on_living_area", using: :btree
  add_index "listings", ["longitude"], name: "index_listings_on_longitude", using: :btree
  add_index "listings", ["lot_size"], name: "index_listings_on_lot_size", using: :btree
  add_index "listings", ["property_sub_type_id"], name: "index_listings_on_property_sub_type_id", using: :btree
  add_index "listings", ["property_type_id"], name: "index_listings_on_property_type_id", using: :btree
  add_index "listings", ["year_built"], name: "index_listings_on_year_built", using: :btree
  add_index "listings", ["zoning_type_id"], name: "index_listings_on_zoning_type_id", using: :btree

  create_table "listings_participants", id: false, force: :cascade do |t|
    t.integer "listing_id",     null: false
    t.integer "participant_id", null: false
  end

  add_index "listings_participants", ["listing_id"], name: "index_listings_participants_on_listing_id", using: :btree
  add_index "listings_participants", ["participant_id", "listing_id"], name: "index_listings_participants_on_participant_id_and_listing_id", unique: true, using: :btree

  create_table "listings_places", id: false, force: :cascade do |t|
    t.integer "listing_id", null: false
    t.integer "place_id",   null: false
  end

  add_index "listings_places", ["listing_id", "place_id"], name: "index_listings_places_on_listing_id_and_place_id", unique: true, using: :btree
  add_index "listings_places", ["listing_id"], name: "index_listings_places_on_listing_id", using: :btree

  create_table "open_houses", force: :cascade do |t|
    t.date     "showing_date"
    t.time     "start_time"
    t.time     "end_time"
    t.text     "description"
    t.integer  "listing_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "open_houses", ["end_time"], name: "index_open_houses_on_end_time", using: :btree
  add_index "open_houses", ["listing_id"], name: "index_open_houses_on_listing_id", using: :btree
  add_index "open_houses", ["showing_date"], name: "index_open_houses_on_showing_date", using: :btree
  add_index "open_houses", ["start_time"], name: "index_open_houses_on_start_time", using: :btree

  create_table "participant_licenses", force: :cascade do |t|
    t.integer  "license_category_id", null: false
    t.string   "license_number"
    t.string   "jurisdiction"
    t.string   "state_or_province"
    t.integer  "participant_id",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participant_licenses", ["license_category_id"], name: "index_participant_licenses_on_license_category_id", using: :btree
  add_index "participant_licenses", ["participant_id"], name: "index_participant_licenses_on_participant_id", using: :btree

  create_table "participants", force: :cascade do |t|
    t.string   "participant_key"
    t.string   "participant_identifier"
    t.string   "participant_code"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "person_id"
    t.integer  "participant_role_id",    null: false
    t.string   "primary_contact_phone"
    t.string   "office_phone"
    t.string   "mobile_phone"
    t.string   "email"
    t.string   "fax"
    t.string   "website_url"
    t.string   "photo_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participants", ["participant_identifier"], name: "index_participants_on_participant_identifier", using: :btree
  add_index "participants", ["participant_key"], name: "index_participants_on_participant_key", using: :btree
  add_index "participants", ["participant_role_id"], name: "index_participants_on_participant_role_id", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "person_key"
    t.string   "personal_title"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "nick_name"
    t.string   "last_name"
    t.string   "suffix"
    t.date     "birthdate"
    t.integer  "gender_id"
    t.string   "preferred_locale",       default: "en-US"
    t.string   "modification_timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", force: :cascade do |t|
    t.string   "name",                             null: false
    t.string   "city"
    t.string   "state_or_province"
    t.string   "country",           default: "US", null: false
    t.string   "type",                             null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "places", ["city"], name: "index_places_on_city", using: :btree
  add_index "places", ["country"], name: "index_places_on_country", using: :btree
  add_index "places", ["name"], name: "index_places_on_name", using: :btree
  add_index "places", ["state_or_province"], name: "index_places_on_state_or_province", using: :btree
  add_index "places", ["type"], name: "index_places_on_type", using: :btree

  create_table "places_schools", id: false, force: :cascade do |t|
    t.integer "place_id",  null: false
    t.integer "school_id", null: false
  end

  add_index "places_schools", ["place_id", "school_id"], name: "index_places_schools_on_place_id_and_school_id", unique: true, using: :btree

  create_table "properties", force: :cascade do |t|
    t.string   "mls_listing_number"
    t.string   "mls_name"
    t.string   "mls_sources"
    t.date     "mls_date_added"
    t.date     "mls_date_modified"
    t.integer  "street_number"
    t.string   "street_name"
    t.string   "unit_number"
    t.string   "city"
    t.integer  "zip"
    t.string   "location"
    t.string   "full_address"
    t.string   "property_type"
    t.text     "last_update_description"
    t.text     "short_last_update_description"
    t.string   "status"
    t.decimal  "current_list_price"
    t.decimal  "sold_price"
    t.decimal  "sqft"
    t.decimal  "sqft_price"
    t.decimal  "lot_sqft"
    t.integer  "year_built"
    t.string   "listing_office"
    t.string   "condition"
    t.integer  "bedrooms"
    t.decimal  "half_bathrooms"
    t.integer  "full_bathrooms"
    t.integer  "favorited"
    t.integer  "fake_favorited"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "properties", ["full_address"], name: "index_properties_on_full_address", unique: true, using: :btree
  add_index "properties", ["mls_listing_number"], name: "index_properties_on_mls_listing_number", unique: true, using: :btree

  create_table "rooms", force: :cascade do |t|
    t.integer  "room_category_id"
    t.integer  "listing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rooms", ["listing_id"], name: "index_rooms_on_listing_id", using: :btree
  add_index "rooms", ["room_category_id"], name: "index_rooms_on_room_category_id", using: :btree

  create_table "schools", force: :cascade do |t|
    t.string   "name"
    t.integer  "school_category_id", null: false
    t.string   "district"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schools", ["school_category_id"], name: "index_schools_on_school_category_id", using: :btree

  create_table "taxes", force: :cascade do |t|
    t.integer  "year"
    t.decimal  "amount",      null: false
    t.string   "description"
    t.integer  "listing_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taxes", ["listing_id"], name: "index_taxes_on_listing_id", using: :btree

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
    t.string   "name"
    t.string   "phone"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
