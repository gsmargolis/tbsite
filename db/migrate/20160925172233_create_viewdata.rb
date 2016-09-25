class CreateViewdata < ActiveRecord::Migration

  def change
    create_table :viewdata, id: false do |t|
      t.text :viewdata
      t.string :viewtype
      t.integer :weeknum

      t.timestamps null: false
    end
  end
end
