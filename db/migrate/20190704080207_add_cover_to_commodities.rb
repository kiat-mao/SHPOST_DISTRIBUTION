class AddCoverToCommodities < ActiveRecord::Migration
  def change
    add_column :commodities, :cover, :string
  end
end
