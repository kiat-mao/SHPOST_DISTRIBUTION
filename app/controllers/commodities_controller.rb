class CommoditiesController < ApplicationController
  load_and_authorize_resource :commodity

  def index
    @commodities = initialize_grid(@commodities,
      :order => 'commodities.cno',
      :order_direction => 'asc',
      :name => 'commodities',
      :enable_export_to_csv => true,
      :csv_file_name => 'commodities',
      :per_page => params[:page_size])
    export_grid_if_requested
  end

  def show
  end

  def new
  end

  def edit
    set_autocom_update(@commodity)
    @source = request.referer
  end

  
  def cover_upload
    @source = request.referer
    # @operation = "commodity_upload"
    # @commodity = Commodity.find_by(id: params[:format])
    # @commodity.cover = params[:cover]
    # redirect_to commodity_upload_commodities_path(commodity) , :notice => '设置成功'
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
        format.html { redirect_to params[:source], notice: I18n.t('controller.update_success_notice', model: '商品') }
        format.json { head :no_content }
      else
        @source = params[:source]
        format.html { render action: 'edit' }
        format.json { render json: @commodity.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @commodity.can_destroy?
      @commodity.destroy
    else
      flash[:alert] = "已有子订单中包含该商品，不可删除"
    end
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

            if file.end_with?('.xlsx')
              instance= Roo::Excelx.new(file)
            elsif file.end_with?('.xls')
              instance= Roo::Excel.new(file)
            elsif file.end_with?('.csv')
              instance= Roo::CSV.new(file)
            else
              respond_to do |format|
                format.html { redirect_to commodity_import_commodities_path, notice: "文件后缀名必须为xlsx,xls或csv" }
                format.json { head :no_content }
              end
            end
            instance.default_sheet = instance.sheets.first
            title_row = instance.row(1)
            # cno_index = title_row.index("商品编码").blank? ? 0 : title_row.index("商品编码")
            dms_no_index = title_row.index("DMS商品编码").blank? ? 1 : title_row.index("DMS商品编码")
            name_index = title_row.index("商品名称").blank? ? 2 : title_row.index("商品名称")
            supplier_index = title_row.index("供应商").blank? ? 3 : title_row.index("供应商")
            cost_price_index = title_row.index("商家结算价").blank? ? 4 : title_row.index("商家结算价")
            sell_price_index = title_row.index("参考销售价").blank? ? 5 : title_row.index("参考销售价")
            desc_index = title_row.index("商品详情").blank? ? 6 : title_row.index("商品详情")
            is_on_sell_index = title_row.index("是否上架").blank? ? 7 : title_row.index("是否上架")

            2.upto(instance.last_row) do |line|
              current_line = line
              rowarr = instance.row(line)
              # cno = rowarr[cno_index].blank? ? "" : rowarr[cno_index].to_s.split('.0')[0]
              dms_no = rowarr[dms_no_index].blank? ? "" : rowarr[dms_no_index].to_s.split('.0')[0]
              name = rowarr[name_index].blank? ? "" : rowarr[name_index].to_s.split('.0')[0]
              supplier = rowarr[supplier_index].blank? ? "" : rowarr[supplier_index].to_s.split('.0')[0]
              cost_price = rowarr[cost_price_index].blank? ? "" : rowarr[cost_price_index].to_f
              sell_price = rowarr[sell_price_index].blank? ? "" : rowarr[sell_price_index].to_f
              desc = rowarr[desc_index].blank? ? "" : rowarr[desc_index].to_s.split('.0')[0]
              is_on_sell = rowarr[is_on_sell_index].blank? ? "" : rowarr[is_on_sell_index].to_s.split('.0')[0]
              is_on_sell = (is_on_sell.eql?"否") ? false : true
              
              if dms_no.blank?
                is_error = true
                is_red = "yes"
                txt = "缺少DMS商品编码"
                sheet_back << (rowarr << txt << is_red)
              else
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
                    if Supplier.find_by(sno: supplier).blank?
                      is_error = true
                      is_red = "yes"
                      txt = "供应商不存在"
                      sheet_back << (rowarr << txt << is_red)
                    else
                      supplier_id = Supplier.find_by(sno: supplier).id
                      if cost_price.blank?
                        is_error = true
                        is_red = "yes"
                        txt = "缺少商家结算价"
                        sheet_back << (rowarr << txt << is_red)
                      else
                        if sell_price.blank?
                          is_error = true
                          is_red = "yes"
                          txt = "缺少参考销售价"
                          sheet_back << (rowarr << txt << is_red)
                        else
                          if !Commodity.find_by(dms_no: dms_no).blank?
                            is_red = "yes"
                            txt = "商品已存在"
                            sheet_back << (rowarr << txt << is_red)
                          else
                            Commodity.create!(dms_no: dms_no, name: name, supplier_id: supplier_id, cost_price: cost_price, sell_price: sell_price, desc: desc, is_on_sell: is_on_sell)
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
      else
        sheet1[count_row,0]=Commodity.find_by(dms_no:obj[1]).try(:cno)
      end
       
      count = 1
      while count<size-1
        sheet1[count_row,count]=obj[count]
        count += 1
      end
      
      count_row += 1
    end 
    book.write xls_report  
    xls_report.string  
  end      

  def set_on_sell
    @operation = "set_on_sell"
    @commodity.is_on_sell = !@commodity.is_on_sell
    
    respond_to do |format|
      if @commodity.save
        txt = @commodity.is_on_sell ? "上架" : "下架"
        format.html { redirect_to request.referer, notice: "已成功#{txt}" }
        format.json { head :no_content }
      else
        format.html { redirect_to request.referer }
        format.json { render json: @commodity.errors, status: :unprocessable_entity }
      end
    end
  end      


  private
    def commodity_params
      params.require(:commodity).permit(:cno, :dms_no, :name, :supplier_id , :desc, :is_on_sell, :cover).merge params.require(:commodity).permit(:cost_price, :sell_price).transform_values{|x| x.truncate_decimal(2)}
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
