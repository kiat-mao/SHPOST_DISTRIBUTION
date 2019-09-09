class Order < ActiveRecord::Base
  has_many :order_details, dependent: :destroy
  belongs_to :user
  belongs_to :unit

  before_create :generate_no

  validates :name, :address, :unit, presence: { :message => "不能为空" }

  validates :phone, presence: { :message => "电话或手机不能都为空" }, if: "tel.blank?"

  validate :phone_complexity

  # validates :tel, presence: { :message => "电话或手机不能都为空" }, if: "tel.blank?"

  scope :fresh, -> { where(is_fresh: true)}
  scope :by_status, ->(status = []) { joins(:order_details).where(order_details: {status: status}).distinct }


  def checking!
    Order.transaction do
      begin
        order_details =  []
        self.is_fresh = false
        self.save!
        self.order_details.each do |x|
          order_details << x if x.checking!
        end
        order_details
      rescue Exception => e
        raise e
      end
    end
  end

  def rechecking!
    Order.transaction do
      begin
        order_details =  []
        self.order_details.each do |x|
         order_details << x if x.rechecking!
        end
        order_details
      rescue Exception => e
        raise e
      end
    end
  end

  def pending! why_decline = nil
    Order.transaction do
      begin
        order_details =  []
        self.order_details.each do |x|
          order_details << x if x.pending! why_decline
        end
        order_details
      rescue Exception => e
        raise e
      end
    end
  end

  def receiving!
    Order.transaction do
      begin
        order_details =  []
        self.order_details.each do |x|
          order_details << x if x.receiving!
        end
        order_details
      rescue Exception => e
        raise e
      end
    end
  end

  def declined! why_decline = nil
    Order.transaction do
      begin
        order_details =  []
        self.order_details.each do |x|
          order_details << x if x.declined! why_decline
        end
        order_details
      rescue Exception => e
        raise e
      end
    end
  end

  def closed!
    Order.transaction do
      begin
        order_details =  []
        self.order_details.each do |x|
          order_details << x if x.closed!
        end
        order_details
      rescue Exception => e
        raise e
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
    # count = (Order.where(unit: self.unit).where(created_at: [today .. (today + 1.day)]).count + 1).to_s.rjust(3, '0')
    # count += 1 unless Order.find_by(no: "#{self.unit.short_name}#{today.strftime('%Y%m%d')}#{count}").nil?
    rows = Order.where(unit: self.unit).where(created_at: [today .. (today + 1.day)]).count
    if rows.zero?
      count = 1
    else 
      count = (Order.where(unit: self.unit).where(created_at: [today .. (today + 1.day)]).last.no.last(3).to_i + 1)
      count = rows + 1 if count < rows + 1
    end
    self.no = "#{self.unit.short_name}#{today.strftime('%Y%m%d')}#{count.to_s.rjust(3, '0') }"
  end

  def phone_complexity
    if tel.present?
       if !tel.match(/^((\d{3,4}-)|\d{3.4}-)?\d{7,8}$/) 
         errors.add :tel, "电话号码不正确"
       end
    end
    if phone.present?
      if !phone.match(/^1[34578]\d{9}$/) 
         errors.add :phone, "手机号码不正确"
       end
    end
  end
  
end
