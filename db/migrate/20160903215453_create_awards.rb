class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.string :type
      t.integer :weeknum
      t.references :player, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
