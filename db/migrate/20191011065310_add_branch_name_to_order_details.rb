class AddBranchNameToOrderDetails < ActiveRecord::Migration
  def change
  	add_column :order_details, :branch_name, :string
  	add_column :order_details, :branch_no, :string, :limit => 8
  end
end
