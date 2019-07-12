class OrderDetail < ActiveRecord::Base
  belongs_to :order
  belongs_to :at_unit, class_name: "Unit"
  belongs_to :commodity

  has_many :order_detail_logs

  before_create :generate_no


  validates :amount, :price, :order, :commodity, presence: {:message => "不能为空"}

  validates :amount, numericality: {:greater_than => 0 }

  validates :price, numericality: { only_integer: true, :greater_than => 0 }

  enum status: { waiting: 'waiting', checking: 'checking', rechecking: 'rechecking', receiving: 'receiving', closed: 'closed', canceled: 'canceled' , pending: 'pending', declined: 'declined'}

  STATUS_NAME = { waiting: '待处理', checking: '待审核', rechecking: '待复核', receiving: '待收货', closed: '结单', canceled: '取消', pending: '审核被驳回', declined: '复核被驳回'}

  def status_name
    status.blank? ? "" : OrderDetail::STATUS_NAME["#{status}".to_sym]
  end

  def can_update?
    waiting? || pending?
  end

  def can_destroy?
    waiting?
  end

  private
  def generate_no
    count = (OrderDetail.where(order: self.order).count + 1).to_s.rjust(3, '0')
    self.no = "#{self.order.no}-#{count}"
  end
end
