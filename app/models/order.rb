class Order < ActiveRecord::Base
  has_many :order_details
  belongs_to :user
  belongs_to :unit

  before_create :generate_no

  validates :name, :address, :unit, presence: { :message => "不能为空" }

  validates :phone, presence: { :message => "电话或手机不能都为空" }, if: "tel.blank?"

  # validates :tel, presence: { :message => "电话或手机不能都为空" }, if: "tel.blank?"

  scope :fresh, -> { where(is_fresh: true)}
  scope :by_status, ->(status = []) { joins(:order_details).where(order_details: {status: status}).distinct }


  def checking!
    # @order.at_unit
    Order.transaction do
      begin
        self.is_fresh = false
        self.save!
        self.order_details.each do |x|
          x.at_unit = Unit::DELIVERY
          x.checking!
        end
      rescue Exception => e
        raise ActiveRecord::Rollback
      end
    end
  end

  def can_update?
    ! order_details.where.not(status: [OrderDetail.statuses[:waiting], OrderDetail.statuses[:pending], OrderDetail.statuses[:canceled]]).exists?
  end

  def can_destroy?
    is_fresh
  end
    
  private
  def generate_no
    today = Date.today
    count = (Order.where(unit: self.unit).where(created_at: [today .. (today + 1.day)]).count + 1).to_s.rjust(3, '0')
    self.no = "#{self.unit.short_name}#{today.strftime('%Y%m%d')}#{count}"
  end
  
end
