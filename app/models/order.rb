class Order < ActiveRecord::Base
  has_many :order_details
  belongs_to :user
  belongs_to :unit

  before_create :generate_no

  validates :name, :address, :unit, presence: {:message => "不能为空"}

  scope :fresh, -> { where(is_fresh: true)}
  scope :by_status, ->(status = []) { joins(:order_details).where(order_details: {status: status}).distinct }

  private
  def generate_no
    today = Date.today
    count = (Order.where(unit: self.unit).where(created_at: [today .. (today + 1.day)]).count + 1).to_s.rjust(3, '0')
    self.no = "#{self.unit.short_name}#{today.strftime('%Y%m%d')}#{count}"
  end
  
end
