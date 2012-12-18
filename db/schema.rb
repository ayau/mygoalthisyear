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

ActiveRecord::Schema.define(:version => 20121212000047) do

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "goal_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "events", ["goal_id"], :name => "index_events_on_goal_id"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "goals", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.boolean  "completed",    :default => false
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.datetime "completed_at", :default => '2012-12-09 03:13:46', :null => false
    t.integer  "points",       :default => 0
    t.string   "ancestry"
  end

  add_index "goals", ["ancestry"], :name => "index_goals_on_ancestry"
  add_index "goals", ["user_id"], :name => "index_goals_on_user_id"

  create_table "goalsinmonths", :force => true do |t|
    t.integer  "month_id"
    t.integer  "goal_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "months", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "months", ["user_id"], :name => "index_months_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "uid"
    t.string   "token"
    t.string   "remember_token"
  end

end
