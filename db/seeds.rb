# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
unit1 = Unit.create(name: 'unit1_name', desc: 'unit1_desc', no: '0001', short_name: 'ut1', unit_type: 'postbuy')

unit2 = Unit.create(name: 'unit2_name', desc: 'unit2_desc', no: '0002', short_name: 'ut2', unit_type: 'delivery')

superadmin = User.create(email: 'superadmin@examples.com', username: 'superadmin', password: 'pwd12345', name: 'superadmin', role: 'superadmin', unit_id: 0)

role_1 = Role.create(user: superadmin, unit: unit1, role: 'superadmin')