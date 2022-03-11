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

ActiveRecord::Schema[7.0].define(version: 2022_03_11_205247) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assigned_chores", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "chore_id", null: false
    t.boolean "completed", default: false, null: false
    t.boolean "failed", default: false, null: false
    t.datetime "due_date", precision: nil
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chore_id"], name: "index_assigned_chores_on_chore_id"
    t.index ["user_id"], name: "index_assigned_chores_on_user_id"
  end

  create_table "chores", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_chores_on_name", unique: true
  end

  create_table "consequences", force: :cascade do |t|
    t.bigint "assigned_chore_id", null: false
    t.integer "value", default: 0, null: false
    t.integer "duration", default: 0, null: false
    t.integer "category", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_chore_id"], name: "index_consequences_on_assigned_chore_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.bigint "assigned_chore_id", null: false
    t.integer "value", default: 0, null: false
    t.integer "category", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_chore_id"], name: "index_rewards_on_assigned_chore_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.integer "role", default: 0, null: false
    t.integer "rewards_balance", default: 0, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "last_sign_in_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "assigned_chores", "chores"
  add_foreign_key "assigned_chores", "users"
  add_foreign_key "consequences", "assigned_chores"
  add_foreign_key "rewards", "assigned_chores"
end
