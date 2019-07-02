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

ActiveRecord::Schema.define(version: 20190701055556) do

  create_table "commodities", force: true do |t|
    t.string   "cno",                        null: false
    t.string   "dms_no",                     null: false
    t.string   "name",                       null: false
    t.integer  "supplier_id",                null: false
    t.float    "cost_price",                 null: false
    t.float    "sell_price",                 null: false
    t.string   "desc"
    t.boolean  "is_on_sell",  default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "import_files", force: true do |t|
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

  create_table "roles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "unit_id"
    t.string   "role",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suppliers", force: true do |t|
    t.string   "sno",                         null: false
    t.string   "name",                        null: false
    t.datetime "valid_before"
    t.boolean  "is_valid",     default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "desc",       limit: 255
    t.string   "no",         limit: 255
    t.string   "short_name", limit: 255
    t.string   "tcbd_khdh",  limit: 255
    t.integer  "level"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "units", ["name"], name: "index_units_on_name", unique: true

  create_table "up_downloads", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "use",        limit: 255
    t.string   "desc",       limit: 255
    t.string   "ver_no",     limit: 255
    t.string   "url",        limit: 255
    t.datetime "oper_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_logs", force: :cascade do |t|
    t.integer  "user_id",                        default: 0,  null: false
    t.string   "operation",          limit: 255, default: "", null: false
    t.string   "object_class",       limit: 255
    t.integer  "object_primary_key"
    t.string   "object_symbol",      limit: 255
    t.string   "desc",               limit: 255
    t.integer  "parent_id"
    t.string   "parent_type",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "username",               limit: 255, default: "", null: false
    t.string   "role",                   limit: 255, default: "", null: false
    t.string   "name",                   limit: 255
    t.integer  "unit_id"
    t.datetime "locked_at"
    t.integer  "failed_attempts",                    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
