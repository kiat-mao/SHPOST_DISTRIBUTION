class Commodity < ActiveRecord::Base
	belongs_to :supplier

	# has_and_belongs_to_many :Order
    mount_uploader :cover, CoverUploader
	# validates_presence_of :cno, :dms_no, :name, :supplier_id, :cost_price, :sell_price, :message => '不能为空'
	# validates_uniqueness_of :cno, :message => '该商品编码已存在'

	has_many :order_details

	validates :cno, :dms_no, :name, :supplier_id, :cost_price, :sell_price, presence: {:message => "不能为空"}
	validates :cno, uniqueness: {:message => "该商品编码已存在"}
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
end
