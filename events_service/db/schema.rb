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

ActiveRecord::Schema.define(version: 2021_11_06_181241) do

  create_table "bought_tickets", force: :cascade do |t|
    t.integer "booking_id"
    t.string "ticket_FIO"
    t.integer "ticket_age"
    t.integer "ticket_price"
    t.string "ticket_type"
    t.integer "doc_num"
    t.string "doc_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "event_id", null: false
    t.index ["event_id"], name: "index_bought_tickets_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "event_name"
    t.date "event_date"
    t.integer "general_feels"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ticket_types", force: :cascade do |t|
    t.string "ticket_type"
    t.integer "count"
    t.integer "init_price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "event_id", null: false
    t.index ["event_id"], name: "index_ticket_types_on_event_id"
  end

  add_foreign_key "bought_tickets", "events"
  add_foreign_key "ticket_types", "events"
end
