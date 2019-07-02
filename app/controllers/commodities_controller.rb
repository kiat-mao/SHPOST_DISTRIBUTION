class CommoditiesController < ApplicationController
  load_and_authorize_resource :commodity

  def index
    @commodities = initialize_grid(@commodities,
      :order => 'commodities.cno',
      :order_direction => 'asc',
      :name => 'commodities',
      :enable_export_to_csv => true,
      :csv_file_name => 'commodities')
    export_grid_if_requested
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @commodity.save
        format.html { redirect_to @commodity, notice: I18n.t('controller.create_success_notice', model: '商品') }
        format.json { render action: 'show', status: :created, location: @commodity }
      else
        format.html { render action: 'new' }
        format.json { render json: @commodity.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @commodity.update(commodity_params)
        format.html { redirect_to @commodity, notice: I18n.t('controller.update_success_notice', model: '商品') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @commodity.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # if @commodity.can_destroy?
      @commodity.destroy
    # else
    #   flash[:alert] = "已有订单中包含该商品，不可删除"
    # end
    respond_to do |format|
      format.html { redirect_to commodities_url }
      format.json { head :no_content }
    end
  end

  def commodity_import
    unless request.get?
      if file = upload_commodity(params[:file]['file'])       
        Commodity.transaction do
          begin
            sheet_back = []
            rowarr = [] 
            instance=nil
            flash_message = "导入成功!"
            current_line = 0
            is_error = false
            is_red = ""

            if file.include?('.xlsx')
              instance= Roo::Excelx.new(file)
            elsif file.include?('.xls')
              instance= Roo::Excel.new(file)
            elsif file.include?('.csv')
              instance= Roo::CSV.new(file)
            end
            instance.default_sheet = instance.sheets.first
            title_row = instance.row(1)
            name_index = title_row.index("商品名称").blank? ? 0 : title_row.index("商品名称")
            supplier_index = title_row.index("供应商").blank? ? 1 : title_row.index("供应商")
            cost_price_index = title_row.index("商家结算价").blank? ? 2 : title_row.index("商家结算价")
            sell_price_index = title_row.index("最低销售价").blank? ? 3 : title_row.index("最低销售价")
            desc_index = title_row.index("商品详情").blank? ? 4 : title_row.index("商品详情")
            is_on_sell_index = title_row.index("是否上架").blank? ? 5 : title_row.index("是否上架")

            2.upto(instance.last_row) do |line|
              current_line = line
              rowarr = instance.row(line)
              name = rowarr[name_index].blank? ? "" : rowarr[name_index].to_s.split('.0')[0]
              supplier = rowarr[supplier_index].blank? ? "" : rowarr[supplier_index].to_s.split('.0')[0]
              cost_price = rowarr[cost_price_index].blank? ? "" : rowarr[cost_price_index].to_f
              sell_price = rowarr[sell_price_index].blank? ? "" : rowarr[sell_price_index].to_f
              desc = rowarr[desc_index].blank? ? "" : rowarr[desc_index].to_s.split('.0')[0]
              is_on_sell = rowarr[is_on_sell_index].blank? ? "" : rowarr[is_on_sell_index].to_s.split('.0')[0]
              is_on_sell = (is_on_sell.eql?"否") ? false : true
              
              if name.blank?
                is_error = true
                is_red = "yes"
                txt = "缺少商品名称"
                sheet_back << (rowarr << txt << is_red)
              else
                if supplier.blank?
                  is_error = true
                  is_red = "yes"
                  txt = "缺少供应商"
                  sheet_back << (rowarr << txt << is_red)
                else
                  if Supplier.find_by(name: supplier).blank?
                    is_error = true
                    is_red = "yes"
                    txt = "供应商不存在"
                    sheet_back << (rowarr << txt << is_red)
                  else
                    supplier_id = Supplier.find_by(name: supplier).id
                    if cost_price.blank?
                      is_error = true
                      is_red = "yes"
                      txt = "缺少商家结算价"
                      sheet_back << (rowarr << txt << is_red)
                    else
                      if sell_price.blank?
                        is_error = true
                        is_red = "yes"
                        txt = "缺少最低销售价"
                        sheet_back << (rowarr << txt << is_red)
                      else
                        if !Commodity.find_by(cno: cno).blank?
                          is_red = "no"
                          txt = "商品已存在"
                          sheet_back << (rowarr << txt << is_red)
                        else
                          Commodity.create!(name: name, supplier_id: supplier_id, cost_price: cost_price, sell_price: sell_price, desc: desc, is_on_sell: is_on_sell)
                          is_red = "no"
                          txt = "商品新建成功"
                          sheet_back << (rowarr << txt << is_red)
                        end
                      end
                    end
                  end
                end
              end
            end

            if is_error
              flash_message << "有部分信息导入失败！"
            end
            flash[:notice] = flash_message

            send_data(exportcommodity_infos_xls_content_for(sheet_back,title_row),  
              :type => "text/excel;charset=utf-8; header=present",  
              :filename => "Commodity_Infos_#{Time.now.strftime("%Y%m%d")}.xls")

          rescue Exception => e
            Rails.logger.error e.backtrace
            flash[:alert] = e.message + "第" + current_line.to_s + "行"
            raise ActiveRecord::Rollback
          end
        end
      end   
    end
  end

  def exportcommodity_infos_xls_content_for(obj,title_row)
    xls_report = StringIO.new  
    book = Spreadsheet::Workbook.new  
    sheet1 = book.create_worksheet :name => "sheet1"  

    blue = Spreadsheet::Format.new :color => :blue, :weight => :bold, :size => 10  
    red = Spreadsheet::Format.new :color => :red
    sheet1.row(0).default_format = blue 
    sheet1.row(0).concat title_row
    size = obj.first.size 
    count_row = 1
    obj.each do |obj|
      if obj.last.eql?"yes"
        sheet1.row(count_row).default_format = red
      end

      count = 0
      while count<size-1
        sheet1[count_row,count]=obj[count]
        count += 1
      end
      
      count_row += 1
    end 
    book.write xls_report  
    xls_report.string  
  end      

  def to_set_on_sell
  end

  def set_on_sell
    @operation = "set_on_sell"
    respond_to do |format|
      if @commodity.update(commodity_params)
        txt = @commodity.is_on_sell ? "上架" : "下架"
        format.html { redirect_to commodities_url, notice: "已成功#{txt}" }
        format.json { head :no_content }
      else
        format.html { render action: 'set_on_sell' }
        format.json { render json: @commodity.errors, status: :unprocessable_entity }
      end
    end
  end      


  private
    def set_commodity
      @commodity = Commodity.find(params[:id])
    end

    def commodity_params
      params.require(:commodity).permit(:cno, :dms_no, :name, :supplier_id, :cost_price, :sell_price, :desc, :is_on_sell)
    end

    def upload_commodity(file)
      if !file.original_filename.empty?
        direct = "#{Rails.root}/upload/commodity/"
        filename = "#{Time.now.to_f}_#{file.original_filename}"
        if !File.exist?("#{Rails.root}/upload/")
          Dir.mkdir("#{Rails.root}/upload/")          
        end
        if !File.exist?("#{Rails.root}/upload/commodity/")
          Dir.mkdir("#{Rails.root}/upload/commodity/")          
        end

        file_path = direct + filename
        File.open(file_path, "wb") do |f|
           f.write(file.read)
        end
        file_path
      end
    end
end
