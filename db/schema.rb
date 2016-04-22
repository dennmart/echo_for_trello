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

ActiveRecord::Schema.define(version: 20160422120245) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "card_logs", force: :cascade do |t|
    t.integer  "card_id",    null: false
    t.integer  "user_id",    null: false
    t.boolean  "successful", null: false
    t.text     "message"
    t.datetime "created_at", null: false
  end

  add_index "card_logs", ["card_id"], name: "index_card_logs_on_card_id", using: :btree
  add_index "card_logs", ["user_id"], name: "index_card_logs_on_user_id", using: :btree

  create_table "cards", force: :cascade do |t|
    t.integer  "user_id",                          null: false
    t.string   "title",                            null: false
    t.text     "description"
    t.string   "trello_board_id",                  null: false
    t.string   "trello_list_id",                   null: false
    t.integer  "frequency",                        null: false
    t.integer  "frequency_period"
    t.boolean  "disabled",         default: false
    t.datetime "next_run"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "position"
  end

  add_index "cards", ["next_run"], name: "index_cards_on_next_run", using: :btree
  add_index "cards", ["user_id"], name: "index_cards_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider",    null: false
    t.string   "uid",         null: false
    t.string   "full_name"
    t.string   "nickname"
    t.string   "oauth_token"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "time_zone"
  end

  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", using: :btree

end
