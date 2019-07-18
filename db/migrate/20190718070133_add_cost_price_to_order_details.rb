class AddCostPriceToOrderDetails < ActiveRecord::Migration
  def change
  	add_column :order_details, :cost_price, :decimal, :precision => 10, :scale => 2
  end
end
