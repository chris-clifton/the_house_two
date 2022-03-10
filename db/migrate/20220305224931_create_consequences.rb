class CreateConsequences < ActiveRecord::Migration[7.0]
  def change
    create_table :consequences do |t|
      t.references  :user,              null: false, foreign_key: true
      t.integer     :value,             null: false, foreign_key: true
      t.references  :consequence_type,  null: false, foreign_key: true
      t.boolean     :completed,         null: false, default: false
      t.text        :note
      t.timestamps
    end
  end
end
