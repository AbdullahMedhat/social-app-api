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

ActiveRecord::Schema.define(version: 20180910003849) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.string  "title",          default: "", null: false
    t.string  "description",    default: "", null: false
    t.integer "list_id",                     null: false
    t.integer "user_id",                     null: false
    t.integer "comments_count", default: 0
  end

  add_index "cards", ["list_id"], name: "index_cards_on_list_id", using: :btree
  add_index "cards", ["user_id"], name: "index_cards_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "content",    default: "", null: false
    t.integer  "user_id",                 null: false
    t.integer  "card_id"
    t.integer  "replay_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "comments", ["card_id"], name: "index_comments_on_card_id", using: :btree
  add_index "comments", ["replay_id"], name: "index_comments_on_replay_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "list_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "list_users", ["list_id"], name: "index_list_users_on_list_id", using: :btree
  add_index "list_users", ["user_id", "list_id"], name: "index_list_users_on_user_id_and_list_id", unique: true, using: :btree
  add_index "list_users", ["user_id"], name: "index_list_users_on_user_id", using: :btree

  create_table "lists", force: :cascade do |t|
    t.string  "title",   default: "", null: false
    t.integer "user_id",              null: false
  end

  add_index "lists", ["user_id"], name: "index_lists_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string  "provider",           default: "email", null: false
    t.string  "uid",                default: "",      null: false
    t.string  "email",                                null: false
    t.string  "encrypted_password", default: "",      null: false
    t.boolean "admin",              default: false,   null: false
    t.string  "username",           default: "",      null: false
    t.json    "tokens"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

end
