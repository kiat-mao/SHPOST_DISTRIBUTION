class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :sno, :null => false, :unique => true
      t.string :name, :null => false
      t.datetime :valid_before
      t.boolean :is_valid, :null => false, :default => true

      t.timestamps
    end
  end
end
