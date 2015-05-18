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

ActiveRecord::Schema.define(version: 20150514185156) do

  create_table "events", force: :cascade do |t|
    t.integer  "user_id",     limit: 4,                  null: false
    t.string   "description", limit: 64,                 null: false
    t.string   "event_type",  limit: 64
    t.date     "event_date",                             null: false
    t.boolean  "recur",       limit: 1,  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friends", id: false, force: :cascade do |t|
    t.integer  "user_id",    limit: 4, null: false
    t.integer  "friend_id",  limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friends", ["friend_id"], name: "index_friends_on_friend_id", using: :btree
  add_index "friends", ["user_id"], name: "index_friends_on_user_id", using: :btree

  create_table "gifts", force: :cascade do |t|
    t.integer  "user_id",     limit: 4,                                  null: false
    t.string   "description", limit: 256,                                null: false
    t.string   "url",         limit: 256
    t.decimal  "price",                   precision: 10
    t.boolean  "multi",       limit: 1,                  default: false
    t.boolean  "hidden",      limit: 1,                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gifts", ["user_id"], name: "index_gifts_on_user_id", using: :btree

  create_table "gifts_tags", force: :cascade do |t|
    t.integer "tag_id",  limit: 4
    t.integer "gift_id", limit: 4
  end

  add_index "gifts_tags", ["tag_id", "gift_id"], name: "index_taggings_on_tag_id_and_taggable_id_and_taggable_type", using: :btree

  create_table "givings", id: false, force: :cascade do |t|
    t.integer  "user_id",    limit: 4,                  null: false
    t.integer  "gift_id",    limit: 4,                  null: false
    t.string   "intent",     limit: 4, default: "will", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "givings", ["user_id", "gift_id"], name: "index_givings_on_user_id_and_gift_id", unique: true, using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 32
    t.integer "taggings_count", limit: 4,  default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "login",             limit: 255
    t.string   "email",             limit: 255
    t.string   "crypted_password",  limit: 255,                  null: false
    t.string   "password_salt",     limit: 255, default: "",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "persistence_token", limit: 255
    t.string   "role",              limit: 32,  default: "user", null: false
    t.string   "postal_code",       limit: 16
    t.integer  "lead_time",         limit: 4
    t.integer  "lead_frequency",    limit: 4,   default: 1,      null: false
    t.string   "notes",             limit: 255
    t.datetime "current_login_at"
    t.datetime "last_login_at"
  end

  add_index "users", ["login"], name: "index_users_on_login", using: :btree
  add_index "users", ["persistence_token"], name: "index_users_on_persistence_token", using: :btree

end
