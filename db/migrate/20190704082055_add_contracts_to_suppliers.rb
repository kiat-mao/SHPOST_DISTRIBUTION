class AddContractsToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :contracts, :string
  end
end
