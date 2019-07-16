class OrderDetail < ActiveRecord::Base
  belongs_to :order
  belongs_to :at_unit, class_name: "Unit"
  belongs_to :commodity

  has_many :order_detail_logs, dependent: :destroy

  before_create :generate_no

  validates :amount, :price, :order, :commodity, presence: {:message => "不能为空"}

  validates :amount, numericality: {only_integer: true, :greater_than => 0 }

  validates :price, numericality: {:greater_than => 0 }

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

  def has_checked?
    order_detail_logs.exists?(operation: ['to_recheck', 'check_decline'])
  end

  def has_rechecked?
    order_detail_logs.exists?(operation: ['place', 'recheck_decline'])
  end


  def checking!
    self.at_unit = Unit::DELIVERY
    super
  end

  def rechecking!
    self.at_unit = Unit::POSTBUY
    super
  end

  def pending!
    self.at_unit = self.order.unit
    super
  end

  def receiving!
    self.at_unit = self.order.unit
    super
  end

  def declined!
    self.at_unit = Unit::DELIVERY
    super
  end

  private
  def generate_no
    count = (OrderDetail.where(order: self.order).count + 1).to_s.rjust(3, '0')
    self.no = "#{self.order.no}-#{count}"
  end
end
