class AddGameclockToGames < ActiveRecord::Migration
  def change
    add_column :games, :gameclock, :string
  end
end
