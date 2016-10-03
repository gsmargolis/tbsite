class AddLastlogonToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lastlogon, :datetime
  end
end
