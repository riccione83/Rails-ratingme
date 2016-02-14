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

ActiveRecord::Schema.define(version: 20160212085915) do

  create_table "average_caches", force: :cascade do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "avg",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rates", force: :cascade do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "stars",         null: false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["rateable_id", "rateable_type"], name: "index_rates_on_rateable_id_and_rateable_type"
  add_index "rates", ["rater_id"], name: "index_rates_on_rater_id"

  create_table "rating_caches", force: :cascade do |t|
    t.integer  "cacheable_id"
    t.string   "cacheable_type"
    t.float    "avg",            null: false
    t.integer  "qty",            null: false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rating_caches", ["cacheable_id", "cacheable_type"], name: "index_rating_caches_on_cacheable_id_and_cacheable_type"

  create_table "ratings", force: :cascade do |t|
    t.integer  "review_id"
    t.integer  "user_id"
    t.string   "user_name"
    t.integer  "point"
    t.text     "description"
    t.integer  "rate_question1"
    t.integer  "rate_question2"
    t.integer  "rate_question3"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "reported",       default: "0"
  end

  add_index "ratings", ["review_id"], name: "index_ratings_on_review_id"

  create_table "reviews", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "title"
    t.text     "description"
    t.string   "question1"
    t.string   "question2"
    t.string   "question3"
    t.integer  "isAdvertisement"
    t.string   "adImageLink"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "picture"
    t.string   "reported",        default: "0"
  end

  create_table "users", force: :cascade do |t|
    t.integer  "rating_id"
    t.string   "user_name"
    t.string   "user_password_hash"
    t.string   "user_email"
    t.string   "user_city"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "reported",           default: "0"
    t.string   "device_token"
  end

  add_index "users", ["rating_id"], name: "index_users_on_rating_id"

end
