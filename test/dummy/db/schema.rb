# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2016_03_10_030821) do

  create_table "calls", force: :cascade do |t|
    t.string "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "custom_auto_increments", force: :cascade do |t|
    t.string "counter_model_name"
    t.integer "counter", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "counter_model_scope"
    t.index ["counter_model_name", "counter_model_scope"], name: "counter_model_name_scope", unique: true
    t.index ["counter_model_name"], name: "index_custom_auto_increments_on_counter_model_name"
  end

  create_table "protocols", force: :cascade do |t|
    t.string "number"
    t.string "context"
    t.string "context_2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
