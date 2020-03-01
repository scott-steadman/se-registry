# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 9) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.bigint "user_id"
    t.string "description", null: false
    t.string "event_type", default: "Event"
    t.date "event_date", null: false
    t.boolean "recur", default: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "friends", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "friend_id", null: false
    t.index ["friend_id"], name: "index_friends_on_friend_id"
    t.index ["user_id", "friend_id"], name: "index_friends_on_user_id_and_friend_id", unique: true
  end

  create_table "gifts", force: :cascade do |t|
    t.bigint "user_id"
    t.string "description", null: false
    t.string "url"
    t.boolean "multi", default: false
    t.boolean "hidden", default: false
    t.float "price"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["user_id"], name: "index_gifts_on_user_id"
  end

  create_table "givings", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "gift_id"
    t.string "intent", default: "will", null: false
    t.index ["gift_id"], name: "index_givings_on_gift_id"
    t.index ["user_id", "gift_id"], name: "index_givings_on_user_id_and_gift_id", unique: true
    t.index ["user_id"], name: "index_givings_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "login", null: false
    t.string "role", default: "user", null: false
    t.string "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.string "crypted_password", null: false
    t.string "password_salt", null: false
    t.string "persistence_token"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.integer "lead_time", default: 10
    t.integer "lead_frequency", default: 10
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login"], name: "index_users_on_login"
    t.index ["persistence_token"], name: "index_users_on_persistence_token", unique: true
  end

  add_foreign_key "events", "users"
  add_foreign_key "friends", "users"
  add_foreign_key "friends", "users", column: "friend_id"
  add_foreign_key "gifts", "users"
  add_foreign_key "givings", "gifts"
  add_foreign_key "givings", "users"
  add_foreign_key "taggings", "tags"
end
