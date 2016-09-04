class CreatePicks < ActiveRecord::Migration
  def change
    create_table :picks do |t|
      t.references :player, index: true, foreign_key: true
      t.integer :weeknum
      t.references :game, index: true, foreign_key: true
      t.string :type
      t.string :pick

      t.timestamps null: false
    end
  end
end
