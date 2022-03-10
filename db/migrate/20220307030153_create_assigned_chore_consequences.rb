class CreateAssignedChoreConsequences < ActiveRecord::Migration[7.0]
  def change
    create_table :assigned_chore_consequences do |t|
      t.references :assigned_chore, null: false, foreign_key: true
      t.references :consequence, null: false, foreign_key: true

      t.timestamps
    end
  end
end
