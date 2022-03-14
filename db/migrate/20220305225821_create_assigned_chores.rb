class CreateAssignedChores < ActiveRecord::Migration[7.0]
  def change
    create_table :assigned_chores do |t|
      t.references :user,     null: false, foreign_key: true
      t.references :chore,    null: false, foreign_key: true
      t.integer    :status,   null: false, default: 0
      t.timestamp  :due_date
      t.text       :note
      t.timestamps
    end
  end
end
