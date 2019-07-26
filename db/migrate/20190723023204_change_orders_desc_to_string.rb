class ChangeOrdersDescToString < ActiveRecord::Migration
  def change
    remove_column :orders, :desc
    add_column :orders, :desc, :string
  end
end
