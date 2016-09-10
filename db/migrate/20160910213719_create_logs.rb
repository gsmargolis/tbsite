class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.datetime :startdt
      t.text :action
      t.text :result

      t.timestamps null: false
    end
  end
end
