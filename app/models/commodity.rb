class Commodity < ActiveRecord::Base
	belongs_to :supplier
	# has_and_belongs_to_many :Order

	IS_ON_SELL = { true: '是', false: '否'}

	def is_on_sell_name
	    if is_on_sell
	    	name = "是"
	    else
	        name = "否"
	    end
	end

	# def can_destroy?
	# 	if self.orders.blank?
	# 		return true
	# 	else
	# 		return false
	# 	end
	# end
end
