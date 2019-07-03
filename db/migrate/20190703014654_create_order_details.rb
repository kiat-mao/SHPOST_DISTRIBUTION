class CreateOrderDetails < ActiveRecord::Migration
  def change
    create_table :order_details do |t|
      t.string :no, :null => false, :unique => true

      t.integer :amount
      t.decimal :price, :null => false, precision: 5, scale: 2
       
      t.string :status 

      t.text :desc

      t.string :why_decline

      t.datetime :closed_at
      
      t.references :order
      t.references :commodity
      t.references :unit, index: {name: 'at_unit'}

      t.timestamps null: false
    end
  end
end
