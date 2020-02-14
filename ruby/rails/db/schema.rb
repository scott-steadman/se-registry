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

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",                                null: false
    t.string   "description", limit: 64,                 null: false
    t.string   "event_type",  limit: 64
    t.date     "event_date",                             null: false
    t.boolean  "recur",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friends", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",    null: false
    t.integer  "friend_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["friend_id"], name: "index_friends_on_friend_id", using: :btree
    t.index ["user_id"], name: "index_friends_on_user_id", using: :btree
  end

  create_table "gifts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",                                                null: false
    t.string   "description", limit: 256,                                null: false
    t.string   "url",         limit: 256
    t.decimal  "price",                   precision: 10
    t.boolean  "multi",                                  default: false
    t.boolean  "hidden",                                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_gifts_on_user_id", using: :btree
  end

  create_table "gifts_tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "tag_id"
    t.integer "gift_id"
    t.index ["tag_id", "gift_id"], name: "index_taggings_on_tag_id_and_taggable_id_and_taggable_type", using: :btree
  end

  create_table "givings", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "user_id",                               null: false
    t.integer  "gift_id",                               null: false
    t.string   "intent",     limit: 4, default: "will", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id", "gift_id"], name: "index_givings_on_user_id_and_gift_id", unique: true, using: :btree
  end

  create_table "taggings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
  end

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name",           limit: 32
    t.integer "taggings_count",            default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",                              null: false
    t.string   "password_salt",                default: "",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "persistence_token"
    t.string   "role",              limit: 32, default: "user", null: false
    t.string   "postal_code",       limit: 16
    t.integer  "lead_time"
    t.integer  "lead_frequency",               default: 1,      null: false
    t.string   "notes"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.index ["login"], name: "index_users_on_login", using: :btree
    t.index ["persistence_token"], name: "index_users_on_persistence_token", using: :btree
  end

end
