class OrderDetail < ActiveRecord::Base
  belongs_to :order
  belongs_to :at_unit, class_name: "Unit"
  belongs_to :commodity

  has_many :order_detail_logs, dependent: :destroy

  before_create :generate_no

  validates :amount, :price, :order, :commodity, presence: {:message => "不能为空"}

  validates :amount, numericality: {only_integer: true, :greater_than => 0 }

  validates :price, numericality: {:greater_than => 0 }

  validates :commodity, uniqueness: {scope: :order,:message => "该订单下已创建过同种商品的子订单"}

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

  def waiting!
    false
  end

  def checking!
    if self.waiting? || self.pending?
      self.at_unit = Unit::DELIVERY
      super
    else
      false
    end
  end

  def rechecking!
    if self.checking? || self.declined?
      self.at_unit = Unit::POSTBUY
      super
    else
      false
    end
  end

  def pending! why_decline = nil
    if self.checking? || self.declined?
      self.why_decline = why_decline
      self.at_unit = self.order.unit
      super()
    else
      false
    end
  end

  def receiving!
    if self.rechecking?
      self.at_unit = self.order.unit
      super
    else
      false
    end
  end

  def declined! why_decline = nil
    if self.rechecking?
      self.why_decline = why_decline
      self.at_unit = Unit::DELIVERY
      super()
    else
      false
    end
  end

  def closed!
    if self.receiving?
      self.closed_at = Time.now
      self.at_unit = self.order.unit
      super
    else
      false
    end
  end

  def canceled!
    self.at_unit = self.order.unit
    super
  end

  private
  def generate_no
    # count = (OrderDetail.where(order: self.order).count + 1).to_s.rjust(3, '0')
    rows = OrderDetail.where(order: self.order).count
    if rows.zero?
      count = 1
    else 
      count = (OrderDetail.where(order: self.order).last.cno.last(3).to_i + 1)
      count = rows + 1 if count < rows + 1
    end

    self.no = "#{self.order.no}-#{count.to_s.rjust(3, '0')}"
  end
end
