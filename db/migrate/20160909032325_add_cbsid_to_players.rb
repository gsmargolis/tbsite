class AddCbsidToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :cbsid, :string
  end
end
