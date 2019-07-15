# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# unit1 = Unit.create(name: 'unit1_name', desc: 'unit1_desc', no: '0001', short_name: 'ut1', unit_type: 'postbuy')

# unit2 = Unit.create(name: 'unit2_name', desc: 'unit2_desc', no: '0002', short_name: 'ut2', unit_type: 'delivery')

# superadmin = User.create(email: 'superadmin@examples.com', username: 'superadmin', password: 'pwd12345', name: 'superadmin', role: 'superadmin', unit_id: 0)

# role_1 = Role.create(user: superadmin, unit: unit1, role: 'superadmin')

unit1 = Unit.create(name: '中国邮政集团公司上海市浦东新区寄递事业部', desc: '寄递事业部', no: '20120000000001', short_name: 'pdjd', unit_type: 'branch')
unit2 = Unit.create(name: '中国邮政集团公司上海市黄浦区寄递事业部', desc: '寄递事业部', no: '20190000000001', short_name: 'hpjd', unit_type: 'branch')
unit3 = Unit.create(name: '中国邮政集团公司上海市徐汇区寄递事业部', desc: '寄递事业部', no: '20190000000002', short_name: 'xhjd', unit_type: 'branch')
unit4 = Unit.create(name: '中国邮政集团公司上海市长宁区寄递事业部', desc: '寄递事业部', no: '20140000000012', short_name: 'cnjd', unit_type: 'branch')
unit5 = Unit.create(name: '中国邮政集团公司上海市普陀区寄递事业部', desc: '寄递事业部', no: '20140000000050', short_name: 'ptjd', unit_type: 'branch')
unit6 = Unit.create(name: '中国邮政集团公司上海市静安区寄递事业部', desc: '寄递事业部', no: '20190000000003', short_name: 'jajd', unit_type: 'branch')
unit7 = Unit.create(name: '中国邮政集团公司上海市虹口区寄递事业部', desc: '寄递事业部', no: '20190000000004', short_name: 'hkjd', unit_type: 'branch')
unit8 = Unit.create(name: '中国邮政集团公司上海市杨浦区寄递事业部', desc: '寄递事业部', no: '20140000000063', short_name: 'ypjd', unit_type: 'branch')
unit9 = Unit.create(name: '中国邮政集团公司上海市宝山区寄递事业部', desc: '寄递事业部', no: '20120000000011', short_name: 'bsjd', unit_type: 'branch')
unit10 = Unit.create(name: '中国邮政集团公司上海市闵行区寄递事业部', desc: '寄递事业部', no: '20120000000010', short_name: 'mhjd', unit_type: 'branch')
unit11 = Unit.create(name: '中国邮政集团公司上海市嘉定区寄递事业部', desc: '寄递事业部', no: '20120000000004', short_name: 'jdjd', unit_type: 'branch')
unit12 = Unit.create(name: '中国邮政集团公司上海市金山区寄递事业部', desc: '寄递事业部', no: '20120000000012', short_name: 'jsjd', unit_type: 'branch')
unit13 = Unit.create(name: '中国邮政集团公司上海市松江区寄递事业部', desc: '寄递事业部', no: '20120000000009', short_name: 'sjjd', unit_type: 'branch')
unit14 = Unit.create(name: '中国邮政集团公司上海市青浦区寄递事业部', desc: '寄递事业部', no: '20120000000015', short_name: 'qpjd', unit_type: 'branch')
unit15 = Unit.create(name: '中国邮政集团公司上海市奉贤区寄递事业部', desc: '寄递事业部', no: '20120000000014', short_name: 'fxjd', unit_type: 'branch')
unit16 = Unit.create(name: '中国邮政集团公司上海市崇明区寄递事业部', desc: '寄递事业部', no: '20120000000016', short_name: 'cmjd', unit_type: 'branch')
unit17 = Unit.create(name: '中国邮政集团公司上海市寄递事业部商企业务分公司', desc: '业务分公司', no: '20140000000070', short_name: 'sqfgs', unit_type: 'branch')
unit18 = Unit.create(name: '中国邮政集团公司上海市寄递事业部物流业务分公司', desc: '业务分公司', no: '20140000000074', short_name: 'wlfgs', unit_type: 'branch')
unit19 = Unit.create(name: '中国邮政集团公司上海市寄递事业部国际业务分公司', desc: '业务分公司', no: '20140000000073', short_name: 'gjfgs', unit_type: 'branch')
unit20 = Unit.create(name: '中国邮政集团公司上海市寄递事业部同城业务分公司', desc: '业务分公司', no: '20160000000001', short_name: 'tcfgs', unit_type: 'branch')


user1 = User.create(username: 'pinanqi', password: 'pinanqi12345', name: '皮楠淇', role: 'user', unit: unit1)