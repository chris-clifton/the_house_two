class CreateRewards < ActiveRecord::Migration[7.0]
  def change
    create_table :rewards do |t|
      t.references :assignment, null: false, foreign_key: true
      t.integer    :value,      null: false, default: 0
      t.integer    :category,   null: false, default: 0

      t.timestamps
    end
  end
end
