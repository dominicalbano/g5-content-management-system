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

ActiveRecord::Schema.define(:version => 20121126164637) do

  create_table "clients", :force => true do |t|
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "features", :force => true do |t|
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "uid"
    t.string   "name"
    t.boolean  "corporate"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "page_layouts", :force => true do |t|
    t.string   "url"
    t.string   "name"
    t.integer  "page_id"
    t.text     "html"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "page_layouts", ["page_id"], :name => "index_page_layouts_on_page_id"

  create_table "pages", :force => true do |t|
    t.integer  "location_id"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "pages", ["location_id"], :name => "index_pages_on_location_id"

  create_table "themes", :force => true do |t|
    t.string   "url"
    t.string   "name"
    t.integer  "page_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "themes", ["page_id"], :name => "index_themes_on_page_id"

  create_table "widgets", :force => true do |t|
    t.string   "url"
    t.string   "name"
    t.integer  "page_id"
    t.integer  "position"
    t.text     "html"
    t.text     "css"
    t.text     "javascript"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "widgets", ["page_id"], :name => "index_widgets_on_page_id"

end
