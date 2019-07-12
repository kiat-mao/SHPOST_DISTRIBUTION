class OrderDetailLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :order_detail
end
