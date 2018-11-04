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

ActiveRecord::Schema.define(version: 2018_11_04_133714) do

  create_table "meeting_configs", force: :cascade do |t|
    t.string "start_time"
    t.integer "time_limit"
    t.text "yesterday_tips"
    t.text "today_tips"
    t.text "trouble_tips"
    t.string "bearychat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "risk_tips"
    t.boolean "show_risk"
    t.boolean "show_trouble"
    t.integer "end_time_number"
    t.integer "start_time_number"
  end

  create_table "meeting_messages", force: :cascade do |t|
    t.integer "meeting_config_id"
    t.string "uid"
    t.text "yesterday_tips"
    t.text "today_tips"
    t.text "trouble_tips"
    t.text "risk_tips"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "channel_id"
  end

end
