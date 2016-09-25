class AddIdToViewdatum < ActiveRecord::Migration
  def change
    add_column :viewdata, :id, :primary_key
  end
end
