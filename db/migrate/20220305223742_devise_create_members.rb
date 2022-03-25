# frozen_string_literal: true

class DeviseCreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.string      :first_name,      null: false, default: ""
      t.string      :last_name,       null: false, default: ""
      t.integer     :role,            null: false, default: 0
      t.integer     :rewards_balance, null: false, default: 0
      t.references  :crew,            null: false, foreign_key: true
      t.string      :slug

      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :last_sign_in_at


      t.timestamps null: false
    end

    add_index :members, :slug,                 unique: true
    add_index :members, :email,                unique: true
    add_index :members, :reset_password_token, unique: true
  end
end
