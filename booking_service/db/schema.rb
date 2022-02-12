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

ActiveRecord::Schema.define(version: 2021_11_11_163738) do

  create_table "booking_tickets", force: :cascade do |t|
    t.string "t_type"
    t.integer "t_price"
    t.datetime "t_time"
    t.integer "ticket_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "event_id", null: false
    t.index ["event_id"], name: "index_booking_tickets_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "event_name"
    t.date "event_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ticket_types", force: :cascade do |t|
    t.string "t_type"
    t.integer "t_init_price"
    t.integer "t_init_num"
    t.integer "t_now"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "event_id", null: false
    t.index ["event_id"], name: "index_ticket_types_on_event_id"
  end

  add_foreign_key "booking_tickets", "events"
  add_foreign_key "ticket_types", "events"
end
