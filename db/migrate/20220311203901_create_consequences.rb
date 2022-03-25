class CreateConsequences < ActiveRecord::Migration[7.0]
  def change
    create_table :consequences do |t|
      t.references :assignment, null: false, foreign_key: true
      t.references :crew,       null: false, foreign_key: true
      t.integer    :value,      null: false, default: 0
      t.integer    :duration,   null: false, default: 0
      t.integer    :category,   null: false, default: 0

      t.timestamps
    end
  end
end
