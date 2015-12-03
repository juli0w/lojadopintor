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

ActiveRecord::Schema.define(version: 20151127174620) do

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "alternative_id"
    t.integer  "level"
    t.boolean  "active"
    t.string   "slug"
  end

  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true

  create_table "coupons", force: :cascade do |t|
    t.string   "name"
    t.decimal  "value",         precision: 8, scale: 2
    t.decimal  "decimal",       precision: 8, scale: 2
    t.integer  "discount_type"
    t.datetime "expire_at"
    t.integer  "owner_id"
    t.boolean  "active",                                default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "line_products", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "cellphone"
    t.text     "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "order_id"
    t.decimal  "unit_price",  precision: 12, scale: 3
    t.integer  "quantity"
    t.decimal  "total_price", precision: 12, scale: 3
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id"
  add_index "order_items", ["product_id"], name: "index_order_items_on_product_id"

  create_table "order_statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.decimal  "subtotal",           precision: 12, scale: 3
    t.decimal  "total",              precision: 12, scale: 3
    t.integer  "order_status_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "customer_name"
    t.string   "customer_phone"
    t.string   "customer_cellphone"
    t.string   "shipping_address"
    t.string   "shipping_uf"
    t.string   "shipping_city"
    t.string   "shipping_cep"
    t.integer  "user_id"
    t.integer  "coupon_id"
    t.decimal  "shipping_price",     precision: 8,  scale: 2
    t.integer  "shipping_method"
  end

  add_index "orders", ["order_status_id"], name: "index_orders_on_order_status_id"

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price",           precision: 12, scale: 3
    t.boolean  "active"
    t.text     "description"
    t.string   "excerpt"
    t.decimal  "tax",             precision: 12, scale: 3
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "image"
    t.integer  "category_id"
    t.decimal  "width",           precision: 8,  scale: 2
    t.decimal  "weight",          precision: 8,  scale: 2
    t.decimal  "height",          precision: 8,  scale: 2
    t.decimal  "depth",           precision: 8,  scale: 2
    t.integer  "alternative_id"
    t.string   "slug"
    t.integer  "line_product_id"
  end

  add_index "products", ["category_id"], name: "index_products_on_category_id"
  add_index "products", ["slug"], name: "index_products_on_slug", unique: true

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",                   default: 0
    t.string   "name"
    t.string   "phone"
    t.string   "cellphone"
    t.string   "address"
    t.string   "uf"
    t.string   "city"
    t.string   "cep"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
