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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120821060918) do

  create_table "cities", :force => true do |t|
    t.integer  "human"
    t.float    "food"
    t.integer  "gold"
    t.float    "tax_rate"
    t.integer  "pos_x"
    t.integer  "pos_y"
    t.string   "name"
    t.boolean  "capital"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "cities", ["capital", "user_id"], :name => "index_cities_on_capital_and_user_id"
  add_index "cities", ["capital"], :name => "index_cities_on_capital"
  add_index "cities", ["user_id"], :name => "index_cities_on_user_id"

  create_table "fights", :force => true do |t|
    t.integer  "origin_city_id"
    t.integer  "target_city_id"
    t.integer  "status"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "solider_queues", :force => true do |t|
    t.integer  "city_id"
    t.integer  "solider_num"
    t.integer  "solider_kind"
    t.integer  "status",       :default => 0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "solider_queues", ["city_id", "status"], :name => "index_solider_queues_on_city_id_and_status"
  add_index "solider_queues", ["city_id"], :name => "index_solider_queues_on_city_id"

  create_table "soliders", :force => true do |t|
    t.integer  "kind"
    t.integer  "city_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "status",     :default => 1
    t.integer  "fight_id"
  end

  add_index "soliders", ["city_id"], :name => "index_soliders_on_city_id"
  add_index "soliders", ["status", "kind", "city_id"], :name => "index_soliders_on_status_and_kind_and_city_id"
  add_index "soliders", ["status"], :name => "index_soliders_on_status"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "users", ["name"], :name => "index_users_on_name", :unique => true

end
