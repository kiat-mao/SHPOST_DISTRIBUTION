class CreateCommodities < ActiveRecord::Migration
  def change
    create_table :commodities do |t|
      t.string :cno, :null => false, :unique => true
      t.string :dms_no, :null => false
      t.string :name, :null => false
      t.integer :supplier_id, :null => false
      t.number :cost_price, :null => false
      t.number :sell_price, :null => false
      t.text :desc
      t.boolean :is_on_sell, :null => false, :default => true

      t.timestamps
    end
  end
end
