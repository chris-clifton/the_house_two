class CreateConsequenceTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :consequence_types do |t|
      t.string :name,   null: false, default: ""
      t.integer :unit,  null: false, default: 0
      t.timestamps
    end
  end
end
