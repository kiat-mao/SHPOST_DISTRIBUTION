class ChangeOrderDetailsDescToString < ActiveRecord::Migration
  def change
    remove_column :order_details, :desc
    add_column :order_details, :desc, :string
  end
end
