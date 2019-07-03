class OrderDetail < ActiveRecord::Base
  enum status: { waiting: 'waiting', checking: 'checking', rechecking: 'rechecking', receiving: 'receiving', closed: 'closed', canceled: 'canceled' , pending: 'pending', declined: 'declined'}
end
