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

ActiveRecord::Schema.define(version: 20170724083020) do

  create_table "admin_roles", force: :cascade do |t|
    t.string   "name",              limit: 255,                 null: false
    t.string   "authorizable_type", limit: 255
    t.integer  "authorizable_id",   limit: 4
    t.boolean  "system",            limit: 1,   default: false, null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "admin_roles", ["authorizable_type", "authorizable_id"], name: "index_admin_roles_on_authorizable_type_and_authorizable_id", using: :btree
  add_index "admin_roles", ["name"], name: "index_admin_roles_on_name", using: :btree

  create_table "admin_roles_admin_users", id: false, force: :cascade do |t|
    t.integer "admin_user_id", limit: 4, null: false
    t.integer "admin_role_id", limit: 4, null: false
  end

  add_index "admin_roles_admin_users", ["admin_role_id"], name: "index_admin_roles_admin_users_on_admin_role_id", using: :btree
  add_index "admin_roles_admin_users", ["admin_user_id"], name: "index_admin_roles_admin_users_on_admin_user_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "full_name",              limit: 255,              null: false
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "state",                  limit: 4,   default: 1,  null: false
  end

  add_index "admin_users", ["confirmation_token"], name: "index_admin_users_on_confirmation_token", unique: true, using: :btree
  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "api_requests", force: :cascade do |t|
    t.string   "path",         limit: 255,   null: false
    t.text     "params",       limit: 65535, null: false
    t.integer  "login_id",     limit: 4
    t.integer  "user_id",      limit: 4
    t.string   "ip",           limit: 255,   null: false
    t.integer  "network_type", limit: 4
    t.string   "ssid",         limit: 255
    t.float    "latitude",     limit: 24
    t.float    "longitude",    limit: 24
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "api_requests", ["login_id"], name: "fk_rails_4708e54bd3", using: :btree
  add_index "api_requests", ["user_id"], name: "fk_rails_a68585556a", using: :btree

  create_table "app_version_translations", force: :cascade do |t|
    t.integer  "app_version_id",  limit: 4,     null: false
    t.string   "locale",          limit: 255,   null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "expired_message", limit: 65535
  end

  add_index "app_version_translations", ["app_version_id"], name: "index_app_version_translations_on_app_version_id", using: :btree
  add_index "app_version_translations", ["locale"], name: "index_app_version_translations_on_locale", using: :btree

  create_table "app_versions", force: :cascade do |t|
    t.string   "name",                       limit: 255, null: false
    t.integer  "mobile_operating_system_id", limit: 4,   null: false
    t.datetime "expired_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "app_versions", ["mobile_operating_system_id"], name: "fk_rails_d3579a1031", using: :btree

  create_table "device_manufacturers", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "device_models", force: :cascade do |t|
    t.integer  "device_manufacturer_id", limit: 4,   null: false
    t.string   "name",                   limit: 255, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "device_models", ["device_manufacturer_id"], name: "fk_rails_6a7afbe86b", using: :btree

  create_table "devices", force: :cascade do |t|
    t.integer  "user_id",                            limit: 4
    t.string   "device_token",                       limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "mobile_operating_system_version_id", limit: 4,    null: false
    t.integer  "device_model_id",                    limit: 4,    null: false
    t.string   "unique_identifier",                  limit: 2056, null: false
  end

  add_index "devices", ["device_model_id"], name: "index_devices_on_device_model_id", using: :btree
  add_index "devices", ["mobile_operating_system_version_id"], name: "index_devices_on_mobile_operating_system_version_id", using: :btree
  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id",      limit: 4,     null: false
    t.string   "provider",     limit: 255
    t.string   "uid",          limit: 255
    t.text     "token",        limit: 65535
    t.text     "token_secret", limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "logins", force: :cascade do |t|
    t.string   "code",                               limit: 255,                null: false
    t.integer  "user_id",                            limit: 4
    t.string   "ip",                                 limit: 255,                null: false
    t.integer  "network_type",                       limit: 4,                  null: false
    t.string   "ssid",                               limit: 255
    t.float    "latitude",                           limit: 24
    t.float    "longitude",                          limit: 24
    t.integer  "state",                              limit: 4,   default: 0,    null: false
    t.string   "denied_reason",                      limit: 255
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.integer  "device_id",                          limit: 4
    t.integer  "mobile_operating_system_version_id", limit: 4
    t.string   "locale_language",                    limit: 255, default: "es", null: false
    t.string   "locale_country",                     limit: 255, default: "ES", null: false
    t.integer  "app_version_id",                     limit: 4
  end

  add_index "logins", ["app_version_id"], name: "index_logins_on_app_version_id", using: :btree
  add_index "logins", ["code"], name: "index_logins_on_code", unique: true, using: :btree
  add_index "logins", ["created_at"], name: "index_logins_on_created_at", using: :btree
  add_index "logins", ["device_id"], name: "fk_rails_a57c0f9a6e", using: :btree
  add_index "logins", ["ip"], name: "index_logins_on_ip", using: :btree
  add_index "logins", ["mobile_operating_system_version_id"], name: "index_logins_on_mobile_operating_system_version_id", using: :btree
  add_index "logins", ["user_id"], name: "fk_rails_767ed2de2b", using: :btree

  create_table "mobile_operating_system_versions", force: :cascade do |t|
    t.integer  "mobile_operating_system_id", limit: 4,   null: false
    t.string   "name",                       limit: 255, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "mobile_operating_system_versions", ["mobile_operating_system_id"], name: "fk_rails_9fc83e93fd", using: :btree

  create_table "mobile_operating_systems", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",              limit: 255,                 null: false
    t.string   "authorizable_type", limit: 255
    t.integer  "authorizable_id",   limit: 4
    t.boolean  "system",            limit: 1,   default: false, null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "roles", ["authorizable_type", "authorizable_id"], name: "index_roles_on_authorizable_type_and_authorizable_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4, null: false
    t.integer "role_id", limit: 4, null: false
  end

  add_index "roles_users", ["role_id"], name: "index_roles_users_on_role_id", using: :btree
  add_index "roles_users", ["user_id"], name: "index_roles_users_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255
    t.string   "encrypted_password",     limit: 255
    t.string   "api_key",                limit: 255,             null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "image_file_name",        limit: 255
    t.string   "image_content_type",     limit: 255
    t.integer  "image_file_size",        limit: 4
    t.datetime "image_updated_at"
    t.integer  "state",                  limit: 4,   default: 1, null: false
  end

  add_index "users", ["api_key"], name: "index_users_on_api_key", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255,        null: false
    t.integer  "item_id",    limit: 4,          null: false
    t.string   "event",      limit: 255,        null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object",     limit: 4294967295
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "admin_roles_admin_users", "admin_roles"
  add_foreign_key "admin_roles_admin_users", "admin_users"
  add_foreign_key "api_requests", "logins"
  add_foreign_key "api_requests", "users"
  add_foreign_key "app_versions", "mobile_operating_systems"
  add_foreign_key "device_models", "device_manufacturers"
  add_foreign_key "devices", "device_models"
  add_foreign_key "devices", "mobile_operating_system_versions"
  add_foreign_key "devices", "users"
  add_foreign_key "identities", "users"
  add_foreign_key "logins", "devices"
  add_foreign_key "logins", "mobile_operating_system_versions"
  add_foreign_key "logins", "users"
  add_foreign_key "mobile_operating_system_versions", "mobile_operating_systems"
  add_foreign_key "roles_users", "roles"
  add_foreign_key "roles_users", "users"
end
