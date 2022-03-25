class CreateCrews < ActiveRecord::Migration[7.0]
  def change
    create_table :crews do |t|
      t.string :name, null: false
      t.string :slug

      t.timestamps

      t.index :name, unique: true
      t.index :slug, unique: true
    end
  end
end
