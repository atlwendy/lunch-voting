# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_10_18_174934) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "invitations", force: :cascade do |t|
    t.string "recipient_email"
    t.string "string"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sender_id"
  end

  create_table "meeting_memberships", force: :cascade do |t|
    t.integer "meeting_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "going", limit: 10
  end

  create_table "meeting_restaurant_selections", force: :cascade do |t|
    t.integer "meeting_id"
    t.integer "restaurant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meetings", force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.datetime "date", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "reminder_sent"
    t.boolean "result_sent"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo_url"
    t.string "yelp_rating"
    t.string "categories"
    t.integer "review_count", default: 0
  end

  create_table "user_mrs_votecounts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "mrs_id"
    t.integer "vote_counts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "password_digest"
    t.string "remember_token"
    t.integer "invitation_id"
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  create_table "votes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "meeting_restaurant_selection_id"
    t.integer "vote_counts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
