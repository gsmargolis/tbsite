class AddGamestatusToGames < ActiveRecord::Migration
  def change
    add_column :games, :status, :string
    add_column :games, :quarter, :string
    add_column :games, :gamedt, :datetime
  end
end
