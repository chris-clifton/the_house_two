class CreateAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :assignments do |t|
      t.references :member,          null: false, foreign_key: true
      t.references :task,            null: false, foreign_key: true
      t.references :crew,            null: false, foreign_key: true
      t.integer    :status,          null: false, default: 0
      t.integer    :reward
      t.boolean    :reward_applied,  null: false, default: false
      t.timestamp  :due_date
      t.text       :note

      t.timestamps
    end
  end
end
