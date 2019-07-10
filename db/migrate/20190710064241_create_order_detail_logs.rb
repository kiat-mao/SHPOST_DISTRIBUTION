class CreateOrderDetailLogs < ActiveRecord::Migration
  def change
    create_table :order_detail_logs do |t|
      t.string   :operation
      t.string   :desc

      t.references :user
      t.references :order_detail

      t.timestamps null: false
    end
  end
end
