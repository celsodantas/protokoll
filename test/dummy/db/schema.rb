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

ActiveRecord::Schema.define(version: 20120222164124) do

  create_table "calls", force: true do |t|
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "custom_auto_increments", force: true do |t|
    t.string   "model_name"
    t.integer  "counter",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_auto_increments", ["model_name"], name: "index_custom_auto_increments_on_model_name"

  create_table "protocols", force: true do |t|
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
