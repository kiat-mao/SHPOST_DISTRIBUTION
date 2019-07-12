class SuppliersController < ApplicationController
  load_and_authorize_resource :supplier

  def index
    @suppliers = initialize_grid(@suppliers,
      :order => 'suppliers.sno',
      :order_direction => 'asc',
      :name => 'suppliers',
      :enable_export_to_csv => true,
      :csv_file_name => 'suppliers')
    export_grid_if_requested
  end

  def show
  end

  def new
  end

  def edit
  end

  def contracts_upload
    # @supplier = Supplier.find_by(id: params[:format])
    # @supplier.contracts = @supplier.contracts.insert("params[:contracts]")
    # @supplier.save
    # x = @supplier.contracts
    # @supplier.contracts = x.concat(params[:contracts])
    # s = Supplier.new(params[:supplier])
    
  end
  def contracts_show
  end

  

  def create
    respond_to do |format|
      if @supplier.save!
        format.html { redirect_to @supplier, notice: I18n.t('controller.create_success_notice', model: '供应商') }
        format.json { render action: 'show', status: :created, location: @supplier }
      else
        format.html { render action: 'new' }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @supplier.update(supplier_params)
        format.html { redirect_to @supplier, notice: I18n.t('controller.update_success_notice', model: '供应商') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @supplier.can_destroy?
      @supplier.destroy
    else
      flash[:alert] = "供应商下存在商品，不可删除。只能标记为无效。"
    end
    respond_to do |format|
      format.html { redirect_to suppliers_url }
      format.json { head :no_content }
    end
  end

  def supplier_import
    unless request.get?
      if file = upload_supplier(params[:file]['file'])       
        Supplier.transaction do
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
            sno_index = title_row.index("供应商编码").blank? ? 0 : title_row.index("供应商编码")
            name_index = title_row.index("供应商名称").blank? ? 1 : title_row.index("供应商名称")
            valid_before_index = title_row.index("合同到期日").blank? ? 2 : title_row.index("合同到期日")
            is_valid_index = title_row.index("是否有效").blank? ? 3 : title_row.index("是否有效")

            2.upto(instance.last_row) do |line|
              current_line = line
              rowarr = instance.row(line)
              sno = rowarr[sno_index].blank? ? "" : rowarr[sno_index].to_s.split('.0')[0]
              name = rowarr[name_index].blank? ? "" : rowarr[name_index].to_s.split('.0')[0]
              valid_before = rowarr[valid_before_index].blank? ? nil : DateTime.parse(rowarr[valid_before_index].to_s.split(".0")[0]).strftime('%Y-%m-%d')
              is_valid = rowarr[is_valid_index].blank? ? "" : rowarr[is_valid_index].to_s.split('.0')[0]
              is_valid = (is_valid.eql?"否") ? false : true
              
              if name.blank?
                is_error = true
                is_red = "yes"
                txt = "缺少供应商名称"
                sheet_back << (rowarr << txt << is_red)
              else
                if sno.blank?
                  is_error = true
                  is_red = "yes"
                  txt = "缺少供应商编码"
                  sheet_back << (rowarr << txt << is_red)
                else
                  if !Supplier.find_by(sno: sno).blank?
                    is_red = "no"
                    txt = "供应商已存在"
                    sheet_back << (rowarr << txt << is_red)
                  else
                    Supplier.create!(sno: sno, name: name, valid_before: valid_before, is_valid: is_valid)
                    is_red = "no"
                    txt = "供应商新建成功"
                    sheet_back << (rowarr << txt << is_red)
                  end
                end
              end
            end

            if is_error
              flash_message << "有部分信息导入失败！"
            end
            flash[:notice] = flash_message

            send_data(exportsupplier_infos_xls_content_for(sheet_back,title_row),  
              :type => "text/excel;charset=utf-8; header=present",  
              :filename => "Supplier_Infos_#{Time.now.strftime("%Y%m%d")}.xls")

          rescue Exception => e
            Rails.logger.error e.backtrace
            flash[:alert] = e.message + "第" + current_line.to_s + "行"
            raise ActiveRecord::Rollback
          end
        end
      end   
    end
  end

  def exportsupplier_infos_xls_content_for(obj,title_row)
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

  def set_valid
    @operation = "set_valid"
    @supplier.is_valid = !@supplier.is_valid
      
    respond_to do |format|
      if @supplier.save!
        txt = @supplier.is_valid ? "有效" : "无效"
        format.html { redirect_to suppliers_url, notice: "已成功标记为#{txt}" }
        format.json { head :no_content }
      else
        format.html { redirect_to suppliers_url }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    def supplier_params
      params.require(:supplier).permit(:sno, :name, :valid_before, :is_valid, {contracts: []})
    end

    def upload_supplier(file)
      if !file.original_filename.empty?
        direct = "#{Rails.root}/upload/supplier/"
        filename = "#{Time.now.to_f}_#{file.original_filename}"
        if !File.exist?("#{Rails.root}/upload/")
          Dir.mkdir("#{Rails.root}/upload/")          
        end
        if !File.exist?("#{Rails.root}/upload/supplier/")
          Dir.mkdir("#{Rails.root}/upload/supplier/")          
        end

        file_path = direct + filename
        File.open(file_path, "wb") do |f|
           f.write(file.read)
        end
        file_path
      end
    end
end
