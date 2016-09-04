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

ActiveRecord::Schema.define(version: 20160903215453) do

  create_table "awards", force: :cascade do |t|
    t.string   "type"
    t.integer  "weeknum"
    t.integer  "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "awards", ["player_id"], name: "index_awards_on_player_id"

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
  end

  create_table "picks", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "weeknum"
    t.integer  "game_id"
    t.string   "type"
    t.string   "pick"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "picks", ["game_id"], name: "index_picks_on_game_id"
  add_index "picks", ["player_id"], name: "index_picks_on_player_id"

  create_table "players", force: :cascade do |t|
    t.text     "playername"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
