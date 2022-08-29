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

ActiveRecord::Schema[7.0].define(version: 2022_07_08_171540) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brackets", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "admin_id", default: 1
    t.integer "game_state", default: -1, null: false
    t.index ["code"], name: "index_brackets_on_code", unique: true
  end

  create_table "brackets_users", id: false, force: :cascade do |t|
    t.bigint "bracket_id", null: false
    t.bigint "user_id", null: false
    t.index ["bracket_id"], name: "index_brackets_users_on_bracket_id"
    t.index ["user_id"], name: "index_brackets_users_on_user_id"
  end

  create_table "choices", force: :cascade do |t|
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "bracket_id"
    t.string "reasoning"
    t.index ["bracket_id"], name: "index_choices_on_bracket_id"
    t.index ["user_id"], name: "index_choices_on_user_id"
  end

  create_table "initial_votes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "choice_id", null: false
    t.bigint "bracket_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bracket_id"], name: "index_initial_votes_on_bracket_id"
    t.index ["choice_id"], name: "index_initial_votes_on_choice_id"
    t.index ["user_id"], name: "index_initial_votes_on_user_id"
  end

  create_table "matchups", force: :cascade do |t|
    t.bigint "round_id", null: false
    t.integer "first_choice_id"
    t.integer "second_choice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_matchups_on_round_id"
  end

  create_table "readies", force: :cascade do |t|
    t.bigint "ready_bracket_id", null: false
    t.bigint "ready_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ready_bracket_id"], name: "index_readies_on_ready_bracket_id"
    t.index ["ready_user_id"], name: "index_readies_on_ready_user_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.bigint "bracket_id", null: false
    t.boolean "active", default: false
    t.integer "round_num", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bracket_id"], name: "index_rounds_on_bracket_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "matchup_id", null: false
    t.integer "choice_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["matchup_id"], name: "index_votes_on_matchup_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "choices", "brackets"
  add_foreign_key "choices", "users"
  add_foreign_key "initial_votes", "brackets"
  add_foreign_key "initial_votes", "choices"
  add_foreign_key "initial_votes", "users"
  add_foreign_key "matchups", "rounds"
  add_foreign_key "readies", "brackets", column: "ready_bracket_id"
  add_foreign_key "readies", "users", column: "ready_user_id"
  add_foreign_key "rounds", "brackets"
  add_foreign_key "votes", "matchups"
  add_foreign_key "votes", "users"
end
