class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string      :name,         null: false, default: ""
      t.text        :description,  null: false, default: ""
      t.integer     :category,     null: false, default: 0
      t.references  :crew,         null: false, foreign_key: true

      t.timestamps
    end
  end
end
