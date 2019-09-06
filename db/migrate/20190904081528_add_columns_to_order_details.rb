class AddColumnsToOrderDetails < ActiveRecord::Migration
  def change
  	add_column :order_details, :check_at, :datetime
  	add_column :order_details, :recheck_at, :datetime
  end
end
