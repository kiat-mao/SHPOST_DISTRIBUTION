class Supplier < ActiveRecord::Base
	has_many :commodities, dependent: :destroy
# <<<<<<< HEAD
    
# 	validates_presence_of :sno, :name, :message => '不能为空'
# 	validates_uniqueness_of :sno, :message => '该供应商编码已存在'
# =======

	validates :sno, :name, presence: {:message => "不能为空"}
	validates :sno, uniqueness: {:message => "该供应商编码已存在"}
# >>>>>>> 16d640798b378af2317209e3c4700813a9fb236b

    mount_uploaders :contracts, ContractsUploader
    serialize :contracts, JSON
    
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
