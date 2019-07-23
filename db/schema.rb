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

ActiveRecord::Schema.define(version: 20190718070133) do

  create_table "commodities", force: :cascade do |t|
    t.string   "cno",                                                null: false
    t.string   "dms_no",                                             null: false
    t.string   "name",                                               null: false
    t.integer  "supplier_id",                                        null: false
    t.decimal  "cost_price",  precision: 5, scale: 2,                null: false
    t.decimal  "sell_price",  precision: 5, scale: 2,                null: false
    t.text     "desc"
    t.boolean  "is_on_sell",                          default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cover"
  end

  create_table "import_files", force: :cascade do |t|
    t.string   "file_name",                            null: false
    t.string   "file_path",               default: "", null: false
    t.integer  "user_id"
    t.integer  "unit_id"
    t.integer  "symbol_id"
    t.string   "symbol_type"
    t.string   "size"
    t.string   "category"
    t.string   "file_ext"
    t.string   "desc",        limit: 200
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_detail_logs", force: :cascade do |t|
    t.string   "operation"
    t.string   "desc"
    t.integer  "user_id"
    t.integer  "order_detail_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "order_details", force: :cascade do |t|
    t.string   "no",                                    null: false
    t.integer  "amount"
    t.decimal  "price",        precision: 10, scale: 2, null: false
    t.string   "status"
    t.text     "desc"
    t.string   "why_decline"
    t.datetime "closed_at"
    t.integer  "order_id"
    t.integer  "commodity_id"
    t.integer  "at_unit_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.decimal  "cost_price",   precision: 10, scale: 2
  end

  add_index "order_details", ["at_unit_id"], name: "index_order_details_on_at_unit_id"

  create_table "orders", force: :cascade do |t|
    t.string   "no",                        null: false
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "tel"
    t.text     "desc"
    t.integer  "user_id"
    t.integer  "unit_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "is_fresh",   default: true
  end

  add_index "orders", ["unit_id"], name: "index_orders_on_unit_id"
  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "roles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "unit_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string   "sno",                         null: false
    t.string   "name",                        null: false
    t.datetime "valid_before"
    t.boolean  "is_valid",     default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contracts"
  end

  create_table "units", force: :cascade do |t|
    t.string   "name"
    t.string   "desc"
    t.string   "no"
    t.string   "short_name"
    t.string   "tcbd_khdh"
    t.integer  "level"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unit_type"
  end

  add_index "units", ["name"], name: "index_units_on_name", unique: true

  create_table "up_downloads", force: :cascade do |t|
    t.string   "name"
    t.string   "use"
    t.string   "desc"
    t.string   "ver_no"
    t.string   "url"
    t.datetime "oper_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_logs", force: :cascade do |t|
    t.integer  "user_id",            default: 0,  null: false
    t.string   "operation",          default: "", null: false
    t.string   "object_class"
    t.integer  "object_primary_key"
    t.string   "object_symbol"
    t.string   "desc"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "username",               default: "", null: false
    t.string   "role",                   default: "", null: false
    t.string   "name"
    t.integer  "unit_id"
    t.datetime "locked_at"
    t.integer  "failed_attempts",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
