class CreateAssignedChores < ActiveRecord::Migration[7.0]
  def change
    create_table :assigned_chores do |t|
      t.references :user,         null: false, foreign_key: true
      t.references :chore,        null: false, foreign_key: true
      t.integer    :reward,       null: false, default: 0
      t.boolean    :completed,    null: false, default: false
      t.boolean    :failed,       null: false, default: false
      t.timestamp  :due_date
      t.text       :note
      t.timestamps
    end
  end
end
