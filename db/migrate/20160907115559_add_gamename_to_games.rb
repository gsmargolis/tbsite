class AddGamenameToGames < ActiveRecord::Migration
  def change
    add_column :games, :gamename, :string
  end
end
