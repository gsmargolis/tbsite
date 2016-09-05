class AddDivisionToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :division, :text
  end
end
