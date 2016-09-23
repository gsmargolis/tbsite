class AddCbsIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cbs_id, :string
  end
end
