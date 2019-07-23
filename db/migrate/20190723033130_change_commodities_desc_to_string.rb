class ChangeCommoditiesDescToString < ActiveRecord::Migration
  def change
    remove_column :commodities, :desc
    add_column :commodities, :desc, :string
  end
end
