class ReportsController < ApplicationController
	
	def order_report
		filters = {}
		if current_user.unit.unit_type.eql?"branch"
			@at_units = Unit.where("unit_type=? or unit_type=? or id=?", "delivery", "postbuy", current_user.unit.id)
		else
			@at_units = Unit.all
		end
	    unless request.get?
	      selectorder_details = OrderDetail.accessible_by(current_ability).joins(:order).joins(:order=>[:unit]).joins(:commodity).joins(:commodity=>[:supplier])

	      if !params[:create_at_start].blank? && !params[:create_at_start][:create_at_start].blank?
	      	selectorder_details=selectorder_details.where("orders.created_at >= ?", to_date(params[:create_at_start][:create_at_start]))
	      	filters["create_at_start"] = params[:create_at_start][:create_at_start]
	      end

	      if !params[:create_at_end].blank? && !params[:create_at_end][:create_at_end].blank?
	      	selectorder_details=selectorder_details.where("orders.created_at <= ?", to_date(params[:create_at_end][:create_at_end]))
	      	filters["create_at_end"] = params[:create_at_end][:create_at_end]
	      end

	      if !params[:supplier].blank? && !(params[:supplier].eql?"全部")
	      	selectorder_details=selectorder_details.where("suppliers.id = ?", params[:supplier].to_i)
	      	filters["supplier"] = Supplier.find(params[:supplier].to_i).name
	      else
	      	filters["supplier"] = "全部"
	      end

	      if !params[:commodity_name].blank? && !params[:commodity_name][:commodity_name].blank?
	      	selectorder_details=selectorder_details.where("commodities.name like ?", "%#{params[:commodity_name][:commodity_name]}%")
	      	filters["commodity_name"] = params[:commodity_name][:commodity_name]
	      end

	      if !params[:status].blank? && !(params[:status].eql?"全部")
	      	selectorder_details=selectorder_details.where("order_details.status = ?", params[:status])
	      	filters["status"] = params[:status]
	      else
	      	filters["status"] = "全部"
	      end

	      if !params[:order_no].blank? && !params[:order_no][:order_no].blank?
	      	selectorder_details=selectorder_details.where("orders.no = ?", params[:order_no][:order_no])
	      	filters["order_no"] = params[:order_no][:order_no]
	      end

	      if !params[:price_start].blank? && !params[:price_start][:price_start].blank?
	      	selectorder_details=selectorder_details.where("order_details.price >= ?", params[:price_start][:price_start].to_f)
	      	filters["price_start"] = params[:price_start][:price_start]
	      end

	      if !params[:price_end].blank? && !params[:price_end][:price_end].blank?
	      	selectorder_details=selectorder_details.where("order_details.price <= ?", params[:price_end][:price_end].to_f)
	      	filters["price_end"] = params[:price_end][:price_end]
	      end

	      if !params[:at_unit].blank? && !(params[:at_unit].eql?"全部")
	      	selectorder_details=selectorder_details.where("order_details.at_unit_id = ?", params[:at_unit].to_i)
	      	filters["at_unit"] = Unit.find(params[:at_unit].to_i).name
	      else
	      	filters["at_unit"] = "全部"
	      end

	      if !params[:create_unit_name].blank? && !params[:create_unit_name][:create_unit_name].blank?
	      	selectorder_details=selectorder_details.where("units.name like ?", "%#{params[:create_unit_name][:create_unit_name]}%")
	      	filters["create_unit_name"] = params[:create_unit_name][:create_unit_name]
	      end

	      if !params[:order_user_name].blank? && !params[:order_user_name][:order_user_name].blank?
	      	selectorder_details=selectorder_details.where("orders.name like ?", "%#{params[:order_user_name][:order_user_name]}%")
	      	filters["order_user_name"] = params[:order_user_name][:order_user_name]
	      end

	      if !params[:phone].blank? && !params[:phone][:phone].blank?
	      	selectorder_details=selectorder_details.where("orders.phone = ? or orders.tel = ?", params[:phone][:phone], params[:phone][:phone])
	      	filters["phone"] = params[:phone][:phone]
	      end

	      if selectorder_details.blank?
	        flash[:alert] = "无数据"
	        redirect_to :action => 'order_report'
	      else
	        send_data(order_report_xls_content_for(selectorder_details,filters),:type => "text/excel;charset=utf-8; header=present",:filename => "订单管理报表_#{Time.now.strftime("%Y%m%d")}.xls")  
	      end
   		end
   	end

   	class GreyFormat1 < Spreadsheet::Format
	  def initialize(gb_color, font_color)
	    super :pattern => 1, :pattern_fg_color => gb_color,:color => font_color, :text_wrap => 1, :weight => :bold, :size => 11, :align => :center, :border => :thin
	  end
	end

	class GreyFormat2 < Spreadsheet::Format
	  def initialize(gb_color, font_color)
	    super :pattern => 1, :pattern_fg_color => gb_color,:color => font_color, :text_wrap => 1, :weight => :bold, :size => 12, :align => :center, :border => :thin
	  end
	end

   	def order_report_xls_content_for(objs,filters) 
	    xls_report = StringIO.new  
	    book = Spreadsheet::Workbook.new  
	    sheet1 = book.create_worksheet :name => "订单管理报表"  
	    
	    title = Spreadsheet::Format.new :weight => :bold, :size => 18
	    filter = Spreadsheet::Format.new :size => 12
	    red = Spreadsheet::Format.new :color => :red, :size => 12
	    bold = Spreadsheet::Format.new :weight => :bold, :size => 10, :border => :thin
	    body = Spreadsheet::Format.new :size => 10, :border => :thin, :align => :center

	    # 设置列宽
	    1.upto(2) do |i|
	    	sheet1.column(i).width = 20
	    end
	    3.upto(4) do |i|
	    	sheet1.column(i).width = 25
	    end
	    sheet1.column(5).width = 50
	    6.upto(9) do |i|
	    	sheet1.column(i).width = 15
	    end
	    sheet1.column(10).width = 20
	    11.upto(14) do |i|
	    	sheet1.column(i).width = 15
	    end
	    sheet1.column(15).width = 35
	    sheet1.column(16).width = 25
	    sheet1.column(18).width = 35
	    19.upto(22) do |i|
	    	sheet1.column(i).width = 15
	    end
	    sheet1.column(23).width = 20

	    # 设置行高
		sheet1.row(0).height = 40
		1.upto(2) do |i|
	    	sheet1.row(i).height = 30
	    end
	    sheet1.row(3).height = 20
	    sheet1.row(4).height = 25

	    # 表头
	    # sheet1.merge_cells(start_row, start_col, end_row, end_col)	    
	    sheet1.row(0).default_format = title 
	    sheet1.merge_cells(0, 0, 0, 24)
  		sheet1[0,0] = "           订单管理报表"

  		sheet1.row(1).default_format = filter
  		sheet1.merge_cells(1, 0, 1, 2)
  		sheet1[1,0] = "  下单时间：#{filters['create_at_start']}至#{filters['create_at_end']}"
  		sheet1[1,3] = "供应商：#{filters['supplier']}"
  		sheet1[1,5] = "商品名称：#{filters['commodity_name']}"
  		sheet1[1,6] = (filters['status'].eql?"全部") ? "子订单状态：全部" : "子订单状态：#{OrderDetail::STATUS_NAME[filters['status'].to_sym]}"
  		sheet1[1,9] = "收货人：#{filters['order_user_name']}"
  		sheet1.row(1).set_format(9,red)
  		sheet1[1,12] = "创建单位：#{filters['create_unit_name']}"
  		sheet1.row(1).set_format(12,red)
  		
  		sheet1.row(2).default_format = filter
  		sheet1[2,0] = "  单位名称：#{current_user.unit.name}"
  		sheet1[2,3] = "主订单编号：#{filters['order_no']}"
  		sheet1[2,5] = "价格区间：#{filters['price_start']} - #{filters['price_end']}"
  		sheet1[2,6] = "目前流转单位：#{filters['at_unit']}"
  		sheet1[2,9] = "收货人手机号码：#{filters['phone']}"
  		sheet1.row(2).set_format(9,red)
  		
  		sheet1[3,0] = "子订单信息"
    	sheet1.merge_cells(3, 0, 3, 15)	
    	
  		sheet1[3,15] = "主订单信息区"
  		sheet1.merge_cells(3, 16, 3, 24)
  		0.upto(24) do |i|
  			sheet1.row(3).set_format(i, GreyFormat1.new(:grey, :black))
  		end	
   		
  		sheet1.row(4).concat %w{序号 子订单编号 商品编码 DMS商品编码 供应商 商品名称 数量 销售单价 商家结算价 订单状态 目前流转单位 下单时间 结单时间 是否审核过 是否复核过 最后一次驳回理由 主订单编号 收货人 收货地址 收货人电话 收货人手机 创建时间 创建人 创建单位 备注}
  		0.upto(24) do |i|
  			sheet1.row(4).set_format(i, GreyFormat2.new(:grey, :black))
  		end

  		# 表格内容
  		count_row = 5
  		i=1
  		objs.each do |x|
  			sheet1[count_row,0] = i
  			sheet1[count_row,1] = x.no
  			sheet1[count_row,2] = x.commodity.cno
  			sheet1[count_row,3] = x.commodity.dms_no
  			sheet1[count_row,4] = x.commodity.supplier.name
  			sheet1[count_row,5] = x.commodity.name
  			sheet1[count_row,6] = x.amount
  			sheet1[count_row,7] = x.price
  			sheet1[count_row,8] = x.cost_price
  			sheet1[count_row,9] = x.status_name
  			sheet1[count_row,10] = x.at_unit.name
  			sheet1[count_row,11] = x.created_at.strftime("%Y%m%d")
  			sheet1[count_row,12] = x.closed_at.blank? ? "" : x.closed_at.strftime("%Y%m%d")
  			sheet1[count_row,13] = x.has_checked? ? "是" : "否"
  			sheet1[count_row,14] = x.has_rechecked? ? "是" : "否"
  			sheet1[count_row,15] = x.why_decline.blank? ? "" : x.why_decline
  			sheet1[count_row,16] = x.order.no
  			sheet1[count_row,17] = x.order.name
  			sheet1[count_row,18] = x.order.address
  			sheet1[count_row,19] = x.order.tel
  			sheet1[count_row,20] = x.order.phone
  			sheet1[count_row,21] = x.order.created_at.strftime("%Y%m%d")
  			sheet1[count_row,22] = x.order.user.name
  			sheet1[count_row,23] = x.order.unit.name
  			sheet1[count_row,24] = x.order.desc

  			0.upto(24) do |x|
	  			sheet1.row(count_row).set_format(x, body)
	  		end	
	  		sheet1.row(count_row).height = 30

  			count_row += 1
  			i += 1
  		end

  		sheet1[count_row,0] = "合计"
  		sheet1[count_row,1] = "订单总数：#{objs.count}"
  		sheet1[count_row,6] = "商品总数：#{objs.sum(:amount)}"
  		sheet1[count_row,7] = "销售总额：#{objs.sum(:price)}"
  		sheet1[count_row,8] = "结算总额：#{objs.sum(:cost_price)}"
  		0.upto(24) do |x|
	  		sheet1.row(count_row).set_format(x, bold)
	  	end
	  	sheet1.row(count_row).height = 25

  		count_row += 1
		sheet1.row(count_row).default_format = filter
		sheet1.merge_cells(count_row, 0, 0, 24)
  		sheet1[count_row,0] = "打印机构：#{current_user.unit.name}                     打印人：#{current_user.name}                打印时间：#{Time.now.strftime('%Y-%m-%d %H:%m:%S')}"
  		sheet1.row(count_row).height = 30

  		book.write xls_report  
    	xls_report.string
	end

   	private
	  def to_date(time)
	    date = Date.civil(time.split(/-|\//)[0].to_i,time.split(/-|\//)[1].to_i,time.split(/-|\//)[2].to_i)
	    return date
	  end
 end