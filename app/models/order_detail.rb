class OrderDetail < ActiveRecord::Base
  belongs_to :order
  belongs_to :at_unit, class_name: "Unit"
  belongs_to :commodity

  before_create :generate_no


  validates :amount, :price, :order, :commodity, presence: {:message => "不能为空"}

  validates :amount, numericality: {:greater_than => 0 }

  validates :price, numericality: { only_integer: true, :greater_than => 0 }

  enum status: { waiting: 'waiting', checking: 'checking', rechecking: 'rechecking', receiving: 'receiving', closed: 'closed', canceled: 'canceled' , pending: 'pending', declined: 'declined'}

  def can_update?
    waiting? || pending?
  end

  def can_destroy?
    waiting?
  end

  private
  def generate_no
    count = (OrderDetail.where(order: order).count + 1).to_s.rjust(3, '0')
    self.no = "#{self.order.no}-#{count}"
  end
end
