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

ActiveRecord::Schema.define(:version => 20130101161253) do

  create_table "commitments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "goal_id"
    t.integer  "is_current"
    t.integer  "completed",    :default => 0
    t.datetime "completed_at", :default => '2012-12-29 10:07:17'
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "goal_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.text     "post",       :default => ""
  end

  add_index "events", ["goal_id"], :name => "index_events_on_goal_id"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "goals", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "points",       :default => 0
    t.text     "description",  :default => ""
    t.date     "deadline"
    t.integer  "has_deadline", :default => 0
    t.string   "badge"
    t.string   "color"
    t.integer  "owner_id"
    t.integer  "parent_id",    :default => 0
  end

  add_index "goals", ["owner_id"], :name => "index_goals_on_owner_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "uid"
    t.string   "token"
    t.string   "remember_token"
    t.integer  "auto_add",       :default => 0
    t.text     "avatar"
    t.string   "timezone"
  end

end
