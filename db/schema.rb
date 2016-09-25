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

ActiveRecord::Schema.define(version: 20160925174955) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "awards", force: :cascade do |t|
    t.string   "awardtype"
    t.integer  "weeknum"
    t.integer  "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "awards", ["player_id"], name: "index_awards_on_player_id", using: :btree

  create_table "games", force: :cascade do |t|
    t.integer  "weeknum"
    t.datetime "startdt"
    t.string   "awayteam"
    t.string   "hometeam"
    t.float    "line"
    t.integer  "awayscore"
    t.integer  "homescore"
    t.text     "currentstatus"
    t.boolean  "ismnf"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "gamename"
    t.string   "status"
    t.string   "quarter"
    t.datetime "gamedt"
    t.string   "gameclock"
  end

  create_table "logs", force: :cascade do |t|
    t.datetime "startdt"
    t.text     "action"
    t.text     "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "picks", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "weeknum"
    t.integer  "game_id"
    t.string   "picktype"
    t.string   "gamepick"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "picks", ["game_id"], name: "index_picks_on_game_id", using: :btree
  add_index "picks", ["player_id"], name: "index_picks_on_player_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.text     "playername"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "division"
    t.string   "cbsid"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "cbs_id"
  end

  create_table "viewdata", force: :cascade do |t|
    t.text     "viewdata"
    t.string   "viewtype"
    t.integer  "weeknum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
