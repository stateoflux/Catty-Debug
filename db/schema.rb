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

ActiveRecord::Schema.define(:version => 20110510222348) do

  create_table "assemblies", :force => true do |t|
    t.string   "project_name"
    t.integer  "revision"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num_of_r2d2s"
    t.string   "proper_name"
    t.string   "assembly_number"
  end

  create_table "bad_bits", :force => true do |t|
    t.integer  "bad_bit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bad_bits_r2d2_debugs", :id => false, :force => true do |t|
    t.integer "bad_bit_id"
    t.integer "r2d2_debug_id"
  end

  create_table "r2d2_debugs", :force => true do |t|
    t.integer  "r2d2_instance"
    t.string   "interface"
    t.string   "serial_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "assembly_id"
    t.text     "data_read"
  end

  create_table "r2d2s", :force => true do |t|
    t.integer  "assembly_id"
    t.string   "part_number"
    t.integer  "instance"
    t.string   "refdes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rework_requests", :force => true do |t|
    t.string   "board_name"
    t.text     "instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "r2d2_debug_id"
    t.string   "turn_around"
    t.string   "xray"
    t.string   "bake"
    t.string   "serial_numbers"
  end

  create_table "rx_memories", :force => true do |t|
    t.integer  "r2d2_id"
    t.string   "part_number"
    t.integer  "instance"
    t.string   "refdes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tx_memories", :force => true do |t|
    t.integer  "r2d2_id"
    t.string   "part_number"
    t.integer  "instance"
    t.string   "refdes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.string   "first_name"
    t.string   "last_name"
  end

end
