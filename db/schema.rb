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

ActiveRecord::Schema.define(version: 20141021202057) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", force: true do |t|
    t.string   "url"
    t.integer  "website_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", force: true do |t|
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "vertical"
    t.string   "type"
    t.string   "domain"
    t.string   "organization"
  end

  create_table "drop_targets", force: true do |t|
    t.integer  "web_template_id"
    t.string   "html_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "g5_authenticatable_users", force: true do |t|
    t.string   "email",              default: "",   null: false
    t.string   "provider",           default: "g5", null: false
    t.string   "uid",                               null: false
    t.string   "g5_access_token"
    t.integer  "sign_in_count",      default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "g5_authenticatable_users", ["email"], name: "index_g5_authenticatable_users_on_email", unique: true, using: :btree
  add_index "g5_authenticatable_users", ["provider", "uid"], name: "index_g5_authenticatable_users_on_provider_and_uid", unique: true, using: :btree

  create_table "garden_web_layouts", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "url"
    t.string   "thumbnail"
    t.text     "stylesheets"
    t.text     "html"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "garden_web_themes", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "url"
    t.string   "thumbnail"
    t.text     "javascripts"
    t.text     "stylesheets"
    t.string   "primary_color"
    t.string   "secondary_color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "garden_widgets", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "url"
    t.string   "thumbnail"
    t.text     "edit_html"
    t.string   "edit_javascript"
    t.text     "show_html"
    t.string   "show_javascript"
    t.text     "lib_javascripts"
    t.text     "show_stylesheets"
    t.text     "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "widget_type"
    t.integer  "widget_id"
  end

  create_table "locations", force: true do |t|
    t.string   "uid"
    t.string   "name"
    t.boolean  "corporate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "urn"
    t.string   "state"
    t.string   "city"
    t.string   "street_address"
    t.string   "postal_code"
    t.string   "domain"
    t.string   "city_slug"
    t.string   "phone_number"
    t.string   "neighborhood"
    t.string   "primary_amenity"
    t.string   "primary_landmark"
    t.string   "qualifier"
    t.string   "floor_plans"
    t.string   "status",           default: "Pending"
  end

  add_index "locations", ["urn"], name: "index_locations_on_urn", using: :btree

  create_table "settings", force: true do |t|
    t.string   "name"
    t.text     "value"
    t.boolean  "editable"
    t.string   "default_value"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "owner_type"
    t.text     "categories"
    t.integer  "priority"
    t.integer  "website_id"
  end

  add_index "settings", ["website_id"], name: "index_settings_on_website_id", using: :btree

  create_table "sibling_deploys", force: true do |t|
    t.integer  "sibling_id"
    t.integer  "instruction_id"
    t.boolean  "manual"
    t.string   "state"
    t.string   "git_repo"
    t.string   "heroku_repo"
    t.string   "heroku_app_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sibling_instructions", force: true do |t|
    t.string   "uid"
    t.string   "name"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "siblings", force: true do |t|
    t.string   "uid"
    t.string   "name"
    t.string   "git_repo"
    t.string   "heroku_repo"
    t.string   "heroku_app_name"
    t.boolean  "main_app"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "web_layouts", force: true do |t|
    t.integer  "web_template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "garden_web_layout_id"
  end

  add_index "web_layouts", ["garden_web_layout_id"], name: "index_web_layouts_on_garden_web_layout_id", using: :btree
  add_index "web_layouts", ["web_template_id"], name: "index_web_layouts_on_web_template_id", using: :btree

  create_table "web_templates", force: true do |t|
    t.integer  "website_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.boolean  "template",          default: false
    t.string   "title"
    t.string   "type"
    t.boolean  "enabled"
    t.integer  "display_order"
    t.string   "redirect_patterns"
    t.boolean  "in_trash"
    t.integer  "parent_id"
  end

  add_index "web_templates", ["website_id"], name: "index_web_templates_on_website_id", using: :btree

  create_table "web_themes", force: true do |t|
    t.integer  "web_template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "custom_colors"
    t.string   "custom_primary_color"
    t.string   "custom_secondary_color"
    t.integer  "garden_web_theme_id"
  end

  add_index "web_themes", ["garden_web_theme_id"], name: "index_web_themes_on_garden_web_theme_id", using: :btree
  add_index "web_themes", ["web_template_id"], name: "index_web_themes_on_web_template_id", using: :btree

  create_table "websites", force: true do |t|
    t.integer  "owner_id"
    t.string   "urn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "owner_type"
  end

  add_index "websites", ["owner_id"], name: "index_websites_on_owner_id", using: :btree

  create_table "widget_entries", force: true do |t|
    t.integer  "widget_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "widgets", force: true do |t|
    t.integer  "drop_target_id"
    t.integer  "display_order"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "section"
    t.boolean  "removeable"
    t.integer  "garden_widget_id"
  end

  add_index "widgets", ["drop_target_id"], name: "index_widgets_on_drop_target_id", using: :btree
  add_index "widgets", ["garden_widget_id"], name: "index_widgets_on_garden_widget_id", using: :btree

end
