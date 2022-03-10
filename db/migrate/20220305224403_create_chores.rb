class CreateChores < ActiveRecord::Migration[7.0]
  def change
    create_table :chores do |t|
      t.string :name,         null: false, default: ""
      t.text   :description,  null: false, default: ""
      t.timestamps
    end

    add_index :chores, :name, unique: true
  end
end
