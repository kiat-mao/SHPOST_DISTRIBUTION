class Supplier < ActiveRecord::Base
	has_many :commodities, dependent: :destroy

	validates :sno, :name, presence: {:message => "不能为空"}
	validates :sno, uniqueness: {:message => "该供应商编码已存在"}

	IS_VALID = { true: '是', false: '否'}

	def is_valid_name
	    if is_valid
	    	name = "是"
	    else
	        name = "否"
	    end
	end

	def can_destroy?
		if self.commodities.blank?
			return true
		else
			return false
		end
	end
end
