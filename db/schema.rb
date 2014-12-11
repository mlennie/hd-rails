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

ActiveRecord::Schema.define(version: 20141211173754) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "cuisines", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorite_restaurants", force: true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.boolean  "archived"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorite_restaurants", ["restaurant_id"], name: "index_favorite_restaurants_on_restaurant_id", using: :btree
  add_index "favorite_restaurants", ["user_id"], name: "index_favorite_restaurants_on_user_id", using: :btree

  create_table "invoices", force: true do |t|
    t.float    "previous_balance"
    t.float    "additional_balance"
    t.integer  "hd_percent"
    t.datetime "due_date"
    t.datetime "date_paid"
    t.string   "confirmation"
    t.float    "total_amount_paid"
    t.integer  "restaurant_id"
    t.boolean  "archived"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoices", ["restaurant_id"], name: "index_invoices_on_restaurant_id", using: :btree

  create_table "promotions", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.text     "description"
    t.float    "amount"
    t.integer  "percent"
    t.boolean  "new_user_only"
    t.datetime "expiry_date"
    t.integer  "usage_limit"
    t.integer  "times_used"
    t.boolean  "archived"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", force: true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.integer  "reservation_id"
    t.integer  "number"
    t.text     "comment"
    t.boolean  "archived"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["reservation_id"], name: "index_ratings_on_reservation_id", using: :btree
  add_index "ratings", ["restaurant_id"], name: "index_ratings_on_restaurant_id", using: :btree
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id", using: :btree

  create_table "related_transactions", force: true do |t|
    t.integer  "transaction_id"
    t.integer  "other_transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "related_transactions", ["other_transaction_id"], name: "index_related_transactions_on_other_transaction_id", using: :btree
  add_index "related_transactions", ["transaction_id"], name: "index_related_transactions_on_transaction_id", using: :btree

  create_table "reservation_errors", force: true do |t|
    t.integer  "reservation_id"
    t.integer  "user_id"
    t.integer  "kind"
    t.text     "description"
    t.boolean  "archived"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reservation_errors", ["reservation_id"], name: "index_reservation_errors_on_reservation_id", using: :btree
  add_index "reservation_errors", ["user_id"], name: "index_reservation_errors_on_user_id", using: :btree

  create_table "reservations", force: true do |t|
    t.string   "confirmation"
    t.integer  "nb_people"
    t.datetime "time"
    t.integer  "status"
    t.datetime "viewed_at"
    t.datetime "cancelled_at"
    t.datetime "validated_at"
    t.datetime "absent_at"
    t.datetime "finalized_at"
    t.integer  "restaurant_id"
    t.integer  "user_id"
    t.integer  "service_id"
    t.float    "bill_amount"
    t.float    "user_balance"
    t.float    "restaurant_balance"
    t.integer  "discount"
    t.float    "user_contribution"
    t.string   "booking_name"
    t.boolean  "archived"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reservations", ["restaurant_id"], name: "index_reservations_on_restaurant_id", using: :btree
  add_index "reservations", ["service_id"], name: "index_reservations_on_service_id", using: :btree
  add_index "reservations", ["user_id"], name: "index_reservations_on_user_id", using: :btree

  create_table "restaurant_cuisines", force: true do |t|
    t.integer  "restaurant_id"
    t.integer  "cuisine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "restaurant_cuisines", ["cuisine_id"], name: "index_restaurant_cuisines_on_cuisine_id", using: :btree
  add_index "restaurant_cuisines", ["restaurant_id"], name: "index_restaurant_cuisines_on_restaurant_id", using: :btree

  create_table "restaurants", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "street"
    t.string   "district"
    t.string   "city"
    t.string   "country"
    t.string   "zipcode"
    t.string   "geocoded_address"
    t.integer  "lat"
    t.integer  "lng"
    t.integer  "user_id"
    t.boolean  "archived"
    t.integer  "wallet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "restaurants", ["user_id"], name: "index_restaurants_on_user_id", using: :btree
  add_index "restaurants", ["wallet_id"], name: "index_restaurants_on_wallet_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", force: true do |t|
    t.integer  "availabilities"
    t.datetime "start_time"
    t.datetime "last_booking_time"
    t.integer  "restaurant_id"
    t.integer  "nb_10"
    t.integer  "nb_15"
    t.integer  "nb_20"
    t.integer  "nb_25"
    t.boolean  "archived"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "services", ["restaurant_id"], name: "index_services_on_restaurant_id", using: :btree

  create_table "transactions", force: true do |t|
    t.integer  "kind"
    t.float    "original_balance"
    t.float    "amount"
    t.boolean  "amount_positive"
    t.float    "final_balance"
    t.string   "confirmation"
    t.string   "itemable_type"
    t.integer  "itemable_id"
    t.string   "concernable_type"
    t.integer  "concernable_id"
    t.boolean  "archived"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["concernable_id"], name: "index_transactions_on_concernable_id", using: :btree
  add_index "transactions", ["itemable_id"], name: "index_transactions_on_itemable_id", using: :btree

  create_table "user_promotions", force: true do |t|
    t.integer  "user_id"
    t.integer  "reservation_id"
    t.integer  "promotion_id"
    t.integer  "usage_case"
    t.boolean  "archived"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_promotions", ["promotion_id"], name: "index_user_promotions_on_promotion_id", using: :btree
  add_index "user_promotions", ["reservation_id"], name: "index_user_promotions_on_reservation_id", using: :btree
  add_index "user_promotions", ["user_id"], name: "index_user_promotions_on_user_id", using: :btree

  create_table "user_roles", force: true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id", using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "users", force: true do |t|
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_name"
    t.string   "first_name"
    t.integer  "referrer_id"
    t.boolean  "referrer_paid"
    t.string   "phone"
    t.date     "birth_date"
    t.string   "gender"
    t.integer  "wallet_id"
    t.string   "street"
    t.string   "district"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zipcode"
    t.string   "geocoded_address"
    t.integer  "lat"
    t.integer  "lng"
    t.boolean  "archived"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["gender"], name: "index_users_on_gender", using: :btree
  add_index "users", ["referrer_id"], name: "index_users_on_referrer_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["wallet_id"], name: "index_users_on_wallet_id", using: :btree

  create_table "wallets", force: true do |t|
    t.float    "balance"
    t.string   "concernable_type"
    t.integer  "concernable_id"
    t.boolean  "archived"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wallets", ["concernable_id"], name: "index_wallets_on_concernable_id", using: :btree

end
