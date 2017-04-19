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

ActiveRecord::Schema.define(version: 20170419054611) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "guild_permissions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "guild_id"
    t.integer  "permissions"
    t.boolean  "owner"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "guild_permissions", ["guild_id"], name: "index_guild_permissions_on_guild_id", using: :btree
  add_index "guild_permissions", ["user_id"], name: "index_guild_permissions_on_user_id", using: :btree

  create_table "guilds", force: :cascade do |t|
    t.string   "name"
    t.string   "uid"
    t.string   "icon"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "announcement_channel"
  end

  add_index "guilds", ["uid"], name: "index_guilds_on_uid", unique: true, using: :btree

  create_table "phases", force: :cascade do |t|
    t.integer  "raid_id"
    t.string   "name"
    t.datetime "start"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "phases", ["raid_id"], name: "index_phases_on_raid_id", using: :btree

  create_table "raids", force: :cascade do |t|
    t.integer  "guild_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "raid_type"
  end

  add_index "raids", ["guild_id"], name: "index_raids_on_guild_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "uid"
    t.string   "discriminator"
    t.string   "avatar"
    t.boolean  "verified"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "token"
    t.string   "refresh_token"
  end

  add_index "users", ["uid"], name: "index_users_on_uid", unique: true, using: :btree

end
