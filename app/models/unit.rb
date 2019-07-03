class Unit < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :units, as: :parent

  # has_many :tarrif_items, dependent: :destroy
  # has_many :tarrif_packages, dependent: :destroy

  validates_presence_of :name, :short_name, :message => '不能为空'
  validates_uniqueness_of :name, :message => '该单位已存在'

  validates_uniqueness_of :short_name, :message => '该缩写已存在'

  # UNIT_LEVEL = {1=>'1',2=>'2',3=>'3'}
  TYPE = {branch: '区分公司', delivery: '寄递事业部', postbuy: '国际邮购'}
  # TYPE_BRANCH = {branch: '区分公司'}
  DELIVERY = Unit.find_by(unit_type: 'delivery') 
  POSTBUY = Unit.find_by(unit_type: 'postbuy') 
  def unit_type_name
    unit_type.blank? ? "" : self.class.human_attribute_name("unit_type_#{unit_type}")
  end

  def can_destroy?
		if self.users.blank?
			return true
		else
			return false
		end
  end
  # def delivery?
  #   (unit_type.eql? 'delivery') ? true : false
  # end
  # def postbuy?
  #   (unit_type.eql? 'postbuy') ? true : false
  # end
end
