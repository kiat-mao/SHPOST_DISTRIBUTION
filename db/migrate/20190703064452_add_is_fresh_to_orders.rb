class AddIsFreshToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :is_fresh, :boolean, :default => true
  end
end
