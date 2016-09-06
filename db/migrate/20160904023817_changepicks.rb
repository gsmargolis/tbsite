class Changepicks < ActiveRecord::Migration
  def change
    change_table :picks do |t|
      t.rename :type, :picktype
      t.rename :pick, :gamepick
    
    end
  end
end
