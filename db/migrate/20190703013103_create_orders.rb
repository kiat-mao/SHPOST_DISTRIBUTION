class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :no, :null => false, :unique => true
      t.string :name
      t.string :address
      t.string :phone
      t.string :tel

      t.text :desc

      t.references :created_user, foreign_key: {to_table: :user}, index: true
      t.references :created_unit, foreign_key: {to_table: :user}, index: true

      t.timestamps null: false
    end
  end
end