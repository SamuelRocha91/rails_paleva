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

ActiveRecord::Schema[7.1].define(version: 2024_12_28_013752) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "beverages", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_alcoholic"
    t.string "calories"
    t.integer "establishment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status", default: true
    t.index ["establishment_id"], name: "index_beverages_on_establishment_id"
  end

  create_table "cancellations", force: :cascade do |t|
    t.integer "order_id", null: false
    t.text "justification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_cancellations_on_order_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "cpf"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discount_offers", force: :cascade do |t|
    t.integer "offer_id", null: false
    t.integer "discount_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discount_id"], name: "index_discount_offers_on_discount_id"
    t.index ["offer_id"], name: "index_discount_offers_on_offer_id"
  end

  create_table "discounts", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.decimal "percent", precision: 4, scale: 2
    t.integer "limit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "establishment_id", null: false
    t.index ["establishment_id"], name: "index_discounts_on_establishment_id"
  end

  create_table "dish_tags", force: :cascade do |t|
    t.integer "dish_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dish_id"], name: "index_dish_tags_on_dish_id"
    t.index ["tag_id"], name: "index_dish_tags_on_tag_id"
  end

  create_table "dishes", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "calories"
    t.integer "establishment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status", default: true
    t.index ["establishment_id"], name: "index_dishes_on_establishment_id"
  end

  create_table "establishments", force: :cascade do |t|
    t.string "trade_name"
    t.string "legal_name"
    t.string "cnpj"
    t.string "address"
    t.string "phone_number"
    t.string "email"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "formats", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_formats_on_name", unique: true
  end

  create_table "menu_items", force: :cascade do |t|
    t.integer "menu_id", null: false
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id", "menu_id", "item_type"], name: "index_menu_items_on_item_id_and_menu_id_and_item_type", unique: true
    t.index ["item_type", "item_id"], name: "index_menu_items_on_item"
    t.index ["menu_id"], name: "index_menu_items_on_menu_id"
  end

  create_table "menus", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "establishment_id"
    t.date "valid_from"
    t.date "valid_until"
    t.index ["establishment_id"], name: "index_menus_on_establishment_id"
    t.index ["name", "establishment_id"], name: "index_menus_on_name_and_establishment_id", unique: true
  end

  create_table "offers", force: :cascade do |t|
    t.integer "format_id", null: false
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.datetime "start_offer"
    t.datetime "end_offer"
    t.boolean "active", default: true
    t.text "details"
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["format_id"], name: "index_offers_on_format_id"
    t.index ["item_type", "item_id"], name: "index_offers_on_item"
  end

  create_table "operating_hours", force: :cascade do |t|
    t.integer "week_day"
    t.time "start_time"
    t.time "end_time"
    t.integer "establishment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_closed"
    t.index ["establishment_id"], name: "index_operating_hours_on_establishment_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "offer_id", null: false
    t.integer "order_id", null: false
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offer_id"], name: "index_order_items_on_offer_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.string "code"
    t.integer "establishment_id", null: false
    t.datetime "accepted_at"
    t.datetime "completed_at"
    t.datetime "delivered_at"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["establishment_id"], name: "index_orders_on_establishment_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "temporary_users", force: :cascade do |t|
    t.string "email"
    t.string "cpf"
    t.integer "establishment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_temporary_users_on_cpf", unique: true
    t.index ["establishment_id"], name: "index_temporary_users_on_establishment_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "establishment_id"
    t.integer "role", default: 0
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "beverages", "establishments"
  add_foreign_key "cancellations", "orders"
  add_foreign_key "discount_offers", "discounts"
  add_foreign_key "discount_offers", "offers"
  add_foreign_key "discounts", "establishments"
  add_foreign_key "dish_tags", "dishes"
  add_foreign_key "dish_tags", "tags"
  add_foreign_key "dishes", "establishments"
  add_foreign_key "menu_items", "menus"
  add_foreign_key "menus", "establishments"
  add_foreign_key "offers", "formats"
  add_foreign_key "operating_hours", "establishments"
  add_foreign_key "order_items", "offers"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "establishments"
  add_foreign_key "temporary_users", "establishments"
  add_foreign_key "users", "establishments"
end
