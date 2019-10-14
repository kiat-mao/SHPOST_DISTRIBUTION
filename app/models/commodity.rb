class Commodity < ActiveRecord::Base
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
	 validates :sell_price, numericality: {:greater_than => :cost_price, :message => "必须不小于#{human_attribute_name(:cost_price)}" }


	IS_ON_SELL = { true: '是', false: '否'}

	def is_on_sell_name
    if is_on_sell
    	name = "是"
    else
       name = "否"
    end
	end

	def on_sell?
		is_on_sell && self.supplier.is_valid
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

		rows = Commodity.where(supplier: self.supplier).count
    if rows.zero?
      count = 1
    else 
      count = (Commodity.where(supplier: self.supplier).last.cno.last(5).to_i + 1)
      count = rows + 1 if count < rows + 1
    end

    self.cno = "#{self.supplier.sno}-#{count.to_s.rjust(5, '0')}"
  end
end

class String
  def truncate_decimal(scale = 2)
    if scale.to_i < 0
      scale = 2
    end
    if self.include?('.')
      _ary = self.split('.')
      if _ary.size == 2
        if scale == 0
          return _ary[0]
        else
          _ary[1] = _ary[1][0, scale.to_i]
          return "#{_ary[0]}.#{_ary[1]}"
        end
      else
        return self
      end
    else
      return self
    end
  end
end
