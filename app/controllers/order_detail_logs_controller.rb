class  OrderDetailLogsController < ApplicationController
  load_and_authorize_resource :order_detail, only: [:index]
  load_resource :order_detail_logs,  through: :order_detail, only: [:index]

  def index
	  @order_detail_logs = @order_detail.order_detail_logs
		# binding.pry
		respond_to do |format|
      format.js
		end
	end

end