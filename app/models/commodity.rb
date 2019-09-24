class Commodity < ApplicationRecord
	belongs_to :supplier

	# has_and_belongs_to_many :Order
    mount_uploader :cover, CoverUploader
	# validates_presence_of :cno, :dms_no, :name, :supplier_id, :cost_price, :sell_price, :message => '不能为空'
	# validates_uniqueness_of :cno, :message => '该商品编码已存在'

	has_many :order_details

	before_create :generate_no
    
	validates :dms_no, :name, :supplier_id, :cost_price, :sell_price, presence: {:message => "不能为空"}
	validates :cno, :dms_no, uniqueness: {:message => "该商品编码已存在"}
	validates :name, uniqueness: {scope: :supplier,:message => "该供应商下已存在同名商品"}
	validates :cost_price, :sell_price, numericality: {:greater_than => 0 }


	IS_ON_SELL = { true: '是', false: '否'}

	def is_on_sell_name
	    if is_on_sell
	    	name = "是"
	    else
	        name = "否"
	    end
	end

    

	def can_destroy?
		if self.order_details.blank?
			return true
		else
			return false
		end
	end

	def can_cover_upload
		if Unit.unit_type = 'postbuy'
			return true
		else
			return false
		end
	end

	

	private
	def generate_no
    count = (Commodity.where(supplier: self.supplier).count + 1).to_s.rjust(5, '0')
    self.cno = "#{self.supplier.sno}-#{count}"
  end
end
