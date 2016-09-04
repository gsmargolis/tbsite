class Changeawards < ActiveRecord::Migration
  def change
    change_table :awards do |a|
      a.rename :type, :awardtype
    end
  end
end
