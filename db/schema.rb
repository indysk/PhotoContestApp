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

ActiveRecord::Schema.define(version: 2021_09_16_030046) do

  create_table "contests", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.datetime "entry_start_at", null: false
    t.datetime "entry_end_at", null: false
    t.datetime "vote_start_at", null: false
    t.datetime "vote_end_at", null: false
    t.integer "visible_range_entry", null: false
    t.integer "visible_range_vote", null: false
    t.integer "visible_range_show", null: false
    t.integer "visible_range_result", null: false
    t.integer "voting_points", null: false
    t.integer "num_of_views_in_result", null: false
    t.integer "visible_setting_for_user_name", null: false
    t.string "limited_url_entry", default: "", null: false
    t.string "limited_url_vote", default: "", null: false
    t.string "limited_url_show", default: "", null: false
    t.string "limited_url_result", default: "", null: false
    t.index ["limited_url_entry"], name: "index_contests_on_limited_url_entry"
    t.index ["limited_url_result"], name: "index_contests_on_limited_url_result"
    t.index ["limited_url_show"], name: "index_contests_on_limited_url_show"
    t.index ["limited_url_vote"], name: "index_contests_on_limited_url_vote"
    t.index ["user_id"], name: "fk_rails_95cc4b10b0"
  end

  create_table "photos", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "user_id"
    t.string "contest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photographer"
    t.text "description"
    t.string "camera"
    t.string "lens"
    t.string "iso"
    t.string "aperture"
    t.string "shutter_speed"
    t.string "image"
    t.index ["contest_id"], name: "fk_rails_f9368fe956"
    t.index ["user_id"], name: "fk_rails_c79d76afc0"
  end

  create_table "users", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "user_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["user_id"], name: "index_users_on_user_id", unique: true
  end

  create_table "votes", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "contest_id", null: false
    t.string "photo_id", null: false
    t.string "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "point", null: false
    t.index ["contest_id"], name: "fk_rails_2e961e225e"
    t.index ["photo_id"], name: "fk_rails_e0710e95e4"
    t.index ["user_id"], name: "fk_rails_c9b3bef597"
  end

  add_foreign_key "contests", "users"
  add_foreign_key "photos", "contests"
  add_foreign_key "photos", "users"
  add_foreign_key "votes", "contests"
  add_foreign_key "votes", "photos"
  add_foreign_key "votes", "users"
end
