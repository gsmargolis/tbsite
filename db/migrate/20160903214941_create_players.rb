class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.text :playername

      t.timestamps null: false
    end
  end
end
