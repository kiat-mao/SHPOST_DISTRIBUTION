class OrderDetail < ActiveRecord::Base
  belongs_to :order
  belongs_to :at_unit, class_name: "Unit"

  before_create :generate_no

  # validates_presence_of :amount, :price, :commodity, :order, :message => '不能为空'

  validates :amount, :price, :order, presence: {:message => "不能为空"}

  enum status: { waiting: 'waiting', checking: 'checking', rechecking: 'rechecking', receiving: 'receiving', closed: 'closed', canceled: 'canceled' , pending: 'pending', declined: 'declined'}

  private
  def generate_no
    count = (OrderDetail.where(order: order).count + 1).to_s.rjust(3, '0')
    self.no = "#{self.order.no}-#{count}"
  end
end
