class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :weeknum
      t.datetime :startdt
      t.string :awayteam
      t.string :hometeam
      t.float :line
      t.integer :awayscore
      t.integer :homescore
      t.text :currentstatus
      t.boolean :ismnf

      t.timestamps null: false
    end
  end
end
