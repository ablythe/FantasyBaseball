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

ActiveRecord::Schema.define(version: 20150712175259) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "players", force: :cascade do |t|
    t.integer  "mlb_id"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "user_id"
    t.string   "team"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "position"
    t.boolean  "rookie_status", default: false
    t.integer  "roster_id"
  end

  create_table "rosters", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "forty_five"
    t.boolean "minor"
  end

  create_table "team_pitching_stats_for_days", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "date",                        null: false
    t.integer  "pitching_starts", default: 0, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "team_pitching_stats_for_days", ["user_id", "date"], name: "index_team_pitching_stats_for_days_on_user_id_and_date", unique: true, using: :btree
  add_index "team_pitching_stats_for_days", ["user_id"], name: "index_team_pitching_stats_for_days_on_user_id", using: :btree

  create_table "team_scrapers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "starts",                 default: 0
    t.integer  "yahoo_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "yahoo_api_tokens", force: :cascade do |t|
    t.string   "oauth_token"
    t.string   "oauth_token_secret"
    t.string   "oauth_session_handle"
    t.datetime "token_expires_in"
    t.datetime "authorization_expires_in"
    t.string   "yahoo_guid"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_foreign_key "team_pitching_stats_for_days", "users"
end
