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

ActiveRecord::Schema.define(version: 20140911200915) do

  create_table "invitations", force: true do |t|
    t.string   "recipient_email"
    t.string   "string"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sender_id"
  end

  create_table "meeting_memberships", force: true do |t|
    t.integer  "meeting_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "going",      limit: 10
  end

  create_table "meeting_restaurant_selections", force: true do |t|
    t.integer  "meeting_id"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meetings", force: true do |t|
    t.string   "title",         null: false
    t.string   "description"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "reminder_sent"
    t.boolean  "result_sent"
  end

  create_table "restaurants", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_url"
    t.string   "yelp_rating"
    t.string   "categories"
    t.integer  "review_count", default: 0
  end

  create_table "user_mrs_votecounts", force: true do |t|
    t.integer  "user_id"
    t.integer  "mrs_id"
    t.integer  "vote_counts"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.integer  "invitation_id"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "meeting_restaurant_selection_id"
    t.integer  "vote_counts"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
